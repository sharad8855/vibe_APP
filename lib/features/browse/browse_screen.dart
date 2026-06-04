part of '../../main.dart';

class _BrowseHeader extends StatelessWidget {
  const _BrowseHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Browse',
                style: GoogleFonts.poppins(
                  color: EditoColors.dark,
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Discover thousands of stunning templates',
                style: GoogleFonts.inter(
                  color: EditoColors.body.withValues(alpha: 0.72),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        const _BrowseIconButton(icon: Icons.search_rounded),
        const SizedBox(width: 12),
        const _BrowseIconButton(icon: Icons.tune_rounded),
      ],
    );
  }
}

class _BrowseIconButton extends StatelessWidget {
  const _BrowseIconButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: EditoColors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: EditoColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, 8),
            blurRadius: 22,
          ),
        ],
      ),
      child: Icon(icon, color: EditoColors.dark, size: 29),
    );
  }
}

class _BrowseSearchField extends StatelessWidget {
  const _BrowseSearchField();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: EditoColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: EditoColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            offset: Offset(0, 8),
            blurRadius: 22,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: EditoColors.body.withValues(alpha: 0.70),
            size: 28,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Text(
              'Search templates, categories or creators',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: EditoColors.body.withValues(alpha: 0.66),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrowseCategoryStrip extends StatelessWidget {
  const _BrowseCategoryStrip();

  static const items = [
    ('All', Icons.grid_view_rounded, EditoColors.primary),
    ('Trending', Icons.local_fire_department_rounded, EditoColors.accent),
    ('Travel', Icons.flight_takeoff_rounded, EditoColors.primary),
    ('Wedding', Icons.ring_volume_rounded, Color(0xFF675FA8)),
    ('Business', Icons.business_center_rounded, EditoColors.primary),
    ('Fitness', Icons.fitness_center_rounded, Color(0xFF675FA8)),
    ('Lifestyle', Icons.eco_rounded, Color(0xFF675FA8)),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            _BrowseCategoryTile(
              label: items[i].$1,
              icon: items[i].$2,
              color: items[i].$3,
              selected: i == 0,
            ),
            if (i != items.length - 1) const SizedBox(width: 22),
          ],
        ],
      ),
    );
  }
}

class _BrowseCategoryTile extends StatelessWidget {
  const _BrowseCategoryTile({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: selected ? EditoColors.primary : EditoColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? EditoColors.primary : EditoColors.border,
              ),
              boxShadow: [
                BoxShadow(
                  color: selected
                      ? const Color(0x306C63FF)
                      : const Color(0x08000000),
                  offset: const Offset(0, 8),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Icon(icon, color: selected ? Colors.white : color, size: 27),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: selected ? EditoColors.primary : EditoColors.dark,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedCollections extends StatelessWidget {
  const _FeaturedCollections();

  static const collections = [
    CollectionData(
      title: 'Summer\nVibes',
      count: '28 Templates',
      color: Color(0xFF2C9FB3),
      accent: Color(0xFFFFB347),
      icon: Icons.wb_sunny_rounded,
    ),
    CollectionData(
      title: 'Wedding\nMoments',
      count: '36 Templates',
      color: EditoColors.accent,
      accent: Color(0xFFFFB347),
      icon: Icons.diamond_rounded,
    ),
    CollectionData(
      title: 'Business\nPromo',
      count: '22 Templates',
      color: Color(0xFF244AB5),
      accent: Color(0xFF5D8CEB),
      icon: Icons.business_center_rounded,
    ),
    CollectionData(
      title: 'Travel\nDiaries',
      count: '30 Templates',
      color: Color(0xFF1E1E2E),
      accent: Color(0xFF43C59E),
      icon: Icons.flight_takeoff_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 136,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: collections.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return _CollectionCard(data: collections[index]);
        },
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  const _CollectionCard({required this.data});

  final CollectionData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 118,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [data.color, data.accent.withValues(alpha: 0.72)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            offset: Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _CollectionPainter())),
          Positioned(
            left: 0,
            top: 0,
            right: 8,
            child: Text(
              data.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
                height: 1.22,
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 52,
            right: 0,
            child: Text(
              data.count,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.92),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 31,
              height: 31,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_right_rounded,
                color: EditoColors.dark,
                size: 25,
              ),
            ),
          ),
          Positioned(
            right: 4,
            top: 2,
            child: Icon(
              data.icon,
              color: Colors.white.withValues(alpha: 0.28),
              size: 46,
            ),
          ),
        ],
      ),
    );
  }
}

class _CollectionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.12);
    canvas.drawCircle(Offset(size.width * 0.78, size.height * 0.22), 38, paint);
    canvas.drawCircle(Offset(size.width * 0.15, size.height * 0.90), 34, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
