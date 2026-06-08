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

  String _selectedCategory = 'All';

  List<Widget> _buildHomeContent() {
    final filteredTemplates = _selectedCategory == 'All'
        ? _templates
        : _templates.where((t) => t.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();

    return [
      const _HomeTopBar(),
      const SizedBox(height: 27),
      const _HomeBannerCarousel(),
      const SizedBox(height: 18),
      _StatsRow(
        onTapStat: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      const SizedBox(height: 30),
      _CategoryPills(
        selectedCategory: _selectedCategory,
        onSelected: (cat) {
          setState(() {
            _selectedCategory = cat;
          });
        },
      ),
      const SizedBox(height: 28),
      _SectionHeader(title: _selectedCategory == 'All' ? 'Trending Now' : '$_selectedCategory Templates'),
      const SizedBox(height: 14),
      _TemplateGrid(
        templates: filteredTemplates,
        showDuration: true,
        showByCreator: true,
        aspectRatio: 0.68,
      ),
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
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const SearchScreen(),
              ),
            );
          },
          child: const Icon(Icons.search_rounded, color: EditoColors.dark, size: 35),
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
  const _StatsRow({required this.onTapStat});

  final ValueChanged<int> onTapStat;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.layers_rounded,
            value: '1,250+',
            label: 'Templates\nAvailable',
            color: EditoColors.primary,
            tint: EditoColors.primaryLight,
            onTap: () => onTapStat(1), // index 1 is Browse
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.movie_creation_rounded,
            value: '24.6K',
            label: 'Videos\nCreated',
            color: const Color(0xFF22B77A),
            tint: const Color(0xFFDDF7EA),
            onTap: () => onTapStat(2), // index 2 is My Videos
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.wallet_rounded,
            value: '₹ 3,45,678',
            label: 'Earnings\nPaid',
            color: EditoColors.accent,
            tint: const Color(0xFFFFE5EC),
            onTap: () => onTapStat(3), // index 3 is Profile
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
    required this.onTap,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final Color tint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 125,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: EditoColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              offset: Offset(0, 8),
              blurRadius: 24,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: tint,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                Icon(
                  Icons.arrow_outward_rounded,
                  color: EditoColors.body.withValues(alpha: 0.3),
                  size: 14,
                ),
              ],
            ),
            const Spacer(),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: GoogleFonts.poppins(
                  color: color,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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
    );
  }
}

class _CategoryPills extends StatelessWidget {
  const _CategoryPills({required this.selectedCategory, required this.onSelected});

  final String selectedCategory;
  final ValueChanged<String> onSelected;

  static const categories = [
    ('All', Icons.auto_awesome_rounded),
    ('Trending', Icons.local_fire_department_rounded),
    ('Travel', Icons.flight_takeoff_rounded),
    ('Wedding', Icons.ring_volume_rounded),
    ('Business', Icons.business_center_rounded),
    ('Urban', Icons.location_city_rounded),
    ('Lifestyle', Icons.eco_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (var i = 0; i < categories.length; i++) ...[
            GestureDetector(
              onTap: () => onSelected(categories[i].$1),
              child: _CategoryChip(
                label: categories[i].$1,
                icon: categories[i].$2,
                selected: selectedCategory.toLowerCase() == categories[i].$1.toLowerCase(),
              ),
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

class _NavItem extends StatefulWidget {
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
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final selectedColor = EditoColors.primary;
    final unselectedColor = EditoColors.body.withValues(alpha: 0.72);
    final activeBgColor = EditoColors.primaryLight;
    final inactiveBgColor = Colors.transparent;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed ? 0.90 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: SizedBox(
          width: 74,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                width: widget.selected ? 36 : 0,
                height: 3,
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: selectedColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              if (!widget.selected)
                const SizedBox(height: 7),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutBack,
                width: widget.selected ? 43 : 36,
                height: widget.selected ? 43 : 36,
                decoration: BoxDecoration(
                  color: widget.selected ? activeBgColor : inactiveBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  color: widget.selected ? selectedColor : unselectedColor,
                  size: widget.selected ? 31 : 29,
                ),
              ),
              const SizedBox(height: 3),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                style: GoogleFonts.inter(
                  color: widget.selected ? selectedColor : unselectedColor,
                  fontSize: 12,
                  fontWeight: widget.selected ? FontWeight.w800 : FontWeight.w600,
                ),
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Home Banner Slider / Carousel
// ─────────────────────────────────────────────────────────────
class _HomeBannerCarousel extends StatefulWidget {
  const _HomeBannerCarousel();

  @override
  State<_HomeBannerCarousel> createState() => _HomeBannerCarouselState();
}

class _HomeBannerCarouselState extends State<_HomeBannerCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % 3;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 185,
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              const _CreatorBanner(),
              _buildFeaturedTemplateBanner(),
              _buildProBanner(),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 3; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == i ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _currentPage == i ? EditoColors.primary : const Color(0xFFDCDDEA),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeaturedTemplateBanner() {
    final weddingTemplate = const TemplateData(
      title: 'Royal Wedding Moments',
      category: 'WEDDING',
      rating: '4.9 (5.1K)',
      creator: 'The Wedding Films',
      duration: '00:25',
      price: '₹199',
      color: EditoColors.accent,
      secondaryColor: Color(0xFFFFB347),
      overlayText: '',
    );
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE91E63), Color(0xFFFF9800)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x20E91E63),
            offset: Offset(0, 10),
            blurRadius: 24,
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'HOT FEATURED TEMPLATE',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Royal Wedding\nMoments',
                  maxLines: 2,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    height: 1.16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Craft cinematic wedding films in seconds.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => TemplateDetailScreen(template: weddingTemplate),
                      ),
                    );
                  },
                  child: Container(
                    width: 120,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Text(
                      'Try Template',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFE91E63),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Expanded(flex: 8, child: _BannerArtWedding()),
        ],
      ),
    );
  }

  Widget _buildProBanner() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8A3CFF), Color(0xFF2196F3)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x208A3CFF),
            offset: Offset(0, 10),
            blurRadius: 24,
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'GO PROFESSIONAL',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Unlock Edito Pro\nGet All Templates',
                  maxLines: 2,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    height: 1.16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Gain unlimited access to 1,250+ paid video templates.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Pro subscription packages are coming soon!',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Container(
                    width: 110,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Text(
                      'Upgrade Now',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF8A3CFF),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Expanded(flex: 8, child: _BannerArtPro()),
        ],
      ),
    );
  }
}

class _BannerArtWedding extends StatelessWidget {
  const _BannerArtWedding();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: Colors.white.withValues(alpha: 0.15),
        ),
        const Icon(
          Icons.favorite_rounded,
          color: Colors.white,
          size: 40,
        ),
      ],
    );
  }
}

class _BannerArtPro extends StatelessWidget {
  const _BannerArtPro();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: Colors.white.withValues(alpha: 0.15),
        ),
        const Icon(
          Icons.star_rounded,
          color: Colors.white,
          size: 44,
        ),
      ],
    );
  }
}
