part of '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _animController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          PageRouteBuilder<void>(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070412),
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.3,
                  colors: [
                    Color(0xFF1D1243),
                    Color(0xFF090514),
                  ],
                ),
              ),
            ),
          ),

          // Filmstrips background custom paint
          const Positioned.fill(
            child: CustomPaint(
              painter: _BackgroundFilmstripPainter(),
            ),
          ),

          // Twinkling stars scattered
          const Positioned(
            left: 50,
            top: 150,
            child: _TwinklingStar(size: 20, color: Color(0xFF9E56FF), delayMs: 0),
          ),
          const Positioned(
            right: 80,
            top: 240,
            child: _TwinklingStar(size: 26, color: Color(0xFFB176FF), delayMs: 400),
          ),
          const Positioned(
            left: 70,
            bottom: 300,
            child: _TwinklingStar(size: 16, color: Color(0xFF9E56FF), delayMs: 800),
          ),
          const Positioned(
            right: 60,
            bottom: 180,
            child: _TwinklingStar(size: 22, color: Color(0xFFB176FF), delayMs: 200),
          ),

          // Center Logo and text content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Stylized 'E' logo icon
                const CustomPaint(
                  size: Size(82, 100),
                  painter: _LogoIconPainter(),
                ),
                const SizedBox(height: 18),

                // Typographic Text Logo "Edito"
                _buildEditoTextLogo(),
                const SizedBox(height: 16),

                // Subtitle
                Text(
                  'Templates that tell your story.',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),

                // Step slogan list
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _buildStepText('Choose Template'),
                    _buildStepDot(),
                    _buildStepText('Add Your Clips'),
                    _buildStepDot(),
                    _buildStepText('Create Magic'),
                  ],
                ),
              ],
            ),
          ),

          // Loading Progress Bar & Text at the bottom
          Positioned(
            left: 60,
            right: 60,
            bottom: 70,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Progress Bar
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: SizedBox(
                        height: 5,
                        child: LinearProgressIndicator(
                          value: _progressAnimation.value,
                          backgroundColor: const Color(0xFF1D1440),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF9E56FF)),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // Loading Text
                Text(
                  'Loading magic...',
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditoTextLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Ed',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 62,
            fontWeight: FontWeight.w900,
            height: 1.0,
          ),
        ),
        _buildCustomLetterI(),
        Text(
          't',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 62,
            fontWeight: FontWeight.w900,
            height: 1.0,
          ),
        ),
        _buildCustomLetterO(),
      ],
    );
  }

  Widget _buildCustomLetterI() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 4-pointed star above
          CustomPaint(
            size: const Size(18, 18),
            painter: const _FourPointStarPainter(color: Color(0xFF9E56FF)),
          ),
          const SizedBox(height: 4),
          // Stem of the 'i' (dotless 'ı')
          Text(
            'ı',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 62,
              fontWeight: FontWeight.w900,
              height: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomLetterO() {
    return Container(
      margin: const EdgeInsets.only(left: 2),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'o',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 62,
              fontWeight: FontWeight.w900,
              height: 1.0,
            ),
          ),
          Positioned(
            bottom: 11, // Adjust to center in the hole of 'o'
            child: Container(
              width: 19,
              height: 19,
              decoration: const BoxDecoration(
                color: Color(0xFF9E56FF),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Padding(
                padding: EdgeInsets.only(left: 2),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepText(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        color: const Color(0xFFA57EFF),
        fontSize: 11.5,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _buildStepDot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        '•',
        style: GoogleFonts.inter(
          color: const Color(0xFFA57EFF),
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _FourPointStarPainter extends CustomPainter {
  const _FourPointStarPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    final cx = size.width / 2;
    final cy = size.height / 2;
    final rx = size.width / 2;
    final ry = size.height / 2;

    path.moveTo(cx, cy - ry);
    path.quadraticBezierTo(cx, cy, cx + rx, cy);
    path.quadraticBezierTo(cx, cy, cx, cy + ry);
    path.quadraticBezierTo(cx, cy, cx - rx, cy);
    path.quadraticBezierTo(cx, cy, cx, cy - ry);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _FourPointStarPainter oldDelegate) => oldDelegate.color != color;
}

class _LogoIconPainter extends CustomPainter {
  const _LogoIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFB176FF), // Neon Violet/Purple
          Color(0xFF5F2EEA), // Indigo/Blue-Purple
        ],
      ).createShader(rect)
      ..style = PaintingStyle.fill;

    final path = Path();
    final w = size.width;
    final h = size.height;
    
    final leftBarWidth = w * 0.32;
    final armHeight = h * 0.20;
    final midArmWidth = w * 0.88;
    final midArmY = h * 0.40;
    final midArmHeight = h * 0.20;

    // Top arm path
    path.moveTo(0, armHeight);
    path.lineTo(0, 12);
    path.quadraticBezierTo(0, 0, 12, 0);
    path.lineTo(w - 12, 0);
    path.quadraticBezierTo(w, 0, w, 12);
    path.lineTo(w, armHeight - 6);
    path.quadraticBezierTo(w, armHeight, w - 6, armHeight);
    
    path.lineTo(leftBarWidth + 12, armHeight);
    path.quadraticBezierTo(leftBarWidth, armHeight, leftBarWidth, armHeight + 12);
    
    path.lineTo(leftBarWidth, midArmY - 12);
    path.quadraticBezierTo(leftBarWidth, midArmY, leftBarWidth + 12, midArmY);
    path.lineTo(midArmWidth - 12, midArmY);
    path.quadraticBezierTo(midArmWidth, midArmY, midArmWidth, midArmY + 6);
    
    path.lineTo(midArmWidth, midArmY + midArmHeight - 6);
    path.quadraticBezierTo(midArmWidth, midArmY + midArmHeight, midArmWidth - 12, midArmY + midArmHeight);
    path.lineTo(leftBarWidth + 12, midArmY + midArmHeight);
    
    path.quadraticBezierTo(leftBarWidth, midArmY + midArmHeight, leftBarWidth, midArmY + midArmHeight + 12);
    
    path.lineTo(leftBarWidth, h - armHeight - 12);
    path.quadraticBezierTo(leftBarWidth, h - armHeight, leftBarWidth + 12, h - armHeight);
    path.lineTo(w - 6, h - armHeight);
    path.quadraticBezierTo(w, h - armHeight, w, h - armHeight + 6);
    path.lineTo(w, h - 12);
    path.quadraticBezierTo(w, h, w - 12, h);
    path.lineTo(12, h);
    path.quadraticBezierTo(0, h, 0, h - 12);
    path.close();

    canvas.drawPath(path, paint);

    // Sprocket holes on left backbone
    final holePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final holeW = leftBarWidth * 0.32;
    final holeH = h * 0.08;
    final holeX = leftBarWidth * 0.34;
    
    const holesCount = 5;
    final spacing = (h - (holeH * holesCount)) / (holesCount + 1);
    
    for (int i = 0; i < holesCount; i++) {
      final holeY = spacing + i * (holeH + spacing);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(holeX, holeY, holeW, holeH),
          const Radius.circular(2.5),
        ),
        holePaint,
      );
    }

    // Play triangle on the middle arm
    final playPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final playPath = Path();
    final px = leftBarWidth + (midArmWidth - leftBarWidth) * 0.44;
    final py = midArmY + midArmHeight * 0.5;
    final sizeFactor = h * 0.09;
    
    playPath.moveTo(px - sizeFactor * 0.4, py - sizeFactor * 0.6);
    playPath.lineTo(px + sizeFactor * 0.6, py);
    playPath.lineTo(px - sizeFactor * 0.4, py + sizeFactor * 0.6);
    playPath.close();
    
    canvas.drawPath(playPath, playPaint);
  }

  @override
  bool shouldRepaint(covariant _LogoIconPainter oldDelegate) => false;
}

class _BackgroundFilmstripPainter extends CustomPainter {
  const _BackgroundFilmstripPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = Colors.white.withValues(alpha: 0.07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
      
    final paintFill = Paint()
      ..color = Colors.white.withValues(alpha: 0.02)
      ..style = PaintingStyle.fill;

    final paintHole = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;

    // Top-Right Filmstrip
    _drawFilmstrip(
      canvas,
      p0: Offset(size.width * 0.2, -50),
      p1: Offset(size.width * 0.7, 50),
      p2: Offset(size.width + 50, size.height * 0.28),
      width: 68,
      paintLine: paintLine,
      paintFill: paintFill,
      paintHole: paintHole,
    );

    // Bottom-Left Filmstrip
    _drawFilmstrip(
      canvas,
      p0: Offset(-50, size.height * 0.68),
      p1: Offset(size.width * 0.3, size.height * 0.88),
      p2: Offset(size.width * 0.85, size.height + 50),
      width: 68,
      paintLine: paintLine,
      paintFill: paintFill,
      paintHole: paintHole,
    );
  }

  void _drawFilmstrip(
    Canvas canvas, {
    required Offset p0,
    required Offset p1,
    required Offset p2,
    required double width,
    required Paint paintLine,
    required Paint paintFill,
    required Paint paintHole,
  }) {
    const steps = 24;
    final leftPoints = <Offset>[];
    final rightPoints = <Offset>[];
    final centerPoints = <Offset>[];
    final tangents = <Offset>[];

    for (int i = 0; i <= steps; i++) {
      final t = i / steps;
      final mt = 1 - t;
      final x = mt * mt * p0.dx + 2 * mt * t * p1.dx + t * t * p2.dx;
      final y = mt * mt * p0.dy + 2 * mt * t * p1.dy + t * t * p2.dy;
      final pt = Offset(x, y);
      centerPoints.add(pt);

      final tx = 2 * mt * (p1.dx - p0.dx) + 2 * t * (p2.dx - p1.dx);
      final ty = 2 * mt * (p1.dy - p0.dy) + 2 * t * (p2.dy - p1.dy);
      final tangent = Offset(tx, ty);
      tangents.add(tangent);

      final len = math.sqrt(tx * tx + ty * ty);
      if (len > 0) {
        final nx = -ty / len;
        final ny = tx / len;
        final normal = Offset(nx, ny);
        leftPoints.add(pt + normal * (width / 2));
        rightPoints.add(pt - normal * (width / 2));
      } else {
        leftPoints.add(pt);
        rightPoints.add(pt);
      }
    }

    final fillPath = Path();
    fillPath.moveTo(leftPoints.first.dx, leftPoints.first.dy);
    for (int i = 1; i < leftPoints.length; i++) {
      fillPath.lineTo(leftPoints[i].dx, leftPoints[i].dy);
    }
    for (int i = rightPoints.length - 1; i >= 0; i--) {
      fillPath.lineTo(rightPoints[i].dx, rightPoints[i].dy);
    }
    fillPath.close();
    canvas.drawPath(fillPath, paintFill);

    final leftLinePath = Path();
    leftLinePath.moveTo(leftPoints.first.dx, leftPoints.first.dy);
    for (int i = 1; i < leftPoints.length; i++) {
      leftLinePath.lineTo(leftPoints[i].dx, leftPoints[i].dy);
    }
    canvas.drawPath(leftLinePath, paintLine);

    final rightLinePath = Path();
    rightLinePath.moveTo(rightPoints.first.dx, rightPoints.first.dy);
    for (int i = 1; i < rightPoints.length; i++) {
      rightLinePath.lineTo(rightPoints[i].dx, rightPoints[i].dy);
    }
    canvas.drawPath(rightLinePath, paintLine);

    final holeW = width * 0.08;
    final holeH = width * 0.12;

    for (int i = 1; i < steps; i += 2) {
      final pt = centerPoints[i];
      final tangent = tangents[i];
      final angle = math.atan2(tangent.dy, tangent.dx);
      final len = math.sqrt(tangent.dx * tangent.dx + tangent.dy * tangent.dy);
      
      if (len > 0) {
        final nx = -tangent.dy / len;
        final ny = tangent.dx / len;
        final normal = Offset(nx, ny);

        final holeLeftCenter = pt + normal * (width / 2 - 6);
        final holeRightCenter = pt - normal * (width / 2 - 6);

        _drawRotatedRect(canvas, holeLeftCenter, holeH, holeW, angle, paintHole);
        _drawRotatedRect(canvas, holeRightCenter, holeH, holeW, angle, paintHole);
      }
    }
  }

  void _drawRotatedRect(Canvas canvas, Offset center, double width, double height, double angle, Paint paint) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: width, height: height),
        const Radius.circular(1.5),
      ),
      paint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BackgroundFilmstripPainter oldDelegate) => false;
}

class _TwinklingStar extends StatefulWidget {
  const _TwinklingStar({required this.size, required this.color, required this.delayMs});
  final double size;
  final Color color;
  final int delayMs;

  @override
  State<_TwinklingStar> createState() => _TwinklingStarState();
}

class _TwinklingStarState extends State<_TwinklingStar> with SingleTickerProviderStateMixin {
  late AnimationController _starController;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );
    _opacityAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.1, end: 0.9), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: 0.9, end: 0.1), weight: 60),
    ]).animate(_starController);

    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) {
        _starController.repeat();
      }
    });
  }

  @override
  void dispose() {
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _starController,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnim.value,
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _FourPointStarPainter(color: widget.color),
          ),
        );
      },
    );
  }
}
