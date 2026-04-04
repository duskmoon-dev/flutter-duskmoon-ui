import 'state_effect.dart';

part 'compartment.dart';
part 'state_field.dart';
part 'facet.dart';

/// The base type for all editor extensions.
sealed class Extension {
  const Extension();
}

/// An extension that bundles multiple child extensions.
class ExtensionGroup extends Extension {
  const ExtensionGroup(this.extensions);
  final List<Extension> extensions;
}

/// An extension wrapped with a precedence level.
class PrecedenceExtension extends Extension {
  const PrecedenceExtension(this.inner, this.precedence);
  final Extension inner;
  final Precedence precedence;
}

/// Precedence levels for extension ordering.
enum Precedence {
  fallback,
  base,
  extend,
  override_,
}

/// Wrap an extension with a precedence level.
Extension prec(Precedence p, Extension ext) => PrecedenceExtension(ext, p);
