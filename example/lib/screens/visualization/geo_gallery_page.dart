import 'package:flutter/material.dart';

import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:duskmoon_visualization/duskmoon_visualization_compat.dart'
    as dv;

class GeoGalleryPage extends StatelessWidget {
  const GeoGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Geographic Visualizations')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _GeoCard(
            title: 'World Map Projections',
            description:
                'Switch between Mercator, Equirectangular, and Orthographic projections',
            height: 380,
            child: _WorldMapDemo(),
          ),
          SizedBox(height: 12),
          _GeoCard(
            title: 'Interactive Globe',
            description: 'Auto-rotating 3D globe. Drag to change the view.',
            height: 380,
            child: _GlobeDemo(),
          ),
          SizedBox(height: 12),
          _GeoCard(
            title: 'Regional Focus Maps',
            description: 'Zoom into different world regions',
            height: 320,
            child: _RegionalFocusDemo(),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _GeoCard
// ---------------------------------------------------------------------------

class _GeoCard extends StatelessWidget {
  const _GeoCard({
    required this.title,
    required this.description,
    required this.height,
    required this.child,
  });

  final String title;
  final String description;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            SizedBox(height: height, child: child),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared projection builder (mirrors geo_map_page.dart logic)
// ---------------------------------------------------------------------------

dv.Projection _buildProjection(
  String name,
  double rotation,
  Size size,
) {
  final center = dv.Point(size.width / 2, size.height / 2);
  switch (name) {
    case 'Equirect.':
      return dv.geoEquirectangular(
        center: (0, 12),
        scale: size.width / 6.2,
        translate: center,
      );
    case 'Ortho':
      return dv.geoOrthographic(
        center: (0, 12),
        scale: size.width / 2.7,
        translate: center,
        rotate: (rotation, -8, 0),
      );
    default: // Mercator
      return dv.geoMercator(
        center: (0, 18),
        scale: size.width / 6.8,
        translate: center,
      );
  }
}

String _featureName(dv.GeoJsonFeature feature) {
  return (feature.properties['name'] ??
          feature.properties['NAME'] ??
          feature.id ??
          'Unknown feature')
      .toString();
}

// ---------------------------------------------------------------------------
// Chart 1 – World Map Projection Switcher
// ---------------------------------------------------------------------------

class _WorldMapDemo extends StatefulWidget {
  const _WorldMapDemo();

  @override
  State<_WorldMapDemo> createState() => _WorldMapDemoState();
}

class _WorldMapDemoState extends State<_WorldMapDemo> {
  static const _projections = <String>['Mercator', 'Equirect.', 'Ortho'];

  String _selected = 'Mercator';
  double _rotation = 0;
  String? _selectedFeatureName;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dmColors = Theme.of(context).extension<DmColorExtension>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Projection chip row
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final proj in _projections)
              ChoiceChip(
                label: Text(proj),
                selected: _selected == proj,
                onSelected: (_) => setState(() => _selected = proj),
                visualDensity: VisualDensity.compact,
              ),
          ],
        ),
        // Rotation slider for Orthographic
        if (_selected == 'Ortho') ...[
          const SizedBox(height: 4),
          Text(
            'Rotation ${_rotation.toStringAsFixed(0)}°',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Slider(
            value: _rotation,
            min: -180,
            max: 180,
            onChanged: (v) => setState(() => _rotation = v),
          ),
        ],
        const SizedBox(height: 8),
        // Map
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size =
                  Size(constraints.maxWidth, constraints.maxHeight - 32);
              final projection = _buildProjection(_selected, _rotation, size);

              return Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ColoredBox(
                        color: const Color(0xFFE8F4FF),
                        child: dv.World110mWidget(
                          projection: projection,
                          fillColor: dmColors?.accent.withValues(alpha: 0.22) ??
                              colorScheme.primary.withValues(alpha: 0.18),
                          strokeColor: dmColors?.accent ?? colorScheme.primary,
                          strokeWidth: 0.8,
                          onFeatureTap: (feature, _) => setState(
                            () => _selectedFeatureName = _featureName(feature),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _selectedFeatureName == null
                          ? 'Tap a country to see its name.'
                          : 'Selected: $_selectedFeatureName',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSecondaryContainer,
                          ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Chart 2 – Animated Globe
// ---------------------------------------------------------------------------

class _GlobeDemo extends StatefulWidget {
  const _GlobeDemo();

  @override
  State<_GlobeDemo> createState() => _GlobeDemoState();
}

class _GlobeDemoState extends State<_GlobeDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _dragRotation = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dmColors = Theme.of(context).extension<DmColorExtension>();

    return GestureDetector(
      onPanUpdate: (details) {
        setState(() => _dragRotation += details.delta.dx * 0.5);
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final autoRotation = (_controller.value * 360) - 180;
          final totalRotation = autoRotation + _dragRotation;

          return LayoutBuilder(
            builder: (context, constraints) {
              final size = Size(constraints.maxWidth, constraints.maxHeight);
              final center = dv.Point(size.width / 2, size.height / 2);
              final scale = size.width / 2.2;

              final projection = dv.geoOrthographic(
                center: (0, 0),
                scale: scale,
                translate: center,
                rotate: (totalRotation, -15, 0),
              );

              return Stack(
                alignment: Alignment.center,
                children: [
                  // Ocean circle
                  Container(
                    width: scale * 2,
                    height: scale * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFB0D8F0),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withValues(alpha: 0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  // Land masses
                  dv.World110mWidget(
                    projection: projection,
                    fillColor: dmColors?.success.withValues(alpha: 0.65) ??
                        Colors.green.withValues(alpha: 0.6),
                    strokeColor: dmColors?.success.withValues(alpha: 0.9) ??
                        Colors.green.withValues(alpha: 0.9),
                    strokeWidth: 0.6,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Chart 3 – Regional Focus Maps
// ---------------------------------------------------------------------------

class _RegionalFocusDemo extends StatefulWidget {
  const _RegionalFocusDemo();

  @override
  State<_RegionalFocusDemo> createState() => _RegionalFocusDemoState();
}

class _RegionalFocusDemoState extends State<_RegionalFocusDemo> {
  static const _regions = <String>[
    'World',
    'Americas',
    'Europe/Africa',
    'Asia-Pacific'
  ];

  String _selected = 'World';

  ({double lon, double lat, double scaleMultiplier}) _regionParams(
    String region,
  ) {
    switch (region) {
      case 'Americas':
        return (lon: -80, lat: 10, scaleMultiplier: 4.0);
      case 'Europe/Africa':
        return (lon: 20, lat: 20, scaleMultiplier: 4.5);
      case 'Asia-Pacific':
        return (lon: 130, lat: 20, scaleMultiplier: 4.5);
      default: // World
        return (lon: 0, lat: 15, scaleMultiplier: 6.8);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dmColors = Theme.of(context).extension<DmColorExtension>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Region chip row
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final region in _regions)
              ChoiceChip(
                label: Text(region),
                selected: _selected == region,
                onSelected: (_) => setState(() => _selected = region),
                visualDensity: VisualDensity.compact,
              ),
          ],
        ),
        const SizedBox(height: 8),
        // Map
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;
              final params = _regionParams(_selected);
              final center = dv.Point(width / 2, height / 2);
              final projection = dv.geoMercator(
                center: (params.lon, params.lat),
                scale: width / params.scaleMultiplier,
                translate: center,
              );

              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ColoredBox(
                  color: const Color(0xFFE8F4FF),
                  child: dv.World110mWidget(
                    projection: projection,
                    fillColor: dmColors?.accent.withValues(alpha: 0.22) ??
                        colorScheme.primary.withValues(alpha: 0.18),
                    strokeColor: dmColors?.accent ?? colorScheme.primary,
                    strokeWidth: 0.8,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
