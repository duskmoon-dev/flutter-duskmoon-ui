import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const secondaryRoute = 'secondaryDisplayMain';
const navigationLabels = ['Widgets', 'Forms', 'Charts', 'Editor'];
const editorLanguages = ['Dart', 'Python', 'JavaScript'];

/// The primary owns this state. Companion views submit intents, never snapshots.
@immutable
class AppState {
  const AppState({
    this.selectedIndex = 0,
    this.message = 'Welcome to DuskMoon Duo!',
    this.isViewerOnly = false,
    this.chartData = const [10, 25, 18, 40, 32],
    this.editorLanguage = 'Dart',
    this.projectName = '',
    this.savedProjectName = '',
    this.liveFormPreview = true,
  });

  final int selectedIndex;
  final String message;
  final bool isViewerOnly;
  final List<double> chartData;
  final String editorLanguage;
  final String projectName;
  final String savedProjectName;
  final bool liveFormPreview;

  Map<String, Object> toJson() => {
        'selectedIndex': selectedIndex,
        'message': message,
        'isViewerOnly': isViewerOnly,
        'chartData': chartData,
        'editorLanguage': editorLanguage,
        'projectName': projectName,
        'savedProjectName': savedProjectName,
        'liveFormPreview': liveFormPreview,
      };

  factory AppState.fromJson(Map<String, dynamic> json) {
    final index = json['selectedIndex'];
    final language = json['editorLanguage'];
    final data = json['chartData'];
    if (index is! int ||
        index < 0 ||
        index >= navigationLabels.length ||
        !editorLanguages.contains(language) ||
        data is! List ||
        data.length != 5 ||
        data.any((e) => e is! num || !e.toDouble().isFinite)) {
      throw const FormatException('Invalid application state');
    }
    return AppState(
      selectedIndex: index,
      message: json['message'] as String,
      isViewerOnly: json['isViewerOnly'] as bool,
      chartData: List.unmodifiable(data.map((e) => (e as num).toDouble())),
      editorLanguage: language as String,
      projectName: json['projectName'] as String,
      savedProjectName: json['savedProjectName'] as String,
      liveFormPreview: json['liveFormPreview'] as bool,
    );
  }
}

/// Only Android's presentation-category displays are supported by this sample.
abstract interface class DuoDisplayPlatform {
  Stream<void> get changes;
  Future<List<int>> presentationDisplays();
  Future<bool> show(int displayId);
  Future<bool> hide(int displayId);
}

class AndroidDuoDisplayPlatform implements DuoDisplayPlatform {
  static const _methods = MethodChannel('dev.duskmoon.duo/displays');
  static const _events = EventChannel('dev.duskmoon.duo/display_changes');

  @override
  Stream<void> get changes => _events.receiveBroadcastStream().map((_) {});

  @override
  Future<List<int>> presentationDisplays() async {
    // Native discovery also excludes the Activity's current host display.
    final displays = await _methods.invokeListMethod<int>('listDisplays');
    return [
      for (final display in displays ?? <int>[])
        if (display > 0) display,
    ];
  }

  @override
  Future<bool> show(int displayId) async =>
      displayId > 0 &&
      await _methods.invokeMethod<bool>('show', {'displayId': displayId}) ==
          true;

  @override
  Future<bool> hide(int displayId) async =>
      await _methods.invokeMethod<bool>('hide', {'displayId': displayId}) ==
      true;
}

class SingleDisplayPlatform implements DuoDisplayPlatform {
  const SingleDisplayPlatform();
  @override
  Stream<void> get changes => const Stream.empty();
  @override
  Future<List<int>> presentationDisplays() async => [];
  @override
  Future<bool> show(int displayId) async => false;
  @override
  Future<bool> hide(int displayId) async => true;
}

DuoDisplayPlatform defaultDisplayPlatform() =>
    !kIsWeb && defaultTargetPlatform == TargetPlatform.android
        ? AndroidDuoDisplayPlatform()
        : const SingleDisplayPlatform();

abstract interface class DuoBridge {
  Stream<Object?> get messages;
  void start();
  void send(String message);
  void dispose();
}

/// No ports or plugin channels are created on unsupported platforms or Web.
class SingleDisplayBridge implements DuoBridge {
  const SingleDisplayBridge();
  @override
  Stream<Object?> get messages => const Stream.empty();
  @override
  void start() {}
  @override
  void send(String message) {}
  @override
  void dispose() {}
}

DuoBridge defaultBridge({required bool secondary}) =>
    !kIsWeb && defaultTargetPlatform == TargetPlatform.android
        ? IsolateDuoBridge(secondary: secondary)
        : const SingleDisplayBridge();

/// This sample uses named ports for two-way communication. Across isolate groups
/// we send only
/// JSON strings, never application objects. Looking up the peer for every send
/// lets a cached companion engine discover a replacement primary after restart.
class IsolateDuoBridge implements DuoBridge {
  IsolateDuoBridge({required bool secondary})
      : _ownName = secondary ? _secondaryName : _primaryName,
        _peerName = secondary ? _primaryName : _secondaryName;

  static const _primaryName = 'dev.duskmoon.duo.primary';
  static const _secondaryName = 'dev.duskmoon.duo.secondary';
  final String _ownName;
  final String _peerName;
  final ReceivePort _port = ReceivePort();

  @override
  Stream<Object?> get messages => _port;

  @override
  void start() {
    IsolateNameServer.removePortNameMapping(_ownName);
    if (!IsolateNameServer.registerPortWithName(_port.sendPort, _ownName)) {
      throw StateError('Cannot register duo bridge');
    }
  }

  @override
  void send(String message) =>
      IsolateNameServer.lookupPortByName(_peerName)?.send(message);

  @override
  void dispose() {
    if (IsolateNameServer.lookupPortByName(_ownName) == _port.sendPort) {
      IsolateNameServer.removePortNameMapping(_ownName);
    }
    _port.close();
  }
}

/// Serializes native window mutations and keeps local navigation until the
/// companion acknowledges the current session. Native calls are never retried
/// while pending: a watchdog changes UI state without starting a second call.
class DuoDisplayController extends ChangeNotifier {
  DuoDisplayController({
    required this.secondary,
    required this.platform,
    required this.bridge,
    this.heartbeatInterval = const Duration(seconds: 1),
    this.connectionTimeout = const Duration(seconds: 5),
    Random? random,
    String? session,
  })  : _random = random ?? Random(),
        session = session ??
            '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(1 << 30)}';

  final bool secondary;
  final DuoDisplayPlatform platform;
  final DuoBridge bridge;
  final Duration heartbeatInterval;
  final Duration connectionTimeout;
  final String session;
  final Random _random;
  AppState _state = const AppState();
  AppState get state => _state;
  bool _connected = false;
  bool get connected => _connected;
  String? status;
  int? _shownDisplayId;
  int? get shownDisplayId => _shownDisplayId;
  String? _peerSession;
  int _sequence = 0;
  int _lastSnapshot = -1;
  int _intentSequence = 0;
  int _lastIntent = -1;
  int _nonce = 0;
  int? _pendingNonce;
  StreamSubscription<Object?>? _messages;
  StreamSubscription<void>? _changes;
  Timer? _heartbeat;
  Timer? _watchdog;
  bool _disposed = false;
  bool _started = false;
  bool _refreshAgain = false;
  Future<void>? _refresh;
  Future<void>? _shutdown;
  VoidCallback? onToast;

  void start() {
    if (_started || _disposed) return;
    _started = true;
    // A local-only primary needs neither native discovery nor a peer timer.
    if (!secondary && platform is SingleDisplayPlatform) return;
    try {
      _messages = bridge.messages.listen(_receive, onError: _bridgeError);
      bridge.start();
      if (secondary) {
        _heartbeat = Timer.periodic(heartbeatInterval, (_) => _tick());
        _hello();
      } else {
        _changes = platform.changes.listen(
          (_) => unawaited(refreshDisplays()),
          onError: _bridgeError,
        );
        unawaited(refreshDisplays());
      }
    } catch (error) {
      _bridgeError(error);
    }
  }

  void _bridgeError(Object error) {
    if (_disposed) return;
    status = 'Companion unavailable: $error';
    _setConnected(false);
  }

  void _setConnected(bool value) {
    if (_disposed) return;
    _connected = value;
    notifyListeners();
  }

  void _send(Map<String, Object?> message) {
    if (_disposed) return;
    try {
      bridge.send(jsonEncode({...message, 'session': session}));
    } catch (error) {
      _bridgeError(error);
    }
  }

  void _hello() => _send({'type': 'hello', 'nonce': ++_nonce});

  void _tick() {
    if (!_disposed && secondary) _hello();
  }

  void _recordContact() {
    _watchdog?.cancel();
    _watchdog = Timer(connectionTimeout, () {
      if (_disposed) return;
      status = 'Companion connection lost; local navigation restored.';
      _setConnected(false);
    });
  }

  Future<void> refreshDisplays() {
    if (_disposed || secondary || platform is SingleDisplayPlatform) {
      return Future.value();
    }
    _refreshAgain = true;
    return _refresh ??= _refreshLoop().whenComplete(() => _refresh = null);
  }

  Future<void> _refreshLoop() async {
    while (_refreshAgain && !_disposed) {
      _refreshAgain = false;
      try {
        final displays =
            await platform.presentationDisplays().timeout(connectionTimeout);
        if (_disposed) return;
        final target = displays.contains(_shownDisplayId)
            ? _shownDisplayId
            : displays.firstOrNull;
        if (target == _shownDisplayId &&
            (target == null || _presentationReady)) {
          continue;
        }
        _setConnected(false);
        if (_shownDisplayId != null && !await _hideShown()) continue;
        if (_disposed || target == null) continue;
        // The native host retains its companion engine across Dart hot restart.
        // Await the old Activity's detach before attaching a fresh view.
        if (!await platform.hide(target)) {
          status = 'Companion window could not be closed.';
          _setConnected(false);
          continue;
        }
        if (_disposed) return;
        _peerSession = null;
        _lastIntent = -1;
        _shownDisplayId = target;
        _watchdog?.cancel();
        _watchdog = Timer(connectionTimeout, () {
          if (!_disposed && !_connected) {
            status = 'Companion handshake timed out; using local navigation.';
            _setConnected(false);
          }
        });
        final shown = await platform.show(target);
        if (_disposed) return;
        if (!shown) {
          status = 'Companion could not start; using local navigation.';
          // A failed native call might have created a window before failing.
          await _hideShown();
          _setConnected(false);
        } else {
          _presentationReady = true;
        }
      } catch (error) {
        if (_disposed) return;
        status = 'Companion unavailable: $error';
        _setConnected(false);
        if (_shownDisplayId != null) await _hideShown();
      }
    }
  }

  bool _presentationReady = false;

  Future<bool> _hideShown() async {
    final id = _shownDisplayId;
    if (id == null) return true;
    _presentationReady = false;
    _peerSession = null;
    _watchdog?.cancel();
    try {
      if (!await platform.hide(id)) {
        if (!_disposed) status = 'Companion window could not be closed.';
        return false;
      }
      _shownDisplayId = null;
      return true;
    } catch (error) {
      if (!_disposed) status = 'Companion window could not be closed: $error';
      return false;
    }
  }

  void _receive(Object? raw) {
    if (_disposed || raw is! String) return;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return;
      final type = decoded['type'];
      final sender = decoded['session'];
      if (sender is! String || sender.isEmpty) return;
      if (!secondary && type == 'hello') {
        if (!_presentationReady || _shownDisplayId == null) return;
        final nonce = decoded['nonce'];
        if (nonce is! int || nonce < 1) return;
        if (_peerSession != sender) {
          _peerSession = sender;
          _lastIntent = -1;
          _setConnected(false);
        }
        _pendingNonce = nonce;
        _send({'type': 'welcome', 'peer': sender, 'nonce': nonce});
      } else if (secondary &&
          type == 'welcome' &&
          decoded['peer'] == session &&
          decoded['nonce'] == _nonce) {
        if (_peerSession != sender) {
          _peerSession = sender;
          _lastSnapshot = -1;
          _setConnected(false);
        }
        _send({'type': 'ready', 'peer': sender, 'nonce': _nonce});
      } else if (!secondary &&
          type == 'ready' &&
          _presentationReady &&
          sender == _peerSession &&
          decoded['peer'] == session &&
          decoded['nonce'] == _pendingNonce) {
        _recordContact();
        status = null;
        _setConnected(true);
        _broadcast();
      } else if (secondary &&
          type == 'snapshot' &&
          sender == _peerSession &&
          decoded['peer'] == session) {
        final sequence = decoded['sequence'];
        if (sequence is! int || sequence <= _lastSnapshot) return;
        final state = AppState.fromJson(
          decoded['state'] as Map<String, dynamic>,
        );
        _lastSnapshot = sequence;
        _recordContact();
        _state = state;
        status = null;
        _setConnected(true);
      } else if (!secondary &&
          type == 'intent' &&
          _connected &&
          sender == _peerSession &&
          decoded['peer'] == session) {
        final sequence = decoded['sequence'];
        if (sequence is! int || sequence <= _lastIntent) return;
        if (_applyIntent(decoded['command'], decoded['value'])) {
          _lastIntent = sequence;
          _recordContact();
        }
      }
    } catch (_) {
      // Malformed or stale cross-engine data cannot crash a view or alter state.
    }
  }

  void intent(String command, [Object? value]) {
    if (_disposed) return;
    if (secondary) {
      if (!_connected) return;
      _send({
        'type': 'intent',
        'peer': _peerSession,
        'sequence': ++_intentSequence,
        'command': command,
        'value': value,
      });
    } else {
      _applyIntent(command, value);
    }
  }

  bool _applyIntent(Object? command, Object? value) {
    final next = _state.toJson();
    switch (command) {
      case 'select':
        if (value is! int || value < 0 || value >= navigationLabels.length) {
          return false;
        }
        next['selectedIndex'] = value;
      case 'message':
      case 'projectName':
        if (value is! String) return false;
        next[command as String] = value;
      case 'viewerOnly':
      case 'liveFormPreview':
        if (value is! bool) return false;
        next[command == 'viewerOnly' ? 'isViewerOnly' : 'liveFormPreview'] =
            value;
      case 'saveProject':
        next['savedProjectName'] = _state.projectName;
      case 'randomize':
        next['chartData'] = List.generate(5, (_) => _random.nextDouble() * 100);
      case 'language':
        if (!editorLanguages.contains(value)) return false;
        next['editorLanguage'] = value as String;
      case 'toast':
        onToast?.call();
        return true;
      default:
        return false;
    }
    _state = AppState.fromJson(next);
    ++_sequence;
    notifyListeners();
    _broadcast();
    return true;
  }

  void _broadcast() {
    if (!_connected) return;
    _send({
      'type': 'snapshot',
      'peer': _peerSession,
      // Handshake snapshots also advance so a reconnect can refresh same state.
      'sequence': ++_sequence,
      'state': _state.toJson(),
    });
  }

  /// Closes ports/subscriptions immediately, then dismisses any owned native
  /// window after the in-flight show/hide completes, preserving serialization.
  Future<void> shutdown() => _shutdown ??= _close();

  Future<void> _close() async {
    _disposed = true;
    _connected = false;
    _heartbeat?.cancel();
    _watchdog?.cancel();
    bridge.dispose();
    await Future.wait([
      if (_messages != null) _messages!.cancel(),
      if (_changes != null) _changes!.cancel(),
    ]);
    final refresh = _refresh;
    if (refresh != null) await refresh;
    await _hideShown();
  }

  @override
  void dispose() {
    unawaited(shutdown());
    super.dispose();
  }
}
