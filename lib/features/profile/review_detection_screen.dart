part of '../../main.dart';

class ReviewDetectionScreen extends StatefulWidget {
  const ReviewDetectionScreen({super.key});

  @override
  State<ReviewDetectionScreen> createState() => _ReviewDetectionScreenState();
}

class _ReviewDetectionScreenState extends State<ReviewDetectionScreen> {
  bool _isPlaying = false;

  void _handleContinue() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const DefineSlotsScreen(),
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
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
                  sliver: SliverList.list(
                    children: [
                      // Header Row with centered titles
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
                                'Review & AI Detection',
                                style: GoogleFonts.poppins(
                                  color: EditoColors.dark,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  height: 1.15,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'We analyzed your video and detected key sections',
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

                      // Stepper flow indicator
                      const _ReviewFlowSteps(),
                      const SizedBox(height: 25),

                      // Video Uploaded successfully metadata card
                      const _UploadedStatusCard(),
                      const SizedBox(height: 16),

                      // Main video player mockup
                      _MockVideoPlayer(
                        isPlaying: _isPlaying,
                        onTogglePlay: () {
                          setState(() {
                            _isPlaying = !_isPlaying;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // AI Detected Sections Card
                      const _AiDetectedCard(),
                      const SizedBox(height: 16),

                      // Tip Card
                      const _TipCard(),
                      const SizedBox(height: 27),

                      // Continue Button
                      _ContinueButton(
                        label: 'Continue',
                        onTap: _handleContinue,
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
// Stepper Flow Steps Component
// ─────────────────────────────────────────────────────────────

class _ReviewFlowSteps extends StatelessWidget {
  const _ReviewFlowSteps();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _StepIndicator(
            stepNumber: '1',
            label: 'Upload Video',
            isCompleted: true,
          ),
        ),
        _StepConnector(isCompleted: true),
        Expanded(
          child: _StepIndicator(
            stepNumber: '2',
            label: 'AI Detection',
            isActive: true,
          ),
        ),
        _StepConnector(isCompleted: false),
        Expanded(
          child: _StepIndicator(
            stepNumber: '3',
            label: 'Define Slots',
            isPending: true,
          ),
        ),
      ],
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.stepNumber,
    required this.label,
    this.isActive = false,
    this.isCompleted = false,
    this.isPending = false,
  });

  final String stepNumber;
  final String label;
  final bool isActive;
  final bool isCompleted;
  final bool isPending;

  @override
  Widget build(BuildContext context) {
    final highlighted = isActive || isCompleted;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: highlighted
              ? EditoColors.primary
              : const Color(0xFFE1E3EE),
          child: isCompleted
              ? const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 20,
                )
              : Text(
                  stepNumber,
                  style: GoogleFonts.poppins(
                    color: highlighted ? Colors.white : EditoColors.body,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            color: highlighted ? EditoColors.primary : EditoColors.body,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _StepConnector extends StatelessWidget {
  const _StepConnector({required this.isCompleted});

  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 22),
        child: Container(
          height: 2.5,
          decoration: BoxDecoration(
            color: isCompleted
                ? EditoColors.primary
                : const Color(0xFFE1E3EE),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Upload Status Metadata Card
// ─────────────────────────────────────────────────────────────

class _UploadedStatusCard extends StatelessWidget {
  const _UploadedStatusCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Column(
        children: [
          // Row with status and change video option
          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF20B66F),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Video Uploaded Successfully',
                  style: GoogleFonts.poppins(
                    color: EditoColors.dark,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFDCCCFF)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.edit_outlined,
                        color: EditoColors.primary,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Change Video',
                        style: GoogleFonts.inter(
                          color: EditoColors.primary,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // File thumbnail and title description
          Row(
            children: [
              // Mini thumbnail visual
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 58,
                  height: 44,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const _MiniVisualMock(),
                      Container(color: Colors.black.withValues(alpha: 0.10)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Title and details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wedding_Reel_Final.mp4',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: EditoColors.dark,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: EditoColors.body.withValues(alpha: 0.65),
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '30 sec',
                          style: GoogleFonts.inter(
                            color: EditoColors.body.withValues(alpha: 0.70),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.hd_outlined,
                          color: EditoColors.body.withValues(alpha: 0.65),
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '1080p',
                          style: GoogleFonts.inter(
                            color: EditoColors.body.withValues(alpha: 0.70),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.insert_drive_file_outlined,
                          color: EditoColors.body.withValues(alpha: 0.65),
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '25 MB',
                          style: GoogleFonts.inter(
                            color: EditoColors.body.withValues(alpha: 0.70),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniVisualMock extends StatelessWidget {
  const _MiniVisualMock();

  @override
  Widget build(BuildContext context) {
    final mockTemplate = const TemplateData(
      title: 'Wedding Reel',
      category: 'WEDDING',
      rating: '5.0',
      creator: 'W',
      duration: '00:30',
      price: 'FREE',
      color: EditoColors.accent,
      secondaryColor: Color(0xFFFFB347),
      overlayText: '',
    );
    return _TemplateVisual(data: mockTemplate);
  }
}

// ─────────────────────────────────────────────────────────────
// Mock Video Player Card
// ─────────────────────────────────────────────────────────────

class _MockVideoPlayer extends StatelessWidget {
  const _MockVideoPlayer({
    required this.isPlaying,
    required this.onTogglePlay,
  });

  final bool isPlaying;
  final VoidCallback onTogglePlay;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x18000000),
              offset: Offset(0, 10),
              blurRadius: 24,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Loaded premium wedding cover image
              Image.network(
                'https://images.unsplash.com/photo-1607190074257-dd4b7af0309f?w=800&auto=format&fit=crop&q=80',
                fit: BoxFit.cover,
              ),

              // Shadow overlay
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

              // Play / Pause Indicator circle overlay
              Center(
                child: GestureDetector(
                  onTap: onTogglePlay,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.black.withValues(alpha: 0.65),
                    child: Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                ),
              ),

              // Controls Bar Overlay
              Positioned(
                left: 14,
                right: 14,
                bottom: 14,
                child: Row(
                  children: [
                    Text(
                      '00:00',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          // White indicator slider
                          Positioned(
                            left: 0,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '00:30',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Icon(
                      Icons.fullscreen_rounded,
                      color: Colors.white.withValues(alpha: 0.85),
                      size: 24,
                    ),
                  ],
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
// AI Detected Sections Card Component
// ─────────────────────────────────────────────────────────────

class _AiDetectedCard extends StatelessWidget {
  const _AiDetectedCard();

  @override
  Widget build(BuildContext context) {
    const list = [
      _DetectedSectionData(
        icon: Icons.videocam_outlined,
        title: 'Video Section',
        subtitle: 'Possible video clip',
        timeSpan: '0:00 - 0:05',
        color: EditoColors.primary,
        tint: Color(0xFFF1ECFF),
      ),
      _DetectedSectionData(
        icon: Icons.videocam_outlined,
        title: 'Video Section',
        subtitle: 'Possible video clip',
        timeSpan: '0:05 - 0:10',
        color: EditoColors.primary,
        tint: Color(0xFFF1ECFF),
      ),
      _DetectedSectionData(
        icon: Icons.image_outlined,
        title: 'Photo Section',
        subtitle: 'Possible image/photo',
        timeSpan: '0:10 - 0:15',
        color: Color(0xFF22B37D),
        tint: Color(0xFFE8F8EF),
      ),
      _DetectedSectionData(
        icon: Icons.text_fields_rounded,
        title: 'Text Section',
        subtitle: 'Possible text/title',
        timeSpan: '0:15 - 0:20',
        color: Color(0xFFFF9800),
        tint: Color(0xFFFFF2DE),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EditoColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            offset: Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header of card
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: EditoColors.primary,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Detected Sections',
                        style: GoogleFonts.poppins(
                          color: EditoColors.dark,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'We found 4 key sections in your video',
                        style: GoogleFonts.inter(
                          color: EditoColors.body.withValues(alpha: 0.72),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: EditoColors.border),

          // Section List Rows
          Column(
            children: [
              for (var i = 0; i < list.length; i++) ...[
                _DetectedSectionRow(data: list[i]),
                if (i != list.length - 1)
                  const Divider(height: 1, color: Color(0xFFF1EEFF)),
              ],
            ],
          ),

          // Card Footer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF7F5FF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_fix_high_rounded,
                  color: EditoColors.primary,
                  size: 16,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'You can edit, add or remove sections in the next step',
                    style: GoogleFonts.inter(
                      color: EditoColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
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

class _DetectedSectionRow extends StatelessWidget {
  const _DetectedSectionRow({required this.data});

  final _DetectedSectionData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Icon Box
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: data.tint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              data.icon,
              color: data.color,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),

          // Meta descriptors
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.title,
                  style: GoogleFonts.poppins(
                    color: EditoColors.dark,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.subtitle,
                  style: GoogleFonts.inter(
                    color: EditoColors.body.withValues(alpha: 0.74),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Time duration and badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                data.timeSpan,
                style: GoogleFonts.inter(
                  color: EditoColors.dark,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F8EF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Detected',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1BB676),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
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

class _DetectedSectionData {
  const _DetectedSectionData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.timeSpan,
    required this.color,
    required this.tint,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String timeSpan;
  final Color color;
  final Color tint;
}

// ─────────────────────────────────────────────────────────────
// Tip Card Component
// ─────────────────────────────────────────────────────────────

class _TipCard extends StatelessWidget {
  const _TipCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7EF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFEAD6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline_rounded,
            color: Color(0xFFFF9800),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tip',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFB36B00),
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Detected sections are suggestions. You can adjust timings and types next.',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFCC7A00),
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
