// Unit tests for the `streaming_text` primitive engine: unit splitting,
// snapshot revisions, the markdown partition, reveal timing and the section
// cache. Widget-level behaviour (ticker, reduced motion, theme legs) is
// covered by the `text_animate` component tests.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/streaming_text/streaming_text.dart';
import 'package:flutter_test/flutter_test.dart';

int _stableOf(String pending) => pending.length;

void main() {
  group('splitting', () {
    test('chars split per rune, emoji-safe', () {
      expect(splitStreamingChars(''), isEmpty);
      expect(splitStreamingChars('aB'), const <String>['a', 'B']);
      expect(splitStreamingChars('a👍b'), const <String>['a', '👍', 'b']);
    });

    test('words keep every character and join back exactly', () {
      expect(splitStreamingWords(''), isEmpty);
      const value = '  hi  there \nnow';
      final units = splitStreamingWords(value);
      expect(units.join(), value);
      expect(units.first, '  ');
      expect(units, contains('hi  '));
    });

    test('shared prefix counts equal leading units', () {
      expect(
        sharedStreamingPrefix(
          const <String>['a', 'b'],
          const <String>['a', 'c'],
        ),
        1,
      );
      expect(
        sharedStreamingPrefix(const <String>['a'], const <String>['a']),
        1,
      );
      expect(sharedStreamingPrefix(const <String>[], const <String>['a']), 0);
    });
  });

  group('StreamingSnapshot', () {
    test('initial revision animates everything', () {
      final snapshot = StreamingSnapshot.initial('hi');
      expect(snapshot.fullText, 'hi');
      expect(snapshot.stableChars, isEmpty);
      expect(snapshot.animatedChars, const <String>['h', 'i']);
      expect(snapshot.revision, 0);
    });

    test('append keeps the shared prefix stable', () {
      var snapshot = StreamingSnapshot.initial('Hello');
      snapshot = snapshot.update(
        nextText: 'Hello world',
        now: const Duration(milliseconds: 10),
      );
      expect(snapshot.stableChars.join(), 'Hello');
      expect(snapshot.animatedChars.join(), ' world');
      expect(snapshot.changedAt, const Duration(milliseconds: 10));
      expect(snapshot.revision, 1);
    });

    test('non-append edit restarts from scratch', () {
      var snapshot = StreamingSnapshot.initial('Hello');
      snapshot = snapshot.update(
        nextText: 'Jello',
        now: const Duration(milliseconds: 10),
      );
      expect(snapshot.stableChars, isEmpty);
      expect(snapshot.animatedChars.join(), 'Jello');
    });

    test('empty next text settles immediately', () {
      var snapshot = StreamingSnapshot.initial('Hello');
      snapshot = snapshot.update(nextText: '', now: Duration.zero);
      expect(snapshot.animatedChars, isEmpty);
    });
  });

  group('StreamingMarkdownSplit', () {
    StreamingMarkdownSplit split() =>
        StreamingMarkdownSplit(stableLengthOf: _stableOf);

    test('force reset promotes the stable run', () {
      final s = split()
        ..applyIncoming(
          'ab',
          forceReset: true,
          animateByWord: false,
          now: Duration.zero,
        );
      expect(s.source, 'ab');
      expect(s.committed, 'ab');
      expect(s.pending, isEmpty);
      expect(s.animatedUnits, isEmpty);
    });

    test('append promotes newly stable runs and retargets the tail', () {
      var stable = 0;
      final s = StreamingMarkdownSplit(
        stableLengthOf: (pending) => stable.clamp(0, pending.length).toInt(),
      );
      s.applyIncoming(
        'ab',
        forceReset: true,
        animateByWord: false,
        now: Duration.zero,
      );
      expect(s.pending, 'ab');
      expect(s.animatedUnits.join(), 'ab');
      stable = 2;
      s.applyIncoming(
        'abcd',
        forceReset: false,
        animateByWord: false,
        now: const Duration(milliseconds: 5),
      );
      expect(s.committed, 'ab');
      expect(s.pending, 'cd');
      expect(s.animatedUnits.join(), 'cd');
      expect(s.changedAt, const Duration(milliseconds: 5));
    });

    test('append inside the unstable region keeps the shared prefix', () {
      final t = StreamingMarkdownSplit(stableLengthOf: (_) => 0)
        ..applyIncoming(
          'abc',
          forceReset: true,
          animateByWord: false,
          now: Duration.zero,
        );
      expect(t.pending, 'abc');
      t.applyIncoming(
        'abcd',
        forceReset: false,
        animateByWord: false,
        now: const Duration(milliseconds: 5),
      );
      expect(t.stableUnits.join(), 'abc');
      expect(t.animatedUnits.join(), 'd');
    });

    test('non-append edit resets from scratch', () {
      final s = split()
        ..applyIncoming(
          'abc',
          forceReset: true,
          animateByWord: false,
          now: Duration.zero,
        )
        ..applyIncoming(
          'xbc',
          forceReset: false,
          animateByWord: false,
          now: const Duration(milliseconds: 5),
        );
      expect(s.committed, 'xbc');
      expect(s.pending, isEmpty);
    });

    test('identical re-apply is a no-op', () {
      final s = StreamingMarkdownSplit(stableLengthOf: (_) => 0)
        ..applyIncoming(
          'abc',
          forceReset: true,
          animateByWord: false,
          now: Duration.zero,
        );
      final changedAt = s.changedAt;
      s.applyIncoming(
        'abc',
        forceReset: false,
        animateByWord: false,
        now: const Duration(milliseconds: 9),
      );
      expect(s.changedAt, changedAt);
      expect(s.pending, 'abc');
    });
  });
  group('timing', () {
    test('visible count paces the typewriter', () {
      const cps = 10.0;
      expect(
        streamingVisibleCount(
          total: 6,
          elapsed: Duration.zero,
          enabled: true,
          charsPerSecond: cps,
        ),
        1,
      );
      expect(
        streamingVisibleCount(
          total: 6,
          elapsed: const Duration(milliseconds: 100),
          enabled: true,
          charsPerSecond: cps,
        ),
        2,
      );
      expect(
        streamingVisibleCount(
          total: 6,
          elapsed: const Duration(seconds: 10),
          enabled: true,
          charsPerSecond: cps,
        ),
        6,
      );
      expect(
        streamingVisibleCount(
          total: 0,
          elapsed: const Duration(seconds: 1),
          enabled: true,
          charsPerSecond: cps,
        ),
        0,
      );
      expect(
        streamingVisibleCount(
          total: 6,
          elapsed: Duration.zero,
          enabled: false,
          charsPerSecond: cps,
        ),
        6,
      );
    });

    test('reveal delay waits for the typewriter per unit', () {
      expect(
        streamingRevealDelay(0, enabled: true, charsPerSecond: 10),
        Duration.zero,
      );
      expect(
        streamingRevealDelay(10, enabled: true, charsPerSecond: 10),
        const Duration(seconds: 1),
      );
      expect(
        streamingRevealDelay(5, enabled: false, charsPerSecond: 10),
        Duration.zero,
      );
      expect(
        streamingUnitAge(
          elapsed: const Duration(milliseconds: 1500),
          index: 10,
          enabled: true,
          charsPerSecond: 10,
        ),
        const Duration(milliseconds: 500),
      );
      expect(
        streamingNewestAge(
          elapsed: const Duration(milliseconds: 1500),
          visible: 0,
          enabled: true,
          charsPerSecond: 10,
        ),
        const Duration(milliseconds: 1500),
      );
    });

    test('progress normalizes and clamps', () {
      expect(
        streamingProgress(
          age: Duration.zero,
          duration: Duration.zero,
          curve: Curves.linear,
        ),
        1,
      );
      expect(
        streamingProgress(
          age: const Duration(milliseconds: 100),
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear,
        ),
        0.5,
      );
      expect(
        streamingProgress(
          age: const Duration(seconds: 5),
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear,
        ),
        1,
      );
    });

    test('settled needs every unit revealed and aged', () {
      expect(
        streamingIsSettled(
          elapsed: Duration.zero,
          totalAnimated: 0,
          visibleAnimated: 0,
          typewriterEnabled: true,
          charsPerSecond: 10,
          settleDuration: const Duration(milliseconds: 200),
        ),
        isTrue,
      );
      expect(
        streamingIsSettled(
          elapsed: const Duration(seconds: 1),
          totalAnimated: 3,
          visibleAnimated: 2,
          typewriterEnabled: true,
          charsPerSecond: 10,
          settleDuration: const Duration(milliseconds: 200),
        ),
        isFalse,
      );
      expect(
        streamingIsSettled(
          elapsed: const Duration(seconds: 1),
          totalAnimated: 3,
          visibleAnimated: 3,
          typewriterEnabled: false,
          charsPerSecond: 10,
          settleDuration: Duration.zero,
        ),
        isTrue,
      );
      expect(
        streamingIsSettled(
          elapsed: const Duration(milliseconds: 100),
          totalAnimated: 1,
          visibleAnimated: 1,
          typewriterEnabled: false,
          charsPerSecond: 10,
          settleDuration: const Duration(milliseconds: 200),
        ),
        isFalse,
      );
      expect(
        streamingIsSettled(
          elapsed: const Duration(milliseconds: 300),
          totalAnimated: 1,
          visibleAnimated: 1,
          typewriterEnabled: false,
          charsPerSecond: 10,
          settleDuration: const Duration(milliseconds: 200),
        ),
        isTrue,
      );
    });

    test('blink phase splits the period in half', () {
      expect(
        streamingCursorBlinkOn(now: Duration.zero, blinkPeriod: Duration.zero),
        isTrue,
      );
      expect(
        streamingCursorBlinkOn(
          now: const Duration(milliseconds: 100),
          blinkPeriod: const Duration(milliseconds: 650),
        ),
        isTrue,
      );
      expect(
        streamingCursorBlinkOn(
          now: const Duration(milliseconds: 400),
          blinkPeriod: const Duration(milliseconds: 650),
        ),
        isFalse,
      );
    });
  });

  group('spans and cache', () {
    test('character span sits on the alphabetic baseline', () {
      final span = streamingCharacterSpan(child: const SizedBox());
      expect(span, isA<WidgetSpan>());
      expect((span as WidgetSpan).alignment, PlaceholderAlignment.baseline);
    });

    test('cursor span merges the override over the base', () {
      const base = TextStyle(fontSize: 14);
      const override = TextStyle(fontWeight: FontWeight.bold);
      final span = streamingCursorSpan(
        character: '|',
        baseStyle: base,
        cursorStyle: override,
      );
      expect(span, isA<TextSpan>());
      final style = (span as TextSpan).style!;
      expect(style.fontSize, 14);
      expect(style.fontWeight, FontWeight.bold);
    });

    test('section cache rebuilds on new data only', () {
      final cache = StreamingSectionCache();
      var builds = 0;
      Widget build(String data) {
        builds += 1;
        return Text(data, textDirection: TextDirection.ltr);
      }

      final first = cache.render('a', build);
      expect(builds, 1);
      expect(identical(cache.render('a', build), first), isTrue);
      expect(builds, 1);
      cache.render('b', build);
      expect(builds, 2);
      cache.invalidate();
      cache.render('b', build);
      expect(builds, 3);
    });
  });
}
