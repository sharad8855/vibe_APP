import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

part 'core/theme/colors.dart';
part 'core/services/api_client.dart';
part 'shared/models/template_data.dart';
part 'shared/widgets/background.dart';
part 'shared/widgets/primary_button.dart';
part 'shared/widgets/privacy_card.dart';
part 'shared/widgets/template_widgets.dart';
part 'features/auth/login_screen.dart';
part 'features/auth/verify_otp_screen.dart';
part 'features/auth/splash_screen.dart';
part 'features/auth/success_verification_animation.dart';
part 'features/home/home_screen.dart';
part 'features/home/search_screen.dart';
part 'features/browse/browse_screen.dart';
part 'features/browse/collection_detail_screen.dart';
part 'features/my_videos/my_videos_screen.dart';
part 'features/profile/profile_screen.dart';
part 'features/profile/create_template_screen.dart';
part 'features/profile/review_detection_screen.dart';
part 'features/profile/define_slots_screen.dart';
part 'features/profile/template_submitted_screen.dart';
part 'features/profile/my_templates_screen.dart';
part 'features/profile/earnings_screen.dart';
part 'features/profile/saved_templates_screen.dart';
part 'features/profile/liked_templates_screen.dart';
part 'features/profile/pro_subscription_sheet.dart';
part 'features/profile/account_settings_screen.dart';
part 'features/profile/privacy_security_screen.dart';
part 'features/profile/help_support_screen.dart';
part 'features/settings/settings_screen.dart';
part 'features/notifications/notifications_screen.dart';
part 'features/template_detail/template_detail_screen.dart';
part 'features/use_template/use_template_screen.dart';
part 'features/preview_customize/preview_customize_screen.dart';
part 'features/preview_template/preview_template_screen.dart';
part 'features/generate_video/generate_video_screen.dart';
part 'features/video_ready/video_ready_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiClient.initialize();
  runApp(const EditoApp());
}

class EditoApp extends StatelessWidget {
  const EditoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Edito',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: EditoColors.background,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const SplashScreen(),
    );
  }
}
