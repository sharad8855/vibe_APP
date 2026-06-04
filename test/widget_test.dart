import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vibe/main.dart';

void main() {
  testWidgets('Edito login screen renders', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    await tester.pumpWidget(const EditoApp());

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Welcome back!'), findsOneWidget);
    expect(find.text('Mobile Number'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);

    await tester.enterText(find.byType(EditableText), '9876543210');
    await tester.pump();

    expect(find.text('9876543210'), findsOneWidget);
  });

  testWidgets('Continue opens verify OTP screen', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    await tester.pumpWidget(const EditoApp());

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.byType(VerifyOtpScreen), findsOneWidget);
    expect(find.text('Verify OTP'), findsOneWidget);
    expect(find.text('Enter 6-digit OTP'), findsOneWidget);
    expect(find.text('Verify & Continue'), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('otp_input')), '123456');
    await tester.pump();

    for (final digit in ['1', '2', '3', '4', '5', '6']) {
      expect(find.text(digit), findsOneWidget);
    }
  });

  testWidgets('Verify opens home screen', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    await tester.pumpWidget(const EditoApp());

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Verify & Continue'));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Become a Creator &\nEarn Forever'), findsOneWidget);
    expect(find.text('Trending Now'), findsOneWidget);
    expect(find.text('Wanderlust Journey'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Browse'), findsOneWidget);
    expect(find.text('My Videos'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    await tester.tap(find.text('Wanderlust Journey').first);
    await tester.pumpAndSettle();

    expect(find.byType(TemplateDetailScreen), findsOneWidget);
    expect(find.text('Use This Template'), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -560));
    await tester.pumpAndSettle();

    expect(find.text('What You Need'), findsOneWidget);
    expect(find.text('Preview by Other Users'), findsOneWidget);
    expect(find.text('Reviews (5.1K)'), findsOneWidget);

    await tester.tap(find.text('Use This Template'));
    await tester.pumpAndSettle();

    expect(find.byType(UseTemplateScreen), findsOneWidget);
    expect(find.text('Upload Required Assets'), findsOneWidget);
    expect(find.text('Travel Video'), findsOneWidget);
    expect(find.text('Cover Photo'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Title Text'),
      320,
      scrollable: find.byType(Scrollable),
    );
    await tester.pumpAndSettle();

    expect(find.text('Title Text'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Tips for best results'),
      320,
      scrollable: find.byType(Scrollable),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tips for best results'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Continue with Preview'),
      360,
      scrollable: find.byType(Scrollable),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue with Preview'));
    await tester.pumpAndSettle();

    expect(find.byType(PreviewCustomizeScreen), findsOneWidget);
    expect(find.text('Review Your Content'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Video Settings'),
      360,
      scrollable: find.byType(Scrollable),
    );
    await tester.pumpAndSettle();

    expect(find.text('Video Settings'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('AI Magic'),
      360,
      scrollable: find.byType(Scrollable),
    );
    await tester.pumpAndSettle();

    expect(find.text('AI Magic'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Generate Video'),
      360,
      scrollable: find.byType(Scrollable),
    );
    await tester.pumpAndSettle();

    expect(find.text('Generate Video'), findsOneWidget);

    await tester.tap(find.text('Generate Video'));
    await tester.pumpAndSettle();

    expect(find.byType(PreviewTemplateScreen), findsOneWidget);
    expect(find.text('Preview Template'), findsOneWidget);
    expect(find.text('Scene Breakdown'), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -520));
    await tester.pumpAndSettle();

    expect(find.text('Template Flow (Your Assets)'), findsOneWidget);
    expect(find.text('AI Quality Check'), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -900));
    await tester.pumpAndSettle();

    expect(find.text('Output Information'), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -520));
    await tester.pumpAndSettle();

    expect(find.text('Generate Final Video'), findsOneWidget);

    await tester.tap(find.text('Generate Final Video'));
    await tester.pumpAndSettle();

    expect(find.byType(GenerateVideoScreen), findsOneWidget);
    expect(find.text('Generating Your Video'), findsOneWidget);
    expect(find.text('AI is working its magic'), findsOneWidget);
    expect(find.text('Preparing Your Assets'), findsOneWidget);
    expect(find.text('Go to My Videos'), findsOneWidget);
    expect(find.text("Please don't close the app"), findsOneWidget);

    await tester.tap(find.text("Please don't close the app"));
    await tester.pumpAndSettle();

    expect(find.byType(VideoReadyScreen), findsOneWidget);
    expect(find.text('Your Video is Ready!'), findsOneWidget);
    expect(find.text('Download'), findsOneWidget);
    expect(find.text('Create Another Video'), findsOneWidget);
    expect(find.text('Saved to My Videos'), findsOneWidget);
    expect(find.text('Share Now'), findsOneWidget);

    await tester.tap(find.text('Go to My Videos'));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(MyVideosScreen), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Wanderlust Journey').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Use This Template'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue with Preview'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Generate Video'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Generate Final Video'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Go to My Videos'));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(MyVideosScreen), findsOneWidget);
    expect(find.text("All videos you've created or edited"), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Wanderlust Journey').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Use This Template'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue with Preview'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Generate Video'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Browse'));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(
      find.text('Discover thousands of stunning templates'),
      findsOneWidget,
    );
    expect(
      find.text('Search templates, categories or creators'),
      findsOneWidget,
    );
    expect(find.text('Featured Collections'), findsOneWidget);
    expect(find.text('Trending Templates'), findsOneWidget);
    expect(find.text('Summer\nVibes'), findsOneWidget);
    expect(find.text('by Rohit Creative'), findsOneWidget);

    await tester.tap(find.text('My Videos'));
    await tester.pumpAndSettle();

    expect(find.byType(MyVideosScreen), findsOneWidget);
    expect(find.text("All videos you've created or edited"), findsOneWidget);
    expect(find.text('Sort by:'), findsOneWidget);
    expect(find.text('Last Modified'), findsOneWidget);
    expect(find.text('Grid View'), findsOneWidget);
    expect(find.text('Memories Forever'), findsOneWidget);
    expect(find.text('Party Night Vibes'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(
      find.text('Manage your account, templates and more'),
      findsOneWidget,
    );
    expect(find.text('Rohit Creative'), findsOneWidget);
    expect(find.text('Edito Pro'), findsOneWidget);
    expect(find.text('Upgrade Now'), findsOneWidget);
    expect(find.text('Creator Tools'), findsOneWidget);
    expect(find.text('Create Template'), findsOneWidget);
    expect(find.text('Account Settings'), findsOneWidget);
    expect(find.text('Privacy & Security'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.notifications_none_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(NotificationsScreen), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Template Approved'), findsOneWidget);
    expect(find.text('New Purchase'), findsOneWidget);
    expect(find.text('Mark all as read'), findsOneWidget);
    expect(find.text('Welcome to Edito'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsScreen), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('rohitcreative@gmail.com'), findsOneWidget);
    expect(find.text('Download Quality'), findsOneWidget);
    expect(find.text('Default Template Settings'), findsOneWidget);
    expect(find.text('Clear Cache'), findsOneWidget);
    expect(find.text('About Edito'), findsOneWidget);
  });
}
