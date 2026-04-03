import 'rope.dart';

// ---------------------------------------------------------------------------
// ChangeSpec
// ---------------------------------------------------------------------------

/// A single edit specification: replace the range [from]..[to] with [insert].
///
/// - Pure insertion: `from == to`
/// - Pure deletion:  [insert] is empty
/// - Replacement:    both `to > from` and [insert] is non-empty
class ChangeSpec {
  const ChangeSpec({required this.from, int? to, this.insert = ''})
      : to = to ?? from;

  /// Convenience constructor for a pure insertion at [pos].
  const ChangeSpec.insert(int pos, String text)
      : from = pos,
        to = pos,
        insert = text;

  /// Start of the replaced range (inclusive).
  final int from;

  /// End of the replaced range (exclusive). Equals [from] for pure insertions.
  final int to;

  /// Text to insert in place of the deleted range.
  final String insert;

  /// Number of characters deleted by this change (`to - from`).
  int get deleteLen => to - from;
}

// ---------------------------------------------------------------------------
// ChangeSet
// ---------------------------------------------------------------------------

/// An immutable, composable representation of one or more document edits.
///
/// Internally stored as two parallel lists:
/// - [_sections]: alternating positive (retain) and non-positive (change) ints.
///   A change entry stores `-(deleteLen)` where `deleteLen >= 0`.
/// - [_inserted]: one string per change entry with the text to insert.
///
/// The critical invariant: every `_Change` entry has a corresponding index in
/// `_inserted`. Retain entries have no corresponding inserted entry.
///
/// To distinguish a zero-length delete from a retain we rely on the structure:
/// change entries are always paired with an `_inserted` index, retain entries
/// are not. We use a separate `_isChange` list to track which sections are
/// changes.
///
/// Mirrors the architecture of CodeMirror 6's `ChangeSet`.
class ChangeSet {
  ChangeSet._(this._retains, this._changes);

  /// Flat list of retain lengths (only positive) and change-section indices.
  /// Encodes as: positive int = retain N chars; -1 = "next change section".
  final List<int> _retains; // parallel encoding (see below)

  // Internal encoding:
  // _retains is actually _plan: a list of either positive ints (retain) or
  // the sentinel -1 (meaning "consume next change from _changes").
  final List<_ChangeEntry> _changes;

  // -------------------------------------------------------------------------
  // Factory
  // -------------------------------------------------------------------------

  /// Creates a [ChangeSet] from a list of [ChangeSpec]s applied to a document
  /// of [docLength] characters.
  ///
  /// The specs must be **sorted** by [ChangeSpec.from] and **non-overlapping**.
  factory ChangeSet.of(int docLength, List<ChangeSpec> changes) {
    final plan = <int>[];
    final entries = <_ChangeEntry>[];
    var cursor = 0;

    for (final spec in changes) {
      assert(spec.from >= cursor, 'Changes must be sorted and non-overlapping');
      assert(spec.from <= spec.to, 'ChangeSpec.from must be <= to');

      final retain = spec.from - cursor;
      if (retain > 0) _planAddRetain(plan, retain);

      plan.add(-1); // sentinel for a change
      entries.add(_ChangeEntry(spec.deleteLen, spec.insert));

      cursor = spec.to;
    }

    final trailing = docLength - cursor;
    if (trailing > 0) _planAddRetain(plan, trailing);

    return ChangeSet._(plan, entries);
  }

  // -------------------------------------------------------------------------
  // Public properties
  // -------------------------------------------------------------------------

  /// Total character count of the *original* document.
  int get oldLength {
    var len = 0;
    var ci = 0;
    for (final p in _retains) {
      if (p > 0) {
        len += p;
      } else {
        len += _changes[ci++].deleteLen;
      }
    }
    return len;
  }

  /// Total character count of the *new* document.
  int get newLength {
    var len = 0;
    var ci = 0;
    for (final p in _retains) {
      if (p > 0) {
        len += p;
      } else {
        len += _changes[ci++].insert.length;
      }
    }
    return len;
  }

  /// Whether this changeset actually modifies the document.
  bool get docChanged {
    for (final c in _changes) {
      if (c.deleteLen > 0 || c.insert.isNotEmpty) return true;
    }
    return false;
  }

  // -------------------------------------------------------------------------
  // Apply
  // -------------------------------------------------------------------------

  /// Applies this changeset to [rope], returning a new [Rope].
  Rope apply(Rope rope) {
    final buf = StringBuffer();
    var pos = 0;
    var ci = 0;
    for (final p in _retains) {
      if (p > 0) {
        buf.write(rope.sliceString(pos, pos + p));
        pos += p;
      } else {
        final c = _changes[ci++];
        buf.write(c.insert);
        pos += c.deleteLen;
      }
    }
    return Rope.fromString(buf.toString());
  }

  // -------------------------------------------------------------------------
  // mapPos
  // -------------------------------------------------------------------------

  /// Maps a position in the old document to its position in the new document.
  ///
  /// [assoc]:
  ///   -  1 (default): at change boundaries, map to *after* inserted text.
  ///   - -1:           at change boundaries, map to *before* inserted text.
  int mapPos(int pos, {int assoc = 1}) {
    var oldPos = 0;
    var newPos = 0;
    var ci = 0;

    for (final p in _retains) {
      if (p > 0) {
        if (oldPos + p > pos) {
          // pos is inside this retain block.
          return newPos + (pos - oldPos);
        }
        if (oldPos + p == pos) {
          // pos is exactly at the end of this retain — could be at start of
          // next change.
          oldPos += p;
          newPos += p;
          continue;
        }
        oldPos += p;
        newPos += p;
      } else {
        final c = _changes[ci++];
        final del = c.deleteLen;
        final ins = c.insert;

        if (del == 0) {
          // Pure insertion (doesn't consume old-doc chars).
          if (pos == oldPos) {
            return assoc < 0 ? newPos : newPos + ins.length;
          }
          newPos += ins.length;
        } else {
          // Change that consumes [del] old-doc chars.
          if (pos == oldPos) {
            return assoc < 0 ? newPos : newPos + ins.length;
          }
          if (pos < oldPos + del) {
            // pos is inside deleted range.
            return assoc < 0 ? newPos : newPos + ins.length;
          }
          oldPos += del;
          newPos += ins.length;
        }
      }
    }

    return newPos + (pos - oldPos);
  }

  // -------------------------------------------------------------------------
  // compose
  // -------------------------------------------------------------------------

  /// Composes this changeset (applied first) with [other] (applied second)
  /// into a single changeset producing the same result.
  ///
  /// Precondition: `this.newLength == other.oldLength`.
  ChangeSet compose(ChangeSet other) {
    assert(
      newLength == other.oldLength,
      'compose: this.newLength ($newLength) must equal other.oldLength '
      '(${other.oldLength})',
    );

    // We iterate over the "middle document" — the new doc of `this` = old doc
    // of `other`. Both changesets are expanded into a stream of ops:
    //
    //   A-side (this):  retainA(n) | changeA(del, ins)
    //   B-side (other): retainB(n) | changeB(del, ins)
    //
    // A-side produces the middle doc; B-side consumes it.
    //
    // Output rules:
    //   retainA + retainB  → retain min(n,m)
    //   changeA + retainB  → keep changeA (its delete is against old doc)
    //   any    + changeB   → merge: B's delete eats A's middle chars, B inserts
    //   retainA + changeB  → changeB deletes middle chars; emit change(del=A chars eaten, ins=B ins)

    final outPlan = <int>[];
    final outChanges = <_ChangeEntry>[];

    // Iterators.
    var ai = 0;
    var aOff = 0; // offset within current A plan entry (for retain) or insert (for change)
    var aci = 0; // index into _changes for A
    var bci = 0;

    // Pending output accumulator.
    var pendingOldDel = 0;
    var pendingNewIns = StringBuffer();

    void flushPending() {
      if (pendingOldDel > 0 || pendingNewIns.isNotEmpty) {
        outPlan.add(-1);
        outChanges.add(_ChangeEntry(pendingOldDel, pendingNewIns.toString()));
        pendingOldDel = 0;
        pendingNewIns = StringBuffer();
      }
    }

    // Consume n chars of the middle doc from A's output, folding into pending.
    // `fromOther` = true means B is deleting these chars (skip A's insert).
    // `fromOther` = false means B is retaining; emit A's structure.
    void consumeAMiddle(int n, {required bool bDeletes}) {
      var rem = n;
      while (rem > 0) {
        if (ai >= _retains.length) break;
        final p = _retains[ai];

        if (p > 0) {
          // A retain: these middle chars = old-doc chars passed through.
          final avail = p - aOff;
          final take = rem < avail ? rem : avail;

          if (bDeletes) {
            // B is eating these: they become deletions in the output.
            pendingOldDel += take;
          } else {
            // B retains: output a retain.
            flushPending();
            _planAddRetain(outPlan, take);
          }

          aOff += take;
          rem -= take;
          if (aOff >= p) {
            aOff = 0;
            ai++;
          }
        } else {
          // A change: it has a delete (against old doc) and an insert (middle chars).
          final c = _changes[aci];

          // First handle the delete part of A's change (if not already emitted).
          // The delete is emitted regardless of what B does.
          if (aOff == 0) {
            // Just entering this change — accumulate its old-doc deletion.
            pendingOldDel += c.deleteLen;
          }

          // Now consume from A's insert (which are middle chars).
          final insAvail = c.insert.length - aOff;
          final take = rem < insAvail ? rem : insAvail;

          if (!bDeletes) {
            // B retains these inserted chars: emit them as inserted.
            pendingNewIns.write(c.insert.substring(aOff, aOff + take));
          }
          // If bDeletes: these chars vanish — don't emit them.

          aOff += take;
          rem -= take;

          if (aOff >= c.insert.length) {
            // Finished this A change.
            if (insAvail == 0 && aOff == 0) {
              // Zero-length insert: still advance.
              pendingOldDel += c.deleteLen; // already handled if aOff==0 above
            }
            flushPending();
            aOff = 0;
            aci++;
            ai++;
          }
        }
      }
    }

    // Main loop over B.
    for (var bi = 0; bi < other._retains.length; bi++) {
      final bp = other._retains[bi];

      if (bp > 0) {
        // B retains bp middle chars: copy A's structure for those chars.
        consumeAMiddle(bp, bDeletes: false);
      } else {
        // B change: delete bDel middle chars, then insert bIns.
        final bc = other._changes[bci++];
        if (bc.deleteLen > 0) {
          consumeAMiddle(bc.deleteLen, bDeletes: true);
        }
        // Append B's insertion to pending.
        if (bc.insert.isNotEmpty) {
          pendingNewIns.write(bc.insert);
        }
        flushPending();
      }
    }

    // Emit any remaining A sections (B is exhausted).
    while (ai < _retains.length) {
      final p = _retains[ai];
      if (p > 0) {
        final avail = p - aOff;
        _planAddRetain(outPlan, avail);
        aOff = 0;
        ai++;
      } else {
        final c = _changes[aci];
        if (aOff == 0) {
          outPlan.add(-1);
          outChanges.add(c);
        } else {
          // Partially consumed change.
          outPlan.add(-1);
          outChanges.add(_ChangeEntry(0, c.insert.substring(aOff)));
        }
        aOff = 0;
        aci++;
        ai++;
      }
    }

    if (pendingOldDel > 0 || pendingNewIns.isNotEmpty) {
      outPlan.add(-1);
      outChanges.add(_ChangeEntry(pendingOldDel, pendingNewIns.toString()));
    }

    return ChangeSet._(outPlan, outChanges);
  }

  // -------------------------------------------------------------------------
  // invert
  // -------------------------------------------------------------------------

  /// Creates the inverse: applying it to `apply(originalDoc)` restores
  /// [originalDoc].
  ChangeSet invert(Rope originalDoc) {
    final invPlan = <int>[];
    final invChanges = <_ChangeEntry>[];
    var pos = 0;
    var ci = 0;

    for (final p in _retains) {
      if (p > 0) {
        _planAddRetain(invPlan, p);
        pos += p;
      } else {
        final c = _changes[ci++];
        // Original: delete c.deleteLen chars, insert c.insert.
        // Inverse:  delete c.insert.length chars, insert original deleted text.
        final originalText =
            c.deleteLen > 0
                ? originalDoc.sliceString(pos, pos + c.deleteLen)
                : '';
        invPlan.add(-1);
        invChanges.add(_ChangeEntry(c.insert.length, originalText));
        pos += c.deleteLen;
      }
    }

    return ChangeSet._(invPlan, invChanges);
  }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  static void _planAddRetain(List<int> plan, int n) {
    if (n <= 0) return;
    if (plan.isNotEmpty && plan.last > 0) {
      plan[plan.length - 1] += n;
    } else {
      plan.add(n);
    }
  }

  @override
  String toString() {
    final sb = StringBuffer('ChangeSet([');
    var ci = 0;
    for (var i = 0; i < _retains.length; i++) {
      if (i > 0) sb.write(', ');
      final p = _retains[i];
      if (p > 0) {
        sb.write('retain($p)');
      } else {
        final c = _changes[ci++];
        sb.write('change(del=${c.deleteLen}, ins="${c.insert}")');
      }
    }
    sb.write('])');
    return sb.toString();
  }
}

// ---------------------------------------------------------------------------
// _ChangeEntry  (internal)
// ---------------------------------------------------------------------------

class _ChangeEntry {
  const _ChangeEntry(this.deleteLen, this.insert);
  final int deleteLen;
  final String insert;
}
