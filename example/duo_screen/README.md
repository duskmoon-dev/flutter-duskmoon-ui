# DuskMoon Duo Screen

An Android presentation-display demo: the primary screen shows DuskMoon widgets,
forms, a chart, and a themed code editor; an external display controls them.
Web, macOS, Linux, Windows, and iOS run the same interactive single-screen demo
without calling `presentation_displays`. iOS is deliberately not enabled: the
plugin's iOS implementation starts its default entry point and needs additional
native setup, unlike the Android contract used here.

## Run on Android

From the workspace root:

```sh
dart pub get
cd example/duo_screen
flutter run -d <android-device-id>
```

On an Android emulator or compatible device, enable Developer options, select
**Simulate secondary displays** (sometimes **Simulated secondary displays**),
and select an external display size. The example queries only Android's
`DISPLAY_CATEGORY_PRESENTATION` displays and uses the first eligible display,
retaining the current target while it remains eligible. A real HDMI or wireless
presentation display works through the same plugin API. Remove the simulated
display to test disconnect recovery. Device-specific display behavior needs a
real Android run; widget tests simulate the platform boundary.

## Two-engine lifecycle

`main` starts the viewer. Android `presentation_displays` 1.0.0 always executes
the annotated `secondaryDisplayMain` Dart entry point for its cached companion
engine. `routerName: secondaryDisplayMain` is both its engine-cache key and its
initial route; the app declares that route explicitly.

`DuoDisplayController` serializes window changes and tracks the shown display.
Repeated display events do not show another window. The previous window is
hidden before switching targets, including a window retained across primary
hot restart. A failed hide prevents creating another window. A successful native
show alone does not remove primary navigation: both engines must complete a
hello/welcome/ready handshake first. A five-second handshake or heartbeat timeout
restores local navigation. Pending native mutations are not retried, even after
the UI watchdog expires, so slow native calls cannot create overlapping windows.

Both engines register named ports and resolve the peer on every send. Companion
hello messages repeat every second, letting a cached engine discover a restarted
primary. The plugin's built-in transfer channel is one-way, so the sample uses
`IsolateNameServer` for two-way intents and snapshots. Only JSON strings cross
engine/isolate-group boundaries. Session IDs, handshake nonces and monotonic
sequences reject stale snapshots and repeated commands; malformed data is ignored.
The primary is the sole state authority. The companion submits intents and waits
for authoritative snapshots before changing its state. Disposal closes ports,
subscriptions and timers, then hides the window after any pending mutation.

## Shared controls

The navigation categories are Widgets, Forms, Charts and Editor. The primary
retains usable controls in single-screen mode. Companion **Fire Toast** submits
an intent and shows the toast on the viewer. **Randomize Data** generates five
independent random chart values. Editor languages are Dart, Python and JavaScript;
selecting a language replaces the read-only sample and its syntax highlighting
through the public themed `DmCodeEditor`.

Both screens share the project draft, saved project and **Live form preview**
setting. With preview enabled, the viewer displays the current shared draft.
With preview disabled, it displays the last saved project; **Save Configuration**
commits the draft. This setting controls the preview, not bridge connectivity.
The app uses `DuskmoonApp` as its platform-style provider around a system-themed
`MaterialApp`, as required by the current public API. The AppBar is visible at
all widths. An external-display role is set only after companion handshake;
foldable layouts remain the adaptive scaffold's responsibility.

## Validate

```sh
flutter test
dart analyze --fatal-infos
```

Tests inject fake display and bridge implementations for show/hide deduplication,
handshake, failed calls, timeout, restart, malformed/stale messages, primary-only
state authority, form semantics and viewer toasts. Widget tests cover compact
and expanded AppBars/navigation, form controls, languages and companion routing.
