import 'package:fl_clash/common/community.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/widgets/community_welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final entry in {
    '前往频道': CommunityChoice.visit,
    '不再提醒': CommunityChoice.hideWelcome,
    '下次不再进入': CommunityChoice.skipAutoJump,
    '关闭': CommunityChoice.close,
  }.entries) {
    testWidgets('welcome action ${entry.key}', (tester) async {
      CommunityChoice? result;
      await tester.pumpWidget(MaterialApp(
        locale: const Locale('zh', 'CN'),
        supportedLocales: AppLocalizations.delegate.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        home: Builder(builder: (context) => TextButton(
          onPressed: () async {
            result = await showDialog<CommunityChoice>(
              context: context,
              builder: (_) => const CommunityWelcome(),
            );
          },
          child: const Text('show'),
        )),
      ));
      await tester.tap(find.text('show'));
      await tester.pumpAndSettle();
      expect(find.text(communityUrl), findsOneWidget);
      expect(find.text('TG频道'), findsOneWidget);
      await tester.tap(find.text(entry.key));
      await tester.pumpAndSettle();
      expect(result, entry.value);
      expect(find.text('show'), findsOneWidget);
      expect(find.byType(CommunityWelcome), findsNothing);
    });
  }
}
