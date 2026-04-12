import 'package:flutter/material.dart';

import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:duskmoon_visualization/duskmoon_visualization_compat.dart'
    as dv;

import '../../destination.dart';

class GeoMapPage extends StatefulWidget {
  static const name = 'Geo Map';
  static const path = 'geo-map';

  const GeoMapPage({super.key});

  @override
  State<GeoMapPage> createState() => _GeoMapPageState();
}

class _GeoMapPageState extends State<GeoMapPage> {
  static const _projectionOptions = <String>[
    'Mercator',
    'Equirectangular',
    'Orthographic',
  ];

  String _selectedProjection = _projectionOptions.first;
  double _rotation = 0;
  String? _selectedFeatureName;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dmColors = Theme.of(context).extension<DmColorExtension>();

    return DmAdaptiveScaffold(
      selectedIndex: Destinations.indexOf(const Key('Visualization')),
      onSelectedIndexChange: (idx) => Destinations.changeHandler(idx, context),
      destinations: Destinations.navs,
      useDrawer: true,
      transitionDuration: Duration.zero,
      appBar: DmAppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        title: const Text('Geo Projection Lab'),
        leading: const BackButton(),
        actions: const [PlatformSwitchAction()],
      ),
      appBarBreakpoint: Breakpoints.standard,
      body: (_) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'World map projections',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'This screen adapts the original data_visualization geo example into the DuskMoon showcase while keeping the migrated compat geo stack available.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          DmCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 240),
                        child: SizedBox(
                          width: double.infinity,
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedProjection,
                            decoration:
                                const InputDecoration(labelText: 'Projection'),
                            items: [
                              for (final projection in _projectionOptions)
                                DropdownMenuItem<String>(
                                  value: projection,
                                  child: Text(_projectionLabel(projection)),
                                ),
                            ],
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() => _selectedProjection = value);
                            },
                          ),
                        ),
                      ),
                      if (_selectedProjection == 'Orthographic')
                        SizedBox(
                          width: 320,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rotation ${_rotation.toStringAsFixed(0)}°',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Slider(
                                value: _rotation,
                                min: -180,
                                max: 180,
                                onChanged: (value) {
                                  setState(() => _rotation = value);
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final height = width < 640 ? 280.0 : 380.0;
                      final projection = _buildProjection(Size(width, height));

                      return Container(
                        height: height,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.surfaceContainerHighest,
                              colorScheme.surface,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: colorScheme.outlineVariant,
                          ),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: ColoredBox(
                            color: const Color(0xFFE8F4FF),
                            child: dv.World110mWidget(
                              projection: projection,
                              fillColor: dmColors?.accent
                                      .withValues(alpha: 0.22) ??
                                  colorScheme.primary.withValues(alpha: 0.18),
                              strokeColor:
                                  dmColors?.accent ?? colorScheme.primary,
                              strokeWidth: 0.8,
                              onFeatureTap: (feature, _) {
                                final name = _featureName(feature);
                                setState(() => _selectedFeatureName = name);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _selectedFeatureName == null
                          ? 'Tap a country to inspect feature properties.'
                          : 'Selected feature: $_selectedFeatureName',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSecondaryContainer,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _projectionLabel(String projection) {
    switch (projection) {
      case 'Equirectangular':
        return 'Equirect.';
      case 'Orthographic':
        return 'Ortho';
      case 'Mercator':
      default:
        return 'Mercator';
    }
  }

  dv.Projection _buildProjection(Size size) {
    final center = dv.Point(size.width / 2, size.height / 2);

    switch (_selectedProjection) {
      case 'Equirectangular':
        return dv.geoEquirectangular(
          center: (0, 12),
          scale: size.width / 6.2,
          translate: center,
        );
      case 'Orthographic':
        return dv.geoOrthographic(
          center: (0, 12),
          scale: size.width / 2.7,
          translate: center,
          rotate: (_rotation, -8, 0),
        );
      case 'Mercator':
      default:
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
}
