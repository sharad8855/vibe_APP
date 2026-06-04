part of '../../main.dart';

class _TemplateGrid extends StatelessWidget {
  const _TemplateGrid({
    required this.templates,
    this.showDuration = false,
    this.showByCreator = false,
    this.aspectRatio = 0.70,
  });

  final List<TemplateData> templates;
  final bool showDuration;
  final bool showByCreator;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: templates.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 13,
        mainAxisSpacing: 24,
        childAspectRatio: aspectRatio,
      ),
      itemBuilder: (context, index) {
        return _TemplateCard(
          data: templates[index],
          showDuration: showDuration,
          showByCreator: showByCreator,
        );
      },
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({
    required this.data,
    this.showDuration = false,
    this.showByCreator = false,
  });

  final TemplateData data;
  final bool showDuration;
  final bool showByCreator;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(11),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => TemplateDetailScreen(template: data),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: EditoColors.white,
            borderRadius: BorderRadius.circular(11),
            boxShadow: const [
              BoxShadow(
                color: Color(0x11000000),
                offset: Offset(0, 8),
                blurRadius: 22,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _TemplateVisual(data: data),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.05),
                              Colors.black.withValues(alpha: 0.24),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite_border_rounded,
                            color: EditoColors.dark,
                            size: 22,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 8,
                        bottom: 8,
                        child: _TemplateBadge(
                          label: data.category,
                          color: data.color,
                        ),
                      ),
                      if (showDuration)
                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.62),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              data.duration,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      if (data.overlayText.isNotEmpty)
                        Center(
                          child: Text(
                            data.overlayText,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.w900,
                              height: 1.03,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(9, 10, 9, 9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: EditoColors.dark,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFFFB72C),
                            size: 17,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            data.rating,
                            style: GoogleFonts.inter(
                              color: EditoColors.body.withValues(alpha: 0.74),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 13),
                      Row(
                        children: [
                          ClipOval(
                            child: Container(
                              width: 24,
                              height: 24,
                              color: EditoColors.primaryLight,
                              child: const Icon(
                                Icons.person_rounded,
                                size: 16,
                                color: EditoColors.dark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              showByCreator
                                  ? 'by ${data.creator}'
                                  : data.creator,
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                color: EditoColors.dark,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          _PriceBadge(price: data.price),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TemplateVisual extends StatelessWidget {
  const _TemplateVisual({required this.data});

  final TemplateData data;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TemplateVisualPainter(data),
      child: const SizedBox.expand(),
    );
  }
}

class _TemplateVisualPainter extends CustomPainter {
  const _TemplateVisualPainter(this.data);

  final TemplateData data;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [data.secondaryColor, data.color, EditoColors.dark],
        ).createShader(rect),
    );

    final glow = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
    canvas.drawCircle(Offset(size.width * 0.25, size.height * 0.22), 42, glow);
    canvas.drawCircle(Offset(size.width * 0.78, size.height * 0.70), 56, glow);

    if (data.category == 'TRAVEL') {
      _mountains(canvas, size);
    } else if (data.category == 'WEDDING') {
      _wedding(canvas, size);
    } else if (data.category == 'BUSINESS') {
      _business(canvas, size);
    } else {
      _city(canvas, size);
    }
  }

  void _mountains(Canvas canvas, Size size) {
    final back = Path()
      ..moveTo(0, size.height * 0.72)
      ..lineTo(size.width * 0.30, size.height * 0.32)
      ..lineTo(size.width * 0.52, size.height * 0.70)
      ..lineTo(size.width * 0.74, size.height * 0.40)
      ..lineTo(size.width, size.height * 0.74)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      back,
      Paint()..color = Colors.white.withValues(alpha: 0.45),
    );

    final lake = Path()
      ..moveTo(0, size.height * 0.78)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.68,
        size.width,
        size.height * 0.78,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(lake, Paint()..color = const Color(0x992CA8D8));
  }

  void _wedding(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.70);
    canvas.drawCircle(Offset(size.width * 0.40, size.height * 0.46), 28, paint);
    canvas.drawCircle(Offset(size.width * 0.60, size.height * 0.46), 28, paint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.50, size.height * 0.68),
          width: 98,
          height: 42,
        ),
        const Radius.circular(18),
      ),
      paint,
    );
    for (var i = 0; i < 10; i++) {
      canvas.drawCircle(
        Offset((i + 1) * size.width / 11, size.height * 0.20),
        2.5,
        Paint()..color = const Color(0xFFFFD75F),
      );
    }
  }

  void _business(Canvas canvas, Size size) {
    final table = RRect.fromRectAndRadius(
      Rect.fromLTWH(16, size.height * 0.66, size.width - 32, 20),
      const Radius.circular(8),
    );
    canvas.drawRRect(
      table,
      Paint()..color = Colors.white.withValues(alpha: 0.58),
    );
    for (var i = 0; i < 5; i++) {
      final x = 24 + i * (size.width - 48) / 4;
      canvas.drawCircle(
        Offset(x, size.height * 0.42),
        13,
        Paint()..color = Colors.white.withValues(alpha: 0.72),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x, size.height * 0.57),
            width: 28,
            height: 24,
          ),
          const Radius.circular(7),
        ),
        Paint()..color = Colors.white.withValues(alpha: 0.50),
      );
    }
  }

  void _city(Canvas canvas, Size size) {
    final buildingPaint = Paint()..color = Colors.black.withValues(alpha: 0.38);
    for (var i = 0; i < 7; i++) {
      final width = 20.0 + (i % 3) * 8;
      final height = 48.0 + (i % 4) * 15;
      final x = i * size.width / 6 - width / 2;
      canvas.drawRect(
        Rect.fromLTWH(x, size.height - height, width, height),
        buildingPaint,
      );
    }
    final road = Path()
      ..moveTo(size.width * 0.40, size.height)
      ..lineTo(size.width * 0.50, size.height * 0.52)
      ..lineTo(size.width * 0.60, size.height)
      ..close();
    canvas.drawPath(
      road,
      Paint()..color = Colors.white.withValues(alpha: 0.25),
    );
  }

  @override
  bool shouldRepaint(covariant _TemplateVisualPainter oldDelegate) =>
      oldDelegate.data != data;
}

class _TemplateBadge extends StatelessWidget {
  const _TemplateBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _PriceBadge extends StatelessWidget {
  const _PriceBadge({required this.price});

  final String price;

  @override
  Widget build(BuildContext context) {
    final isFree = price == 'FREE';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: isFree ? const Color(0xFFE7FAF2) : const Color(0xFFFFE8F0),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        price,
        style: GoogleFonts.poppins(
          color: isFree ? const Color(0xFF1BB676) : const Color(0xFFE91E70),
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
