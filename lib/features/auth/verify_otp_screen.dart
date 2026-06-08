part of '../../main.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _otpController = TextEditingController();
  final _otpFocusNode = FocusNode();
  String? _errorMessage;
  bool _showSuccessAnimation = false;

  @override
  void initState() {
    super.initState();
    _otpController.addListener(_onOtpChanged);
  }

  void _onOtpChanged() {
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  @override
  void dispose() {
    _otpController.removeListener(_onOtpChanged);
    _otpController.dispose();
    _otpFocusNode.dispose();
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
              physics: const NeverScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      size.height -
                      MediaQuery.paddingOf(context).top -
                      MediaQuery.paddingOf(context).bottom,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: isCompact ? 18 : 52),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_rounded),
                          iconSize: 37,
                          color: EditoColors.dark,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 48,
                            minHeight: 48,
                          ),
                        ),
                      ),
                      SizedBox(height: isCompact ? 44 : 92),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isNarrow = constraints.maxWidth < 360;
                          final colWidth = isNarrow ? constraints.maxWidth : constraints.maxWidth * 0.66;
                          final illSize = isNarrow ? 120.0 : 180.0;
                          return SizedBox(
                            height: 248,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  right: -6,
                                  top: isNarrow ? 40 : 0,
                                  child: Opacity(
                                    opacity: isNarrow ? 0.35 : 1.0,
                                    child: SizedBox(
                                      width: illSize,
                                      height: 230,
                                      child: const _OtpIllustration(),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  top: 30,
                                  width: colWidth,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Verify OTP',
                                        style: GoogleFonts.poppins(
                                          color: EditoColors.dark,
                                          fontSize: isNarrow ? 31 : 37,
                                          fontWeight: FontWeight.w800,
                                          height: 1.05,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        'Enter the 6-digit code sent to',
                                        style: GoogleFonts.inter(
                                          color: EditoColors.body.withValues(
                                            alpha: 0.74,
                                          ),
                                          fontSize: isNarrow ? 16 : 19,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      RichText(
                                        text: TextSpan(
                                          style: GoogleFonts.inter(
                                            color: EditoColors.dark,
                                            fontSize: isNarrow ? 16 : 19,
                                            fontWeight: FontWeight.w800,
                                          ),
                                          children: const [
                                            TextSpan(text: '+91 98765 43210  '),
                                            TextSpan(
                                              text: 'Change',
                                              style: TextStyle(
                                                color: EditoColors.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: isCompact ? 48 : 94),
                      Text(
                        'Enter 6-digit OTP',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: EditoColors.body.withValues(alpha: 0.76),
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 34),
                      _OtpBoxes(
                        controller: _otpController,
                        focusNode: _otpFocusNode,
                        hasError: _errorMessage != null,
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                      const SizedBox(height: 44),
                      const _OtpValidity(),
                      const SizedBox(height: 47),
                      _ContinueButton(
                        label: 'Verify & Continue',
                        onTap: () {
                          final otp = _otpController.text.trim();
                          if (otp.length < 6) {
                            setState(() {
                              _errorMessage = 'Please enter the 6-digit OTP code';
                            });
                          } else {
                            setState(() {
                              _errorMessage = null;
                              _showSuccessAnimation = true;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 44),
                      Text.rich(
                        TextSpan(
                          style: GoogleFonts.inter(
                            color: EditoColors.body.withValues(alpha: 0.72),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          children: const [
                            TextSpan(text: "Didn't receive the code?  "),
                            TextSpan(
                              text: 'Resend OTP in 00:28',
                              style: TextStyle(
                                color: EditoColors.primary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isCompact ? 78 : 132),
                      const _PrivacyCard(),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_showSuccessAnimation)
            Positioned.fill(
              child: SuccessVerificationAnimation(
                onAnimationComplete: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) => const HomeScreen(),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _OtpIllustration extends StatelessWidget {
  const _OtpIllustration();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _OtpIllustrationPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _OtpIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.56, size.height * 0.5);
    final shadow = Paint()
      ..color = const Color(0x206C63FF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, size.height * 0.87),
        width: 142,
        height: 24,
      ),
      shadow,
    );

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(0.08);
    final phone = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: 114, height: 190),
      const Radius.circular(27),
    );
    canvas.drawRRect(
      phone,
      Paint()
        ..color = const Color(0x806C63FF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7,
    );
    canvas.drawRRect(
      phone,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF4F0FF), Color(0xFFFFFFFF)],
        ).createShader(phone.outerRect),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: const Offset(0, -80), width: 34, height: 5),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFDCD4FF),
    );
    canvas.restore();

    final bubble = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.10, size.height * 0.27, 96, 78),
      const Radius.circular(13),
    );
    canvas.drawRRect(
      bubble,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8E77FF), Color(0xFF6C63FF)],
        ).createShader(bubble.outerRect),
    );
    final tail = Path()
      ..moveTo(size.width * 0.46, size.height * 0.62)
      ..lineTo(size.width * 0.39, size.height * 0.50)
      ..lineTo(size.width * 0.52, size.height * 0.50)
      ..close();
    canvas.drawPath(tail, Paint()..color = const Color(0xFF7463FA));

    final shield = Path()
      ..moveTo(size.width * 0.34, size.height * 0.34)
      ..lineTo(size.width * 0.48, size.height * 0.40)
      ..lineTo(size.width * 0.44, size.height * 0.55)
      ..quadraticBezierTo(
        size.width * 0.34,
        size.height * 0.62,
        size.width * 0.25,
        size.height * 0.55,
      )
      ..lineTo(size.width * 0.21, size.height * 0.40)
      ..close();
    canvas.drawPath(shield, Paint()..color = const Color(0xFFEFEAFF));
    final check = Path()
      ..moveTo(size.width * 0.28, size.height * 0.48)
      ..lineTo(size.width * 0.34, size.height * 0.54)
      ..lineTo(size.width * 0.44, size.height * 0.43);
    canvas.drawPath(
      check,
      Paint()
        ..color = EditoColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    final otp = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.36, size.height * 0.57, 97, 41),
      const Radius.circular(9),
    );
    canvas.drawRRect(otp, Paint()..color = Colors.white);
    canvas.drawRRect(
      otp,
      Paint()
        ..color = const Color(0x15000000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    final dotPaint = Paint()..color = const Color(0xFFC9C0FF);
    for (var i = 0; i < 4; i++) {
      canvas.drawCircle(
        Offset(size.width * (0.47 + i * 0.10), size.height * 0.66),
        5,
        dotPaint,
      );
    }

    _drawLeaf(canvas, Offset(size.width * 0.18, size.height * 0.72), -0.52);
    _drawLeaf(canvas, Offset(size.width * 0.76, size.height * 0.72), 0.54);

    final smallDotPaint = Paint()..color = const Color(0xFFE4DEFF);
    for (final dot in [
      Offset(size.width * 0.07, size.height * 0.43),
      Offset(size.width * 0.14, size.height * 0.56),
      Offset(size.width * 0.86, size.height * 0.38),
      Offset(size.width * 0.93, size.height * 0.48),
    ]) {
      canvas.drawCircle(dot, 4.5, smallDotPaint);
    }
  }

  void _drawLeaf(Canvas canvas, Offset center, double rotation) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    final leaf = Path()
      ..moveTo(0, -32)
      ..cubicTo(22, -9, 20, 20, 0, 35)
      ..cubicTo(-20, 17, -18, -12, 0, -32)
      ..close();
    canvas.drawPath(leaf, Paint()..color = const Color(0xFFDCD5FF));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _OtpBoxes extends StatefulWidget {
  const _OtpBoxes({
    required this.controller,
    required this.focusNode,
    this.hasError = false,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;

  @override
  State<_OtpBoxes> createState() => _OtpBoxesState();
}

class _OtpBoxesState extends State<_OtpBoxes> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleOtpChanged);
  }

  @override
  void didUpdateWidget(covariant _OtpBoxes oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleOtpChanged);
      widget.controller.addListener(_handleOtpChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleOtpChanged);
    super.dispose();
  }

  void _handleOtpChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.controller.text;
    final activeIndex = value.length.clamp(0, 5);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => widget.focusNode.requestFocus(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 1,
            width: 1,
            child: TextField(
              key: const ValueKey('otp_input'),
              controller: widget.controller,
              focusNode: widget.focusNode,
              autofocus: true,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              maxLength: 6,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.transparent, fontSize: 1),
              cursorColor: Colors.transparent,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              final digit = index < value.length ? value[index] : '';
              final isActive = index == activeIndex && value.length < 6;

              return Container(
                width: 51,
                height: 70,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: EditoColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: widget.hasError
                        ? const Color(0xFFFF3356)
                        : isActive
                            ? EditoColors.primary
                            : const Color(0xFFE1E0F0),
                    width: widget.hasError || isActive ? 1.8 : 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.hasError
                          ? const Color(0x18FF3356)
                          : const Color(0x08000000),
                      offset: const Offset(0, 6),
                      blurRadius: 18,
                    ),
                  ],
                ),
                child: digit.isEmpty
                    ? isActive
                          ? Container(
                              width: 3,
                              height: 30,
                              decoration: BoxDecoration(
                                color: EditoColors.primary,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            )
                          : null
                    : Text(
                        digit,
                        style: GoogleFonts.poppins(
                          color: EditoColors.dark,
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _OtpValidity extends StatelessWidget {
  const _OtpValidity();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: const BoxDecoration(
            color: Color(0xFFE8E3FF),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.verified_user_rounded,
            color: Color(0xFFB1A3FF),
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.inter(
                color: EditoColors.body.withValues(alpha: 0.75),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              children: const [
                TextSpan(text: 'OTP is valid for '),
                TextSpan(
                  text: '2:00',
                  style: TextStyle(
                    color: EditoColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(text: ' minutes'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
