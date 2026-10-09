import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:duo_screen/duo_display_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation_displays/displays_manager.dart';

class FakePlatform implements DuoDisplayPlatform {
  final events = StreamController<void>.broadcast();
  List<int> displays = [];
  final shown = <int>[];
  final hidden = <int>[];
  bool showResult = true;
  bool hideResult = true;
  bool showThrows = false;
  bool listThrows = false;
  Completer<bool>? pendingShow;
  int concurrent = 0;
  int maxConcurrent = 0;

  @override
  Stream<void> get changes => events.stream;
  @override
  Future<List<int>> presentationDisplays() async {
    if (listThrows) throw StateError('display lookup failed');
    return displays;
  }

  @override
  Future<bool> show(int id) async {
    shown.add(id);
    concurrent++;
    maxConcurrent = max(maxConcurrent, concurrent);
    try {
      if (showThrows) throw StateError('show failed');
      return pendingShow == null ? showResult : await pendingShow!.future;
    } finally {
      concurrent--;
    }
  }

  @override
  Future<bool> hide(int id) async {
    hidden.add(id);
    concurrent++;
    maxConcurrent = max(maxConcurrent, concurrent);
    concurrent--;
    return hideResult;
  }
}

class FakeBridge implements DuoBridge {
  final incoming = StreamController<Object?>.broadcast();
  final sent = <Map<String, dynamic>>[];
  FakeBridge? peer;
  bool drop = false;
  bool closed = false;
  @override
  Stream<Object?> get messages => incoming.stream;
  @override
  void start() {}
  @override
  void send(String value) {
    sent.add(jsonDecode(value) as Map<String, dynamic>);
    if (!drop && peer != null && !peer!.closed) peer!.incoming.add(value);
  }

  void inject(Object? value) => incoming.add(value);
  @override
  void dispose() {
    closed = true;
    unawaited(incoming.close());
  }
}

const heartbeat = Duration(milliseconds: 20);
const timeout = Duration(milliseconds: 100);

DuoDisplayController makeController({
  bool secondary = false,
  required FakeBridge bridge,
  required FakePlatform platform,
  String? session,
}) =>
    DuoDisplayController(
      secondary: secondary,
      platform: platform,
      bridge: bridge,
      session: session,
      heartbeatInterval: heartbeat,
      connectionTimeout: timeout,
      random: Random(42),
    );

Future<void> flush() => Future<void>.delayed(const Duration(milliseconds: 2));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Android adapter filters presentation displays and uses companion route',
      () async {
    const channel = MethodChannel('presentation_displays_plugin');
    final calls = <MethodCall>[];
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      if (call.method == 'listDisplay') {
        return jsonEncode([
          {'displayId': 0, 'name': 'Primary'},
          {'displayId': 7, 'name': 'Presentation'},
          {'displayId': null, 'name': 'Unknown'},
        ]);
      }
      return true;
    });
    addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
    final platform = AndroidDuoDisplayPlatform();
    expect(await platform.presentationDisplays(), [7]);
    expect(calls.single.method, 'listDisplay');
    expect(calls.single.arguments, DISPLAY_CATEGORY_PRESENTATION);
    expect(await platform.show(7), isTrue);
    expect(calls.last.method, 'showPresentation');
    expect(jsonDecode(calls.last.arguments as String),
        {'displayId': 7, 'routerName': secondaryRoute});
    expect(await platform.hide(7), isTrue);
    expect(calls.last.method, 'hidePresentation');
    expect(jsonDecode(calls.last.arguments as String), {'displayId': 7});
  });

  test('state accepts integer chart points and rejects invalid values', () {
    final data = const AppState().toJson();
    data['chartData'] = [1, 2, 3, 4, 5];
    expect(AppState.fromJson(data).chartData, [1.0, 2.0, 3.0, 4.0, 5.0]);
    data['chartData'] = [double.nan, 2, 3, 4, 5];
    expect(() => AppState.fromJson(data), throwsFormatException);
    data['chartData'] = [1, 2, 3, 4, 5];
    data['selectedIndex'] = 20;
    expect(() => AppState.fromJson(data), throwsFormatException);
  });

  test('window events dedupe, switch targets and hide on disconnect', () async {
    final platform = FakePlatform()..displays = [7];
    final bridge = FakeBridge();
    final controller = makeController(bridge: bridge, platform: platform);
    controller.start();
    await flush();
    expect(platform.shown, [7]);
    expect(platform.hidden, [7]); // cleanup a window surviving hot restart
    expect(controller.connected, isFalse);
    for (var i = 0; i < 5; i++) {
      platform.events.add(null);
    }
    await flush();
    expect(platform.shown, [7]);
    platform.displays = [7, 9];
    await controller.refreshDisplays();
    expect(platform.shown, [7]); // retain the current eligible target
    platform.displays = [9];
    await controller.refreshDisplays();
    expect(platform.shown, [7, 9]);
    expect(platform.hidden, [7, 7, 9]);
    platform.displays = [];
    await controller.refreshDisplays();
    expect(platform.hidden, [7, 7, 9, 9]);
    expect(controller.shownDisplayId, isNull);
    expect(platform.maxConcurrent, 1);
    controller.dispose();
    await controller.shutdown();
    await platform.events.close();
  });

  test('no handshake, false result and errors preserve local mode', () async {
    for (final failure in ['timeout', 'false', 'exception', 'query']) {
      final platform = FakePlatform()
        ..displays = [4]
        ..showResult = failure != 'false'
        ..showThrows = failure == 'exception'
        ..listThrows = failure == 'query';
      final controller = makeController(
        bridge: FakeBridge(),
        platform: platform,
      );
      controller.start();
      await flush();
      await Future<void>.delayed(timeout);
      expect(controller.connected, isFalse, reason: failure);
      expect(controller.status, isNotNull, reason: failure);
      controller.dispose();
      await controller.shutdown();
      await platform.events.close();
    }
  });

  test('pending show cannot race events, timeout or disposal cleanup',
      () async {
    final platform = FakePlatform()
      ..displays = [4]
      ..pendingShow = Completer<bool>();
    final controller = makeController(
      bridge: FakeBridge(),
      platform: platform,
    );
    controller.start();
    await flush();
    platform.events.add(null);
    await Future<void>.delayed(timeout);
    expect(controller.connected, isFalse);
    expect(platform.shown, [4]);
    controller.dispose();
    platform.pendingShow!.complete(true);
    await controller.shutdown();
    expect(platform.hidden, [4, 4]);
    expect(platform.maxConcurrent, 1);
    await platform.events.close();
  });

  test('failed hide prevents starting a second native window', () async {
    final platform = FakePlatform()..displays = [4];
    final controller = makeController(
      bridge: FakeBridge(),
      platform: platform,
    );
    controller.start();
    await flush();
    platform
      ..displays = [5]
      ..hideResult = false;
    await controller.refreshDisplays();
    expect(platform.shown, [4]);
    expect(controller.connected, isFalse);
    platform.hideResult = true;
    controller.dispose();
    await controller.shutdown();
    await platform.events.close();
  });

  test('failed hide recovers when the same display becomes the target again',
      () async {
    final platform = FakePlatform()..displays = [4];
    final controller = makeController(
      bridge: FakeBridge(),
      platform: platform,
    );
    controller.start();
    await flush();
    platform
      ..displays = [5]
      ..hideResult = false;
    await controller.refreshDisplays();
    expect(platform.shown, [4]);
    expect(controller.shownDisplayId, 4);
    expect(controller.connected, isFalse);
    platform
      ..displays = [4]
      ..hideResult = true;
    await controller.refreshDisplays();
    expect(platform.shown, [4, 4]);
    expect(platform.hidden, [4, 4, 4, 4]);
    expect(controller.shownDisplayId, 4);
    expect(platform.maxConcurrent, 1);
    // Recreating the same window still requires a fresh handshake.
    expect(controller.connected, isFalse);
    controller.dispose();
    await controller.shutdown();
    expect(platform.hidden, [4, 4, 4, 4, 4]);
    await platform.events.close();
  });

  test('handshake, authority, form behavior and viewer toast', () async {
    final primaryBridge = FakeBridge();
    final secondaryBridge = FakeBridge();
    primaryBridge.peer = secondaryBridge;
    secondaryBridge.peer = primaryBridge;
    final platform = FakePlatform()..displays = [7];
    final primary = makeController(
      bridge: primaryBridge,
      platform: platform,
      session: 'primary',
    );
    final secondary = makeController(
      secondary: true,
      bridge: secondaryBridge,
      platform: FakePlatform(),
      session: 'secondary',
    );
    primary.start();
    await flush();
    secondary.start();
    await flush();
    expect(primary.connected, isTrue);
    expect(secondary.connected, isTrue);
    secondary.intent('projectName', 'Orbit');
    expect(secondary.state.projectName, isEmpty); // no local state authority
    await flush();
    expect(primary.state.projectName, 'Orbit');
    expect(secondary.state.projectName, 'Orbit');
    secondary.intent('saveProject');
    await flush();
    secondary.intent('liveFormPreview', false);
    secondary.intent('projectName', 'Comet');
    await flush();
    expect(primary.state.liveFormPreview, isFalse);
    expect(primary.state.savedProjectName, 'Orbit');
    expect(secondary.state.projectName, 'Comet');
    var toasts = 0;
    primary.onToast = () => toasts++;
    secondary.intent('toast');
    await flush();
    expect(toasts, 1);
    secondary.intent('randomize');
    await flush();
    expect(primary.state.chartData.toSet(), hasLength(5));
    expect(secondary.state.chartData, primary.state.chartData);
    primary.intent('language', 'Python');
    await flush();
    expect(secondary.state.editorLanguage, 'Python');
    final duplicate =
        secondaryBridge.sent.lastWhere((e) => e['type'] == 'intent');
    primaryBridge.inject(jsonEncode(duplicate));
    primaryBridge.inject('{bad');
    primaryBridge
        .inject(jsonEncode({'type': 'snapshot', 'session': 'secondary'}));
    await flush();
    expect(toasts, 1);
    expect(primary.state.editorLanguage, 'Python');
    secondary.dispose();
    primary.dispose();
    await Future.wait([primary.shutdown(), secondary.shutdown()]);
    await platform.events.close();
  });

  test('stale snapshots and malformed input cannot overwrite state', () async {
    final bridge = FakeBridge();
    final controller = makeController(
      secondary: true,
      bridge: bridge,
      platform: FakePlatform(),
      session: 'secondary',
    );
    controller.start();
    bridge.inject(jsonEncode({
      'type': 'welcome',
      'session': 'primary',
      'peer': 'secondary',
      'nonce': 1,
    }));
    await flush();
    Map<String, Object?> snapshot(int sequence, String message) => {
          'type': 'snapshot',
          'session': 'primary',
          'peer': 'secondary',
          'sequence': sequence,
          'state': {...const AppState().toJson(), 'message': message},
        };
    bridge.inject(jsonEncode(snapshot(3, 'new')));
    bridge.inject(jsonEncode(snapshot(2, 'old')));
    bridge.inject(jsonEncode({
      ...snapshot(4, 'invalid'),
      'state': {'chartData': 'bad'}
    }));
    bridge.inject(jsonEncode(
        {...snapshot(5, 'other session'), 'session': 'old-primary'}));
    bridge.inject(12);
    bridge.inject('[]');
    bridge.inject('{');
    await flush();
    expect(controller.state.message, 'new');
    controller.dispose();
    await controller.shutdown();
  });

  test('heartbeat loss restores navigation and cached peer reconnects',
      () async {
    final primaryBridge = FakeBridge();
    final secondaryBridge = FakeBridge();
    primaryBridge.peer = secondaryBridge;
    secondaryBridge.peer = primaryBridge;
    final platform = FakePlatform()..displays = [7];
    final primary = makeController(bridge: primaryBridge, platform: platform);
    final secondary = makeController(
      secondary: true,
      bridge: secondaryBridge,
      platform: FakePlatform(),
    );
    primary.start();
    await flush();
    secondary.start();
    await flush();
    expect(primary.connected, isTrue);
    secondaryBridge.drop = true;
    await Future<void>.delayed(timeout);
    await flush();
    expect(primary.connected, isFalse);
    expect(secondary.connected, isFalse);
    secondaryBridge.drop = false;
    await Future<void>.delayed(heartbeat);
    await flush();
    expect(primary.connected, isTrue);
    expect(platform.shown, [7]);
    primary.dispose();
    await primary.shutdown();
    final newBridge = FakeBridge()..peer = secondaryBridge;
    secondaryBridge.peer = newBridge;
    final restarted = makeController(bridge: newBridge, platform: platform);
    restarted.start();
    await flush();
    await Future<void>.delayed(heartbeat);
    await flush();
    expect(restarted.connected, isTrue);
    restarted.intent('message', 'After restart');
    await flush();
    expect(secondary.state.message, 'After restart');
    secondary.dispose();
    restarted.dispose();
    await Future.wait([restarted.shutdown(), secondary.shutdown()]);
    await platform.events.close();
  });
}
