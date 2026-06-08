part of '../../main.dart';

class VideoReadyScreen extends StatelessWidget {
  const VideoReadyScreen({
    super.key,
    required this.template,
    required this.assetsData,
    required this.quality,
    required this.length,
    required this.ratio,
  });

  final TemplateData template;
  final Map<String, (String, String)> assetsData;
  final String quality;
  final String length;
  final String ratio;

  void _showAction(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _goHome(BuildContext context, int index) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => HomeScreen(initialIndex: index)),
      (route) => false,
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
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 34),
                  sliver: SliverList.list(
                    children: [
                      _VideoReadyHeader(onDone: () => _goHome(context, 2)),
                      const SizedBox(height: 22),
                      _ReadyVideoPlayer(template: template, length: length),
                      const SizedBox(height: 16),
                      _ReadyInfoCard(
                        template: template,
                        quality: quality,
                        length: length,
                        assetsData: assetsData,
                        onEditAgain: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(height: 14),
                      _ReadyActionGrid(
                        onDownload: () =>
                            _showAction(context, 'Download started'),
                        onShare: () =>
                            _showAction(context, 'Share sheet opened'),
                        onInstagram: () =>
                            _showAction(context, 'Instagram export prepared'),
                        onCopy: () => _showAction(context, 'Link copied'),
                        onMore: () =>
                            _showAction(context, 'More options opened'),
                      ),
                      const SizedBox(height: 14),
                      _ExperienceCard(
                        onRate: () => _showAction(context, 'Thanks for rating'),
                      ),
                      const SizedBox(height: 14),
                      _WhatsNextCard(
                        onCreateAnother: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  UseTemplateScreen(template: template),
                            ),
                          );
                        },
                        onExplore: () => _goHome(context, 1),
                      ),
                      const SizedBox(height: 14),
                      _SavedToVideosCard(onGo: () => _goHome(context, 2)),
                      const SizedBox(height: 14),
                      _ReadyShareBanner(
                        onShare: () =>
                            _showAction(context, 'Share sheet opened'),
                      ),
                      const SizedBox(height: 20),
                      const _ReadySecureNote(),
                      const SizedBox(height: 24),
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
}

// ─────────────────────────────────────────────────────────────
// Header  —  back | centred title+subtitle | Done
// ─────────────────────────────────────────────────────────────

class _VideoReadyHeader extends StatelessWidget {
  const _VideoReadyHeader({required this.onDone});

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _UseHeaderButton(
              icon: Icons.chevron_left_rounded,
              onTap: () => Navigator.of(context).pop(),
            ),
            const Spacer(),
            _SmallOutlineButton(label: 'Done', onTap: onDone),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Video is Ready!',
              style: GoogleFonts.poppins(
                color: EditoColors.dark,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                height: 1.1,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.celebration_rounded,
              color: Color(0xFFFFB72C),
              size: 24,
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Sit back and enjoy your beautiful creation.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: EditoColors.body.withValues(alpha: 0.75),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Video player
// ─────────────────────────────────────────────────────────────

class _ReadyVideoPlayer extends StatefulWidget {
  const _ReadyVideoPlayer({required this.template, required this.length});

  final TemplateData template;
  final String length;

  @override
  State<_ReadyVideoPlayer> createState() => _ReadyVideoPlayerState();
}

class _ReadyVideoPlayerState extends State<_ReadyVideoPlayer> {
  Timer? _playbackTimer;
  double _progress = 0.0;
  bool _isPlaying = false;
  bool _showActionOverlay = false;
  IconData _overlayIcon = Icons.play_arrow_rounded;

  int get _totalSeconds {
    final numericOnly = RegExp(r'\d+').firstMatch(widget.length)?.group(0);
    if (numericOnly != null) {
      return int.tryParse(numericOnly) ?? 30;
    }
    return 30;
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      _overlayIcon = _isPlaying ? Icons.play_arrow_rounded : Icons.pause_rounded;
      _showActionOverlay = true;
      if (_isPlaying) {
        _startTimer();
      } else {
        _playbackTimer?.cancel();
      }
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showActionOverlay = false;
        });
      }
    });
  }

  void _startTimer() {
    _playbackTimer?.cancel();
    _playbackTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) return;
      setState(() {
        _progress += 0.1 / _totalSeconds;
        if (_progress >= 1.0) {
          _progress = 0.0; // Loop
        }
      });
    });
  }

  String _formatDuration(double factor) {
    final total = _totalSeconds;
    final current = (factor * total).round();
    final mins = current ~/ 60;
    final secs = current % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _seekTo(double localX, double totalWidth) {
    if (totalWidth <= 0) return;
    final newProgress = (localX / totalWidth).clamp(0.0, 1.0);
    setState(() {
      _progress = newProgress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _TemplateVisual(data: widget.template),
            if (_isPlaying)
              Positioned.fill(
                child: _VideoPlayerRippleAnimation(
                  progress: _progress,
                  color: widget.template.color,
                ),
              ),
            CustomPaint(painter: _DetailHeroOverlayPainter(widget.template)),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.05),
                    Colors.black.withValues(alpha: 0.55),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 14,
              top: 14,
              child: _VideoPill(icon: Icons.hd_outlined, label: widget.length.contains('4K') ? '4K' : '1080p'),
            ),
            Positioned(
              right: 14,
              top: 14,
              child: _VideoPill(label: widget.length),
            ),
            if (_showActionOverlay)
              Center(
                child: AnimatedOpacity(
                  opacity: _showActionOverlay ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _overlayIcon,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              )
            else if (!_isPlaying)
              Center(
                child: GestureDetector(
                  onTap: _togglePlay,
                  child: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0x70000000),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
            GestureDetector(
              onTap: _togglePlay,
              behavior: HitTestBehavior.translucent,
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _togglePlay,
                    child: Icon(
                      _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(_formatDuration(_progress), style: _readyVideoTextStyle()),
                  const SizedBox(width: 10),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            _seekTo(details.localPosition.dx, constraints.maxWidth);
                          },
                          onTapDown: (details) {
                            _seekTo(details.localPosition.dx, constraints.maxWidth);
                          },
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.35),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: _progress,
                                child: Container(
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: EditoColors.primary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment((_progress * 2.0) - 1.0, 0),
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: const BoxDecoration(
                                    color: EditoColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(_formatDuration(1.0), style: _readyVideoTextStyle()),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.fullscreen_rounded,
                    color: Colors.white,
                    size: 26,
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

TextStyle _readyVideoTextStyle() {
  return GoogleFonts.inter(
    color: Colors.white,
    fontSize: 13,
    fontWeight: FontWeight.w800,
  );
}

class _VideoPill extends StatelessWidget {
  const _VideoPill({required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 14),
            const SizedBox(width: 4),
          ],
          Text(label, style: _readyVideoTextStyle()),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Info card  —  thumbnail | title/meta column | Edit Again
// ─────────────────────────────────────────────────────────────

class _ReadyInfoCard extends StatelessWidget {
  const _ReadyInfoCard({
    required this.template,
    required this.quality,
    required this.length,
    required this.assetsData,
    required this.onEditAgain,
  });

  final TemplateData template;
  final String quality;
  final String length;
  final Map<String, (String, String)> assetsData;
  final VoidCallback onEditAgain;

  @override
  Widget build(BuildContext context) {
    final customTitle = assetsData['Couple Name']?.$1 ?? assetsData['Title Text']?.$1 ?? template.title;
    final shortQuality = quality.contains('4K') ? '4K' : quality.contains('720p') ? '720p' : '1080p';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _readyCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 72,
                  height: 56,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _TemplateVisual(data: template),
                      CustomPaint(
                        painter: _DetailHeroOverlayPainter(template),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  customTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: EditoColors.dark,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: onEditAgain,
                  child: Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: EditoColors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFDCCCFF)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.edit_outlined,
                          color: EditoColors.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Edit Again',
                          style: GoogleFonts.inter(
                            color: EditoColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                color: EditoColors.body,
                size: 15,
              ),
              const SizedBox(width: 5),
              Text(
                'June 6, 2026  •  17:50 PM',
                style: GoogleFonts.inter(
                  color: EditoColors.body,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              _MiniHdBadge(label: shortQuality),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Flexible(
                child: Text(
                  'By ${template.creator} Studio',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: EditoColors.body,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.verified_rounded,
                color: EditoColors.primary,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniHdBadge extends StatelessWidget {
  const _MiniHdBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: EditoColors.body.withValues(alpha: 0.55)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: EditoColors.body,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Action grid  —  5 tiles that never clip their labels
// ─────────────────────────────────────────────────────────────

class _ReadyActionGrid extends StatelessWidget {
  const _ReadyActionGrid({
    required this.onDownload,
    required this.onShare,
    required this.onInstagram,
    required this.onCopy,
    required this.onMore,
  });

  final VoidCallback onDownload;
  final VoidCallback onShare;
  final VoidCallback onInstagram;
  final VoidCallback onCopy;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: _readyCardDecoration(),
      child: Row(
        children: [
          _ReadyActionTile(
            icon: Icons.file_download_outlined,
            label: 'Download',
            color: EditoColors.primary,
            onTap: onDownload,
          ),
          _ReadyActionTile(
            icon: Icons.share_rounded,
            label: 'Share',
            color: const Color(0xFF0FA85A),
            onTap: onShare,
          ),
          _ReadyActionTile(
            icon: Icons.camera_alt_outlined,
            label: 'Instagram',
            color: const Color(0xFFE43F83),
            onTap: onInstagram,
          ),
          _ReadyActionTile(
            icon: Icons.link_rounded,
            label: 'Copy Link',
            color: EditoColors.body,
            onTap: onCopy,
          ),
          _ReadyActionTile(
            icon: Icons.more_horiz_rounded,
            label: 'More',
            color: EditoColors.body,
            onTap: onMore,
          ),
        ],
      ),
    );
  }
}

class _ReadyActionTile extends StatelessWidget {
  const _ReadyActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withValues(alpha: 0.16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 26),
                const SizedBox(height: 8),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
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

// ─────────────────────────────────────────────────────────────
// Experience / rating card  —  column layout for mobile
// ─────────────────────────────────────────────────────────────

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({required this.onRate});

  final VoidCallback onRate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _readyCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: EditoColors.primary,
                child: Icon(Icons.star_rounded, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'How was your experience?',
                  style: GoogleFonts.poppins(
                    color: EditoColors.dark,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Rate this template to help us improve and create better templates for you.',
            style: GoogleFonts.inter(
              color: EditoColors.body,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          // Star row — evenly spread
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var i = 0; i < 5; i++)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: onRate,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.star_border_rounded,
                        color: EditoColors.body.withValues(alpha: 0.55),
                        size: 36,
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
}

// ─────────────────────────────────────────────────────────────
// What's Next card
// ─────────────────────────────────────────────────────────────

class _WhatsNextCard extends StatelessWidget {
  const _WhatsNextCard({
    required this.onCreateAnother,
    required this.onExplore,
  });

  final VoidCallback onCreateAnother;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _readyCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What's Next?",
            style: GoogleFonts.poppins(
              color: EditoColors.dark,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _NextActionCard(
                  icon: Icons.video_collection_outlined,
                  title: 'Create Another Video',
                  subtitle: 'Use the same template with new content.',
                  color: EditoColors.primary,
                  tint: const Color(0xFFF1ECFF),
                  onTap: onCreateAnother,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _NextActionCard(
                  icon: Icons.auto_fix_high_rounded,
                  title: 'Explore More Templates',
                  subtitle: 'Discover more amazing templates.',
                  color: const Color(0xFF0FA85A),
                  tint: const Color(0xFFEAF8F1),
                  onTap: onExplore,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NextActionCard extends StatelessWidget {
  const _NextActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.tint,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color tint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: tint,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(icon, color: color, size: 22),
                  ),
                  const Spacer(),
                  Icon(Icons.chevron_right_rounded, color: color, size: 22),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: EditoColors.body,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
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
// Saved to My Videos card
// ─────────────────────────────────────────────────────────────

class _SavedToVideosCard extends StatelessWidget {
  const _SavedToVideosCard({required this.onGo});

  final VoidCallback onGo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _readyCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1ECFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.folder_copy_outlined,
                  color: EditoColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'Saved to My Videos',
                  style: GoogleFonts.poppins(
                    color: EditoColors.dark,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'You can find your video in My Videos section.',
            style: GoogleFonts.inter(
              color: EditoColors.body,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          // Full-width button
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onGo,
              child: Container(
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: EditoColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFDCCCFF)),
                ),
                child: Text(
                  'Go to My Videos',
                  style: GoogleFonts.inter(
                    color: EditoColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Share banner  —  "Nice Job! Your video is ready."
// ─────────────────────────────────────────────────────────────

class _ReadyShareBanner extends StatelessWidget {
  const _ReadyShareBanner({required this.onShare});

  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [Color(0xFF5A2EFF), Color(0xFF9E56FF)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x336C63FF),
            offset: Offset(0, 10),
            blurRadius: 22,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.emoji_events_rounded,
                color: Color(0xFFFFB72C),
                size: 48,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nice Job! Your video is ready.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Keep creating and share your story with the world.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.88),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Full-width Share Now button
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onShare,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Share Now',
                      style: GoogleFonts.inter(
                        color: EditoColors.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.reply_rounded,
                      color: EditoColors.primary,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Secure note
// ─────────────────────────────────────────────────────────────

class _ReadySecureNote extends StatelessWidget {
  const _ReadySecureNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EAFF).withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: EditoColors.primary,
            size: 20,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              'Your video is saved securely and will be available anytime in your account.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: EditoColors.body,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Small outline button  (header Done button)
// ─────────────────────────────────────────────────────────────

class _SmallOutlineButton extends StatelessWidget {
  const _SmallOutlineButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: EditoColors.white.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFDCCCFF)),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                color: EditoColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Card decoration
// ─────────────────────────────────────────────────────────────

BoxDecoration _readyCardDecoration() {
  return BoxDecoration(
    color: EditoColors.white.withValues(alpha: 0.90),
    borderRadius: BorderRadius.circular(14),
    boxShadow: const [
      BoxShadow(
        color: Color(0x07000000),
        offset: Offset(0, 8),
        blurRadius: 22,
      ),
    ],
  );
}
