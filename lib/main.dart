import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

part 'core/theme/colors.dart';
part 'shared/models/template_data.dart';
part 'shared/widgets/background.dart';
part 'shared/widgets/primary_button.dart';
part 'shared/widgets/privacy_card.dart';
part 'shared/widgets/template_widgets.dart';
part 'features/auth/login_screen.dart';
part 'features/auth/verify_otp_screen.dart';
part 'features/auth/success_verification_animation.dart';
part 'features/home/home_screen.dart';
part 'features/browse/browse_screen.dart';
part 'features/my_videos/my_videos_screen.dart';
part 'features/profile/profile_screen.dart';
part 'features/settings/settings_screen.dart';
part 'features/notifications/notifications_screen.dart';
part 'features/template_detail/template_detail_screen.dart';
part 'features/use_template/use_template_screen.dart';
part 'features/preview_customize/preview_customize_screen.dart';
part 'features/preview_template/preview_template_screen.dart';
part 'features/generate_video/generate_video_screen.dart';
part 'features/video_ready/video_ready_screen.dart';

void main() {
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
      home: const LoginScreen(),
    );
  }
}
