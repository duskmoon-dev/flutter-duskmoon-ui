import 'dart:math' as math;

import 'node.dart';
import 'link.dart';

/// Force simulation for laying out network graphs.
class ForceSimulation {
  /// Nodes in the simulation.
  final List<NetworkNode> nodes;

  /// Links in the simulation.
  final List<NetworkLink> links;

  /// Simulation alpha (temperature).
  double alpha;

  /// Minimum alpha before simulation stops.
  double alphaMin;

  /// Alpha decay rate per tick.
  double alphaDecay;

  /// Target alpha for reheating.
  double alphaTarget;

  /// Velocity decay (friction).
  double velocityDecay;

  /// Whether the simulation is running.
  bool _running = false;

  /// Forces applied to the simulation.
  final List<Force> forces;

  /// Callback when simulation ticks.
  void Function()? onTick;

  /// Callback when simulation ends.
  void Function()? onEnd;

  /// Node lookup map.
  late Map<String, NetworkNode> _nodeMap;

  ForceSimulation({
    required this.nodes,
    required this.links,
    this.alpha = 1.0,
    this.alphaMin = 0.001,
    this.alphaDecay = 0.0228,
    this.alphaTarget = 0,
    this.velocityDecay = 0.4,
    List<Force>? forces,
    this.onTick,
    this.onEnd,
  }) : forces = forces ?? [] {
    _buildNodeMap();
    _initializePositions();
  }

  void _buildNodeMap() {
    _nodeMap = {for (final node in nodes) node.id: node};
  }

  void _initializePositions() {
    final random = math.Random();
    for (final node in nodes) {
      if (node.x == 0 && node.y == 0) {
        node.x = random.nextDouble() * 100 - 50;
        node.y = random.nextDouble() * 100 - 50;
      }
    }
  }

  /// Gets a node by ID.
  NetworkNode? getNode(String id) => _nodeMap[id];

  /// Whether the simulation is currently running.
  bool get isRunning => _running;

  /// Starts the simulation.
  void start() {
    if (_running) return;
    _running = true;
    _run();
  }

  /// Stops the simulation.
  void stop() {
    _running = false;
  }

  /// Reheats the simulation.
  void restart() {
    alpha = 1.0;
    start();
  }

  /// Runs a single tick of the simulation.
  void tick() {
    // Update alpha
    alpha += (alphaTarget - alpha) * alphaDecay;

    // Apply forces
    for (final force in forces) {
      force.apply(this);
    }

    // Update positions
    for (final node in nodes) {
      if (node.fixed) continue;

      node.vx *= velocityDecay;
      node.vy *= velocityDecay;
      node.x += node.vx;
      node.y += node.vy;
    }
  }

  void _run() async {
    while (_running && alpha >= alphaMin) {
      tick();
      onTick?.call();
      await Future.delayed(const Duration(milliseconds: 16));
    }

    if (alpha < alphaMin) {
      _running = false;
      onEnd?.call();
    }
  }

  /// Finds the node closest to a point.
  NetworkNode? findNode(double x, double y, {double radius = double.infinity}) {
    NetworkNode? closest;
    double minDistance = radius;

    for (final node in nodes) {
      final dx = node.x - x;
      final dy = node.y - y;
      final distance = math.sqrt(dx * dx + dy * dy);

      if (distance < minDistance) {
        minDistance = distance;
        closest = node;
      }
    }

    return closest;
  }

  /// Adds a force to the simulation.
  void addForce(Force force) {
    forces.add(force);
  }

  /// Removes a force from the simulation.
  void removeForce(Force force) {
    forces.remove(force);
  }

  /// Creates a simulation with default forces.
  factory ForceSimulation.withDefaults({
    required List<NetworkNode> nodes,
    required List<NetworkLink> links,
    double centerX = 0,
    double centerY = 0,
    double chargeStrength = -30,
    double linkDistance = 30,
    void Function()? onTick,
    void Function()? onEnd,
  }) {
    return ForceSimulation(
      nodes: nodes,
      links: links,
      forces: [
        CenterForce(x: centerX, y: centerY),
        ManyBodyForce(strength: chargeStrength),
        LinkForce(links: links, distance: linkDistance),
      ],
      onTick: onTick,
      onEnd: onEnd,
    );
  }
}

/// Base class for forces in the simulation.
abstract class Force {
  /// Applies the force to the simulation.
  void apply(ForceSimulation simulation);
}

/// Force that pushes nodes toward a center point.
class CenterForce extends Force {
  final double x;
  final double y;
  final double strength;

  CenterForce({
    this.x = 0,
    this.y = 0,
    this.strength = 1,
  });

  @override
  void apply(ForceSimulation simulation) {
    final nodes = simulation.nodes;
    final n = nodes.length;
    if (n == 0) return;

    // Calculate center of mass
    double sx = 0, sy = 0;
    for (final node in nodes) {
      sx += node.x;
      sy += node.y;
    }
    sx = (sx / n - x) * strength;
    sy = (sy / n - y) * strength;

    // Move nodes toward center
    for (final node in nodes) {
      node.x -= sx;
      node.y -= sy;
    }
  }
}

/// Repulsive force between all nodes (charge).
class ManyBodyForce extends Force {
  double strength;
  double theta;
  double distanceMin;
  double distanceMax;

  ManyBodyForce({
    this.strength = -30,
    this.theta = 0.9,
    this.distanceMin = 1,
    this.distanceMax = double.infinity,
  });

  @override
  void apply(ForceSimulation simulation) {
    final nodes = simulation.nodes;
    final alpha = simulation.alpha;

    for (int i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      if (node.fixed) continue;

      for (int j = 0; j < nodes.length; j++) {
        if (i == j) continue;

        final other = nodes[j];
        final dx = other.x - node.x;
        final dy = other.y - node.y;
        var distance = math.sqrt(dx * dx + dy * dy);

        if (distance < distanceMin) distance = distanceMin;
        if (distance > distanceMax) continue;

        // Apply repulsive force
        final force = strength * alpha / (distance * distance);
        node.vx -= dx / distance * force;
        node.vy -= dy / distance * force;
      }
    }
  }
}

/// Force that maintains link distances.
class LinkForce extends Force {
  final List<NetworkLink> links;
  double distance;
  double strength;
  int iterations;

  LinkForce({
    required this.links,
    this.distance = 30,
    this.strength = 1,
    this.iterations = 1,
  });

  @override
  void apply(ForceSimulation simulation) {
    final alpha = simulation.alpha;

    for (int iter = 0; iter < iterations; iter++) {
      for (final link in links) {
        final source = simulation.getNode(link.source);
        final target = simulation.getNode(link.target);

        if (source == null || target == null) continue;

        var dx = target.x - source.x;
        var dy = target.y - source.y;
        var dist = math.sqrt(dx * dx + dy * dy);

        if (dist == 0) {
          dist = 0.001;
          dx = dist;
        }

        final targetDist = distance * link.weight;
        final force = (dist - targetDist) / dist * alpha * strength;

        dx *= force;
        dy *= force;

        const sourceWeight = 1.0;
        const targetWeight = 1.0;
        const totalWeight = sourceWeight + targetWeight;

        if (!target.fixed) {
          target.vx -= dx * sourceWeight / totalWeight;
          target.vy -= dy * sourceWeight / totalWeight;
        }

        if (!source.fixed) {
          source.vx += dx * targetWeight / totalWeight;
          source.vy += dy * targetWeight / totalWeight;
        }
      }
    }
  }
}

/// Force that pushes nodes away from each other for collision detection.
class CollideForce extends Force {
  double radius;
  double strength;
  int iterations;

  CollideForce({
    this.radius = 10,
    this.strength = 1,
    this.iterations = 1,
  });

  @override
  void apply(ForceSimulation simulation) {
    final nodes = simulation.nodes;

    for (int iter = 0; iter < iterations; iter++) {
      for (int i = 0; i < nodes.length; i++) {
        final node = nodes[i];
        if (node.fixed) continue;

        for (int j = i + 1; j < nodes.length; j++) {
          final other = nodes[j];

          var dx = other.x - node.x;
          var dy = other.y - node.y;
          var dist = math.sqrt(dx * dx + dy * dy);

          final minDist = node.radius + other.radius + radius;

          if (dist < minDist) {
            if (dist == 0) {
              dist = 0.001;
              dx = dist;
            }

            final overlap = (minDist - dist) / dist * strength;
            dx *= overlap / 2;
            dy *= overlap / 2;

            if (!node.fixed) {
              node.x -= dx;
              node.y -= dy;
            }

            if (!other.fixed) {
              other.x += dx;
              other.y += dy;
            }
          }
        }
      }
    }
  }
}

/// Force that positions nodes along the x-axis based on a value.
class ForceX extends Force {
  final double x;
  double strength;

  ForceX({
    this.x = 0,
    this.strength = 0.1,
  });

  @override
  void apply(ForceSimulation simulation) {
    final alpha = simulation.alpha;

    for (final node in simulation.nodes) {
      if (node.fixed) continue;
      node.vx += (x - node.x) * strength * alpha;
    }
  }
}

/// Force that positions nodes along the y-axis based on a value.
class ForceY extends Force {
  final double y;
  double strength;

  ForceY({
    this.y = 0,
    this.strength = 0.1,
  });

  @override
  void apply(ForceSimulation simulation) {
    final alpha = simulation.alpha;

    for (final node in simulation.nodes) {
      if (node.fixed) continue;
      node.vy += (y - node.y) * strength * alpha;
    }
  }
}

/// Force that constrains nodes within a bounding box.
class BoundingBoxForce extends Force {
  final double minX;
  final double minY;
  final double maxX;
  final double maxY;
  final double bounce;

  BoundingBoxForce({
    required this.minX,
    required this.minY,
    required this.maxX,
    required this.maxY,
    this.bounce = 0.5,
  });

  @override
  void apply(ForceSimulation simulation) {
    for (final node in simulation.nodes) {
      if (node.fixed) continue;

      if (node.x - node.radius < minX) {
        node.x = minX + node.radius;
        node.vx *= -bounce;
      } else if (node.x + node.radius > maxX) {
        node.x = maxX - node.radius;
        node.vx *= -bounce;
      }

      if (node.y - node.radius < minY) {
        node.y = minY + node.radius;
        node.vy *= -bounce;
      } else if (node.y + node.radius > maxY) {
        node.y = maxY - node.radius;
        node.vy *= -bounce;
      }
    }
  }
}
