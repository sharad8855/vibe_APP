part of '../../main.dart';

class CreateTemplateScreen extends StatefulWidget {
  const CreateTemplateScreen({super.key});

  @override
  State<CreateTemplateScreen> createState() => _CreateTemplateScreenState();
}

enum _UploadState { idle, uploading, completed }

class _CreateTemplateScreenState extends State<CreateTemplateScreen> {
  _UploadState _uploadState = _UploadState.idle;
  double _uploadProgress = 0.0;
  Timer? _uploadTimer;

  @override
  void dispose() {
    _uploadTimer?.cancel();
    super.dispose();
  }

  void _startMockUpload() {
    setState(() {
      _uploadState = _UploadState.uploading;
      _uploadProgress = 0.0;
    });

    _uploadTimer?.cancel();
    _uploadTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        if (_uploadProgress < 1.0) {
          _uploadProgress += 0.08;
          if (_uploadProgress > 1.0) _uploadProgress = 1.0;
        } else {
          _uploadState = _UploadState.completed;
          timer.cancel();
        }
      });
    });
  }

  void _resetUpload() {
    setState(() {
      _uploadState = _UploadState.idle;
      _uploadProgress = 0.0;
    });
  }

  void _handleContinue() {
    if (_uploadState != _UploadState.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select and upload a video first'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const ReviewDetectionScreen(),
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
                                'Create Template',
                                style: GoogleFonts.poppins(
                                  color: EditoColors.dark,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  height: 1.15,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Upload your edited video to create\na reusable template',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: EditoColors.body.withValues(alpha: 0.74),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Dash Upload Container
                      _UploadBox(
                        uploadState: _uploadState,
                        progress: _uploadProgress,
                        onSelect: _startMockUpload,
                        onReset: _resetUpload,
                      ),
                      const SizedBox(height: 25),

                      // How It Works Card
                      const _HowItWorksCard(),
                      const SizedBox(height: 18),

                      // Safe Content Card
                      const _SafeContentCard(),
                      const SizedBox(height: 35),

                      // Continue Button
                      _ContinueButton(
                        label: 'Continue',
                        onTap: _handleContinue,
                      ),
                      const SizedBox(height: 16),

                      // Lock Footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_outline_rounded,
                            color: EditoColors.body.withValues(alpha: 0.60),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'You can edit slots and details in the next step',
                              style: GoogleFonts.inter(
                                color: EditoColors.body.withValues(alpha: 0.70),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
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

// ─────────────────────────────────────────────────────────────
// Dash Upload Box Component
// ─────────────────────────────────────────────────────────────

class _UploadBox extends StatelessWidget {
  const _UploadBox({
    required this.uploadState,
    required this.progress,
    required this.onSelect,
    required this.onReset,
  });

  final _UploadState uploadState;
  final double progress;
  final VoidCallback onSelect;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: EditoColors.primary.withValues(alpha: 0.40),
          strokeWidth: 1.5,
          borderRadius: 24,
          dashPattern: const [8, 6],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            color: const Color(0xFFFBFBFF).withValues(alpha: 0.65),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: switch (uploadState) {
                _UploadState.idle => _buildIdleState(),
                _UploadState.uploading => _buildUploadingState(),
                _UploadState.completed => _buildCompletedState(),
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIdleState() {
    return SingleChildScrollView(
      key: const ValueKey('idle'),
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Sparkle Video Icon
          SizedBox(
            height: 90,
            width: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Purple gradient video circle
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFECEBFF),
                    boxShadow: [
                      BoxShadow(
                        color: EditoColors.primary.withValues(alpha: 0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF8E78FF),
                            EditoColors.primary,
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                ),
                // Sparkles left
                const Positioned(
                  left: 12,
                  top: 24,
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: Color(0xFF8E78FF),
                    size: 16,
                  ),
                ),
                const Positioned(
                  left: 28,
                  bottom: 12,
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: Color(0xFF8E78FF),
                    size: 10,
                  ),
                ),
                // Sparkles right
                const Positioned(
                  right: 14,
                  top: 18,
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: Color(0xFF8E78FF),
                    size: 19,
                  ),
                ),
                const Positioned(
                  right: 24,
                  bottom: 22,
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: Color(0xFF8E78FF),
                    size: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Upload Edited Video',
            style: GoogleFonts.poppins(
              color: EditoColors.dark,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Upload a fully edited video that will be\nused as a template',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: EditoColors.body.withValues(alpha: 0.76),
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),

          // Select Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onSelect,
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5E2DFF), Color(0xFF7D33FF)],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x246C63FF),
                      offset: Offset(0, 8),
                      blurRadius: 18,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_upload_outlined,
                      color: Colors.white,
                      size: 21,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Select Video',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'MP4, MOV or AVI • Max 500MB • Up to 2 minutes',
            style: GoogleFonts.inter(
              color: EditoColors.body.withValues(alpha: 0.60),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadingState() {
    return Column(
      key: const ValueKey('uploading'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 90,
          height: 90,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 8,
                backgroundColor: const Color(0xFFECEBFF),
                color: EditoColors.primary,
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: GoogleFonts.poppins(
                  color: EditoColors.dark,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Uploading Video...',
          style: GoogleFonts.poppins(
            color: EditoColors.dark,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Please do not close or leave the app',
          style: GoogleFonts.inter(
            color: EditoColors.body.withValues(alpha: 0.72),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedState() {
    final mockTemplate = const TemplateData(
      title: 'Cinematic Vlog Template',
      category: 'TRAVEL',
      rating: '5.0',
      creator: 'User Creator',
      duration: '00:30',
      price: 'FREE',
      color: Color(0xFF6C63FF),
      secondaryColor: Color(0xFF2CA8D8),
      overlayText: 'MY\nVLOG',
    );

    return Column(
      key: const ValueKey('completed'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            // Video Thumbnail preview
            Container(
              width: 120,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x18000000),
                    offset: Offset(0, 8),
                    blurRadius: 18,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _TemplateVisual(data: mockTemplate),
                    Container(
                      color: Colors.black.withValues(alpha: 0.15),
                    ),
                    const Center(
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0x95000000),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),

            // Video details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F8EF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF20B66F),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Upload Complete',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF168F54),
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'my_edited_video_v1.mp4',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: EditoColors.dark,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Size: 45 MB  •  Duration: 30s',
                    style: GoogleFonts.inter(
                      color: EditoColors.body.withValues(alpha: 0.75),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Reset Button
                  GestureDetector(
                    onTap: onReset,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFFFC5CD)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.delete_outline_rounded,
                            color: Color(0xFFFF3356),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Remove Video',
                            style: GoogleFonts.inter(
                              color: const Color(0xFFFF3356),
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Custom Dashed Border Painter
// ─────────────────────────────────────────────────────────────

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.borderRadius,
    required this.dashPattern,
  });

  final Color color;
  final double strokeWidth;
  final double borderRadius;
  final List<double> dashPattern;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(borderRadius),
        ),
      );

    final dashPath = _buildDashedPath(path, dashPattern);
    canvas.drawPath(dashPath, paint);
  }

  Path _buildDashedPath(Path sourcePath, List<double> pattern) {
    final Path destPath = Path();
    for (final PathMetric metric in sourcePath.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      int index = 0;

      while (distance < metric.length) {
        final double len = pattern[index];
        if (draw) {
          destPath.addPath(
            metric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len;
        draw = !draw;
        index = (index + 1) % pattern.length;
      }
    }
    return destPath;
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.borderRadius != borderRadius;
}

// ─────────────────────────────────────────────────────────────
// How It Works Step Widget
// ─────────────────────────────────────────────────────────────

class _HowItWorksCard extends StatelessWidget {
  const _HowItWorksCard();

  @override
  Widget build(BuildContext context) {
    const steps = [
      'Upload your edited video',
      'Our AI will detect key sections',
      'You\'ll review and publish the template',
      'Earn whenever someone uses your template',
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F5FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFECE7FF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bulb Icon
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFECE7FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: EditoColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // Core Steps list
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How it works',
                  style: GoogleFonts.poppins(
                    color: EditoColors.dark,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                for (var i = 0; i < steps.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${i + 1}. ',
                          style: GoogleFonts.inter(
                            color: EditoColors.body,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            steps[i],
                            style: GoogleFonts.inter(
                              color: EditoColors.body.withValues(alpha: 0.82),
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                          ),
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
}

// ─────────────────────────────────────────────────────────────
// Safe Content Note
// ─────────────────────────────────────────────────────────────

class _SafeContentCard extends StatelessWidget {
  const _SafeContentCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF8F1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD3EFE2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Safety Icon
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFD3EFE2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              color: Color(0xFF20B66F),
              size: 22,
            ),
          ),
          const SizedBox(width: 16),

          // Safe note text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Content is Safe',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF147A49),
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'We keep your videos secure and never share them without your permission.',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF198F56),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
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
