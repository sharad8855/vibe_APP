part of '../../main.dart';

class SuccessVerificationAnimation extends StatefulWidget {
  const SuccessVerificationAnimation({
    super.key,
    required this.onAnimationComplete,
    this.message = 'Your email address has been verified.',
  });

  final VoidCallback onAnimationComplete;
  final String message;

  @override
  State<SuccessVerificationAnimation> createState() =>
      _SuccessVerificationAnimationState();
}

class _SuccessVerificationAnimationState
    extends State<SuccessVerificationAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowScaleAnimation;
  late Animation<double> _cardScaleAnimation;
  late Animation<double> _checkmarkDrawingAnimation;
  late Animation<double> _pulseGlowAnimation;
  late Animation<double> _titleOpacityAnimation;
  late Animation<double> _subtitleOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Glow expands from center
    _glowScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
      ),
    );

    // Card scales from 0.9 to 1.0 with a spring/backOut curve
    _cardScaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.55, curve: Curves.easeOutBack),
      ),
    );

    // Checkmark drawing path progress: 0.0 -> 1.0
    _checkmarkDrawingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.easeInOutCubic),
      ),
    );

    // Title opacity
    _titleOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.85, curve: Curves.easeIn),
      ),
    );

    // Subtitle opacity
    _subtitleOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 0.95, curve: Curves.easeIn),
      ),
    );

    // Pulse animation (glow pulse)
    _pulseGlowAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.15), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.15, end: 1.0), weight: 50),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          widget.onAnimationComplete();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Calculate the fading glow opacity
        double glowOpacity = 0.0;
        if (_controller.value < 0.45) {
          glowOpacity = (_controller.value / 0.45).clamp(0.0, 1.0);
        } else {
          glowOpacity = (1.0 - (_controller.value - 0.45) / 0.55).clamp(0.0, 1.0);
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            // Dark Background overlay
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.82),
              ),
            ),

            // Neon green success glow expanding from center
            CustomPaint(
              size: const Size(350, 350),
              painter: NeonGlowPainter(
                _glowScaleAnimation.value,
                glowOpacity,
              ),
            ),

            // Main success card (glassmorphic + scaled)
            Transform.scale(
              scale: _cardScaleAnimation.value,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(
                    width: 320,
                    padding: const EdgeInsets.symmetric(
                      vertical: 38,
                      horizontal: 24,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.09),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Checkmark inside square (with pulse glow behind)
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            if (_controller.value > 0.4)
                              Transform.scale(
                                scale: _pulseGlowAnimation.value,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF00FF88)
                                            .withValues(alpha: 0.32),
                                        blurRadius: 28,
                                        spreadRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            CustomPaint(
                              size: const Size(82, 82),
                              painter: CheckmarkPainter(
                                _checkmarkDrawingAnimation.value,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Verified Successfully Title
                        Opacity(
                          opacity: _titleOpacityAnimation.value,
                          child: Text(
                            'Verified Successfully',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Subtitle
                        Opacity(
                          opacity: _subtitleOpacityAnimation.value,
                          child: Text(
                            widget.message,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: Colors.white.withValues(alpha: 0.72),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Custom Painters for Neon Glow and Checkmark
// ─────────────────────────────────────────────────────────────

class NeonGlowPainter extends CustomPainter {
  NeonGlowPainter(this.scale, this.opacity);

  final double scale;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0.0) return;

    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF00FF88).withValues(alpha: opacity * 0.48),
          const Color(0xFF00FF88).withValues(alpha: opacity * 0.16),
          Colors.transparent,
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2 * scale,
        ),
      );

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2 * scale,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant NeonGlowPainter oldDelegate) {
    return oldDelegate.scale != scale || oldDelegate.opacity != opacity;
  }
}

class CheckmarkPainter extends CustomPainter {
  CheckmarkPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00FF88)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final width = size.width;
    final height = size.height;

    // Draw the rounded square path
    final boxRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, width, height),
      const Radius.circular(18),
    );

    final boxPath = Path()..addRRect(boxRect);

    // Box outline takes first 50% of the progress
    double boxProgress = (progress * 2.0).clamp(0.0, 1.0);
    // Checkmark takes second 50% of the progress
    double checkmarkProgress = ((progress - 0.5) * 2.0).clamp(0.0, 1.0);

    if (boxProgress > 0) {
      final pathMetrics = boxPath.computeMetrics().first;
      final extractPath = pathMetrics.extractPath(
        0.0,
        pathMetrics.length * boxProgress,
      );
      canvas.drawPath(extractPath, paint);
    }

    if (checkmarkProgress > 0) {
      final checkPath = Path()
        ..moveTo(width * 0.32, height * 0.50)
        ..lineTo(width * 0.46, height * 0.64)
        ..lineTo(width * 0.68, height * 0.38);

      final pathMetrics = checkPath.computeMetrics().first;
      final extractPath = pathMetrics.extractPath(
        0.0,
        pathMetrics.length * checkmarkProgress,
      );
      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
