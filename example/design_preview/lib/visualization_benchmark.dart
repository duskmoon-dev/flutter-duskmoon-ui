import 'dart:convert';
import 'dart:math' as math;

import 'package:duskmoon_visualization/duskmoon_visualization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

const _width = 640.0;
const _height = 360.0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final fixtureText = await rootBundle.loadString(
    'assets/visualization/charts.json',
  );
  final fixtures = jsonDecode(fixtureText) as Map<String, dynamic>;
  final map = fixtures['mercator-fit-holes-and-points'] as Map<String, dynamic>;
  runApp(
    WidgetsApp(
      color: const Color(0xff112233),
      builder: (_, _) => _Benchmark(map: map),
    ),
  );
}

class _Benchmark extends StatefulWidget {
  final Map<String, dynamic> map;
  const _Benchmark({required this.map});

  @override
  State<_Benchmark> createState() => _BenchmarkState();
}

class _BenchmarkState extends State<_Benchmark> {
  Widget? _chart;
  String _report = 'Measuring visualization workloads…';

  late final _line = List.generate(
    4,
    (series) => DmVizSeries(
      id: 's$series',
      name: 'Series $series',
      data: List.generate(
        1000,
        (i) => DmVizDatum(id: 'p$i', x: i, y: series * 2 + math.sin(i * .03)),
      ),
    ),
  );
  late final _scatter = [
    DmVizSeries(
      id: 'points',
      name: 'Points',
      data: List.generate(
        10000,
        (i) => DmVizDatum(id: 'p$i', x: i % 100, y: (i ~/ 100).toDouble()),
      ),
    ),
  ];
  late final _categories = List.generate(
    100,
    (i) => DmVizCategory(id: 'c$i', label: '$i'),
  );
  late final _cells = List.generate(
    10000,
    (i) => DmVizHeatmapDatum(
      id: '$i',
      rowId: 'c${i ~/ 100}',
      columnId: 'c${i % 100}',
      value: ((i % 100 + 7 * (i ~/ 100)) % 101).toDouble(),
    ),
  );
  late final _nodes = List.generate(
    500,
    (i) => DmVizNetworkNode(
      id: 'n$i',
      x: (i % 25).toDouble(),
      y: (i ~/ 25).toDouble(),
    ),
  );
  late final _edges = List.generate(
    1000,
    (i) => DmVizNetworkEdge(
      id: 'e$i',
      source: 'n${i % 500}',
      target: 'n${(i + (i < 500 ? 1 : 25)) % 500}',
    ),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _run());
  }

  Future<double> _frame(Widget? child) async {
    final timer = Stopwatch()..start();
    setState(() => _chart = child);
    await WidgetsBinding.instance.endOfFrame;
    return timer.elapsedMicroseconds / 1000;
  }

  Future<void> _run() async {
    final cases = {
      'line': (int revision) => DmVizLineChart.series(
        series: _line,
        height: _height,
        options: DmVizOptions(title: 'Line $revision'),
      ),
      'scatter': (int revision) => DmVizScatterChart.series(
        series: _scatter,
        height: _height,
        options: DmVizOptions(title: 'Scatter $revision'),
      ),
      'heatmap': (int revision) => DmVizHeatmap.cells(
        rows: _categories,
        columns: _categories,
        data: _cells,
        height: _height,
        options: DmVizOptions(title: 'Heatmap $revision'),
      ),
      'network': (int revision) => DmVizNetworkGraph.fixed(
        nodes: _nodes,
        edges: _edges,
        height: _height,
        options: DmVizOptions(title: 'Network $revision'),
      ),
      'map': (int revision) => DmVizMapChart.mercator(
        geoJson: GeoJsonFeatureCollection.fromJson(
          widget.map['geoJson'] as Map<String, dynamic>,
        ),
        padding:
            ((widget.map['options'] as Map<String, dynamic>)['padding'] as num)
                .toDouble(),
        height: _height,
        options: DmVizOptions(title: 'Map $revision'),
      ),
    };
    final values = <String, List<Map<String, double>>>{};
    for (final MapEntry(key: name, value: render) in cases.entries) {
      values[name] = [];
      for (var index = 0; index < 6; index++) {
        await _frame(null);
        final first = await _frame(render(0));
        final update = await _frame(render(1));
        if (index > 0) {
          values[name]!.add({'firstFrameMs': first, 'updateFrameMs': update});
        }
      }
    }
    await _frame(null);
    final report = jsonEncode({
      'mode': kProfileMode
          ? 'profile'
          : kReleaseMode
          ? 'release'
          : 'debug',
      'samples': values,
    });
    // The profile runner reads this record from Chromium's console.
    debugPrint('DUSKMOON_VIZ_BENCHMARK $report', wrapWidth: 100000);
    if (mounted) setState(() => _report = report);
  }

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topLeft,
    child: SizedBox(width: _width, child: _chart ?? Text(_report)),
  );
}
