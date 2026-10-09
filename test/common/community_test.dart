import 'package:fl_clash/common/community.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final hide in [false, true]) {
    for (final skip in [false, true]) {
      test('independent preferences hide=$hide skip=$skip', () async {
        SharedPreferences.setMockInitialValues({
          CommunityLaunch.hideWelcomeKey: hide,
          CommunityLaunch.skipAutoJumpKey: skip,
        });
        final preferences = await SharedPreferences.getInstance();
        final launch = CommunityLaunch();
        var welcomes = 0;
        var visits = 0;
        Future<void> run() => launch.run(
          preferences: preferences,
          showWelcome: () async {
            welcomes++;
            return CommunityChoice.close;
          },
          openChannel: () async { visits++; },
        );
        await run();
        await run();
        expect(welcomes, hide ? 0 : 1);
        expect(visits, skip ? 0 : 1);
        expect(preferences.getBool(CommunityLaunch.hideWelcomeKey), hide);
        expect(preferences.getBool(CommunityLaunch.skipAutoJumpKey), skip);
      });
    }
  }

  for (final choice in CommunityChoice.values) {
    test('persists only selected opt-out: $choice', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      var visits = 0;
      await CommunityLaunch().run(
        preferences: preferences,
        showWelcome: () async => choice,
        openChannel: () async { visits++; },
      );
      expect(preferences.getBool(CommunityLaunch.hideWelcomeKey) ?? false,
          choice == CommunityChoice.hideWelcome);
      expect(preferences.getBool(CommunityLaunch.skipAutoJumpKey) ?? false,
          choice == CommunityChoice.skipAutoJump);
      expect(visits, choice == CommunityChoice.skipAutoJump ? 0 : 1);
      await preferences.reload();
      expect(preferences.getBool(CommunityLaunch.hideWelcomeKey) ?? false,
          choice == CommunityChoice.hideWelcome);
      expect(preferences.getBool(CommunityLaunch.skipAutoJumpKey) ?? false,
          choice == CommunityChoice.skipAutoJump);
    });
  }

  test('failed external launch cannot retrigger on resume', () async {
    SharedPreferences.setMockInitialValues({CommunityLaunch.hideWelcomeKey: true});
    final preferences = await SharedPreferences.getInstance();
    final launch = CommunityLaunch();
    var attempts = 0;
    Future<void> run() => launch.run(
      preferences: preferences,
      showWelcome: () async => CommunityChoice.close,
      openChannel: () async {
        attempts++;
        throw StateError('unavailable');
      },
    );
    await expectLater(run(), throwsStateError);
    await run();
    expect(attempts, 1);
  });
}
