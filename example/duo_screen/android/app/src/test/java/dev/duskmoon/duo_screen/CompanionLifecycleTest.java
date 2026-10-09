package dev.duskmoon.duo_screen;

/** Dependency-free native regression checks; run with tool/test_native_lifecycle.sh. */
public final class CompanionLifecycleTest {
    public static void main(String[] args) {
        check(!CompanionLifecycle.eligible(0, 6, true), "exclude default display");
        check(!CompanionLifecycle.eligible(6, 6, true), "exclude Activity host");
        check(!CompanionLifecycle.eligible(7, 0, false), "exclude non-presentation display");
        check(CompanionLifecycle.eligible(6, 0, true), "allow eligible external display");

        CompanionLifecycle state = new CompanionLifecycle();
        long first = state.show(6);
        check(!state.needsLaunch() && state.show(6) == first, "dedupe pending show");
        check(state.attach(first), "attach pending host");
        check(!state.attach(first), "reject duplicate host");
        check(state.show(6) == first && !state.needsLaunch(), "dedupe visible/resumed show");
        rejectShow(state, 7);
        check(state.close() && state.close(), "hide waits for Activity detach, idempotently");
        rejectShow(state, 6);
        state.detached(false);
        check(state.needsLaunch() && !state.close(), "detached/duplicate hide is complete");

        long second = state.show(7);
        check(second > first && !state.attach(first), "reject stale launch generation");
        check(state.close() && !state.attach(second), "cancel launch before onCreate");
        check(state.isClosing() && !state.needsLaunch(), "cancelled launch still awaits detach");
        state.detached(false);
        long third = state.show(6);
        check(state.attach(third), "reopen after finish");
        state.detached(true);
        check(!state.needsLaunch() && state.attach(third), "configuration recreates same host generation");
        check(state.close(), "close before configuration teardown");
        state.detached(true);
        check(state.needsLaunch() && state.displayId() == null, "close beats configuration recreation");
        state.show(6);
        state.launchFailed();
        check(state.needsLaunch() && state.displayId() == null, "failed native start releases pending slot");
        System.out.println("CompanionLifecycle: 20 assertions passed");
    }

    private static void rejectShow(CompanionLifecycle state, int displayId) {
        try {
            state.show(displayId);
            throw new AssertionError("must detach before another show");
        } catch (IllegalStateException expected) {
            // Expected invariant, including attempted reuse while closing.
        }
    }

    private static void check(boolean condition, String message) {
        if (!condition) throw new AssertionError(message);
    }
}
