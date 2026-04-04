import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Facet', () {
    test('combines multiple string values with join', () {
      final facet = Facet<String, String>(
        combine: (values) => values.join(', '),
      );

      final store = FacetStore.resolve([
        facet.of('alpha'),
        facet.of('beta'),
        facet.of('gamma'),
      ]);

      expect(store.read(facet), 'alpha, beta, gamma');
    });

    test('returns combine of empty list when no providers', () {
      final facet = Facet<String, String>(
        combine: (values) => values.isEmpty ? '<none>' : values.join(', '),
      );

      final store = FacetStore.resolve([]);

      expect(store.read(facet), '<none>');
    });

    test('works with a single provider', () {
      final facet = Facet<int, int>(
        combine: (values) => values.fold(0, (a, b) => a + b),
      );

      final store = FacetStore.resolve([facet.of(42)]);

      expect(store.read(facet), 42);
    });

    test('numeric facet uses last-wins combine', () {
      final facet = Facet<int, int>(
        combine: (values) => values.isEmpty ? 0 : values.last,
      );

      final store = FacetStore.resolve([
        facet.of(1),
        facet.of(2),
        facet.of(3),
      ]);

      expect(store.read(facet), 3);
    });

    test('boolean facet uses any-true combine', () {
      final facet = Facet<bool, bool>(
        combine: (values) => values.any((v) => v),
      );

      final storeWithTrue = FacetStore.resolve([
        facet.of(false),
        facet.of(true),
        facet.of(false),
      ]);
      expect(storeWithTrue.read(facet), isTrue);

      final storeAllFalse = FacetStore.resolve([
        facet.of(false),
        facet.of(false),
      ]);
      expect(storeAllFalse.read(facet), isFalse);
    });

    test('extension group flattens nested facet values', () {
      final facet = Facet<String, String>(
        combine: (values) => values.join('+'),
      );

      final group = ExtensionGroup([
        facet.of('x'),
        facet.of('y'),
        ExtensionGroup([
          facet.of('z'),
        ]),
      ]);

      final store = FacetStore.resolve([group]);

      expect(store.read(facet), 'x+y+z');
    });
  });
}
