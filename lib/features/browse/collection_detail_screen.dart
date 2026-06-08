part of '../../main.dart';

class CollectionDetailScreen extends StatelessWidget {
  const CollectionDetailScreen({super.key, required this.collection});

  final CollectionData collection;

  List<TemplateData> _getFilteredTemplates() {
    final allTemplates = _HomeScreenState._templates;
    final String title = collection.title.replaceAll('\n', ' ').toLowerCase();

    final String targetCat;
    if (title.contains('wedding')) {
      targetCat = 'wedding';
    } else if (title.contains('travel')) {
      targetCat = 'travel';
    } else if (title.contains('business')) {
      targetCat = 'business';
    } else if (title.contains('summer')) {
      targetCat = 'lifestyle';
    } else {
      targetCat = 'all';
    }

    if (targetCat == 'all') return allTemplates;
    return allTemplates.where((t) => t.category.toLowerCase() == targetCat).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTemplates = _getFilteredTemplates();

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
                      // Header Card
                      _buildHeaderCard(context),
                      const SizedBox(height: 28),

                      // Section Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Featured Templates',
                            style: GoogleFonts.poppins(
                              color: EditoColors.dark,
                              fontSize: 16.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '${filteredTemplates.length} templates',
                            style: GoogleFonts.inter(
                              color: EditoColors.body.withValues(alpha: 0.65),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Content Grid
                      if (filteredTemplates.isEmpty)
                        _buildEmptyState()
                      else
                        _TemplateGrid(
                          templates: filteredTemplates,
                          showDuration: true,
                          showByCreator: true,
                          aspectRatio: 0.68,
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

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [collection.color, collection.accent.withValues(alpha: 0.82)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            offset: Offset(0, 10),
            blurRadius: 24,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _CollectionPainter(),
            ),
          ),
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(
              collection.icon,
              color: Colors.white.withValues(alpha: 0.18),
              size: 150,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _UseHeaderButton(
                      icon: Icons.chevron_left_rounded,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Collection',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  collection.title.replaceAll('\n', ' '),
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Handpicked templates curated by our design team to give your videos a professional touch.',
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.90),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
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
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: EditoColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.category_outlined,
            color: Color(0xFFC4C2F4),
            size: 50,
          ),
          const SizedBox(height: 12),
          Text(
            'No templates in this collection yet',
            style: GoogleFonts.poppins(
              color: EditoColors.dark,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
