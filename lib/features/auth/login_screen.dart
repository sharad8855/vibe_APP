part of '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _phoneController = TextEditingController();
  String? _errorMessage;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_onPhoneChanged);
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.1, 1.0, curve: Curves.easeOut),
      ),
    );
    _slideAnimation = Tween<double>(begin: 24.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.1, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    _fadeController.forward();
  }

  void _onPhoneChanged() {
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  @override
  void dispose() {
    _phoneController.removeListener(_onPhoneChanged);
    _phoneController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isCompact = size.height < 850;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _SoftBackground()),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      size.height -
                      MediaQuery.paddingOf(context).top -
                      MediaQuery.paddingOf(context).bottom,
                ),
                child: AnimatedBuilder(
                  animation: _fadeController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: child,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                      SizedBox(height: isCompact ? 16 : 58),
                      _LogoHeader(isCompact: isCompact),
                      SizedBox(height: isCompact ? 18 : 52),
                      _HeroIllustration(height: isCompact ? 150 : 250),
                      SizedBox(height: isCompact ? 20 : 58),
                      Text(
                        'Welcome back!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: EditoColors.dark,
                          fontSize: isCompact ? 25 : 31,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Enter your mobile number to continue',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: EditoColors.body.withValues(alpha: 0.74),
                          fontSize: isCompact ? 15 : 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: isCompact ? 20 : 54),
                      Text(
                        'Mobile Number',
                        style: GoogleFonts.poppins(
                          color: EditoColors.dark,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _PhoneNumberField(
                        controller: _phoneController,
                        hasError: _errorMessage != null,
                        height: isCompact ? 58 : 66,
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                color: Color(0xFFFF3356),
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFFF3356),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 30),
                      _ContinueButton(
                        label: 'Continue',
                        height: isCompact ? 58 : 66,
                        onTap: () {
                          final phone = _phoneController.text.trim();
                          if (phone.isEmpty) {
                            setState(() {
                              _errorMessage = 'Please enter your mobile number';
                            });
                          } else if (phone.length < 10) {
                            setState(() {
                              _errorMessage = 'Please enter a valid 10-digit mobile number';
                            });
                          } else {
                            setState(() {
                              _errorMessage = null;
                            });
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const VerifyOtpScreen(),
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: isCompact ? 20 : 38),
                      const _DividerWithText(),
                      const SizedBox(height: 28),
                      _GoogleButton(size: isCompact ? 66 : 82),
                      const SizedBox(height: 16),
                      Text(
                        'Continue with Google',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: EditoColors.body.withValues(alpha: 0.76),
                          fontSize: isCompact ? 15 : 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: isCompact ? 36 : 88),
                      const _PrivacyNote(),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
  }
}

class _LogoHeader extends StatelessWidget {
  const _LogoHeader({this.isCompact = false});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final double fontSize = isCompact ? 46.0 : 62.0;
    final dotOffset = isCompact ? const Offset(38, -40) : const Offset(51, -54);
    final textOffset = isCompact ? const Offset(0, -15) : const Offset(0, -20);
    final double textFontSize = isCompact ? 14.0 : 18.0;

    return Column(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'E',
                style: GoogleFonts.poppins(
                  color: EditoColors.primary,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              TextSpan(
                text: 'dito',
                style: GoogleFonts.poppins(
                  color: EditoColors.dark,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
        Transform.translate(
          offset: dotOffset,
          child: const CircleAvatar(
            radius: 6,
            backgroundColor: EditoColors.accent,
          ),
        ),
        Transform.translate(
          offset: textOffset,
          child: Text(
            'Video Template Platform',
            style: GoogleFonts.inter(
              color: EditoColors.body.withValues(alpha: 0.78),
              fontSize: textFontSize,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroIllustration extends StatelessWidget {
  const _HeroIllustration({this.height = 250.0});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _IllustrationPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _IllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double baseHeight = 250.0;
    final double scale = size.height / baseHeight;
    final double baseWidth = size.width / scale;
    canvas.save();
    canvas.scale(scale);

    final center = Offset(baseWidth / 2, baseHeight / 2);
    final shadow = Paint()
      ..color = const Color(0x1F6C63FF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, baseHeight * 0.86),
        width: 190,
        height: 28,
      ),
      shadow,
    );

    final phoneRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 128, height: 205),
      const Radius.circular(28),
    );
    canvas.save();
    canvas.rotate(-0.03);
    final shiftedPhone = phoneRect.shift(const Offset(3, 0));
    canvas.drawRRect(
      shiftedPhone,
      Paint()
        ..color = const Color(0x666C63FF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7,
    );
    canvas.drawRRect(
      shiftedPhone,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF2EFFF), Color(0xFFFFFFFF)],
        ).createShader(phoneRect.outerRect),
    );

    final notch = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, baseHeight * 0.18),
        width: 40,
        height: 5,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(notch, Paint()..color = const Color(0xFFD9D0FF));
    canvas.drawCircle(
      Offset(center.dx, baseHeight * 0.38),
      30,
      Paint()..color = const Color(0xFF7F6EFF),
    );
    canvas.drawCircle(
      Offset(center.dx, baseHeight * 0.34),
      11,
      Paint()..color = const Color(0xFFFFFFFF),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, baseHeight * 0.45),
        width: 42,
        height: 28,
      ),
      Paint()..color = const Color(0xFFFFFFFF),
    );
    for (var i = 0; i < 2; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            center.dx - 48,
            baseHeight * (0.53 + i * 0.13),
            92,
            30,
          ),
          const Radius.circular(8),
        ),
        Paint()..color = const Color(0xFFFFFFFF),
      );
      canvas.drawCircle(
        Offset(center.dx - 39, baseHeight * (0.59 + i * 0.13)),
        4,
        Paint()..color = const Color(0xFFD8CEFF),
      );
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, baseHeight * 0.78),
          width: 42,
          height: 5,
        ),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFFE3DDFF),
    );
    canvas.restore();

    final bubble = RRect.fromRectAndRadius(
      Rect.fromLTWH(baseWidth * 0.18, baseHeight * 0.28, 67, 57),
      const Radius.circular(12),
    );
    canvas.drawRRect(
      bubble,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF8B75FF), Color(0xFF6C63FF)],
        ).createShader(bubble.outerRect),
    );
    final tail = Path()
      ..moveTo(baseWidth * 0.34, baseHeight * 0.49)
      ..lineTo(baseWidth * 0.31, baseHeight * 0.41)
      ..lineTo(baseWidth * 0.39, baseHeight * 0.41)
      ..close();
    canvas.drawPath(tail, Paint()..color = const Color(0xFF7A68FF));
    _drawLock(canvas, Offset(baseWidth * 0.27, baseHeight * 0.39));

    final playRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(baseWidth * 0.65, baseHeight * 0.56, 86, 69),
      const Radius.circular(12),
    );
    canvas.drawRRect(
      playRect,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFFF6E92), Color(0xFFFF4F79)],
        ).createShader(playRect.outerRect),
    );
    final play = Path()
      ..moveTo(baseWidth * 0.73, baseHeight * 0.64)
      ..lineTo(baseWidth * 0.73, baseHeight * 0.76)
      ..lineTo(baseWidth * 0.82, baseHeight * 0.70)
      ..close();
    canvas.drawPath(play, Paint()..color = Colors.white);

    _drawLeaf(canvas, Offset(baseWidth * 0.29, baseHeight * 0.76), -0.55);
    _drawLeaf(canvas, Offset(baseWidth * 0.34, baseHeight * 0.83), -0.9);

    final dotPaint = Paint()..color = const Color(0xFFE6E0FF);
    for (final dot in [
      Offset(baseWidth * 0.67, baseHeight * 0.43),
      Offset(baseWidth * 0.75, baseHeight * 0.37),
      Offset(baseWidth * 0.76, baseHeight * 0.47),
      Offset(baseWidth * 0.23, baseHeight * 0.56),
      Offset(baseWidth * 0.39, baseHeight * 0.64),
    ]) {
      canvas.drawCircle(dot, 5, dotPaint);
    }

    canvas.restore();
  }

  void _drawLock(Canvas canvas, Offset center) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.86)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: center.translate(0, -4), width: 20, height: 21),
      3.15,
      3.15,
      false,
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center.translate(0, 6), width: 24, height: 22),
        const Radius.circular(5),
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.84),
    );
  }

  void _drawLeaf(Canvas canvas, Offset center, double rotation) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    final leaf = Path()
      ..moveTo(0, -35)
      ..cubicTo(28, -12, 25, 22, 0, 38)
      ..cubicTo(-24, 18, -22, -16, 0, -35)
      ..close();
    canvas.drawPath(leaf, Paint()..color = const Color(0xFFD7CEFF));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PhoneNumberField extends StatelessWidget {
  const _PhoneNumberField({
    required this.controller,
    this.hasError = false,
    this.height = 66,
  });

  final TextEditingController controller;
  final bool hasError;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: EditoColors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: hasError ? const Color(0xFFFF3356) : Colors.white,
          width: hasError ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: hasError ? const Color(0x18FF3356) : const Color(0x12000000),
            offset: const Offset(0, 8),
            blurRadius: 24,
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 22),
          const _IndiaFlag(),
          const SizedBox(width: 12),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: EditoColors.body,
            size: 24,
          ),
          const SizedBox(width: 16),
          Container(width: 1, height: 31, color: EditoColors.border),
          const SizedBox(width: 18),
          Text(
            '+91',
            style: GoogleFonts.inter(
              color: EditoColors.dark,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 17),
          Container(width: 1, height: 31, color: EditoColors.border),
          const SizedBox(width: 18),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              maxLength: 10,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              cursorColor: EditoColors.primary,
              style: GoogleFonts.inter(
                color: EditoColors.dark,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                counterText: '',
                border: InputBorder.none,
                hintText: 'Enter mobile number',
                hintStyle: GoogleFonts.inter(
                  color: EditoColors.muted,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IndiaFlag extends StatelessWidget {
  const _IndiaFlag();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: SizedBox(
        width: 28,
        height: 19,
        child: Column(
          children: [
            Expanded(child: Container(color: const Color(0xFFFF9933))),
            Expanded(
              child: Container(
                color: Colors.white,
                alignment: Alignment.center,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2F4C9A),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Expanded(child: Container(color: const Color(0xFF138808))),
          ],
        ),
      ),
    );
  }
}

class _DividerWithText extends StatelessWidget {
  const _DividerWithText();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: EditoColors.border, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            'or',
            style: GoogleFonts.inter(
              color: EditoColors.body.withValues(alpha: 0.7),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const Expanded(child: Divider(color: EditoColors.border, thickness: 1)),
      ],
    );
  }
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton({this.size = 82});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: EditoColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x10000000),
              offset: Offset(0, 8),
              blurRadius: 25,
            ),
          ],
        ),
        child: Center(
          child: Text(
            'G',
            style: GoogleFonts.poppins(
              color: const Color(0xFF4285F4),
              fontSize: size * 0.41,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _PrivacyNote extends StatelessWidget {
  const _PrivacyNote();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 27,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFFC8BFFF),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 19),
        Flexible(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                color: EditoColors.body.withValues(alpha: 0.76),
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.45,
              ),
              children: const [
                TextSpan(text: "We'll never share your number\n"),
                TextSpan(text: 'with anyone. See our '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    color: EditoColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
