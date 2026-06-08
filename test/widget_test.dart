import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vibe/main.dart';

void main() {
  testWidgets('Edito login screen renders', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    await tester.pumpWidget(const EditoApp());
    await tester.pumpAndSettle(const Duration(seconds: 4));

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
    await tester.pumpAndSettle(const Duration(seconds: 4));

    await tester.enterText(find.byType(EditableText), '9876543210');
    await tester.pump();

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
    await tester.pumpAndSettle(const Duration(seconds: 4));

    await tester.enterText(find.byType(EditableText), '9876543210');
    await tester.pump();

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('otp_input')), '123456');
    await tester.pump();
    await tester.tap(find.text('Verify & Continue'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 600));
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

    // Test share button is interactive
    expect(find.byIcon(Icons.ios_share_rounded), findsOneWidget);
    await tester.tap(find.byIcon(Icons.ios_share_rounded));
    await tester.pumpAndSettle();

    // Verify share sheet opened
    expect(find.text('Share Template'), findsOneWidget);
    expect(find.text('WhatsApp'), findsOneWidget);

    // Tap WhatsApp to share
    await tester.tap(find.text('WhatsApp'));
    await tester.pumpAndSettle();

    // Verify share confirmation SnackBar is shown
    expect(find.text('Shared successfully via WhatsApp!'), findsOneWidget);

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

    await tester.tap(find.text('Upload Video'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Upload Photo'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Wanderlust Vlog');
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Title Text'),
      320,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Title Text'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Tips for best results'),
      320,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Tips for best results'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Continue with Preview'),
      360,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue with Preview'));
    await tester.pumpAndSettle();

    expect(find.byType(PreviewCustomizeScreen), findsOneWidget);
    expect(find.text('Review Your Content'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Video Settings'),
      360,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Video Settings'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('AI Magic'),
      360,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('AI Magic'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Generate Video'),
      360,
      scrollable: find.byType(Scrollable).first,
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
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(GenerateVideoScreen), findsOneWidget);
    expect(find.text('Generating Your Video'), findsOneWidget);
    expect(find.text('AI is working its magic'), findsOneWidget);
    expect(find.text('Preparing Your Assets'), findsOneWidget);

    final scrollableFinder = find.descendant(
      of: find.byType(GenerateVideoScreen),
      matching: find.byType(Scrollable),
    );

    await tester.scrollUntilVisible(
      find.text('Go to My Videos'),
      100,
      scrollable: scrollableFinder.first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Go to My Videos'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text("Please don't close the app"),
      100,
      scrollable: scrollableFinder.first,
    );
    await tester.pumpAndSettle();

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

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);

    // ── Test Earnings Screen ──
    await tester.tap(find.text('Earnings'));
    await tester.pumpAndSettle();

    expect(find.byType(EarningsScreen), findsOneWidget);
    expect(find.text('Available Balance'), findsOneWidget);
    expect(find.text('₹4,600'), findsOneWidget);
    expect(find.text('Total Revenue'), findsOneWidget);
    expect(find.text('₹29,600'), findsOneWidget);
    expect(find.text('Total Withdrawn'), findsOneWidget);
    expect(find.text('₹25,000'), findsOneWidget);
    expect(find.text('Withdraw to Bank'), findsOneWidget);

    // Verify filter pills are rendered
    expect(find.text('Sales'), findsOneWidget);
    expect(find.text('Withdrawals'), findsOneWidget);

    // Tap Withdraw to Bank
    await tester.tap(find.text('Withdraw to Bank'));
    await tester.pumpAndSettle();

    expect(find.text('Withdraw to Bank Account'), findsOneWidget);
    expect(find.text('Confirm Withdrawal'), findsOneWidget);

    // Confirm withdrawal
    await tester.tap(find.text('Confirm Withdrawal'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Verify success state in modal
    expect(find.text('Withdrawal Requested!'), findsOneWidget);

    // Wait for modal auto-dismiss
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Now balance should be ₹0
    expect(find.text('₹0'), findsOneWidget);

    // Close Earnings Screen
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);

    // ── Test Saved Templates Screen ──
    await tester.tap(find.text('Saved Templates'));
    await tester.pumpAndSettle();

    expect(find.byType(SavedTemplatesScreen), findsOneWidget);
    expect(find.text('3 Saved Items'), findsOneWidget);
    expect(find.text('Royal Wedding Moments'), findsOneWidget);
    expect(find.text('Concert Reel Pack'), findsOneWidget);
    expect(find.text('Beach Travel Diary'), findsOneWidget);

    // Unsave the first item (Royal Wedding Moments)
    await tester.tap(find.byIcon(Icons.bookmark_rounded).first);
    await tester.pumpAndSettle();

    // Check count decreases to 2
    expect(find.text('2 Saved Items'), findsOneWidget);
    expect(find.text('Royal Wedding Moments'), findsNothing);

    // Verify undo is possible via snackbar
    expect(find.text('UNDO'), findsOneWidget);
    await tester.tap(find.text('UNDO'));
    await tester.pumpAndSettle();

    // Check count returns to 3
    expect(find.text('3 Saved Items'), findsOneWidget);
    expect(find.text('Royal Wedding Moments'), findsOneWidget);

    // Toggle view to list view
    await tester.tap(find.byIcon(Icons.view_list_rounded));
    await tester.pumpAndSettle();

    // Unsave in list view
    await tester.tap(find.byIcon(Icons.bookmark_rounded).first);
    await tester.pumpAndSettle();
    expect(find.text('2 Saved Items'), findsOneWidget);

    // Close Saved Templates Screen
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);

    // ── Test Account Settings Screen via Edit Profile Button ──
    await tester.tap(find.text('Edit Profile'));
    await tester.pumpAndSettle();

    expect(find.byType(AccountSettingsScreen), findsOneWidget);

    // Close Account Settings
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);

    // ── Test Account Settings Screen via Profile Menu ──
    await tester.tap(find.text('Account Settings'));
    await tester.pumpAndSettle();

    expect(find.byType(AccountSettingsScreen), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Creator Bio'), findsOneWidget);
    expect(find.text('Save Changes'), findsOneWidget);

    // Tap Save Changes
    await tester.tap(find.text('Save Changes'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Profile changes saved successfully!'), findsOneWidget);

    // Close Account Settings
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);

    // ── Test Privacy & Security Screen ──
    await tester.tap(find.text('Privacy & Security'));
    await tester.pumpAndSettle();

    expect(find.byType(PrivacySecurityScreen), findsOneWidget);
    expect(find.text('Private Profile'), findsOneWidget);
    expect(find.text('Public Earnings'), findsOneWidget);
    expect(find.text('Two-Factor Authentication'), findsOneWidget);
    expect(find.text('Active Login Sessions'), findsOneWidget);
    expect(find.text('Clear Search History'), findsOneWidget);

    // Close Privacy & Security
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);

    // ── Test Help & Support Screen ──
    await tester.tap(find.text('Help & Support'));
    await tester.pumpAndSettle();

    expect(find.byType(HelpSupportScreen), findsOneWidget);
    expect(find.text('Live Chat'), findsOneWidget);
    expect(find.text('Email Us'), findsOneWidget);
    expect(find.text('Frequently Asked Questions'), findsOneWidget);
    expect(find.text('How do I withdraw my earnings?'), findsOneWidget);

    // Close Help & Support
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);

    // ── Test Liked Templates Screen (Empty State) ──
    await tester.tap(find.text('Liked Templates'));
    await tester.pumpAndSettle();

    expect(find.byType(LikedTemplatesScreen), findsOneWidget);
    expect(find.text('Your liked templates list is empty'), findsOneWidget);

    // Close Liked Templates Screen
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);

    // Go back to Home and Like a template
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Wanderlust Journey').first);
    await tester.pumpAndSettle();

    expect(find.byType(TemplateDetailScreen), findsOneWidget);

    // Tap favorite/like button
    await tester.tap(find.byIcon(Icons.favorite_border_rounded));
    await tester.pumpAndSettle();

    // Verify it is now favorited
    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);

    // Go back to Profile -> Liked Templates
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Liked Templates'));
    await tester.pumpAndSettle();

    // Verify template is present
    expect(find.byType(LikedTemplatesScreen), findsOneWidget);
    expect(find.text('1 Liked Items'), findsOneWidget);
    expect(find.text('Wanderlust Journey'), findsOneWidget);

    // Toggle view to list view
    await tester.tap(find.byIcon(Icons.view_list_rounded));
    await tester.pumpAndSettle();

    // Unlike/Remove from Liked Screen
    await tester.tap(find.byIcon(Icons.favorite_rounded));
    await tester.pumpAndSettle();

    // Verify it's empty
    expect(find.text('Your liked templates list is empty'), findsOneWidget);

    // Go back to Profile
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
  });

  testWidgets('My Videos filtering and tabs work correctly', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    await tester.pumpWidget(const EditoApp());
    await tester.pumpAndSettle(const Duration(seconds: 4));

    // Bypass login by entering phone and continue
    await tester.enterText(find.byType(EditableText), '9876543210');
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const ValueKey('otp_input')), '123456');
    await tester.pump();
    await tester.tap(find.text('Verify & Continue'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Verify we are on HomeScreen, then tap "My Videos" tab
    expect(find.byType(HomeScreen), findsOneWidget);
    await tester.tap(find.text('My Videos'));
    await tester.pumpAndSettle();

    expect(find.byType(MyVideosScreen), findsOneWidget);

    // Initially "All" should show the non-template videos
    expect(find.text('Wanderlust Journey'), findsOneWidget); // Completed
    expect(find.text('Urban Style Intro'), findsOneWidget); // In Progress
    expect(find.text('Party Night Vibes'), findsOneWidget); // Draft
    expect(find.text('Neon Cyberpunk Promo'), findsNothing); // Template is filtered out in 'All'

    // Tap "In Progress" tab
    await tester.tap(find.text('In Progress').first);
    await tester.pumpAndSettle();

    // Verify only "In Progress" videos are visible
    expect(find.text('Urban Style Intro'), findsOneWidget);
    expect(find.text('Corporate Minimal'), findsOneWidget);
    expect(find.text('Wanderlust Journey'), findsNothing);

    // Tap "Completed" stats card
    await tester.tap(find.text('Completed').last);
    await tester.pumpAndSettle();

    // Verify only "Completed" videos are visible
    expect(find.text('Wanderlust Journey'), findsOneWidget);
    expect(find.text('Royal Wedding Moments'), findsOneWidget);
    expect(find.text('Urban Style Intro'), findsNothing);

    // Tap "Drafts" tab
    await tester.tap(find.text('Drafts').first);
    await tester.pumpAndSettle();

    // Verify only "Drafts" are visible
    expect(find.text('Party Night Vibes'), findsOneWidget);
    expect(find.text('Wanderlust Journey'), findsNothing);

    // Tap "Templates" tab
    await tester.tap(find.text('Templates').first);
    await tester.pumpAndSettle();

    // Verify template is visible
    expect(find.text('Neon Cyberpunk Promo'), findsOneWidget);
    expect(find.text('Party Night Vibes'), findsNothing);
  });
}
