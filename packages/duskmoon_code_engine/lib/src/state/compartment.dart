part of 'extension.dart';

/// Dynamic reconfiguration boundary.
class Compartment {
  Compartment();

  /// Wrap an extension in this compartment.
  CompartmentExtension of(Extension ext) =>
      CompartmentExtension(this, ext);

  /// Create an effect that reconfigures this compartment.
  StateEffect<Extension> reconfigure(Extension ext) =>
      _reconfigureType.of(ext);

  final _reconfigureType = const StateEffectType<Extension>();
}

/// An extension wrapped in a Compartment for dynamic reconfiguration.
class CompartmentExtension extends Extension {
  const CompartmentExtension(this.compartment, this.inner);
  final Compartment compartment;
  final Extension inner;
}
