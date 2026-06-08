part of '../../main.dart';

class MyVideosScreen extends StatefulWidget {
  const MyVideosScreen({super.key});

  @override
  State<MyVideosScreen> createState() => _MyVideosScreenState();
}

class _MyVideosScreenState extends State<MyVideosScreen> {
  String _selectedTab = 'All';

  static const _videos = [
    _MyVideoData(
      title: 'Wanderlust Journey',
      category: 'Travel Vlog',
      updated: 'Updated 2 mins ago',
      status: 'Completed',
      duration: '00:28',
      color: Color(0xFF7C63FF),
      secondaryColor: Color(0xFF2CA8D8),
      overlayText: '',
    ),
    _MyVideoData(
      title: 'Royal Wedding Moments',
      category: 'Wedding',
      updated: 'Updated 1 hour ago',
      status: 'Completed',
      duration: '00:35',
      color: EditoColors.accent,
      secondaryColor: Color(0xFFFFB347),
      overlayText: '',
    ),
    _MyVideoData(
      title: 'Urban Style Intro',
      category: 'Promo',
      updated: 'Updated 3 hours ago',
      status: 'In Progress',
      duration: '00:22',
      color: Color(0xFF51428F),
      secondaryColor: Color(0xFF1E1E2E),
      overlayText: 'URBAN\nSTYLE',
    ),
    _MyVideoData(
      title: 'Corporate Minimal',
      category: 'Business',
      updated: 'Updated Yesterday',
      status: 'In Progress',
      duration: '00:18',
      color: Color(0xFF5D8CEB),
      secondaryColor: Color(0xFF43C59E),
      overlayText: '',
    ),
    _MyVideoData(
      title: 'Memories Forever',
      category: 'Family',
      updated: 'Updated 2 days ago',
      status: 'Completed',
      duration: '00:30',
      color: Color(0xFFFF8A4C),
      secondaryColor: Color(0xFFFFD38B),
      overlayText: '',
    ),
    _MyVideoData(
      title: 'Party Night Vibes',
      category: 'Event',
      updated: 'Updated 3 days ago',
      status: 'Draft',
      duration: '00:15',
      color: EditoColors.primary,
      secondaryColor: EditoColors.accent,
      overlayText: '',
    ),
    _MyVideoData(
      title: 'Neon Cyberpunk Promo',
      category: 'Cyberpunk',
      updated: 'Updated 4 days ago',
      status: 'Template',
      duration: '00:12',
      color: Color(0xFF00F0FF),
      secondaryColor: Color(0xFFFF007F),
      overlayText: 'NEON',
    ),
  ];

  List<_MyVideoData> get _filteredVideos {
    if (_selectedTab == 'All') {
      return _videos.where((v) => v.status != 'Template').toList();
    }
    var targetStatus = _selectedTab;
    if (targetStatus == 'Drafts') targetStatus = 'Draft';
    if (targetStatus == 'Templates') targetStatus = 'Template';
    return _videos.where((v) => v.status == targetStatus).toList();
  }

  int get _totalCount => _videos.where((v) => v.status != 'Template').length;
  int get _inProgressCount => _videos.where((v) => v.status == 'In Progress').length;
  int get _completedCount => _videos.where((v) => v.status == 'Completed').length;
  int get _draftsCount => _videos.where((v) => v.status == 'Draft').length;

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredVideos;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _MyVideosHeader(),
        const SizedBox(height: 38),
        _MyVideosTabs(
          selectedTab: _selectedTab,
          onTabChanged: (tab) {
            setState(() {
              _selectedTab = tab;
            });
          },
        ),
        const SizedBox(height: 23),
        _MyVideosStatsRow(
          selectedTab: _selectedTab,
          onTabChanged: (tab) {
            setState(() {
              _selectedTab = tab;
            });
          },
          totalCount: _totalCount,
          inProgressCount: _inProgressCount,
          completedCount: _completedCount,
          draftsCount: _draftsCount,
        ),
        const SizedBox(height: 32),
        const _MyVideosToolbar(),
        const SizedBox(height: 21),
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                'No videos found in this category',
                style: GoogleFonts.inter(
                  color: EditoColors.body.withValues(alpha: 0.6),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        else
          for (var i = 0; i < filtered.length; i++) ...[
            _MyVideoRow(video: filtered[i]),
            if (i != filtered.length - 1) const SizedBox(height: 14),
          ],
      ],
    );
  }
}

class _MyVideosHeader extends StatelessWidget {
  const _MyVideosHeader();

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
                'My Videos',
                style: GoogleFonts.poppins(
                  color: EditoColors.dark,
                  fontSize: 35,
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "All videos you've created or edited",
                style: GoogleFonts.inter(
                  color: EditoColors.body.withValues(alpha: 0.72),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        const _BrowseIconButton(icon: Icons.search_rounded),
        const SizedBox(width: 12),
        const _BrowseIconButton(icon: Icons.filter_alt_outlined),
      ],
    );
  }
}

class _MyVideosTabs extends StatelessWidget {
  const _MyVideosTabs({
    required this.selectedTab,
    required this.onTabChanged,
  });

  final String selectedTab;
  final ValueChanged<String> onTabChanged;

  static const tabs = [
    'All',
    'In Progress',
    'Completed',
    'Drafts',
    'Templates',
  ];

  @override
  Widget build(BuildContext context) {
    final selectedIndex = tabs.indexOf(selectedTab).clamp(0, tabs.length - 1);

    return Column(
      children: [
        Row(
          children: [
            for (var i = 0; i < tabs.length; i++)
              Expanded(
                child: GestureDetector(
                  onTap: () => onTabChanged(tabs[i]),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      tabs[i],
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: tabs[i] == selectedTab
                            ? EditoColors.primary
                            : EditoColors.body.withValues(alpha: 0.76),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 17),
        Stack(
          children: [
            Container(height: 1, color: EditoColors.border),
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: Alignment(-1.0 + (selectedIndex * 2.0 / (tabs.length - 1)), 0.0),
              child: FractionallySizedBox(
                widthFactor: 1 / tabs.length,
                child: Container(
                  height: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: EditoColors.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MyVideosStatsRow extends StatelessWidget {
  const _MyVideosStatsRow({
    required this.selectedTab,
    required this.onTabChanged,
    required this.totalCount,
    required this.inProgressCount,
    required this.completedCount,
    required this.draftsCount,
  });

  final String selectedTab;
  final ValueChanged<String> onTabChanged;
  final int totalCount;
  final int inProgressCount;
  final int completedCount;
  final int draftsCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onTabChanged('All'),
            child: _VideoStatCard(
              icon: Icons.play_arrow_rounded,
              value: totalCount.toString(),
              label: 'Total Videos',
              color: EditoColors.primary,
              tint: EditoColors.primaryLight,
              isActive: selectedTab == 'All',
            ),
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: GestureDetector(
            onTap: () => onTabChanged('In Progress'),
            child: _VideoStatCard(
              icon: Icons.schedule_rounded,
              value: inProgressCount.toString(),
              label: 'In Progress',
              color: const Color(0xFF3182F6),
              tint: const Color(0xFFEAF2FF),
              isActive: selectedTab == 'In Progress',
            ),
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: GestureDetector(
            onTap: () => onTabChanged('Completed'),
            child: _VideoStatCard(
              icon: Icons.check_rounded,
              value: completedCount.toString(),
              label: 'Completed',
              color: const Color(0xFF19A970),
              tint: const Color(0xFFE7FAF2),
              isActive: selectedTab == 'Completed',
            ),
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: GestureDetector(
            onTap: () => onTabChanged('Drafts'),
            child: _VideoStatCard(
              icon: Icons.description_rounded,
              value: draftsCount.toString(),
              label: 'Drafts',
              color: const Color(0xFFFF6D5F),
              tint: const Color(0xFFFFF0F3),
              isActive: selectedTab == 'Drafts',
            ),
          ),
        ),
      ],
    );
  }
}

class _VideoStatCard extends StatelessWidget {
  const _VideoStatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.tint,
    required this.isActive,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final Color tint;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 88,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: EditoColors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: isActive ? color : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isActive ? color.withValues(alpha: 0.15) : const Color(0x0D000000),
            offset: const Offset(0, 8),
            blurRadius: 24,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 9),
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: EditoColors.dark,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: EditoColors.body.withValues(alpha: 0.75),
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _MyVideosToolbar extends StatelessWidget {
  const _MyVideosToolbar();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        width: 430,
        child: Row(
          children: [
            Text(
              'Sort by:',
              style: GoogleFonts.poppins(
                color: EditoColors.dark,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              height: 38,
              width: 136,
              padding: const EdgeInsets.symmetric(horizontal: 13),
              decoration: BoxDecoration(
                color: EditoColors.white.withValues(alpha: 0.52),
                borderRadius: BorderRadius.circular(19),
                border: Border.all(color: EditoColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Last Modified',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: EditoColors.dark,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: EditoColors.dark,
                    size: 22,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              'Grid View',
              style: GoogleFonts.poppins(
                color: EditoColors.dark,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.grid_view_rounded,
              color: EditoColors.dark,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _MyVideoRow extends StatelessWidget {
  const _MyVideoRow({required this.video});

  final _MyVideoData video;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 132,
      child: Row(
        children: [
          Expanded(flex: 4, child: _MyVideoThumbnail(video: video)),
          Expanded(
            flex: 6,
            child: Container(
              height: 132,
              padding: const EdgeInsets.fromLTRB(13, 12, 12, 12),
              decoration: const BoxDecoration(
                color: EditoColors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0B000000),
                    offset: Offset(0, 8),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Icon(
                      Icons.more_horiz_rounded,
                      color: EditoColors.dark,
                      size: 24,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              video.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: EditoColors.dark,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 26),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _CategoryLabel(label: video.category, color: video.color),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.videocam_outlined,
                            color: EditoColors.body.withValues(alpha: 0.62),
                            size: 14,
                          ),
                          const SizedBox(width: 5),
                          _MetaText('1080p'),
                          const SizedBox(width: 15),
                          Icon(
                            Icons.motion_photos_on_outlined,
                            color: EditoColors.body.withValues(alpha: 0.62),
                            size: 14,
                          ),
                          const SizedBox(width: 5),
                          _MetaText('30fps'),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              video.updated,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                color: EditoColors.body.withValues(alpha: 0.75),
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          _StatusBadge(status: video.status),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MyVideoThumbnail extends StatelessWidget {
  const _MyVideoThumbnail({required this.video});

  final _MyVideoData video;

  @override
  Widget build(BuildContext context) {
    final template = TemplateData(
      title: video.title,
      category: video.category.toUpperCase(),
      rating: '',
      creator: '',
      duration: video.duration,
      price: '',
      color: video.color,
      secondaryColor: video.secondaryColor,
      overlayText: video.overlayText,
    );

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        bottomLeft: Radius.circular(12),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _TemplateVisual(data: template),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.02),
                  Colors.black.withValues(alpha: 0.30),
                ],
              ),
            ),
          ),
          Positioned(
            right: 8,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.68),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                video.duration,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          if (video.overlayText.isNotEmpty)
            Center(
              child: Text(
                video.overlayText,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  height: 1.02,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryLabel extends StatelessWidget {
  const _CategoryLabel({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.inter(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        color: EditoColors.body.withValues(alpha: 0.72),
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'Completed' => const Color(0xFF19A970),
      'In Progress' => const Color(0xFF3182F6),
      'Template' => const Color(0xFFFF3F80),
      _ => EditoColors.body,
    };
    final background = switch (status) {
      'Completed' => const Color(0xFFE7FAF2),
      'In Progress' => const Color(0xFFEAF2FF),
      'Template' => const Color(0xFFFFF0F5),
      _ => const Color(0xFFF1F2F7),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        status,
        style: GoogleFonts.inter(
          color: color,
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _MyVideoData {
  const _MyVideoData({
    required this.title,
    required this.category,
    required this.updated,
    required this.status,
    required this.duration,
    required this.color,
    required this.secondaryColor,
    required this.overlayText,
  });

  final String title;
  final String category;
  final String updated;
  final String status;
  final String duration;
  final Color color;
  final Color secondaryColor;
  final String overlayText;
}
