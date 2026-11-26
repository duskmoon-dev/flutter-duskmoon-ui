// Run from the Flutter repository root. Use --check to verify the asset.
import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  const groups = {
    'xy': [
      'line-input-order-gap-and-repeated-x',
      'bar-grouped-vertical',
      'scatter-missing',
    ],
    'heatmap': ['ordered-continuous-and-missing'],
    'scenes': ['network-fixed', 'mercator-fit-holes-and-points'],
  };

  final charts = <String, Object?>{};
  for (final MapEntry(key: group, value: ids) in groups.entries) {
    final fixtures = jsonDecode(
      File('specs/visualization/v1/fixtures/$group.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    for (final id in ids) {
      charts[id] = (fixtures[id] as Map<String, dynamic>)['chart'];
    }
  }
  final asset = File('example/design_preview/assets/visualization/charts.json');
  final expected = '${const JsonEncoder.withIndent('  ').convert(charts)}\n';
  if (args.contains('--check')) {
    if (!asset.existsSync() || asset.readAsStringSync() != expected) {
      stderr.writeln('Shared visualization asset differs from the contract.');
      exitCode = 1;
    }
  } else {
    asset.writeAsStringSync(expected);
  }
}
