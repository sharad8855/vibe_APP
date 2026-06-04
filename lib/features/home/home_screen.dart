part of '../../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _templates = [
    TemplateData(
      title: 'Wanderlust Journey',
      category: 'TRAVEL',
      rating: '4.8 (2.3K)',
      creator: 'Rohit Creative',
      duration: '00:20',
      price: 'FREE',
      color: Color(0xFF7C63FF),
      secondaryColor: Color(0xFF2CA8D8),
      overlayText: '',
    ),
    TemplateData(
      title: 'Royal Wedding Moments',
      category: 'WEDDING',
      rating: '4.9 (5.1K)',
      creator: 'The Wedding Films',
      duration: '00:25',
      price: '₹199',
      color: EditoColors.accent,
      secondaryColor: Color(0xFFFFB347),
      overlayText: '',
    ),
    TemplateData(
      title: 'Urban Style Intro',
      category: 'URBAN',
      rating: '4.7 (1.8K)',
      creator: 'Sam Motion',
      duration: '00:18',
      price: '₹149',
      color: Color(0xFF51428F),
      secondaryColor: Color(0xFF1E1E2E),
      overlayText: 'URBAN\nSTYLE',
    ),
    TemplateData(
      title: 'Corporate Minimal',
      category: 'BUSINESS',
      rating: '4.6 (982)',
      creator: 'Biz Studio',
      duration: '00:22',
      price: '₹149',
      color: Color(0xFF5D8CEB),
      secondaryColor: Color(0xFF43C59E),
      overlayText: '',
    ),
    TemplateData(
      title: 'Concert Reel Pack',
      category: 'TRENDING',
      rating: '4.8 (3.4K)',
      creator: 'Stage Cut',
      duration: '00:16',
      price: 'FREE',
      color: Color(0xFF6C63FF),
      secondaryColor: Color(0xFFFF6584),
      overlayText: '',
    ),
    TemplateData(
      title: 'Beach Travel Diary',
      category: 'LIFESTYLE',
      rating: '4.7 (1.2K)',
      creator: 'Coast Studio',
      duration: '00:21',
      price: '₹99',
      color: Color(0xFF43C59E),
      secondaryColor: Color(0xFF5D8CEB),
      overlayText: '',
    ),
  ];

  late int _selectedIndex = widget.initialIndex;

  List<Widget> _buildHomeContent() {
    return [
      const _HomeTopBar(),
      const SizedBox(height: 27),
      const _CreatorBanner(),
      const SizedBox(height: 18),
      const _StatsRow(),
      const SizedBox(height: 30),
      const _CategoryPills(),
      const SizedBox(height: 28),
      const _SectionHeader(title: 'Trending Now'),
      const SizedBox(height: 14),
      _TemplateGrid(templates: _templates.take(4).toList(growable: false)),
    ];
  }

  List<Widget> _buildBrowseContent() {
    return [
      const _BrowseHeader(),
      const SizedBox(height: 27),
      const _BrowseSearchField(),
      const SizedBox(height: 24),
      const _BrowseCategoryStrip(),
      const SizedBox(height: 32),
      const _SectionHeader(title: 'Featured Collections'),
      const SizedBox(height: 15),
      const _FeaturedCollections(),
      const SizedBox(height: 32),
      const _SectionHeader(title: 'Trending Templates'),
      const SizedBox(height: 15),
      _TemplateGrid(
        templates: _templates,
        showDuration: true,
        showByCreator: true,
        aspectRatio: 0.68,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _SoftBackground()),
          SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 150),
                  sliver: SliverList.list(
                    children: switch (_selectedIndex) {
                      1 => _buildBrowseContent(),
                      2 => const [MyVideosScreen()],
                      3 => const [ProfileScreen()],
                      _ => _buildHomeContent(),
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 17,
            right: 17,
            bottom: 26,
            child: _HomeBottomNav(
              selectedIndex: _selectedIndex,
              onSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeTopBar extends StatelessWidget {
  const _HomeTopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'E',
                style: GoogleFonts.poppins(
                  color: EditoColors.primary,
                  fontSize: 31,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              TextSpan(
                text: 'dito',
                style: GoogleFonts.poppins(
                  color: EditoColors.dark,
                  fontSize: 31,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
        Transform.translate(
          offset: const Offset(-21, -16),
          child: const CircleAvatar(
            radius: 3.5,
            backgroundColor: EditoColors.accent,
          ),
        ),
        const Spacer(),
        const Icon(Icons.search_rounded, color: EditoColors.dark, size: 35),
        const SizedBox(width: 20),
        Container(
          width: 50,
          height: 50,
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [EditoColors.primary, Color(0xFFC7BFFF)],
            ),
          ),
          child: ClipOval(
            child: Container(
              color: EditoColors.primaryLight,
              child: const Icon(
                Icons.person_rounded,
                color: EditoColors.dark,
                size: 34,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CreatorBanner extends StatelessWidget {
  const _CreatorBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 178,
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF683CFF), Color(0xFFFF5F86)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x246C63FF),
            offset: Offset(0, 12),
            blurRadius: 28,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Become a Creator &\nEarn Forever',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    height: 1.16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Share your templates with millions\nand earn every time a user creates\na video.',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.88),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 151,
                  height: 32,
                  padding: const EdgeInsets.only(left: 11, right: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Join Creator Program',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: EditoColors.dark,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: EditoColors.accent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 19,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Expanded(flex: 8, child: _BannerArt()),
        ],
      ),
    );
  }
}

class _BannerArt extends StatelessWidget {
  const _BannerArt();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BannerArtPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _BannerArtPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.56, size.height * 0.52);
    final ringPaint = Paint()
      ..color = const Color(0x552F22C9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    canvas.drawArc(
      Rect.fromCenter(center: center, width: 118, height: 98),
      -0.6,
      5.2,
      false,
      ringPaint,
    );

    final playCard = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 112, height: 82),
      const Radius.circular(22),
    );
    canvas.drawRRect(
      playCard,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFC8B9FF), Color(0xFF6E5BFF)],
        ).createShader(playCard.outerRect),
    );
    canvas.drawShadow(
      Path()..addRRect(playCard),
      const Color(0x805341D9),
      8,
      true,
    );

    final play = Path()
      ..moveTo(center.dx - 12, center.dy - 23)
      ..lineTo(center.dx - 12, center.dy + 23)
      ..lineTo(center.dx + 26, center.dy)
      ..close();
    canvas.drawPath(play, Paint()..color = Colors.white);

    _coin(canvas, Offset(size.width * 0.20, size.height * 0.18), 25);
    _coin(canvas, Offset(size.width * 0.88, size.height * 0.18), 20);
    _coin(canvas, Offset(size.width * 0.91, size.height * 0.72), 22);

    final film = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, size.height * 0.42, 72, 34),
      const Radius.circular(6),
    );
    canvas.save();
    canvas.rotate(0.12);
    canvas.drawRRect(film, Paint()..color = const Color(0xCCFFFFFF));
    canvas.drawRRect(
      film,
      Paint()
        ..color = const Color(0xFF7C63FF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    for (var i = 0; i < 4; i++) {
      canvas.drawCircle(
        Offset(12 + i * 16, size.height * 0.48),
        3,
        Paint()..color = const Color(0xFF8B73FF),
      );
    }
    canvas.restore();
  }

  void _coin(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFFFFC13D));
    canvas.drawCircle(
      center.translate(-3, -3),
      radius * 0.72,
      Paint()..color = const Color(0xFFFFD75F),
    );
    final textPainter = TextPainter(
      text: TextSpan(
        text: '₹',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: radius * 1.05,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _StatCard(
            icon: Icons.layers_rounded,
            value: '1,250+',
            label: 'Templates\nAvailable',
            color: EditoColors.primary,
            tint: EditoColors.primaryLight,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.movie_creation_rounded,
            value: '24.6K',
            label: 'Videos\nCreated',
            color: Color(0xFF22B77A),
            tint: Color(0xFFDDF7EA),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.wallet_rounded,
            value: '₹ 3,45,678',
            label: 'Earnings\nPaid',
            color: EditoColors.accent,
            tint: Color(0xFFFFE5EC),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.tint,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: EditoColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            offset: Offset(0, 10),
            blurRadius: 28,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 21),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: color,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    color: EditoColors.body.withValues(alpha: 0.78),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryPills extends StatelessWidget {
  const _CategoryPills();

  static const categories = [
    ('All', Icons.auto_awesome_rounded),
    ('Travel', Icons.flight_takeoff_rounded),
    ('Wedding', Icons.ring_volume_rounded),
    ('Business', Icons.business_center_rounded),
    ('Fitness', Icons.fitness_center_rounded),
    ('Urban', Icons.location_city_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (var i = 0; i < categories.length; i++) ...[
            _CategoryChip(
              label: categories[i].$1,
              icon: categories[i].$2,
              selected: i == 0,
            ),
            if (i != categories.length - 1) const SizedBox(width: 7),
          ],
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.selected,
  });

  final String label;
  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: EdgeInsets.symmetric(horizontal: selected ? 15 : 12),
      decoration: BoxDecoration(
        color: selected ? EditoColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: selected ? EditoColors.primary : const Color(0xFFDCDDEA),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          if (!selected) ...[
            Icon(
              icon,
              color: EditoColors.body.withValues(alpha: 0.72),
              size: 18,
            ),
            const SizedBox(width: 7),
          ],
          Text(
            label,
            style: GoogleFonts.inter(
              color: selected
                  ? Colors.white
                  : EditoColors.body.withValues(alpha: 0.78),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: EditoColors.dark,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'See All',
          style: GoogleFonts.poppins(
            color: EditoColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 5),
        const Icon(Icons.chevron_right_rounded, color: EditoColors.primary),
      ],
    );
  }
}

class _HomeBottomNav extends StatelessWidget {
  const _HomeBottomNav({required this.selectedIndex, required this.onSelected});

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 79,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(38),
        boxShadow: const [
          BoxShadow(
            color: Color(0x17000000),
            offset: Offset(0, 12),
            blurRadius: 34,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_outlined,
            label: 'Home',
            selected: selectedIndex == 0,
            onTap: () => onSelected(0),
          ),
          _NavItem(
            icon: Icons.grid_view_rounded,
            label: 'Browse',
            selected: selectedIndex == 1,
            onTap: () => onSelected(1),
          ),
          _NavItem(
            icon: Icons.play_circle_outline_rounded,
            label: 'My Videos',
            selected: selectedIndex == 2,
            onTap: () => onSelected(2),
          ),
          _NavItem(
            icon: Icons.person_outline_rounded,
            label: 'Profile',
            selected: selectedIndex == 3,
            onTap: () => onSelected(3),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: SizedBox(
          width: 74,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (selected)
                Transform.translate(
                  offset: const Offset(0, -15),
                  child: Container(
                    width: 36,
                    height: 3,
                    decoration: BoxDecoration(
                      color: EditoColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                )
              else
                const SizedBox(height: 3),
              Container(
                width: selected ? 43 : 36,
                height: selected ? 43 : 36,
                decoration: BoxDecoration(
                  color: selected
                      ? EditoColors.primaryLight
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: selected
                      ? EditoColors.primary
                      : EditoColors.body.withValues(alpha: 0.72),
                  size: selected ? 31 : 29,
                ),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: selected
                      ? EditoColors.primary
                      : EditoColors.body.withValues(alpha: 0.72),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
