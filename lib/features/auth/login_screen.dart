part of '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_onPhoneChanged);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isCompact = size.height < 760;

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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: isCompact ? 26 : 58),
                      const _LogoHeader(),
                      SizedBox(height: isCompact ? 28 : 52),
                      const _HeroIllustration(),
                      SizedBox(height: isCompact ? 30 : 58),
                      Text(
                        'Welcome back!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: EditoColors.dark,
                          fontSize: 31,
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
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: isCompact ? 30 : 54),
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
                              Text(
                                _errorMessage!,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFFFF3356),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 30),
                      _ContinueButton(
                        label: 'Continue',
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
                      SizedBox(height: isCompact ? 26 : 38),
                      const _DividerWithText(),
                      const SizedBox(height: 28),
                      const _GoogleButton(),
                      const SizedBox(height: 16),
                      Text(
                        'Continue with Google',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: EditoColors.body.withValues(alpha: 0.76),
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: isCompact ? 52 : 88),
                      const _PrivacyNote(),
                      const SizedBox(height: 28),
                    ],
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
  const _LogoHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'E',
                style: GoogleFonts.poppins(
                  color: EditoColors.primary,
                  fontSize: 62,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              TextSpan(
                text: 'dito',
                style: GoogleFonts.poppins(
                  color: EditoColors.dark,
                  fontSize: 62,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
        Transform.translate(
          offset: const Offset(51, -54),
          child: const CircleAvatar(
            radius: 6,
            backgroundColor: EditoColors.accent,
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -20),
          child: Text(
            'Video Template Platform',
            style: GoogleFonts.inter(
              color: EditoColors.body.withValues(alpha: 0.78),
              fontSize: 18,
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
  const _HeroIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
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
    final center = Offset(size.width / 2, size.height / 2);
    final shadow = Paint()
      ..color = const Color(0x1F6C63FF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, size.height * 0.86),
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
        center: Offset(center.dx, size.height * 0.18),
        width: 40,
        height: 5,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(notch, Paint()..color = const Color(0xFFD9D0FF));
    canvas.drawCircle(
      Offset(center.dx, size.height * 0.38),
      30,
      Paint()..color = const Color(0xFF7F6EFF),
    );
    canvas.drawCircle(
      Offset(center.dx, size.height * 0.34),
      11,
      Paint()..color = const Color(0xFFFFFFFF),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, size.height * 0.45),
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
            size.height * (0.53 + i * 0.13),
            92,
            30,
          ),
          const Radius.circular(8),
        ),
        Paint()..color = const Color(0xFFFFFFFF),
      );
      canvas.drawCircle(
        Offset(center.dx - 39, size.height * (0.59 + i * 0.13)),
        4,
        Paint()..color = const Color(0xFFD8CEFF),
      );
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, size.height * 0.78),
          width: 42,
          height: 5,
        ),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFFE3DDFF),
    );
    canvas.restore();

    final bubble = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.18, size.height * 0.28, 67, 57),
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
      ..moveTo(size.width * 0.34, size.height * 0.49)
      ..lineTo(size.width * 0.31, size.height * 0.41)
      ..lineTo(size.width * 0.39, size.height * 0.41)
      ..close();
    canvas.drawPath(tail, Paint()..color = const Color(0xFF7A68FF));
    _drawLock(canvas, Offset(size.width * 0.27, size.height * 0.39));

    final playRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.65, size.height * 0.56, 86, 69),
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
      ..moveTo(size.width * 0.73, size.height * 0.64)
      ..lineTo(size.width * 0.73, size.height * 0.76)
      ..lineTo(size.width * 0.82, size.height * 0.70)
      ..close();
    canvas.drawPath(play, Paint()..color = Colors.white);

    _drawLeaf(canvas, Offset(size.width * 0.29, size.height * 0.76), -0.55);
    _drawLeaf(canvas, Offset(size.width * 0.34, size.height * 0.83), -0.9);

    final dotPaint = Paint()..color = const Color(0xFFE6E0FF);
    for (final dot in [
      Offset(size.width * 0.67, size.height * 0.43),
      Offset(size.width * 0.75, size.height * 0.37),
      Offset(size.width * 0.76, size.height * 0.47),
      Offset(size.width * 0.23, size.height * 0.56),
      Offset(size.width * 0.39, size.height * 0.64),
    ]) {
      canvas.drawCircle(dot, 5, dotPaint);
    }
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
  });

  final TextEditingController controller;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
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
  const _GoogleButton();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 82,
        height: 82,
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
              fontSize: 34,
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
