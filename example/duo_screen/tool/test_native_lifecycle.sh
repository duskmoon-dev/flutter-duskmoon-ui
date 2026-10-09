#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
test_output=$(mktemp -d "${TMPDIR:-/tmp}/duo-native-tests.XXXXXX")
trap 'rm -rf "$test_output"' EXIT
java_bin="${JAVA_HOME:+$JAVA_HOME/bin/}"
"${java_bin}javac" -d "$test_output" \
  android/app/src/main/java/dev/duskmoon/duo_screen/CompanionLifecycle.java \
  android/app/src/test/java/dev/duskmoon/duo_screen/CompanionLifecycleTest.java
"${java_bin}java" -cp "$test_output" dev.duskmoon.duo_screen.CompanionLifecycleTest
