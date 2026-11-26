import 'dart:convert';

import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import '../../destination.dart';
import '../../showcase_scaffold.dart';
import 'contract_fixture_chart.dart';

typedef _Json = Map<String, dynamic>;

class ContractGalleryPage extends StatefulWidget {
  static const name = 'Shared Chart Fixtures';
  static const path = 'shared-charts';

  const ContractGalleryPage({super.key});

  @override
  State<ContractGalleryPage> createState() => _ContractGalleryPageState();
}

class _ContractGalleryPageState extends State<ContractGalleryPage> {
  late final Future<_Json> _fixtures = rootBundle
      .loadString('assets/visualization/charts.json')
      .then((text) => jsonDecode(text) as _Json);

  @override
  Widget build(BuildContext context) => ShowcaseScaffold(
    selectedIndex: Destinations.indexOf(const Key('Visualization')),
    appBar: const DmAppBar(
      title: Text(ContractGalleryPage.name),
      actions: [PlatformSwitchAction()],
    ),
    body: (_) => FutureBuilder(
      future: _fixtures,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Could not load visualization fixtures'),
          );
        }
        final data = snapshot.data;
        if (data == null) {
          return const Center(child: Text('Loading chart fixtures…'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: data.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final entry = data.entries.elementAt(index);
            return Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    contractFixtureChart(entry.value as _Json),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        entry.key,
                        style: DefaultTextStyle.of(context).style
                            .copyWith(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ),
  );
}
