part of '../../main.dart';

class GenerateVideoScreen extends StatefulWidget {
  const GenerateVideoScreen({
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
  State<GenerateVideoScreen> createState() => _GenerateVideoScreenState();
}

class _GenerateVideoScreenState extends State<GenerateVideoScreen> {
  Timer? _ticker;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (!mounted) return;
      setState(() {
        _progress += 0.01;
        if (_progress >= 1.0) {
          _progress = 1.0;
          _ticker?.cancel();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (_) => VideoReadyScreen(
                template: widget.template,
                assetsData: widget.assetsData,
                quality: widget.quality,
                length: widget.length,
                ratio: widget.ratio,
              ),
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
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
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 34),
                  sliver: SliverList.list(
                    children: [
                      const _GenerateHeader(),
                      const SizedBox(height: 36),
                      _GenerationPreview(template: widget.template, progress: _progress),
                      const SizedBox(height: 40),
                      _GenerationSteps(progress: _progress),
                      const SizedBox(height: 32),
                      const _GenerationMagicCard(),
                      const SizedBox(height: 24),
                      _GenerationTaskCard(progress: _progress),
                      const SizedBox(height: 24),
                      const _GenerationInfoCard(),
                      const SizedBox(height: 22),
                      _DoNotCloseCard(
                        template: widget.template,
                        assetsData: widget.assetsData,
                        quality: widget.quality,
                        length: widget.length,
                        ratio: widget.ratio,
                      ),
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
// Header
// ─────────────────────────────────────────────────────────────

class _GenerateHeader extends StatelessWidget {
  const _GenerateHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _UseHeaderButton(
          icon: Icons.chevron_left_rounded,
          onTap: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Generating Your Video',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: EditoColors.dark,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Sit back and relax! We're creating something amazing.",
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: EditoColors.body.withValues(alpha: 0.75),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        // Spacer to keep title centred under back button
        const SizedBox(width: 55),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Preview card with circular progress
// ─────────────────────────────────────────────────────────────

class _GenerationPreview extends StatelessWidget {
  const _GenerationPreview({required this.template, required this.progress});

  final TemplateData template;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _TemplateVisual(data: template),
                  CustomPaint(painter: _DetailHeroOverlayPainter(template)),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.27),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: SizedBox(
                width: 148,
                height: 148,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _NeonProgressIndicator(progress: progress),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          progress >= 1.0 ? 'Done!' : 'Generating...',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Sparkle decorations – kept inside the card bounds
          const Positioned(
            left: 14,
            top: 170,
            child: _Sparkle(color: Color(0xFFFFC542)),
          ),
          const Positioned(
            right: 14,
            top: 68,
            child: _Sparkle(color: Color(0xFFB9B3FF)),
          ),
          const Positioned(
            right: 18,
            top: 188,
            child: _Sparkle(color: EditoColors.primary),
          ),
          const Positioned(
            left: 20,
            top: 130,
            child: _Sparkle(color: Color(0xFFFFC542), small: true),
          ),
        ],
      ),
    );
  }
}

class _Sparkle extends StatelessWidget {
  const _Sparkle({required this.color, this.small = false});

  final Color color;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.auto_awesome_rounded,
      color: color,
      size: small ? 18 : 26,
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 4-step progress stepper
// ─────────────────────────────────────────────────────────────

class _GenerationSteps extends StatelessWidget {
  const _GenerationSteps({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final step1Complete = progress > 0.25;
    final step1Active = progress <= 0.25;

    final step2Complete = progress > 0.50;
    final step2Active = progress > 0.25 && progress <= 0.50;

    final step3Complete = progress > 0.75;
    final step3Active = progress > 0.50 && progress <= 0.75;

    final step4Complete = progress >= 1.0;
    final step4Active = progress > 0.75 && progress < 1.0;

    return Row(
      children: [
        Expanded(
          child: _GenerationStep(
            icon: step1Complete ? Icons.check_rounded : null,
            number: step1Complete ? null : '1',
            title: 'Preparing',
            subtitle: step1Complete ? 'Done' : 'In Progress',
            active: step1Active,
            complete: step1Complete,
          ),
        ),
        _GenerationLine(active: progress > 0.25),
        Expanded(
          child: _GenerationStep(
            icon: step2Complete ? Icons.check_rounded : null,
            number: step2Complete ? null : '2',
            title: 'Effects',
            subtitle: step2Complete ? 'Done' : step2Active ? 'In Progress' : 'Pending',
            active: step2Active,
            complete: step2Complete,
          ),
        ),
        _GenerationLine(active: progress > 0.50),
        Expanded(
          child: _GenerationStep(
            icon: step3Complete ? Icons.check_rounded : null,
            number: step3Complete ? null : '3',
            title: 'Rendering',
            subtitle: step3Complete ? 'Done' : step3Active ? 'In Progress' : 'Pending',
            active: step3Active,
            complete: step3Complete,
          ),
        ),
        _GenerationLine(active: progress > 0.75),
        Expanded(
          child: _GenerationStep(
            icon: step4Complete ? Icons.check_rounded : null,
            number: step4Complete ? null : '4',
            title: 'Finalizing',
            subtitle: step4Complete ? 'Done' : step4Active ? 'In Progress' : 'Pending',
            active: step4Active,
            complete: step4Complete,
          ),
        ),
      ],
    );
  }
}

class _GenerationStep extends StatelessWidget {
  const _GenerationStep({
    required this.title,
    required this.subtitle,
    this.number,
    this.icon,
    this.active = false,
    this.complete = false,
  });

  final String title;
  final String subtitle;
  final String? number;
  final IconData? icon;
  final bool active;
  final bool complete;

  @override
  Widget build(BuildContext context) {
    final highlighted = active || complete;
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor:
              highlighted ? EditoColors.primary : const Color(0xFFE1E3EE),
          child: icon == null
              ? Text(
                  number ?? '',
                  style: GoogleFonts.poppins(
                    color: highlighted ? Colors.white : EditoColors.body,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                )
              : Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: EditoColors.dark,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: active ? EditoColors.primary : EditoColors.body,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _GenerationLine extends StatelessWidget {
  const _GenerationLine({this.active = false});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 42),
        child: active
            ? Container(height: 2, color: EditoColors.primary)
            : CustomPaint(painter: _DashedLinePainter()),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// "AI is working its magic" card
// ─────────────────────────────────────────────────────────────

class _GenerationMagicCard extends StatelessWidget {
  const _GenerationMagicCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EAFF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_fix_high_rounded,
              color: EditoColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI is working its magic',
                  style: GoogleFonts.poppins(
                    color: EditoColors.dark,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Syncing clips, adding transitions, effects and music to create a stunning video.',
                  style: GoogleFonts.inter(
                    color: EditoColors.dark.withValues(alpha: 0.82),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.45,
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
// Task checklist
// ─────────────────────────────────────────────────────────────

class _GenerationTaskCard extends StatelessWidget {
  const _GenerationTaskCard({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final tasks = [
      _GenerationTaskData(
        icon: Icons.video_collection_outlined,
        title: 'Preparing Your Assets',
        subtitle: 'Checking videos, images and text',
        status: progress >= 0.20 ? _TaskStatus.done : _TaskStatus.loading,
      ),
      _GenerationTaskData(
        icon: Icons.auto_fix_high_rounded,
        title: 'Applying Effects & Transitions',
        subtitle: 'Adding effects and smooth transitions',
        status: progress >= 0.45 
            ? _TaskStatus.done 
            : (progress >= 0.20 ? _TaskStatus.loading : _TaskStatus.pending),
      ),
      _GenerationTaskData(
        icon: Icons.music_note_rounded,
        title: 'Adding Music',
        subtitle: 'Syncing background music',
        status: progress >= 0.70 
            ? _TaskStatus.done 
            : (progress >= 0.45 ? _TaskStatus.loading : _TaskStatus.pending),
      ),
      _GenerationTaskData(
        icon: Icons.hd_outlined,
        title: 'Rendering Video',
        subtitle: 'Rendering in 1080p quality',
        status: progress >= 0.90 
            ? _TaskStatus.done 
            : (progress >= 0.70 ? _TaskStatus.loading : _TaskStatus.pending),
      ),
      _GenerationTaskData(
        icon: Icons.ios_share_rounded,
        title: 'Finalizing',
        subtitle: 'Optimizing and preparing video',
        status: progress >= 1.0 
            ? _TaskStatus.done 
            : (progress >= 0.90 ? _TaskStatus.loading : _TaskStatus.pending),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: EditoColors.white.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            offset: Offset(0, 8),
            blurRadius: 24,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          children: [
            for (var i = 0; i < tasks.length; i++) ...[
              _GenerationTaskRow(data: tasks[i]),
              if (i != tasks.length - 1)
                const Divider(height: 1, color: EditoColors.border),
            ],
          ],
        ),
      ),
    );
  }
}

class _GenerationTaskRow extends StatelessWidget {
  const _GenerationTaskRow({required this.data});

  final _GenerationTaskData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFF1ECFF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(data.icon, color: EditoColors.primary, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: EditoColors.dark,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: EditoColors.body.withValues(alpha: 0.78),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          _TaskStatusIcon(status: data.status),
        ],
      ),
    );
  }
}

class _TaskStatusIcon extends StatelessWidget {
  const _TaskStatusIcon({required this.status});

  final _TaskStatus status;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      _TaskStatus.done => const CircleAvatar(
        radius: 13,
        backgroundColor: Color(0xFF20B66F),
        child: Icon(Icons.check_rounded, color: Colors.white, size: 17),
      ),
      _TaskStatus.loading => const SizedBox(
        width: 26,
        height: 26,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: EditoColors.primary,
        ),
      ),
      _TaskStatus.pending => Icon(
        Icons.schedule_rounded,
        color: EditoColors.body.withValues(alpha: 0.45),
        size: 26,
      ),
    };
  }
}

// ─────────────────────────────────────────────────────────────
// "Did you know?" info card  — column layout for mobile
// ─────────────────────────────────────────────────────────────

class _GenerationInfoCard extends StatelessWidget {
  const _GenerationInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EAFF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline_rounded,
                color: EditoColors.primary,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                'Did you know?',
                style: GoogleFonts.poppins(
                  color: EditoColors.dark,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'You can find your generated videos in "My Videos" once it is ready.',
            style: GoogleFonts.inter(
              color: EditoColors.dark.withValues(alpha: 0.82),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          // Button – full width so text never clips
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute<void>(
                    builder: (_) => const HomeScreen(initialIndex: 2),
                  ),
                  (route) => false,
                );
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFCCBBFF)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.play_circle_outline_rounded,
                      color: EditoColors.primary,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Go to My Videos',
                      style: GoogleFonts.inter(
                        color: EditoColors.primary,
                        fontSize: 15,
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
    );
  }
}

// ─────────────────────────────────────────────────────────────
// "Please don't close the app" banner
// ─────────────────────────────────────────────────────────────

class _DoNotCloseCard extends StatelessWidget {
  const _DoNotCloseCard({
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
              builder: (_) => VideoReadyScreen(
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
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF5A2EFF), Color(0xFF7634FF)],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x386C63FF),
                offset: Offset(0, 10),
                blurRadius: 24,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Please don't close the app",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "We'll notify you when it's done.",
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.88),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: EditoColors.primary,
                  size: 26,
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
// Data models
// ─────────────────────────────────────────────────────────────

enum _TaskStatus { done, loading, pending }

class _GenerationTaskData {
  const _GenerationTaskData({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.status = _TaskStatus.pending,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final _TaskStatus status;
}

// ─────────────────────────────────────────────────────────────
// Glowing Neon Progress Indicator
// ─────────────────────────────────────────────────────────────

class _NeonProgressIndicator extends StatefulWidget {
  const _NeonProgressIndicator({required this.progress});

  final double progress;

  @override
  State<_NeonProgressIndicator> createState() => _NeonProgressIndicatorState();
}

class _NeonProgressIndicatorState extends State<_NeonProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDone = widget.progress >= 1.0;

    return AnimatedScale(
      duration: const Duration(milliseconds: 400),
      scale: isDone ? 1.05 : 1.0,
      curve: Curves.elasticOut,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isDone)
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: EditoColors.primary.withValues(alpha: 0.25),
                    blurRadius: 35,
                    spreadRadius: 8,
                  ),
                ],
              ),
            ),
          RotationTransition(
            turns: _rotationController,
            child: SizedBox(
              width: 148,
              height: 148,
              child: CustomPaint(
                painter: _NeonProgressPainter(progress: widget.progress),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NeonProgressPainter extends CustomPainter {
  _NeonProgressPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 16) / 2;
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    final trackPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0) return;

    final glowPaintOuter = Paint()
      ..shader = const SweepGradient(
        colors: [
          EditoColors.primary,
          Color(0xFF00F0FF),
          EditoColors.primary,
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      glowPaintOuter,
    );

    final glowPaintMid = Paint()
      ..shader = const SweepGradient(
        colors: [
          EditoColors.primary,
          Color(0xFF00F0FF),
          EditoColors.primary,
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 13
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      glowPaintMid,
    );

    final corePaint = Paint()
      ..shader = const SweepGradient(
        colors: [
          EditoColors.primary,
          Color(0xFF00F0FF),
          EditoColors.primary,
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      corePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _NeonProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
