part of '../../main.dart';

class MyTemplatesScreen extends StatefulWidget {
  const MyTemplatesScreen({super.key});

  @override
  State<MyTemplatesScreen> createState() => _MyTemplatesScreenState();
}

class _MyTemplatesScreenState extends State<MyTemplatesScreen> {
  String _selectedFilter = 'All'; // 'All', 'Live', 'In Review'

  // The 3 templates owned by Rohit Creative (as documented in home and submit screens)
  final List<Map<String, dynamic>> _myTemplates = [
    {
      'template': const TemplateData(
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
      'status': 'Live',
      'uses': '2.3K',
      'earnings': '₹ 4,600',
    },
    {
      'template': const TemplateData(
        title: 'Summer Vibes',
        category: 'LIFESTYLE',
        rating: '4.9 (12.5K)',
        creator: 'Rohit Creative',
        duration: '00:15',
        price: 'FREE',
        color: Color(0xFFFF4F79),
        secondaryColor: Color(0xFFFFB347),
        overlayText: 'SUMMER\nVIBES',
      ),
      'status': 'Live',
      'uses': '12.5K',
      'earnings': '₹ 25,000',
    },
    {
      'template': const TemplateData(
        title: 'Royal Wedding Moments',
        category: 'WEDDING',
        rating: '0.0 (0)',
        creator: 'Rohit Creative',
        duration: '00:30',
        price: 'FREE',
        color: EditoColors.accent,
        secondaryColor: Color(0xFFFFB347),
        overlayText: '',
      ),
      'status': 'In Review',
      'uses': '0',
      'earnings': '₹ 0',
    },
  ];

  void _showNotification(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _selectedFilter == 'All'
        ? _myTemplates
        : _myTemplates.where((t) => t['status'] == _selectedFilter).toList();

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
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
                  sliver: SliverList.list(
                    children: [
                      // Header Row
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: _UseHeaderButton(
                              icon: Icons.chevron_left_rounded,
                              onTap: () => Navigator.of(context).pop(),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'My Templates',
                                style: GoogleFonts.poppins(
                                  color: EditoColors.dark,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  height: 1.15,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'View and manage your published templates',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: EditoColors.body.withValues(alpha: 0.74),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Stats Summary Box
                      const _StatsSummaryBox(),
                      const SizedBox(height: 25),

                      // Filter pills row
                      Row(
                        children: [
                          _FilterPill(
                            label: 'All',
                            selected: _selectedFilter == 'All',
                            count: _myTemplates.length,
                            onTap: () => setState(() => _selectedFilter = 'All'),
                          ),
                          const SizedBox(width: 8),
                          _FilterPill(
                            label: 'Live',
                            selected: _selectedFilter == 'Live',
                            count: _myTemplates.where((t) => t['status'] == 'Live').length,
                            onTap: () => setState(() => _selectedFilter = 'Live'),
                          ),
                          const SizedBox(width: 8),
                          _FilterPill(
                            label: 'In Review',
                            selected: _selectedFilter == 'In Review',
                            count: _myTemplates.where((t) => t['status'] == 'In Review').length,
                            onTap: () => setState(() => _selectedFilter = 'In Review'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Templates List
                      if (filteredList.isEmpty)
                        _buildEmptyState()
                      else
                        for (final t in filteredList)
                          _MyTemplateItem(
                            template: t['template'] as TemplateData,
                            status: t['status'] as String,
                            uses: t['uses'] as String,
                            earnings: t['earnings'] as String,
                            onShare: () => showShareSheet(
                              context,
                              title: (t['template'] as TemplateData).title,
                              template: t['template'] as TemplateData,
                            ),
                            onDelete: () => _showNotification('Delete request submitted for "${t['template'].title}"'),
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: EditoColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.folder_open_rounded,
            color: Color(0xFFC4C2F4),
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'No templates found',
            style: GoogleFonts.poppins(
              color: EditoColors.dark,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Create your first template to share it here.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: EditoColors.body.withValues(alpha: 0.7),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Stats Summary Box Component
// ─────────────────────────────────────────────────────────────

class _StatsSummaryBox extends StatelessWidget {
  const _StatsSummaryBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE7E1F7)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D6C63FF),
            offset: Offset(0, 9),
            blurRadius: 28,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Performance Summary',
            style: GoogleFonts.poppins(
              color: EditoColors.dark,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _SummaryStatItem(
                  value: '3',
                  label: 'Templates',
                  color: EditoColors.primary,
                ),
              ),
              Container(width: 1, height: 42, color: EditoColors.border),
              Expanded(
                child: _SummaryStatItem(
                  value: '14.8K',
                  label: 'Total Uses',
                  color: const Color(0xFF22B37D),
                ),
              ),
              Container(width: 1, height: 42, color: EditoColors.border),
              Expanded(
                child: _SummaryStatItem(
                  value: '₹ 29.6K',
                  label: 'Earnings',
                  color: EditoColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryStatItem extends StatelessWidget {
  const _SummaryStatItem({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            color: color,
            fontSize: 21,
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            color: EditoColors.body.withValues(alpha: 0.72),
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Filter Pill Component
// ─────────────────────────────────────────────────────────────

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.selected,
    required this.count,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? EditoColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: selected ? EditoColors.primary : const Color(0xFFDCDDEA),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                color: selected ? Colors.white : EditoColors.body.withValues(alpha: 0.78),
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: selected ? Colors.white.withValues(alpha: 0.22) : const Color(0xFFECEBFF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                count.toString(),
                style: GoogleFonts.inter(
                  color: selected ? Colors.white : EditoColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Template Item Widget
// ─────────────────────────────────────────────────────────────

class _MyTemplateItem extends StatelessWidget {
  const _MyTemplateItem({
    required this.template,
    required this.status,
    required this.uses,
    required this.earnings,
    required this.onShare,
    required this.onDelete,
  });

  final TemplateData template;
  final String status;
  final String uses;
  final String earnings;
  final VoidCallback onShare;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isLive = status == 'Live';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EditoColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            offset: Offset(0, 8),
            blurRadius: 18,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preview Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 90,
              height: 116,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _TemplateVisual(data: template),
                  Container(color: Colors.black.withValues(alpha: 0.1)),
                  const Center(
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Color(0x95000000),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Template Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        template.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: EditoColors.dark,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isLive ? const Color(0xFFE8F8EF) : const Color(0xFFF1ECFF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isLive ? const Color(0xFF22B37D) : EditoColors.primary,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            status,
                            style: GoogleFonts.inter(
                              color: isLive ? const Color(0xFF168F54) : EditoColors.primary,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  template.category,
                  style: GoogleFonts.inter(
                    color: EditoColors.body.withValues(alpha: 0.65),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),

                // Stats Block
                Row(
                  children: [
                    // Uses
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.trending_up_rounded,
                            color: Color(0xFF22B37D),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                uses,
                                style: GoogleFonts.poppins(
                                  color: EditoColors.dark,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Uses',
                                style: GoogleFonts.inter(
                                  color: EditoColors.body.withValues(alpha: 0.65),
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Earnings
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.account_balance_wallet_outlined,
                            color: EditoColors.accent,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                earnings,
                                style: GoogleFonts.poppins(
                                  color: EditoColors.dark,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Earnings',
                                style: GoogleFonts.inter(
                                  color: EditoColors.body.withValues(alpha: 0.65),
                                  fontSize: 9.5,
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
                
                // Action Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Delete Request
                    GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0F2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.delete_outline_rounded,
                              color: Color(0xFFFF3356),
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Delete',
                              style: GoogleFonts.inter(
                                color: const Color(0xFFFF3356),
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Share Button
                    GestureDetector(
                      onTap: onShare,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1ECFF),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFDCD5FF)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.share_outlined,
                              color: EditoColors.primary,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Share',
                              style: GoogleFonts.inter(
                                color: EditoColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
