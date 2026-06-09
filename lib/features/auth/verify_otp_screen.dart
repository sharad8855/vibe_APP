part of '../../main.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({
    super.key,
    required this.email,
    required this.flowType,
  });

  final String email;
  final String flowType; // 'login' or 'register'

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _otpController = TextEditingController();
  final _otpFocusNode = FocusNode();
  String? _errorMessage;
  bool _showSuccessAnimation = false;
  bool _isLoading = false;
  bool _isResending = false;

  Timer? _resendTimer;
  int _secondsRemaining = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _otpController.addListener(_onOtpChanged);
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        _resendTimer?.cancel();
      }
    });
  }

  void _onResendOtp() async {
    if (_isResending || !_canResend) return;

    setState(() {
      _isResending = true;
      _errorMessage = null;
    });

    try {
      if (widget.flowType == 'register') {
        await ApiClient.resendOtp(widget.email);
      } else {
        await ApiClient.loginOtp(widget.email);
      }
      _startResendTimer();
    } on ApiException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (e) {
      setState(() => _errorMessage = 'Failed to resend OTP');
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
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
    _resendTimer?.cancel();
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: isCompact ? 14 : 52),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_rounded),
                          iconSize: isCompact ? 30 : 37,
                          color: EditoColors.dark,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 48,
                            minHeight: 48,
                          ),
                        ),
                      ),
                      SizedBox(height: isCompact ? 20 : 92),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isNarrow = constraints.maxWidth < 360;
                          final colWidth = isNarrow ? constraints.maxWidth : constraints.maxWidth * 0.66;
                          final illSize = isNarrow ? 100.0 : (isCompact ? 130.0 : 180.0);
                          final illHeight = isCompact ? 160.0 : 230.0;
                          final parentHeight = isCompact ? 170.0 : 248.0;
                          return SizedBox(
                            height: parentHeight,
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
                                      height: illHeight,
                                      child: _OtpIllustration(height: illHeight),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  top: isCompact ? 10 : 30,
                                  width: colWidth,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Verify OTP',
                                        style: GoogleFonts.poppins(
                                          color: EditoColors.dark,
                                          fontSize: isNarrow ? (isCompact ? 26 : 31) : (isCompact ? 30 : 37),
                                          fontWeight: FontWeight.w800,
                                          height: 1.05,
                                        ),
                                      ),
                                      SizedBox(height: isCompact ? 10 : 20),
                                      Text(
                                        'Enter the 6-digit code sent to',
                                        style: GoogleFonts.inter(
                                          color: EditoColors.body.withValues(
                                            alpha: 0.74,
                                          ),
                                          fontSize: isNarrow ? (isCompact ? 14 : 16) : (isCompact ? 16 : 19),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: isCompact ? 8 : 14),
                                      GestureDetector(
                                        onTap: () => Navigator.of(context).pop(),
                                        child: RichText(
                                          text: TextSpan(
                                            style: GoogleFonts.inter(
                                              color: EditoColors.dark,
                                              fontSize: isNarrow ? (isCompact ? 13 : 15) : (isCompact ? 15 : 17),
                                              fontWeight: FontWeight.w800,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: '${widget.email}  ',
                                                style: const TextStyle(
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const TextSpan(
                                                text: 'Change',
                                                style: TextStyle(
                                                  color: EditoColors.primary,
                                                ),
                                              ),
                                            ],
                                          ),
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
                      SizedBox(height: isCompact ? 24 : 94),
                      Text(
                        'Enter 6-digit OTP',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: EditoColors.body.withValues(alpha: 0.76),
                          fontSize: isCompact ? 16 : 19,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: isCompact ? 16 : 34),
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
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  textAlign: TextAlign.center,
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
                      SizedBox(height: isCompact ? 24 : 44),
                      const _OtpValidity(),
                      SizedBox(height: isCompact ? 24 : 47),
                      _ContinueButton(
                        label: 'Verify & Continue',
                        height: isCompact ? 58 : 66,
                        isLoading: _isLoading,
                        onTap: () async {
                          if (_isLoading) return;
                          final otp = _otpController.text.trim();
                          if (otp.length < 6) {
                            setState(() {
                              _errorMessage = 'Please enter the 6-digit OTP code';
                            });
                            return;
                          }

                          setState(() {
                            _isLoading = true;
                            _errorMessage = null;
                          });

                          try {
                            if (widget.flowType == 'register') {
                              final res = await ApiClient.verifyEmail(widget.email, otp);
                              final data = res['data'];
                              final id = data?['id'] as String? ?? '';
                              ApiClient.setSession(AuthSession(
                                id: id,
                                email: widget.email,
                                token: 'dummy_signup_token',
                              ));
                            } else {
                              final res = await ApiClient.verifyLoginOtp(widget.email, otp);
                              final data = res['data'];
                              final token = data?['token'] as String? ?? '';
                              final user = data?['user'];
                              final id = user?['id'] as String? ?? '';
                              ApiClient.setSession(AuthSession(
                                id: id,
                                email: widget.email,
                                token: token,
                              ));
                            }
                            if (!mounted) return;
                            setState(() {
                              _showSuccessAnimation = true;
                            });
                          } on ApiException catch (e) {
                            setState(() => _errorMessage = e.message);
                          } catch (e) {
                            setState(() => _errorMessage = 'Failed to connect to the server');
                          } finally {
                            if (mounted) setState(() => _isLoading = false);
                          }
                        },
                      ),
                      SizedBox(height: isCompact ? 24 : 44),
                      GestureDetector(
                        onTap: _canResend && !_isResending ? _onResendOtp : null,
                        child: Text.rich(
                          TextSpan(
                            style: GoogleFonts.inter(
                              color: EditoColors.body.withValues(alpha: 0.72),
                              fontSize: isCompact ? 14 : 16,
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              const TextSpan(text: "Didn't receive the code?  "),
                              TextSpan(
                                text: _canResend
                                    ? (_isResending ? 'Resending...' : 'Resend OTP')
                                    : 'Resend OTP in 00:${_secondsRemaining.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  color: _canResend && !_isResending
                                      ? EditoColors.primary
                                      : EditoColors.muted,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: isCompact ? 40 : 132),
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
                message: widget.flowType == 'register'
                    ? 'Your email address has been verified.'
                    : 'You have logged in successfully.',
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
  const _OtpIllustration({this.height = 230.0});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _OtpIllustrationPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _OtpIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double baseHeight = 230.0;
    final double scale = size.height / baseHeight;
    final double baseWidth = size.width / scale;
    canvas.save();
    canvas.scale(scale);

    final center = Offset(baseWidth * 0.56, baseHeight * 0.5);
    final shadow = Paint()
      ..color = const Color(0x206C63FF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, baseHeight * 0.87),
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
      Rect.fromLTWH(baseWidth * 0.10, baseHeight * 0.27, 96, 78),
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
      ..moveTo(baseWidth * 0.46, baseHeight * 0.62)
      ..lineTo(baseWidth * 0.39, baseHeight * 0.50)
      ..lineTo(baseWidth * 0.52, baseHeight * 0.50)
      ..close();
    canvas.drawPath(tail, Paint()..color = const Color(0xFF7463FA));

    final shield = Path()
      ..moveTo(baseWidth * 0.34, baseHeight * 0.34)
      ..lineTo(baseWidth * 0.48, baseHeight * 0.40)
      ..lineTo(baseWidth * 0.44, baseHeight * 0.55)
      ..quadraticBezierTo(
        baseWidth * 0.34,
        baseHeight * 0.62,
        baseWidth * 0.25,
        baseHeight * 0.55,
      )
      ..lineTo(baseWidth * 0.21, baseHeight * 0.40)
      ..close();
    canvas.drawPath(shield, Paint()..color = const Color(0xFFEFEAFF));
    final check = Path()
      ..moveTo(baseWidth * 0.28, baseHeight * 0.48)
      ..lineTo(baseWidth * 0.34, baseHeight * 0.54)
      ..lineTo(baseWidth * 0.44, baseHeight * 0.43);
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
      Rect.fromLTWH(baseWidth * 0.36, baseHeight * 0.57, 97, 41),
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
        Offset(baseWidth * (0.47 + i * 0.10), baseHeight * 0.66),
        5,
        dotPaint,
      );
    }

    _drawLeaf(canvas, Offset(baseWidth * 0.18, baseHeight * 0.72), -0.52);
    _drawLeaf(canvas, Offset(baseWidth * 0.76, baseHeight * 0.72), 0.54);

    final smallDotPaint = Paint()..color = const Color(0xFFE4DEFF);
    for (final dot in [
      Offset(baseWidth * 0.07, baseHeight * 0.43),
      Offset(baseWidth * 0.14, baseHeight * 0.56),
      Offset(baseWidth * 0.86, baseHeight * 0.38),
      Offset(baseWidth * 0.93, baseHeight * 0.48),
    ]) {
      canvas.drawCircle(dot, 4.5, smallDotPaint);
    }

    canvas.restore();
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
