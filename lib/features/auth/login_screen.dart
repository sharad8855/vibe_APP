part of '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;
  bool _isLoading = false;
  String? _errorMessage;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onFieldChanged);
    _passwordController.addListener(_onFieldChanged);
    _animController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.9, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.1, 1.0, curve: Curves.easeOutCubic),
    ));
    _animController.forward();
  }

  void _onFieldChanged() {
    if (_errorMessage != null) {
      setState(() => _errorMessage = null);
    }
  }

  @override
  void dispose() {
    _emailController.removeListener(_onFieldChanged);
    _passwordController.removeListener(_onFieldChanged);
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  void _onContinue() async {
    if (_isLoading) return;
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _errorMessage = 'Please enter your email address');
      return;
    }
    if (!_isValidEmail(email)) {
      setState(() => _errorMessage = 'Please enter a valid email address');
      return;
    }

    if (_isSignUp) {
      final password = _passwordController.text;
      if (password.isEmpty) {
        setState(() => _errorMessage = 'Please enter a password');
        return;
      }
      if (password.length < 8) {
        setState(() => _errorMessage = 'Password must be at least 8 characters');
        return;
      }
      
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        await ApiClient.register(email, password);
        if (!mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => VerifyOtpScreen(
              email: email,
              flowType: 'register',
            ),
          ),
        );
      } on ApiException catch (e) {
        setState(() => _errorMessage = e.message);
      } catch (e) {
        setState(() => _errorMessage = 'Failed to connect to the server');
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else {
      // Login flow
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        await ApiClient.loginOtp(email);
        if (!mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => VerifyOtpScreen(
              email: email,
              flowType: 'login',
            ),
          ),
        );
      } on ApiException catch (e) {
        setState(() => _errorMessage = e.message);
      } catch (e) {
        setState(() => _errorMessage = 'Failed to connect to the server');
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final topSectionHeight = size.height * 0.42;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F4FF),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // ── top purple hero ────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topSectionHeight,
            child: const _HeroSection(),
          ),

          // ── white bottom card ──────────────────────────────────────────
          Positioned(
            top: topSectionHeight - 32,
            left: 0,
            right: 0,
            bottom: 0,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // heading
                        Text(
                          'Welcome to Edito',
                          style: GoogleFonts.poppins(
                            color: EditoColors.dark,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isSignUp ? 'Create your account' : 'Login to continue',
                          style: GoogleFonts.inter(
                            color: EditoColors.body,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Premium Sliding Tab Selector
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0EEFF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final width = constraints.maxWidth / 2;
                              return Stack(
                                children: [
                                  AnimatedPositioned(
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeInOutCubic,
                                    left: _isSignUp ? width : 0,
                                    top: 3,
                                    bottom: 3,
                                    child: Container(
                                      width: width - 6,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(9),
                                        boxShadow: [
                                          BoxShadow(
                                            color: EditoColors.primary.withValues(alpha: 0.12),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () => setState(() {
                                            _isSignUp = false;
                                            _errorMessage = null;
                                          }),
                                          child: Center(
                                            child: Text(
                                              'Login',
                                              style: GoogleFonts.poppins(
                                                color: !_isSignUp ? EditoColors.dark : EditoColors.muted,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () => setState(() {
                                            _isSignUp = true;
                                            _errorMessage = null;
                                          }),
                                          child: Center(
                                            child: Text(
                                              'Sign Up',
                                              style: GoogleFonts.poppins(
                                                color: _isSignUp ? EditoColors.dark : EditoColors.muted,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Form fields
                        _EmailField(
                          controller: _emailController,
                          hasError: _errorMessage != null,
                        ),
                        if (_isSignUp) ...[
                          const SizedBox(height: 16),
                          _PasswordField(
                            controller: _passwordController,
                            hasError: _errorMessage != null,
                          ),
                        ],

                        // error
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.error_outline_rounded,
                                  color: Color(0xFFFF3356), size: 15),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFFF3356),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 16),

                        // Continue / Register button
                        _ContinueBtn(
                          onTap: _onContinue,
                          isLoading: _isLoading,
                          label: _isSignUp ? 'Register' : 'Continue',
                        ),

                        const SizedBox(height: 20),

                        // OR divider
                        Row(
                          children: [
                            const Expanded(
                                child: Divider(
                                    color: Color(0xFFE4E6F0), thickness: 1)),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: Text(
                                'OR',
                                style: GoogleFonts.inter(
                                  color: EditoColors.muted,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            const Expanded(
                                child: Divider(
                                    color: Color(0xFFE4E6F0), thickness: 1)),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Feature pills row
                        const _FeaturePills(),

                        const SizedBox(height: 28),

                        // Terms & Privacy
                        const _TermsNote(),

                        const SizedBox(height: 8),
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

// ─────────────────────────────────────────────────────────────────────────────
// Hero Section (purple top area with logo + film-strip illustration)
// ─────────────────────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFEDE9FF), Color(0xFFE0DBFF)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // subtle film-strip background decoration
            const Positioned.fill(child: _FilmStripDecoration()),

            // centered logo + tagline
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                // Logo icon
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                  child: Center(
                    child: CustomPaint(
                      size: const Size(56, 56),
                      painter: _EditoLogoPainter(),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                // "Edito" wordmark
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Edito',
                        style: GoogleFonts.poppins(
                          color: EditoColors.dark,
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          height: 1,
                        ),
                      ),
                      // play-button "o" dot
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                // "Templates that tell your story."
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Templates that tell ',
                        style: GoogleFonts.inter(
                          color: EditoColors.body,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: 'your story.',
                        style: GoogleFonts.inter(
                          color: EditoColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// "E" logo painter that matches the reference (film-strip inside letter E)
// ─────────────────────────────────────────────────────────────────────────────

class _EditoLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Background gradient letter E shape
    final gradPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF9B6FFF), Color(0xFF6C63FF)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    // Draw E shape
    final ePath = Path()
      ..moveTo(w * 0.12, 0)
      ..lineTo(w * 0.95, 0)
      ..lineTo(w * 0.95, h * 0.28)
      ..lineTo(w * 0.38, h * 0.28)
      ..lineTo(w * 0.38, h * 0.42)
      ..lineTo(w * 0.82, h * 0.42)
      ..lineTo(w * 0.82, h * 0.60)
      ..lineTo(w * 0.38, h * 0.60)
      ..lineTo(w * 0.38, h * 0.72)
      ..lineTo(w * 0.95, h * 0.72)
      ..lineTo(w * 0.95, h)
      ..lineTo(w * 0.12, h)
      ..quadraticBezierTo(0, h, 0, h * 0.88)
      ..lineTo(0, h * 0.12)
      ..quadraticBezierTo(0, 0, w * 0.12, 0)
      ..close();
    canvas.drawPath(ePath, gradPaint);

    // Film-strip dots on the left bar
    final dotPaint = Paint()..color = Colors.white.withValues(alpha: 0.9);
    final dotPositions = [0.12, 0.35, 0.58, 0.81];
    for (final pos in dotPositions) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(w * 0.20, h * pos),
            width: w * 0.12,
            height: h * 0.07,
          ),
          const Radius.circular(2),
        ),
        dotPaint,
      );
    }

    // Play triangle inside the E middle section
    final playPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final play = Path()
      ..moveTo(w * 0.50, h * 0.43)
      ..lineTo(w * 0.50, h * 0.59)
      ..lineTo(w * 0.62, h * 0.51)
      ..close();
    canvas.drawPath(play, playPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Film-strip decoration (background decorative lines)
// ─────────────────────────────────────────────────────────────────────────────

class _FilmStripDecoration extends StatelessWidget {
  const _FilmStripDecoration();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _FilmStripPainter());
  }
}

class _FilmStripPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x1A6C63FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Top-left film strip
    _drawFilmStrip(
        canvas, paint, Offset(-10, size.height * 0.05), size.width * 0.45, 70);

    // Bottom-right film strip
    canvas.save();
    canvas.translate(size.width * 0.72, size.height * 0.55);
    canvas.rotate(0.18);
    _drawFilmStripRaw(canvas, paint, Offset.zero, size.width * 0.45, 70);
    canvas.restore();

    // Sparkle dots
    final dotPaint = Paint()
      ..color = const Color(0x336C63FF)
      ..style = PaintingStyle.fill;
    for (final pos in [
      Offset(size.width * 0.85, size.height * 0.18),
      Offset(size.width * 0.15, size.height * 0.70),
      Offset(size.width * 0.90, size.height * 0.60),
      Offset(size.width * 0.30, size.height * 0.20),
    ]) {
      canvas.drawCircle(pos, 4, dotPaint);
    }

    // Small plus signs
    final crossPaint = Paint()
      ..color = const Color(0x446C63FF)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (final pos in [
      Offset(size.width * 0.78, size.height * 0.10),
      Offset(size.width * 0.10, size.height * 0.55),
    ]) {
      canvas.drawLine(pos.translate(-6, 0), pos.translate(6, 0), crossPaint);
      canvas.drawLine(pos.translate(0, -6), pos.translate(0, 6), crossPaint);
    }
  }

  void _drawFilmStrip(
      Canvas canvas, Paint paint, Offset topLeft, double width, double height) {
    canvas.save();
    canvas.translate(topLeft.dx, topLeft.dy);
    canvas.rotate(-0.2);
    _drawFilmStripRaw(canvas, paint, Offset.zero, width, height);
    canvas.restore();
  }

  void _drawFilmStripRaw(
      Canvas canvas, Paint paint, Offset topLeft, double width, double height) {
    final rect =
        Rect.fromLTWH(topLeft.dx, topLeft.dy, width, height);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      paint,
    );
    // Sprocket holes top
    for (int i = 0; i < 6; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(topLeft.dx + 10 + i * (width - 20) / 5, topLeft.dy + 6,
              (width - 20) / 5 - 6, height * 0.18),
          const Radius.circular(2),
        ),
        paint,
      );
    }
    // Sprocket holes bottom
    for (int i = 0; i < 6; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
              topLeft.dx + 10 + i * (width - 20) / 5,
              topLeft.dy + height - height * 0.18 - 6,
              (width - 20) / 5 - 6,
              height * 0.18),
          const Radius.circular(2),
        ),
        paint,
      );
    }
    // Vertical dividers
    for (int i = 1; i < 5; i++) {
      final x = topLeft.dx + (width / 5) * i;
      canvas.drawLine(
        Offset(x, topLeft.dy + height * 0.28),
        Offset(x, topLeft.dy + height * 0.72),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Email Input Field
// ─────────────────────────────────────────────────────────────────────────────

class _EmailField extends StatelessWidget {
  const _EmailField({required this.controller, this.hasError = false});

  final TextEditingController controller;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F6FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: hasError ? const Color(0xFFFF3356) : const Color(0xFFE0DCFF),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(Icons.email_outlined, color: EditoColors.muted, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: EditoColors.primary,
              style: GoogleFonts.inter(
                color: EditoColors.dark,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter email address',
                hintStyle: GoogleFonts.inter(
                  color: EditoColors.muted,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Password Input Field
// ─────────────────────────────────────────────────────────────────────────────

class _PasswordField extends StatefulWidget {
  const _PasswordField({required this.controller, this.hasError = false});

  final TextEditingController controller;
  final bool hasError;

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F6FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: widget.hasError ? const Color(0xFFFF3356) : const Color(0xFFE0DCFF),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(Icons.lock_outlined, color: EditoColors.muted, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: widget.controller,
              obscureText: _obscure,
              textInputAction: TextInputAction.done,
              cursorColor: EditoColors.primary,
              style: GoogleFonts.inter(
                color: EditoColors.dark,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter password',
                hintStyle: GoogleFonts.inter(
                  color: EditoColors.muted,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: EditoColors.muted,
              size: 20,
            ),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Continue Button (deep purple gradient with arrow/spinner)
// ─────────────────────────────────────────────────────────────────────────────

class _ContinueBtn extends StatefulWidget {
  const _ContinueBtn({
    required this.onTap,
    this.isLoading = false,
    required this.label,
  });

  final VoidCallback onTap;
  final bool isLoading;
  final String label;

  @override
  State<_ContinueBtn> createState() => _ContinueBtnState();
}

class _ContinueBtnState extends State<_ContinueBtn> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (!widget.isLoading) setState(() => _pressed = true);
      },
      onTapUp: (_) {
        if (!widget.isLoading) {
          setState(() => _pressed = false);
          widget.onTap();
        }
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed || widget.isLoading ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [Color(0xFF7B5FFF), Color(0xFF5B3FE8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C63FF).withValues(alpha: 0.35),
                offset: const Offset(0, 8),
                blurRadius: 20,
              ),
            ],
          ),
          child: widget.isLoading
              ? const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.label,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Feature pills: Secure | Fast | Create
// ─────────────────────────────────────────────────────────────────────────────

class _FeaturePills extends StatelessWidget {
  const _FeaturePills();

  static const _items = [
    (Icons.shield_outlined, 'Secure', 'Your data is safe\nand protected'),
    (Icons.bolt_rounded, 'Fast', 'Quick login to get\nyou started'),
    (Icons.play_circle_outline_rounded, 'Create',
        'Start creating amazing\nvideos instantly'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_items.length, (i) {
        final (icon, label, sub) = _items[i];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: i == 0 ? 0 : 6,
              right: i == _items.length - 1 ? 0 : 6,
            ),
            child: _FeaturePill(icon: icon, label: label, sub: sub),
          ),
        );
      }),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  const _FeaturePill({
    required this.icon,
    required this.label,
    required this.sub,
  });

  final IconData icon;
  final String label;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF0EEFF),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFDDD9FF),
              width: 1.5,
            ),
          ),
          child: Icon(icon, color: EditoColors.primary, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: EditoColors.dark,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          sub,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: EditoColors.muted,
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Terms & Privacy footer
// ─────────────────────────────────────────────────────────────────────────────

class _TermsNote extends StatelessWidget {
  const _TermsNote();

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.inter(
          color: EditoColors.muted,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.6,
        ),
        children: [
          const TextSpan(text: 'By continuing, you agree to our '),
          TextSpan(
            text: 'Terms of Service',
            style: const TextStyle(
              color: EditoColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const TextSpan(text: '\nand '),
          TextSpan(
            text: 'Privacy Policy',
            style: const TextStyle(
              color: EditoColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
