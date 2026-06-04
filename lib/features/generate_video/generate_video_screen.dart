part of '../../main.dart';

class GenerateVideoScreen extends StatelessWidget {
  const GenerateVideoScreen({super.key, required this.template});

  final TemplateData template;

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
                      _GenerationPreview(template: template),
                      const SizedBox(height: 40),
                      const _GenerationSteps(),
                      const SizedBox(height: 32),
                      const _GenerationMagicCard(),
                      const SizedBox(height: 24),
                      const _GenerationTaskCard(),
                      const SizedBox(height: 24),
                      const _GenerationInfoCard(),
                      const SizedBox(height: 22),
                      _DoNotCloseCard(template: template),
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
  const _GenerationPreview({required this.template});

  final TemplateData template;

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
                    CircularProgressIndicator(
                      value: 0.65,
                      strokeWidth: 11,
                      backgroundColor: Colors.white.withValues(alpha: 0.78),
                      color: EditoColors.primary,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '65%',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          'Generating...',
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
  const _GenerationSteps();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _GenerationStep(
            icon: Icons.check_rounded,
            title: 'Preparing',
            subtitle: 'Done',
            complete: true,
          ),
        ),
        _GenerationLine(active: true),
        Expanded(
          child: _GenerationStep(
            number: '2',
            title: 'Effects',
            subtitle: 'In Progress',
            active: true,
          ),
        ),
        _GenerationLine(),
        Expanded(
          child: _GenerationStep(
            number: '3',
            title: 'Rendering',
            subtitle: 'Pending',
          ),
        ),
        _GenerationLine(),
        Expanded(
          child: _GenerationStep(
            number: '4',
            title: 'Finalizing',
            subtitle: 'Pending',
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
  const _GenerationTaskCard();

  static const tasks = [
    _GenerationTaskData(
      icon: Icons.video_collection_outlined,
      title: 'Preparing Your Assets',
      subtitle: 'Checking videos, images and text',
      status: _TaskStatus.done,
    ),
    _GenerationTaskData(
      icon: Icons.auto_fix_high_rounded,
      title: 'Applying Effects & Transitions',
      subtitle: 'Adding effects and smooth transitions',
      status: _TaskStatus.loading,
    ),
    _GenerationTaskData(
      icon: Icons.music_note_rounded,
      title: 'Adding Music',
      subtitle: 'Syncing background music',
    ),
    _GenerationTaskData(
      icon: Icons.hd_outlined,
      title: 'Rendering Video',
      subtitle: 'Rendering in 1080p quality',
    ),
    _GenerationTaskData(
      icon: Icons.ios_share_rounded,
      title: 'Finalizing',
      subtitle: 'Optimizing and preparing video',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
  const _DoNotCloseCard({required this.template});

  final TemplateData template;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => VideoReadyScreen(template: template),
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
