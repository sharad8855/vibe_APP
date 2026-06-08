part of '../../main.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  bool _isSearching = false;
  List<TemplateData> _filteredTemplates = [];

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

  final List<String> _recentSearches = [
    'Wedding Moments',
    'Wanderlust',
    'Urban Style',
  ];

  final List<String> _popularTags = [
    'Wedding',
    'Travel',
    'Intro',
    'Free Reels',
    'Urban style',
    'Corporate',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    
    // Auto-focus search text field on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _filteredTemplates = [];
      });
    } else {
      setState(() {
        _isSearching = true;
        _filteredTemplates = _templates
            .where((t) =>
                t.title.toLowerCase().contains(query) ||
                t.category.toLowerCase().contains(query) ||
                t.creator.toLowerCase().contains(query))
            .toList();
      });
    }
  }

  void _runSearch(String term) {
    _searchController.text = term;
    // Set selection cursor to end
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: term.length),
    );
    _searchFocusNode.unfocus();

    // Cache to recent searches if not already there
    if (!_recentSearches.contains(term)) {
      setState(() {
        _recentSearches.insert(0, term);
        if (_recentSearches.length > 5) {
          _recentSearches.removeLast();
        }
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _SoftBackground()),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Search bar header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Row(
                    children: [
                      // Back Button
                      _UseHeaderButton(
                        icon: Icons.chevron_left_rounded,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 12),

                      // Search Input field box
                      Expanded(
                        child: Container(
                          height: 55,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                                color: EditoColors.body.withValues(alpha: 0.65),
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  focusNode: _searchFocusNode,
                                  textInputAction: TextInputAction.search,
                                  onSubmitted: (term) {
                                    if (term.trim().isNotEmpty) {
                                      _runSearch(term.trim());
                                    }
                                  },
                                  cursorColor: EditoColors.primary,
                                  style: GoogleFonts.inter(
                                    color: EditoColors.dark,
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search templates or creators...',
                                    hintStyle: GoogleFonts.inter(
                                      color: EditoColors.muted.withValues(alpha: 0.8),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                  ),
                                ),
                              ),
                              if (_searchController.text.isNotEmpty)
                                GestureDetector(
                                  onTap: _clearSearch,
                                  child: Icon(
                                    Icons.cancel_rounded,
                                    color: EditoColors.body.withValues(alpha: 0.5),
                                    size: 20,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Main search page content
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _isSearching ? _buildSearchResults() : _buildSearchSuggestions(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Search Suggestions (Recent / Popular) Builder
  // ─────────────────────────────────────────────────────────────
  Widget _buildSearchSuggestions() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Recent Searches section
          if (_recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Searches',
                  style: GoogleFonts.poppins(
                    color: EditoColors.dark,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _recentSearches.clear();
                    });
                  },
                  child: Text(
                    'Clear All',
                    style: GoogleFonts.inter(
                      color: EditoColors.muted,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                for (final term in _recentSearches)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    leading: Icon(
                      Icons.history_rounded,
                      color: EditoColors.body.withValues(alpha: 0.5),
                      size: 20,
                    ),
                    title: Text(
                      term,
                      style: GoogleFonts.inter(
                        color: EditoColors.dark,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        setState(() {
                          _recentSearches.remove(term);
                        });
                      },
                      child: Icon(
                        Icons.close_rounded,
                        color: EditoColors.body.withValues(alpha: 0.5),
                        size: 16,
                      ),
                    ),
                    onTap: () => _runSearch(term),
                  ),
              ],
            ),
            const SizedBox(height: 25),
          ],

          // Popular Tags section
          Text(
            'Popular Tags',
            style: GoogleFonts.poppins(
              color: EditoColors.dark,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: [
              for (final tag in _popularTags)
                GestureDetector(
                  onTap: () => _runSearch(tag),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE5E6F2)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x04000000),
                          offset: Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Text(
                      tag,
                      style: GoogleFonts.inter(
                        color: EditoColors.body.withValues(alpha: 0.85),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Filtered Search Results Builder
  // ─────────────────────────────────────────────────────────────
  Widget _buildSearchResults() {
    if (_filteredTemplates.isEmpty) {
      return _buildNoResultsPlaceholder();
    }

    final query = _searchController.text.toLowerCase().trim();
    // Get up to 3 autocomplete suggestions
    final suggestions = _templates
        .where((t) =>
            t.title.toLowerCase().contains(query) ||
            t.creator.toLowerCase().contains(query) ||
            t.category.toLowerCase().contains(query))
        .map((t) {
          if (t.title.toLowerCase().contains(query)) return t.title;
          if (t.creator.toLowerCase().contains(query)) return t.creator;
          return t.category;
        })
        .toSet()
        .take(3)
        .toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (suggestions.isNotEmpty && suggestions.any((s) => s.toLowerCase() != query)) ...[
            Text(
              'Suggestions',
              style: GoogleFonts.poppins(
                color: EditoColors.muted,
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final suggestion in suggestions)
                  if (suggestion.toLowerCase() != query)
                    GestureDetector(
                      onTap: () => _runSearch(suggestion),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1ECFF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5DBFF)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.arrow_outward_rounded,
                              size: 14,
                              color: EditoColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              suggestion,
                              style: GoogleFonts.inter(
                                color: EditoColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
            const SizedBox(height: 20),
          ],
          Text(
            'Search Results (${_filteredTemplates.length})',
            style: GoogleFonts.poppins(
              color: EditoColors.dark,
              fontSize: 15.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          _TemplateGrid(
            templates: _filteredTemplates,
            showDuration: true,
            showByCreator: true,
            aspectRatio: 0.68,
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsPlaceholder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration circle
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF2F5),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFFFE0E6), width: 1.5),
            ),
            child: const Icon(
              Icons.search_off_rounded,
              color: Color(0xFFFF4D79),
              size: 40,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Results Found',
            style: GoogleFonts.poppins(
              color: EditoColors.dark,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We couldn\'t find any templates or creators matching "${_searchController.text}". Try another spelling or category.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: EditoColors.body.withValues(alpha: 0.72),
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
