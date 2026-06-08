part of '../../main.dart';

class PreviewTemplateScreen extends StatefulWidget {
  const PreviewTemplateScreen({
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

  @override
  State<PreviewTemplateScreen> createState() => _PreviewTemplateScreenState();
}

class _PreviewTemplateScreenState extends State<PreviewTemplateScreen> {
  late Map<String, (String, String)> _assetsData;
  late String _selectedQuality;
  late String _selectedLength;
  late String _selectedRatio;

  @override
  void initState() {
    super.initState();
    _assetsData = Map.from(widget.assetsData);
    _selectedQuality = widget.quality;
    _selectedLength = widget.length;
    _selectedRatio = widget.ratio;
  }

  void _showAction(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onEditAsset(String title) {
    if (title.contains('Name') || title.contains('Text')) {
      final currentVal = _assetsData[title]?.$1 ?? '';
      showDialog<void>(
        context: context,
        builder: (context) {
          final ctrl = TextEditingController(text: currentVal);
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              'Edit Text',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w800, color: EditoColors.dark),
            ),
            content: TextField(
              controller: ctrl,
              maxLength: 30,
              style: GoogleFonts.inter(fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                hintText: 'Enter title text',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel', style: GoogleFonts.inter(color: EditoColors.body, fontWeight: FontWeight.w800)),
              ),
              ElevatedButton(
                onPressed: () {
                  final txt = ctrl.text.trim();
                  if (txt.isNotEmpty) {
                    setState(() {
                      _assetsData[title] = (txt, 'Font: Poppins SemiBold\nColor: ${title.contains('Name') ? '#E91E63' : '#6C63FF'}');
                    });
                  }
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: EditoColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Save', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w800)),
              ),
            ],
          );
        },
      );
    } else {
      final randomNum = math.Random().nextInt(89) + 10;
      setState(() {
        if (title.contains('Video')) {
          _assetsData[title] = ('custom_video_$randomNum.mp4', '00:16  •  42.1 MB');
        } else if (title.contains('Photo') || title.contains('Cover')) {
          _assetsData[title] = ('custom_photo_$randomNum.jpg', '2048 x 1536  •  2.9 MB');
        } else {
          _assetsData[title] = ('custom_logo_$randomNum.png', '512 x 512  •  88 KB');
        }
      });

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Picked new file for $title!',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          backgroundColor: const Color(0xFF22B37D),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
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
                      _PreviewTemplateHeader(
                        onDemo: () =>
                            _showAction('Demo preview opened'),
                      ),
                      const SizedBox(height: 26),
                      _PreviewTemplatePlayer(
                        template: widget.template,
                        selectedLength: _selectedLength,
                      ),
                      const SizedBox(height: 20),
                      const _TemplateTimeline(),
                      const SizedBox(height: 32),
                      _SceneBreakdown(template: widget.template),
                      const SizedBox(height: 30),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final flow = _TemplateFlowCard(
                            template: widget.template,
                            assetsData: _assetsData,
                            onEdit: _onEditAsset,
                          );

                          if (constraints.maxWidth < 620) {
                            return Column(
                              children: [
                                flow,
                                const SizedBox(height: 18),
                                const _AiQualityCard(),
                              ],
                            );
                          }

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: flow),
                              const SizedBox(width: 18),
                              const Expanded(child: _AiQualityCard()),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      _OutputInfoCard(
                        quality: _selectedQuality,
                        length: _selectedLength,
                        ratio: _selectedRatio,
                      ),
                      const SizedBox(height: 28),
                      _GenerateFinalButton(
                        template: widget.template,
                        assetsData: _assetsData,
                        quality: _selectedQuality,
                        length: _selectedLength,
                        ratio: _selectedRatio,
                      ),
                      const SizedBox(height: 12),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              color: EditoColors.body.withValues(alpha: 0.70),
                              size: 17,
                            ),
                            const SizedBox(width: 7),
                            Text(
                              'Estimated time: 1-2 Minutes',
                              style: GoogleFonts.inter(
                                color: EditoColors.body.withValues(alpha: 0.78),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
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

class _PreviewTemplateHeader extends StatelessWidget {
  const _PreviewTemplateHeader({required this.onDemo});

  final VoidCallback onDemo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 124,
      child: Column(
        children: [
          Row(
            children: [
              _UseHeaderButton(
                icon: Icons.chevron_left_rounded,
                onTap: () => Navigator.of(context).pop(),
              ),
              const Spacer(),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: onDemo,
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: EditoColors.white.withValues(alpha: 0.76),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFDCCCFF)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.play_circle_outline_rounded,
                          color: EditoColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          'View Demo',
                          style: GoogleFonts.inter(
                            color: EditoColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            children: [
              Text(
                'Preview Template',
                style: GoogleFonts.poppins(
                  color: EditoColors.dark,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'See how your content fits into the template',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: EditoColors.body.withValues(alpha: 0.78),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewTemplatePlayer extends StatefulWidget {
  const _PreviewTemplatePlayer({required this.template, required this.selectedLength});

  final TemplateData template;
  final String selectedLength;

  @override
  State<_PreviewTemplatePlayer> createState() => _PreviewTemplatePlayerState();
}

class _PreviewTemplatePlayerState extends State<_PreviewTemplatePlayer> {
  Timer? _playbackTimer;
  double _progress = 0.0;
  bool _isPlaying = false;
  bool _showActionOverlay = false;
  IconData _overlayIcon = Icons.play_arrow_rounded;

  int get _totalSeconds {
    final numericOnly = RegExp(r'\d+').firstMatch(widget.selectedLength)?.group(0);
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
    return SizedBox(
      height: 309,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
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
                    Colors.black.withValues(alpha: 0.50),
                  ],
                ),
              ),
            ),
            const Positioned(
              left: 17,
              top: 17,
              child: _PreviewVideoBadge(
                icon: Icons.hd_outlined,
                label: '1080p',
              ),
            ),
            Positioned(
              right: 17,
              top: 17,
              child: _PreviewVideoBadge(label: widget.template.duration),
            ),
            if (_showActionOverlay)
              Center(
                child: AnimatedOpacity(
                  opacity: _showActionOverlay ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _overlayIcon,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              )
            else if (!_isPlaying)
              Center(
                child: GestureDetector(
                  onTap: _togglePlay,
                  child: const CircleAvatar(
                    radius: 39,
                    backgroundColor: Color(0x65000000),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 54,
                    ),
                  ),
                ),
              ),
            GestureDetector(
              onTap: _togglePlay,
              behavior: HitTestBehavior.translucent,
            ),
            Positioned(
              left: 21,
              right: 21,
              bottom: 20,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _togglePlay,
                    child: Icon(
                      _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 31,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${_formatDuration(_progress)} / ${_formatDuration(1.0)}',
                    style: _previewVideoText(),
                  ),
                  const SizedBox(width: 17),
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
                                  color: Colors.white.withValues(alpha: 0.40),
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
                                  width: 16,
                                  height: 16,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
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
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.volume_up_rounded,
                    color: Colors.white,
                    size: 29,
                  ),
                  const SizedBox(width: 15),
                  const Icon(
                    Icons.fullscreen_rounded,
                    color: Colors.white,
                    size: 31,
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

TextStyle _previewVideoText() {
  return GoogleFonts.inter(
    color: Colors.white,
    fontSize: 15,
    fontWeight: FontWeight.w800,
  );
}

class _PreviewVideoBadge extends StatelessWidget {
  const _PreviewVideoBadge({required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 15),
            const SizedBox(width: 5),
          ],
          Text(label, style: _previewVideoText()),
        ],
      ),
    );
  }
}

class _TemplateTimeline extends StatelessWidget {
  const _TemplateTimeline();

  static const segments = [
    _TimelineSegmentData(
      icon: Icons.videocam_outlined,
      title: 'Bride Video',
      range: '0 - 6s',
      color: EditoColors.primary,
    ),
    _TimelineSegmentData(
      icon: Icons.videocam_outlined,
      title: 'Bride Video',
      range: '6 - 12s',
      color: Color(0xFF5A4DF5),
    ),
    _TimelineSegmentData(
      icon: Icons.videocam_outlined,
      title: 'Groom Video',
      range: '12 - 18s',
      color: Color(0xFF2F85E8),
    ),
    _TimelineSegmentData(
      icon: Icons.image_outlined,
      title: 'Photo',
      range: '18 - 24s',
      color: Color(0xFF50BB70),
    ),
    _TimelineSegmentData(
      icon: Icons.text_fields_rounded,
      title: 'Name',
      range: '24 - 27s',
      color: Color(0xFFFF9819),
    ),
    _TimelineSegmentData(
      title: 'Ending',
      range: '27 - 30s',
      color: Color(0xFF858AA3),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: Row(
            children: [
              Text(
                '00:00',
                style: GoogleFonts.inter(
                  color: EditoColors.body,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Text(
                '00:30',
                style: GoogleFonts.inter(
                  color: EditoColors.body,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              for (var i = 0; i < segments.length; i++) ...[
                SizedBox(width: 88, child: _TimelineSegment(data: segments[i])),
                if (i != segments.length - 1) const SizedBox(width: 6),
              ],
            ],
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 62,
          child: CustomPaint(
            painter: _TimelineTicksPainter(),
            child: Align(
              alignment: const Alignment(-0.32, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 9,
                    height: 34,
                    decoration: BoxDecoration(
                      color: EditoColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -2),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: EditoColors.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '00:08',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TimelineSegment extends StatelessWidget {
  const _TimelineSegment({required this.data});

  final _TimelineSegmentData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: data.color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (data.icon != null) ...[
                Icon(data.icon, color: Colors.white, size: 14),
                const SizedBox(width: 5),
              ],
              Flexible(
                child: Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            data.range,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineTicksPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD5D7E8)
      ..strokeWidth = 1.5;
    final baseY = 12.0;
    canvas.drawLine(Offset(0, baseY), Offset(size.width, baseY), paint);
    for (var i = 0; i <= 48; i++) {
      final x = i * size.width / 48;
      final height = i % 8 == 0 ? 16.0 : 8.0;
      canvas.drawLine(
        Offset(x, baseY - height / 2),
        Offset(x, baseY + height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SceneBreakdown extends StatelessWidget {
  const _SceneBreakdown({required this.template});

  final TemplateData template;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _previewCardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Scene Breakdown',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: EditoColors.dark,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '5 Scenes',
                style: GoogleFonts.inter(
                  color: EditoColors.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                for (var i = 0; i < 5; i++) ...[
                  SizedBox(
                    width: 122,
                    child: _SceneCard(
                      template: template,
                      index: i,
                      title: const [
                        'Opening',
                        'Couple Intro',
                        'Romantic Moment',
                        'Name Reveal',
                        'Ending',
                      ][i],
                      description: const [
                        'Beautiful intro with elegant animation',
                        'Both videos with smooth transition',
                        'Photo with cinematic effects',
                        'Your names with stylish animation',
                        'Logo outro with beautiful finish',
                      ][i],
                    ),
                  ),
                  if (i != 4) const SizedBox(width: 12),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SceneCard extends StatelessWidget {
  const _SceneCard({
    required this.template,
    required this.index,
    required this.title,
    required this.description,
  });

  final TemplateData template;
  final int index;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final preview = TemplateData(
      title: template.title,
      category: template.category,
      rating: template.rating,
      creator: template.creator,
      duration: template.duration,
      price: template.price,
      color: index.isEven ? template.color : template.secondaryColor,
      secondaryColor: index.isEven ? template.secondaryColor : template.color,
      overlayText: template.overlayText,
    );

    return Container(
      decoration: BoxDecoration(
        color: EditoColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: index == 0 ? EditoColors.primary : EditoColors.border,
          width: index == 0 ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 104,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _TemplateVisual(data: preview),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.54),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 9,
                    top: 9,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: index == 3
                          ? const Color(0xFF50BB70)
                          : index == 4
                          ? const Color(0xFFFF9819)
                          : EditoColors.primary,
                      child: Text(
                        '${index + 1}',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 0,
                    right: 0,
                    child: Text(
                      const [
                        '0 - 6s',
                        '6 - 12s',
                        '12 - 18s',
                        '18 - 24s',
                        '24 - 30s',
                      ][index],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: EditoColors.dark,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: EditoColors.body,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    height: 1.28,
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

class _TemplateFlowCard extends StatelessWidget {
  const _TemplateFlowCard({
    required this.template,
    required this.assetsData,
    required this.onEdit,
  });

  final TemplateData template;
  final Map<String, (String, String)> assetsData;
  final ValueChanged<String> onEdit;

  @override
  Widget build(BuildContext context) {
    final isWedding = template.category == 'WEDDING';
    final List<_FlowAssetRowData> rows = [];

    if (isWedding) {
      rows.addAll([
        _FlowAssetRowData(
          icon: Icons.videocam_outlined,
          title: 'Bride Video',
          scene: 'Scene 1',
          color: EditoColors.primary,
          tint: const Color(0xFFF1ECFF),
          preview: template,
          label: assetsData['Bride Video']?.$1 ?? 'Bride.mp4',
        ),
        _FlowAssetRowData(
          icon: Icons.videocam_outlined,
          title: 'Groom Video',
          scene: 'Scene 2',
          color: EditoColors.primary,
          tint: const Color(0xFFF1ECFF),
          preview: template,
          label: assetsData['Groom Video']?.$1 ?? 'Groom.mp4',
        ),
        _FlowAssetRowData(
          icon: Icons.image_outlined,
          title: 'Couple Photo',
          scene: 'Scene 3',
          color: const Color(0xFF22B37D),
          tint: const Color(0xFFE8F8EF),
          preview: template,
          label: assetsData['Couple Photo']?.$1 ?? 'Couple.jpg',
        ),
        _FlowAssetRowData(
          icon: Icons.text_fields_rounded,
          title: 'Couple Name',
          scene: 'Scene 4',
          color: const Color(0xFFFF9819),
          tint: const Color(0xFFFFF2DE),
          label: assetsData['Couple Name']?.$1 ?? 'Rahul & Priya',
        ),
        _FlowAssetRowData(
          icon: Icons.verified_outlined,
          title: 'Logo (Optional)',
          scene: 'Scene 5',
          color: EditoColors.body,
          tint: const Color(0xFFF1F2F7),
          logo: true,
          label: (assetsData['Logo (Optional)']?.$1 ?? template.creator).substring(0, 1).toUpperCase(),
        ),
      ]);
    } else {
      final categoryName = _titleCase(template.category);
      rows.addAll([
        _FlowAssetRowData(
          icon: Icons.videocam_outlined,
          title: '$categoryName Video',
          scene: 'Scene 1',
          color: EditoColors.primary,
          tint: const Color(0xFFF1ECFF),
          preview: template,
          label: assetsData['$categoryName Video']?.$1 ?? '$categoryName.mp4',
        ),
        _FlowAssetRowData(
          icon: Icons.image_outlined,
          title: 'Cover Photo',
          scene: 'Scene 2',
          color: const Color(0xFF22B37D),
          tint: const Color(0xFFE8F8EF),
          preview: template,
          label: assetsData['Cover Photo']?.$1 ?? 'Cover.jpg',
        ),
        _FlowAssetRowData(
          icon: Icons.text_fields_rounded,
          title: 'Title Text',
          scene: 'Scene 3',
          color: const Color(0xFFFF9819),
          tint: const Color(0xFFFFF2DE),
          label: assetsData['Title Text']?.$1 ?? template.title,
        ),
        _FlowAssetRowData(
          icon: Icons.verified_outlined,
          title: 'Logo (Optional)',
          scene: 'Scene 4',
          color: EditoColors.body,
          tint: const Color(0xFFF1F2F7),
          logo: true,
          label: (assetsData['Logo (Optional)']?.$1 ?? template.creator).substring(0, 1).toUpperCase(),
        ),
      ]);
    }

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: _previewCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Template Flow (Your Assets)',
            style: GoogleFonts.poppins(
              color: EditoColors.dark,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 22),
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: 17),
              child: _FlowAssetRow(
                data: row,
                onEdit: () => onEdit(row.title),
              ),
            ),
        ],
      ),
    );
  }
}

class _FlowAssetRow extends StatelessWidget {
  const _FlowAssetRow({required this.data, required this.onEdit});

  final _FlowAssetRowData data;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: data.tint,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(data.icon, color: data.color, size: 25),
        ),
        const SizedBox(width: 15),
        SizedBox(
          width: 92,
          child: Text(
            data.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: EditoColors.dark,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 13),
        SizedBox(
          width: 44,
          height: 44,
          child: data.preview == null
              ? _SmallFlowLabel(data: data)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: _TemplateVisual(data: data.preview!),
                ),
        ),
        const SizedBox(width: 11),
        Icon(
          Icons.arrow_forward_rounded,
          color: EditoColors.body.withValues(alpha: 0.78),
          size: 17,
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data.scene,
                style: GoogleFonts.inter(
                  color: EditoColors.body,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                data.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: EditoColors.dark,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        _TinyEditButton(onTap: onEdit),
      ],
    );
  }
}

class _SmallFlowLabel extends StatelessWidget {
  const _SmallFlowLabel({required this.data});

  final _FlowAssetRowData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: data.logo ? Colors.black : data.tint,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        data.label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.poppins(
          color: data.logo ? const Color(0xFFFFB72C) : data.color,
          fontSize: data.logo ? 21 : 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _TinyEditButton extends StatelessWidget {
  const _TinyEditButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(9),
        onTap: onTap,
        child: Container(
          height: 38,
          width: 62,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFD),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: const Color(0xFFDCCCFF)),
          ),
          child: Text(
            'Edit',
            style: GoogleFonts.inter(
              color: EditoColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _AiQualityCard extends StatelessWidget {
  const _AiQualityCard();

  @override
  Widget build(BuildContext context) {
    const checks = [
      ('Face detection', 'Good'),
      ('Video quality', 'High (1080p)'),
      ('Text placement', 'Perfect'),
      ('Transitions', 'Smooth'),
      ('Overall quality', 'Excellent'),
    ];

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: _previewCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color: EditoColors.primary,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                'AI Quality Check',
                style: GoogleFonts.poppins(
                  color: EditoColors.dark,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          for (final check in checks)
            Padding(
              padding: const EdgeInsets.only(bottom: 17),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 10,
                    backgroundColor: Color(0xFF28B676),
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          check.$1,
                          style: GoogleFonts.inter(
                            color: EditoColors.dark,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          check.$2,
                          style: GoogleFonts.inter(
                            color: EditoColors.body,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F8EF),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 10,
                  backgroundColor: Color(0xFF28B676),
                  child: Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
                const SizedBox(width: 13),
                Text(
                  'Ready for generation',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF168F54),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
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

class _OutputInfoCard extends StatelessWidget {
  const _OutputInfoCard({
    required this.quality,
    required this.length,
    required this.ratio,
  });

  final String quality;
  final String length;
  final String ratio;

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.hd_outlined, 'Quality', quality),
      (Icons.schedule_rounded, 'Duration', length),
      (Icons.description_outlined, 'Estimated Size', quality.contains('4K') ? '~45 MB' : quality.contains('720p') ? '~8 MB' : '~15 MB'),
      (Icons.phone_iphone_rounded, 'Aspect Ratio', ratio),
    ];

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: _previewCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Output Information',
            style: GoogleFonts.poppins(
              color: EditoColors.dark,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth < 560
                  ? (constraints.maxWidth - 12) / 2
                  : (constraints.maxWidth - 3) / 4;

              return Wrap(
                spacing: 12,
                runSpacing: 14,
                children: [
                  for (final item in items)
                    SizedBox(
                      width: itemWidth,
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1ECFF),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Icon(
                              item.$1,
                              color: EditoColors.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.$2,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    color: EditoColors.body,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.$3,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    color: EditoColors.dark,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F4FF),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: EditoColors.primary,
                  size: 22,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Higher quality videos may take a little longer to generate.',
                    style: GoogleFonts.inter(
                      color: EditoColors.body,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
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

class _GenerateFinalButton extends StatelessWidget {
  const _GenerateFinalButton({
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

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => GenerateVideoScreen(
                template: template,
                assetsData: assetsData,
                quality: quality,
                length: length,
                ratio: ratio,
              ),
            ),
          );
        },
        child: Container(
          height: 75,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF5A2EFF), Color(0xFF9E56FF)],
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 18),
                Text(
                  'Generate Final Video',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 20),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimelineSegmentData {
  const _TimelineSegmentData({
    required this.title,
    required this.range,
    required this.color,
    this.icon,
  });

  final String title;
  final String range;
  final Color color;
  final IconData? icon;
}

class _FlowAssetRowData {
  const _FlowAssetRowData({
    required this.icon,
    required this.title,
    required this.scene,
    required this.color,
    required this.tint,
    this.preview,
    this.label = '',
    this.logo = false,
  });

  final IconData icon;
  final String title;
  final String scene;
  final Color color;
  final Color tint;
  final TemplateData? preview;
  final String label;
  final bool logo;
}

BoxDecoration _previewCardDecoration() {
  return BoxDecoration(
    color: EditoColors.white.withValues(alpha: 0.88),
    borderRadius: BorderRadius.circular(14),
    boxShadow: const [
      BoxShadow(color: Color(0x07000000), offset: Offset(0, 8), blurRadius: 22),
    ],
  );
}
