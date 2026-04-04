part of 'extension.dart';

/// A typed extension point that collects values from multiple providers
/// and reduces them with a [combine] function.
class Facet<Input, Output> {
  const Facet({required this.combine});
  final Output Function(List<Input>) combine;

  /// Create an extension that provides [value] to this facet.
  FacetExtension<Input, Output> of(Input value) =>
      FacetExtension<Input, Output>(this, value);

  /// Invoke [combine] with a raw list of dynamic values.
  Output _combineRaw(List<dynamic> values) => combine(values.cast<Input>());
}

/// An extension that provides a value to a [Facet].
class FacetExtension<Input, Output> extends Extension {
  const FacetExtension(this.facet, this.value);
  final Facet<Input, Output> facet;
  final Input value;
}

/// Resolved facet values from a set of extensions.
class FacetStore {
  FacetStore._(this._values);
  final Map<Facet<dynamic, dynamic>, dynamic> _values;

  /// Resolve all facet values from a list of extensions.
  factory FacetStore.resolve(List<Extension> extensions) {
    final providers = <Facet<dynamic, dynamic>, List<dynamic>>{};

    void collect(Extension ext) {
      switch (ext) {
        case FacetExtension<dynamic, dynamic>():
          providers.putIfAbsent(ext.facet, () => []).add(ext.value);
        case ExtensionGroup():
          for (final child in ext.extensions) {
            collect(child);
          }
        case PrecedenceExtension():
          collect(ext.inner);
        default:
          break;
      }
    }

    for (final ext in extensions) {
      collect(ext);
    }

    final values = <Facet<dynamic, dynamic>, dynamic>{};
    for (final entry in providers.entries) {
      values[entry.key] = entry.key._combineRaw(entry.value);
    }

    return FacetStore._(values);
  }

  /// Read the resolved value of a facet.
  Output read<Input, Output>(Facet<Input, Output> facet) {
    if (_values.containsKey(facet)) {
      return _values[facet] as Output;
    }
    return facet.combine(const []);
  }
}
