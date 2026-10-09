import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

const communityUrl = 'https://t.me/qianbeibuzu';

enum CommunityChoice { visit, hideWelcome, skipAutoJump, close }

class CommunityLaunch {
  static const hideWelcomeKey = 'community.hideWelcome';
  static const skipAutoJumpKey = 'community.skipAutoJump';
  bool _started = false;

  Future<void> run({
    required SharedPreferences preferences,
    required Future<CommunityChoice?> Function() showWelcome,
    required Future<void> Function() openChannel,
  }) async {
    if (_started) return;
    _started = true;
    CommunityChoice? choice;
    if (!(preferences.getBool(hideWelcomeKey) ?? false)) {
      choice = await showWelcome();
      if (choice == CommunityChoice.hideWelcome) {
        await preferences.setBool(hideWelcomeKey, true);
      }
      if (choice == CommunityChoice.skipAutoJump) {
        await preferences.setBool(skipAutoJumpKey, true);
      }
    }
    if (choice == CommunityChoice.visit ||
        !(preferences.getBool(skipAutoJumpKey) ?? false)) {
      await openChannel();
    }
  }
}

final communityLaunch = CommunityLaunch();

Future<void> openCommunityChannel() async {
  await launchUrl(
    Uri.parse(communityUrl),
    mode: LaunchMode.externalApplication,
  );
}
