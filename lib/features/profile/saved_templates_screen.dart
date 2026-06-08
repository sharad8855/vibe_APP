part of '../../main.dart';

class SavedTemplatesScreen extends StatefulWidget {
  const SavedTemplatesScreen({super.key});

  @override
  State<SavedTemplatesScreen> createState() => _SavedTemplatesScreenState();
}

class _SavedTemplatesScreenState extends State<SavedTemplatesScreen> {
  bool _isGridView = true;

  final List<TemplateData> _savedTemplates = [
    const TemplateData(
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
    const TemplateData(
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
    const TemplateData(
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

  final List<TemplateData> _removedTemplatesTemp = [];
  final List<int> _removedIndicesTemp = [];

  void _unsaveTemplate(int index) {
    final template = _savedTemplates[index];
    setState(() {
      _savedTemplates.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '"${template.title}" removed from Saved',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: const Color(0xFF22B37D),
          onPressed: () {
            setState(() {
              _savedTemplates.insert(index, template);
            });
          },
        ),
      ),
    );
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
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
                  sliver: SliverList.list(
                    children: [
                      // Header
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
                                'Saved Templates',
                                style: GoogleFonts.poppins(
                                  color: EditoColors.dark,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  height: 1.15,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Templates you saved for later',
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
                      const SizedBox(height: 25),

                      // List/Grid Toggle and Info Row
                      if (_savedTemplates.isNotEmpty) _buildToggleRow(),
                      const SizedBox(height: 16),

                      // Content
                      if (_savedTemplates.isEmpty)
                        _buildEmptyState()
                      else if (_isGridView)
                        _buildGridView()
                      else
                        _buildListView(),
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

  Widget _buildToggleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${_savedTemplates.length} Saved Items',
          style: GoogleFonts.poppins(
            color: EditoColors.dark,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: EditoColors.border),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _isGridView = true),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _isGridView ? EditoColors.primary.withValues(alpha: 0.12) : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.grid_view_rounded,
                    color: _isGridView ? EditoColors.primary : EditoColors.body.withValues(alpha: 0.6),
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => setState(() => _isGridView = false),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: !_isGridView ? EditoColors.primary.withValues(alpha: 0.12) : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.view_list_rounded,
                    color: !_isGridView ? EditoColors.primary : EditoColors.body.withValues(alpha: 0.6),
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.66,
      ),
      itemCount: _savedTemplates.length,
      itemBuilder: (context, index) {
        final template = _savedTemplates[index];
        return _SavedGridItem(
          template: template,
          onUnsave: () => _unsaveTemplate(index),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _savedTemplates.length,
      itemBuilder: (context, index) {
        final template = _savedTemplates[index];
        return _SavedListItem(
          template: template,
          onUnsave: () => _unsaveTemplate(index),
        );
      },
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
            Icons.bookmark_border_rounded,
            color: Color(0xFFC4C2F4),
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'Your saved templates folder is empty',
            style: GoogleFonts.poppins(
              color: EditoColors.dark,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Explore templates and save them to find them here easily.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: EditoColors.body.withValues(alpha: 0.7),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: EditoColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Text(
              'Explore Templates',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Grid Item Component
// ─────────────────────────────────────────────────────────────

class _SavedGridItem extends StatelessWidget {
  const _SavedGridItem({
    required this.template,
    required this.onUnsave,
  });

  final TemplateData template;
  final VoidCallback onUnsave;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => TemplateDetailScreen(template: template),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: EditoColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x04000000),
              offset: Offset(0, 6),
              blurRadius: 16,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thumbnail
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _TemplateVisual(data: template),
                  Container(color: Colors.black.withValues(alpha: 0.05)),
                  // Bookmark unsave button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onUnsave,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x15000000),
                              offset: Offset(0, 2),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.bookmark_rounded,
                          color: EditoColors.primary,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  // Duration badge
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 10),
                          const SizedBox(width: 2),
                          Text(
                            template.duration,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Price Tag
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: template.price == 'FREE' ? const Color(0xFF22B37D) : EditoColors.accent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        template.price,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Details
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    template.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: EditoColors.dark,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'by ${template.creator}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: EditoColors.body.withValues(alpha: 0.65),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFF4B217), size: 12),
                          const SizedBox(width: 3),
                          Text(
                            template.rating.split(' ').first,
                            style: GoogleFonts.inter(
                              color: EditoColors.dark,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => UseTemplateScreen(template: template),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: EditoColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Use',
                            style: GoogleFonts.inter(
                              color: EditoColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
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
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// List Item Component
// ─────────────────────────────────────────────────────────────

class _SavedListItem extends StatelessWidget {
  const _SavedListItem({
    required this.template,
    required this.onUnsave,
  });

  final TemplateData template;
  final VoidCallback onUnsave;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => TemplateDetailScreen(template: template),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: EditoColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x04000000),
              offset: Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 65,
                height: 85,
                child: _TemplateVisual(data: template),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: EditoColors.dark,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'by ${template.creator}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: EditoColors.body.withValues(alpha: 0.65),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Color(0xFFF4B217), size: 13),
                      const SizedBox(width: 3),
                      Text(
                        template.rating.split(' ').first,
                        style: GoogleFonts.inter(
                          color: EditoColors.dark,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: template.price == 'FREE' ? const Color(0xFFE8F8EF) : const Color(0xFFFFF0F2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          template.price,
                          style: GoogleFonts.inter(
                            color: template.price == 'FREE' ? const Color(0xFF168F54) : const Color(0xFFFF3356),
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Actions
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: onUnsave,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: EditoColors.primary.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.bookmark_rounded,
                      color: EditoColors.primary,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => UseTemplateScreen(template: template),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: EditoColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: Text(
                    'Use',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
