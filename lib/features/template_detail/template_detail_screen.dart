part of '../../main.dart';

class TemplateDetailScreen extends StatelessWidget {
  const TemplateDetailScreen({super.key, required this.template});

  final TemplateData template;

  @override
  Widget build(BuildContext context) {
    final price = template.price == 'FREE' ? 'FREE' : template.price;

    return Scaffold(
      backgroundColor: EditoColors.white,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _TemplateDetailHero(template: template),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 126),
                sliver: SliverList.list(
                  children: [
                    const _DetailCarouselDots(),
                    const SizedBox(height: 30),
                    _DetailTitleRow(template: template, price: price),
                    const SizedBox(height: 16),
                    _DetailMetaRow(template: template),
                    const SizedBox(height: 25),
                    _DetailCreatorCard(template: template),
                    const SizedBox(height: 27),
                    const _DetailSectionTitle(
                      title: 'What You Need',
                      showInfoIcon: true,
                    ),
                    const SizedBox(height: 13),
                    const _RequirementStrip(),
                    const SizedBox(height: 27),
                    const Divider(color: EditoColors.border),
                    const SizedBox(height: 18),
                    const _DetailSectionTitle(
                      title: 'Preview by Other Users',
                      action: 'See All',
                    ),
                    const SizedBox(height: 14),
                    _PreviewStrip(template: template),
                    const SizedBox(height: 27),
                    const Divider(color: EditoColors.border),
                    const SizedBox(height: 18),
                    const _DetailSectionTitle(
                      title: 'Reviews (5.1K)',
                      action: 'See All',
                    ),
                    const SizedBox(height: 14),
                    const _ReviewRow(),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: _UseTemplateButton(template: template),
          ),
        ],
      ),
    );
  }
}

class _TemplateDetailHero extends StatelessWidget {
  const _TemplateDetailHero({required this.template});

  final TemplateData template;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, topPadding + 12, 16, 0),
      child: Container(
        height: 270,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Load unsplash image if wedding category
              if (template.category == 'WEDDING')
                Image.network(
                  'https://images.unsplash.com/photo-1607190074257-dd4b7af0309f?w=800&auto=format&fit=crop&q=80',
                  fit: BoxFit.cover,
                )
              else
                _TemplateVisual(data: template),

              // Gradient Overlay
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.35),
                      Colors.transparent,
                      Colors.black.withOpacity(0.65),
                    ],
                  ),
                ),
              ),

              // Player ui overlay
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Top Row
                    Row(
                      children: [
                        _HeroCircleButton(
                          icon: Icons.arrow_back_rounded,
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        const Spacer(),
                        const _HeroCircleButton(
                          icon: Icons.favorite_border_rounded,
                        ),
                        const SizedBox(width: 12),
                        const _HeroCircleButton(
                          icon: Icons.ios_share_rounded,
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Play Button
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.black,
                        size: 34,
                      ),
                    ),
                    const Spacer(),
                    // Seek bar Row
                    Row(
                      children: [
                        const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '00:00',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Container(
                                height: 3,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.35),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: 0.35,
                                child: Container(
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8D56FF),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 60,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF8D56FF),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '00:30',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.fullscreen_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailHeroOverlayPainter extends CustomPainter {
  const _DetailHeroOverlayPainter(this.template);

  final TemplateData template;

  @override
  void paint(Canvas canvas, Size size) {
    if (template.category == 'WEDDING') {
      _weddingCouple(canvas, size);
      return;
    }

    final glow = Paint()
      ..color = Colors.white.withValues(alpha: 0.20)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24);
    canvas.drawCircle(Offset(size.width * 0.72, size.height * 0.28), 64, glow);
    canvas.drawCircle(Offset(size.width * 0.24, size.height * 0.70), 42, glow);
  }

  void _weddingCouple(Canvas canvas, Size size) {
    final left = Offset(size.width * 0.40, size.height * 0.50);
    final right = Offset(size.width * 0.59, size.height * 0.50);

    final light = Paint()
      ..color = const Color(0xFFFFD895).withValues(alpha: 0.24)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    for (var i = 0; i < 18; i++) {
      canvas.drawCircle(
        Offset((i * 47) % size.width, 26 + (i * 31) % 150),
        5,
        light,
      );
    }

    canvas.drawOval(
      Rect.fromCenter(center: left, width: 62, height: 76),
      Paint()..color = const Color(0xFF7F2234),
    );
    canvas.drawOval(
      Rect.fromCenter(center: right, width: 62, height: 76),
      Paint()..color = const Color(0xFFB82935),
    );
    canvas.drawCircle(
      Offset(left.dx, left.dy - 45),
      24,
      Paint()..color = const Color(0xFFD8A074),
    );
    canvas.drawCircle(
      Offset(right.dx, right.dy - 43),
      23,
      Paint()..color = const Color(0xFFD99B70),
    );
    canvas.drawPath(
      Path()
        ..moveTo(right.dx - 36, right.dy - 64)
        ..quadraticBezierTo(
          right.dx + 14,
          right.dy - 92,
          right.dx + 46,
          right.dy,
        )
        ..lineTo(right.dx + 22, right.dy + 48)
        ..quadraticBezierTo(
          right.dx - 36,
          right.dy + 4,
          right.dx - 36,
          right.dy - 64,
        )
        ..close(),
      Paint()..color = const Color(0x99D6323B),
    );
  }

  @override
  bool shouldRepaint(covariant _DetailHeroOverlayPainter oldDelegate) =>
      oldDelegate.template != template;
}

class _HeroCircleButton extends StatelessWidget {
  const _HeroCircleButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Container(
          width: 54,
          height: 54,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: EditoColors.dark, size: 31),
        ),
      ),
    );
  }
}

class _DetailCarouselDots extends StatelessWidget {
  const _DetailCarouselDots();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 17,
          height: 8,
          decoration: BoxDecoration(
            color: EditoColors.primary,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        for (var i = 0; i < 3; i++) ...[
          const SizedBox(width: 8),
          const CircleAvatar(radius: 4, backgroundColor: Color(0xFFC9CBD8)),
        ],
      ],
    );
  }
}

class _DetailTitleRow extends StatelessWidget {
  const _DetailTitleRow({required this.template, required this.price});

  final TemplateData template;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title and ratings
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      template.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: EditoColors.dark,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (template.price != 'FREE') const _ProBadge(),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: Color(0xFFFFB72C),
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '4.9',
                    style: GoogleFonts.inter(
                      color: EditoColors.dark,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(5.1K Reviews)',
                    style: GoogleFonts.inter(
                      color: EditoColors.body.withOpacity(0.65),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.people_outline_rounded,
                    color: EditoColors.body.withOpacity(0.65),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '125K Videos Created',
                    style: GoogleFonts.inter(
                      color: EditoColors.body.withOpacity(0.65),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Price Badge Card
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            price,
            style: GoogleFonts.poppins(
              color: const Color(0xFFE43F83),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProBadge extends StatelessWidget {
  const _ProBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: EditoColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'PRO',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _DetailMetaRow extends StatelessWidget {
  const _DetailMetaRow({required this.template});

  final TemplateData template;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 9,
      children: [
        _DetailChip(
          icon: Icons.sell_outlined,
          label: _titleCase(template.category),
          color: EditoColors.accent,
          tint: const Color(0xFFFFEDF5),
        ),
        const _DetailChip(
          icon: Icons.hd_outlined,
          label: '1080p',
          color: EditoColors.primary,
          tint: Color(0xFFEFE8FF),
        ),
        _DetailChip(
          icon: Icons.timer_outlined,
          label: '${template.duration.replaceFirst('00:', '')}s',
          color: const Color(0xFF43B875),
          tint: const Color(0xFFE8F7EE),
        ),
        const _DetailChip(
          icon: Icons.link_rounded,
          label: 'Multi-clip',
          color: Color(0xFF348ADB),
          tint: Color(0xFFE7F3FF),
        ),
      ],
    );
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.tint,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailCreatorCard extends StatelessWidget {
  const _DetailCreatorCard({required this.template});

  final TemplateData template;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: EditoColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1EEFF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            offset: Offset(0, 9),
            blurRadius: 24,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Created by',
            style: GoogleFonts.poppins(
              color: EditoColors.dark,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Styled W logo
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  'W',
                  style: GoogleFonts.cinzel(
                    color: const Color(0xFFD4AF37),
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            template.creator,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: EditoColors.dark,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.verified_rounded,
                          color: Color(0xFF3B82F6),
                          size: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Professional ${_titleCase(template.category)} Video Creator',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: EditoColors.body.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Stats with icons
                    Row(
                      children: [
                        const Icon(
                          Icons.folder_open_outlined,
                          color: EditoColors.muted,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '45 Templates',
                          style: GoogleFonts.inter(
                            color: EditoColors.body.withOpacity(0.6),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '•',
                          style: TextStyle(
                            color: EditoColors.body.withOpacity(0.4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.people_outline_rounded,
                          color: EditoColors.muted,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '12K Followers',
                          style: GoogleFonts.inter(
                            color: EditoColors.body.withOpacity(0.6),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // View Profile Button
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F1FD),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View Profile',
                        style: GoogleFonts.poppins(
                          color: EditoColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: EditoColors.primary,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailSectionTitle extends StatelessWidget {
  const _DetailSectionTitle({
    required this.title,
    this.action,
    this.showInfoIcon = false,
  });

  final String title;
  final String? action;
  final bool showInfoIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: EditoColors.dark,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (showInfoIcon) ...[
          const SizedBox(width: 6),
          Icon(
            Icons.info_outline_rounded,
            color: EditoColors.body.withOpacity(0.5),
            size: 18,
          ),
        ],
        const Spacer(),
        if (action != null) ...[
          Text(
            action!,
            style: GoogleFonts.inter(
              color: EditoColors.primary,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.chevron_right_rounded,
            color: EditoColors.primary,
            size: 20,
          ),
        ],
      ],
    );
  }
}

class _RequirementStrip extends StatelessWidget {
  const _RequirementStrip();

  static const items = [
    (Icons.videocam_outlined, 'Bride Video', 'Required'),
    (Icons.videocam_outlined, 'Groom Video', 'Required'),
    (Icons.image_outlined, 'Couple Photo', 'Required'),
    (Icons.text_fields_rounded, 'Couple Name', 'Required'),
    (Icons.verified_outlined, 'Logo (Optional)', 'Optional'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            _RequirementTile(
              icon: items[i].$1,
              title: items[i].$2,
              subtitle: items[i].$3,
            ),
            if (i != items.length - 1) const SizedBox(width: 15),
          ],
        ],
      ),
    );
  }
}

class _RequirementTile extends StatelessWidget {
  const _RequirementTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 119,
      height: 111,
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: Color(0xFFF0ECFF),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: EditoColors.primary, size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: EditoColors.dark,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              color: subtitle == 'Required'
                  ? EditoColors.primary
                  : EditoColors.body.withOpacity(0.5),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewStrip extends StatelessWidget {
  const _PreviewStrip({required this.template});

  final TemplateData template;

  static const names = [
    'Priya & Rahul',
    'Anjali & Karan',
    'Neha & Amit',
    'Meera & Vikram',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (var i = 0; i < names.length; i++) ...[
            _UserPreviewCard(template: template, name: names[i], index: i),
            if (i != names.length - 1) const SizedBox(width: 14),
          ],
        ],
      ),
    );
  }
}

class _UserPreviewCard extends StatelessWidget {
  const _UserPreviewCard({
    required this.template,
    required this.name,
    required this.index,
  });

  final TemplateData template;
  final String name;
  final int index;

  @override
  Widget build(BuildContext context) {
    final previewImages = [
      'https://images.unsplash.com/photo-1583939003579-730e3918a45a?w=400&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=400&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=400&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1621616875450-79f22448040e?w=400&auto=format&fit=crop&q=80',
    ];

    final userAvatars = [
      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&auto=format&fit=crop&q=80',
    ];

    final durationText = ['00:28', '00:30', '00:27', '00:29'][index];

    return SizedBox(
      width: 146,
      child: Container(
        decoration: BoxDecoration(
          color: EditoColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1EEFF)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              offset: Offset(0, 8),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 160,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      previewImages[index],
                      fit: BoxFit.cover,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.45),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.black,
                          size: 22,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.65),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          durationText,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundImage: NetworkImage(userAvatars[index]),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: EditoColors.dark,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cards = [
          const _ReviewCard(
            name: 'Rahul Sharma',
            badge: 'Verified Purchase',
            avatarUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100&auto=format&fit=crop&q=80',
            text: 'Perfect template for wedding videos! Very easy to use and output is awesome.',
          ),
          const _ReviewCard(
            name: 'Priya Verma',
            avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&auto=format&fit=crop&q=80',
            text: 'Loved the transitions and music. Highly recommended!',
          ),
        ];

        if (constraints.maxWidth < 500) {
          return Column(
            children: [cards[0], const SizedBox(height: 14), cards[1]],
          );
        }

        return Row(
          children: [
            Expanded(child: cards[0]),
            const SizedBox(width: 14),
            Expanded(child: cards[1]),
          ],
        );
      },
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
    required this.name,
    required this.text,
    required this.avatarUrl,
    this.badge,
  });

  final String name;
  final String text;
  final String avatarUrl;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EditoColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1EEFF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            offset: Offset(0, 8),
            blurRadius: 18,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(avatarUrl),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: EditoColors.dark,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        for (var i = 0; i < 5; i++)
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFFFB72C),
                            size: 14,
                          ),
                        const SizedBox(width: 6),
                        if (badge != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEECFF),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.verified_user_rounded,
                                  color: EditoColors.primary,
                                  size: 10,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  badge!,
                                  style: GoogleFonts.inter(
                                    color: EditoColors.primary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Text(
                            '1 week ago',
                            style: GoogleFonts.inter(
                              color: EditoColors.body.withOpacity(0.5),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            text,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: EditoColors.body.withOpacity(0.85),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _UseTemplateButton extends StatelessWidget {
  const _UseTemplateButton({required this.template});

  final TemplateData template;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => UseTemplateScreen(template: template),
            ),
          );
        },
        child: Container(
          height: 92,
          padding: const EdgeInsets.fromLTRB(22, 14, 18, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              colors: [Color(0xFF5A2EFF), Color(0xFF9E56FF)],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x356C63FF),
                offset: Offset(0, 12),
                blurRadius: 28,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 53,
                height: 53,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.13),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Use This Template',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Upload your content and create a video',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: EditoColors.primary,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _titleCase(String value) {
  if (value.isEmpty) {
    return value;
  }
  final lower = value.toLowerCase();
  return lower.substring(0, 1).toUpperCase() + lower.substring(1);
}
