import 'package:fl_clash/common/community.dart';
import 'package:fl_clash/common/context.dart';
import 'package:material_ui/material_ui.dart';

class CommunityWelcome extends StatelessWidget {
  const CommunityWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.appLocalizations;
    return AlertDialog(
      title: Text(strings.communityChannel),
      content: const SelectableText(communityUrl),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, CommunityChoice.visit),
          child: Text(strings.communityVisit),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, CommunityChoice.hideWelcome),
          child: Text(strings.communityHideWelcome),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, CommunityChoice.skipAutoJump),
          child: Text(strings.communitySkipAutoJump),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, CommunityChoice.close),
          child: Text(strings.close),
        ),
      ],
    );
  }
}
