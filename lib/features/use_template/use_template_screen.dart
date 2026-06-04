part of '../../main.dart';

class UseTemplateScreen extends StatelessWidget {
  const UseTemplateScreen({super.key, required this.template});

  final TemplateData template;

  @override
  Widget build(BuildContext context) {
    final isWedding = template.category == 'WEDDING';
    final assetRows = isWedding
        ? const [
            _UploadAssetData(
              step: '1',
              icon: Icons.videocam_outlined,
              title: 'Bride Video',
              subtitle: 'Recommended: 5-15 sec',
              meta: 'MP4, MOV  •  Max 100MB',
              action: 'Upload Video',
              color: EditoColors.primary,
              tint: Color(0xFFF1ECFF),
              required: true,
            ),
            _UploadAssetData(
              step: '2',
              icon: Icons.videocam_outlined,
              title: 'Groom Video',
              subtitle: 'Recommended: 5-15 sec',
              meta: 'MP4, MOV  •  Max 100MB',
              action: 'Upload Video',
              color: EditoColors.primary,
              tint: Color(0xFFF1ECFF),
              required: true,
            ),
            _UploadAssetData(
              step: '3',
              icon: Icons.image_outlined,
              title: 'Couple Photo',
              subtitle: 'Recommended: Portrait',
              meta: 'JPG, PNG  •  Max 10MB',
              action: 'Upload Photo',
              color: Color(0xFF22B37D),
              tint: Color(0xFFE8F8EF),
              required: true,
            ),
            _UploadAssetData(
              step: '4',
              icon: Icons.text_fields_rounded,
              title: 'Couple Name',
              subtitle: 'Enter the name as you want',
              meta: 'it to appear in the video',
              action: '',
              color: Color(0xFF3478F6),
              tint: Color(0xFFEAF3FF),
              inputHint: 'Enter name (e.g. Rahul & Priya)',
              required: true,
            ),
            _UploadAssetData(
              step: '5',
              icon: Icons.verified_outlined,
              title: 'Logo',
              subtitle: 'Add your logo (if any)',
              meta: 'PNG, JPG  •  Max 10MB',
              action: 'Upload Logo',
              color: Color(0xFFFF9800),
              tint: Color(0xFFFFF2DE),
            ),
          ]
        : [
            _UploadAssetData(
              step: '1',
              icon: Icons.videocam_outlined,
              title: '${_titleCase(template.category)} Video',
              subtitle: 'Recommended: 5-15 sec',
              meta: 'MP4, MOV  •  Max 100MB',
              action: 'Upload Video',
              color: EditoColors.primary,
              tint: const Color(0xFFF1ECFF),
              required: true,
            ),
            const _UploadAssetData(
              step: '2',
              icon: Icons.image_outlined,
              title: 'Cover Photo',
              subtitle: 'Recommended: Portrait',
              meta: 'JPG, PNG  •  Max 10MB',
              action: 'Upload Photo',
              color: Color(0xFF22B37D),
              tint: Color(0xFFE8F8EF),
              required: true,
            ),
            const _UploadAssetData(
              step: '3',
              icon: Icons.text_fields_rounded,
              title: 'Title Text',
              subtitle: 'Enter text as you want',
              meta: 'it to appear in the video',
              action: '',
              color: Color(0xFF3478F6),
              tint: Color(0xFFEAF3FF),
              inputHint: 'Enter title text',
              required: true,
            ),
            const _UploadAssetData(
              step: '4',
              icon: Icons.verified_outlined,
              title: 'Logo',
              subtitle: 'Add your logo (if any)',
              meta: 'PNG, JPG  •  Max 10MB',
              action: 'Upload Logo',
              color: Color(0xFFFF9800),
              tint: Color(0xFFFFF2DE),
            ),
          ];

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
                      const _UseTemplateHeader(),
                      const SizedBox(height: 42),
                      const _TemplateFlowSteps(),
                      const SizedBox(height: 38),
                      const _UploadSectionHeader(),
                      const SizedBox(height: 20),
                      for (var i = 0; i < assetRows.length; i++) ...[
                        _UploadAssetRow(data: assetRows[i]),
                        if (i != assetRows.length - 1)
                          const SizedBox(height: 10),
                      ],
                      const SizedBox(height: 34),
                      _UploadTipsCard(template: template),
                      const SizedBox(height: 62),
                      const _SecureDataNote(),
                      const SizedBox(height: 31),
                      _UploadContinueButton(template: template),
                      const SizedBox(height: 17),
                      Text(
                        'You can preview before final generation',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: EditoColors.body.withValues(alpha: 0.78),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 22),
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

class _UseTemplateHeader extends StatelessWidget {
  const _UseTemplateHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 116,
      child: Stack(
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Use This Template',
                style: GoogleFonts.poppins(
                  color: EditoColors.dark,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Upload your content and let AI create magic',
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
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: EditoColors.white.withValues(alpha: 0.76),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: EditoColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.play_circle_outline_rounded,
                    color: EditoColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Preview Demo',
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
        ],
      ),
    );
  }
}

class _UseHeaderButton extends StatelessWidget {
  const _UseHeaderButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: EditoColors.white.withValues(alpha: 0.70),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: EditoColors.border),
          ),
          child: Icon(icon, color: EditoColors.dark, size: 34),
        ),
      ),
    );
  }
}

class _TemplateFlowSteps extends StatelessWidget {
  const _TemplateFlowSteps();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _FlowStep(number: '1', label: 'Upload Assets', active: true),
        ),
        _FlowLine(),
        Expanded(
          child: _FlowStep(number: '2', label: 'Customize'),
        ),
        _FlowLine(),
        Expanded(
          child: _FlowStep(number: '3', label: 'Preview'),
        ),
        _FlowLine(),
        Expanded(
          child: _FlowStep(number: '4', label: 'Generate'),
        ),
      ],
    );
  }
}

class _FlowStep extends StatelessWidget {
  const _FlowStep({
    required this.number,
    required this.label,
    this.active = false,
  });

  final String number;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: active
              ? EditoColors.primary
              : const Color(0xFFE1E3EE),
          child: Text(
            number,
            style: GoogleFonts.poppins(
              color: active ? Colors.white : EditoColors.body,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            color: active ? EditoColors.primary : EditoColors.body,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _FlowLine extends StatelessWidget {
  const _FlowLine();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 34),
        child: CustomPaint(painter: _DashedLinePainter()),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = EditoColors.border
      ..strokeWidth = 1.5;
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + 8, 0), paint);
      x += 14;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _UploadSectionHeader extends StatelessWidget {
  const _UploadSectionHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upload Required Assets',
                style: GoogleFonts.poppins(
                  color: EditoColors.dark,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Add your content in the correct order for best results.',
                style: GoogleFonts.inter(
                  color: EditoColors.body.withValues(alpha: 0.78),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
          decoration: BoxDecoration(
            color: const Color(0xFFF5EFFF),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Text(
            'Step 1 of 4',
            style: GoogleFonts.inter(
              color: EditoColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _UploadAssetRow extends StatelessWidget {
  const _UploadAssetRow({required this.data});

  final _UploadAssetData data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 224,
      child: Row(
        children: [
          SizedBox(
            width: 45,
            child: Center(
              child: CircleAvatar(
                radius: 14,
                backgroundColor: const Color(0xFFE9DFFF),
                child: Text(
                  data.step,
                  style: GoogleFonts.poppins(
                    color: EditoColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 224,
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
              decoration: BoxDecoration(
                color: EditoColors.white.withValues(alpha: 0.86),
                borderRadius: BorderRadius.circular(13),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x06000000),
                    offset: Offset(0, 8),
                    blurRadius: 22,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 66,
                        height: 66,
                        decoration: BoxDecoration(
                          color: data.tint,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Icon(data.icon, color: data.color, size: 34),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    data.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      color: EditoColors.dark,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                if (data.required)
                                  Text(
                                    '  *',
                                    style: GoogleFonts.poppins(
                                      color: EditoColors.accent,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                if (!data.required)
                                  Text(
                                    '  Optional',
                                    style: GoogleFonts.inter(
                                      color: EditoColors.body.withValues(
                                        alpha: 0.78,
                                      ),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              data.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                color: EditoColors.body.withValues(alpha: 0.78),
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              data.meta,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                color: EditoColors.body.withValues(alpha: 0.78),
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: data.inputHint == null ? 100 : 52,
                    child: data.inputHint == null
                        ? _UploadActionColumn(data: data)
                        : _UploadInputField(hint: data.inputHint!),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadActionColumn extends StatelessWidget {
  const _UploadActionColumn({required this.data});

  final _UploadAssetData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: data.color.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: data.color.withValues(alpha: 0.28)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_upload_outlined, color: data.color, size: 24),
              const SizedBox(width: 10),
              Text(
                data.action,
                style: GoogleFonts.inter(
                  color: data.color,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        RichText(
          text: TextSpan(
            style: GoogleFonts.inter(
              color: EditoColors.body.withValues(alpha: 0.78),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            children: const [
              TextSpan(text: 'or  '),
              TextSpan(
                text: 'Choose from Gallery',
                style: TextStyle(
                  color: EditoColors.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UploadInputField extends StatelessWidget {
  const _UploadInputField({required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFD),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: EditoColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              hint,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: EditoColors.body.withValues(alpha: 0.70),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            '0/30',
            style: GoogleFonts.inter(
              color: EditoColors.body.withValues(alpha: 0.72),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadTipsCard extends StatelessWidget {
  const _UploadTipsCard({required this.template});

  final TemplateData template;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tips = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tips for best results',
              style: GoogleFonts.poppins(
                color: EditoColors.dark,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            for (final tip in const [
              'Use good quality videos and images',
              'Keep videos short and clear',
              'Names will be beautifully animated in the video',
            ])
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  '- $tip',
                  style: GoogleFonts.inter(
                    color: EditoColors.dark,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
              ),
          ],
        );

        final preview = ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _TemplateVisual(data: template),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.06),
                      Colors.black.withValues(alpha: 0.46),
                    ],
                  ),
                ),
              ),
              const Center(
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 43,
                ),
              ),
              Positioned(
                left: 15,
                bottom: 13,
                right: 15,
                child: Text(
                  template.category == 'WEDDING'
                      ? 'RAHUL & PRIYA'
                      : template.title.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        );

        final isCompact = constraints.maxWidth < 560;

        return Container(
          height: isCompact ? 390 : 170,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFF1EAFF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: isCompact
              ? Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.lightbulb_outline_rounded,
                          color: EditoColors.primary,
                          size: 31,
                        ),
                        const SizedBox(width: 14),
                        Expanded(child: tips),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 112,
                      width: double.infinity,
                      child: preview,
                    ),
                  ],
                )
              : Row(
                  children: [
                    const Icon(
                      Icons.lightbulb_outline_rounded,
                      color: EditoColors.primary,
                      size: 31,
                    ),
                    const SizedBox(width: 18),
                    Expanded(child: tips),
                    const SizedBox(width: 24),
                    SizedBox(width: 230, height: 112, child: preview),
                  ],
                ),
        );
      },
    );
  }
}

class _SecureDataNote extends StatelessWidget {
  const _SecureDataNote();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.lock_outline_rounded,
          color: EditoColors.body.withValues(alpha: 0.72),
          size: 19,
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            'Your data is secure and will not be shared with anyone.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: EditoColors.body.withValues(alpha: 0.78),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _UploadContinueButton extends StatelessWidget {
  const _UploadContinueButton({required this.template});

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
              builder: (_) => PreviewCustomizeScreen(template: template),
            ),
          );
        },
        child: Container(
          height: 75,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF5A2EFF), Color(0xFF7B35FF)],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x306C63FF),
                offset: Offset(0, 12),
                blurRadius: 26,
              ),
            ],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Continue with Preview',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 18),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 31,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UploadAssetData {
  const _UploadAssetData({
    required this.step,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.meta,
    required this.action,
    required this.color,
    required this.tint,
    this.inputHint,
    this.required = false,
  });

  final String step;
  final IconData icon;
  final String title;
  final String subtitle;
  final String meta;
  final String action;
  final Color color;
  final Color tint;
  final String? inputHint;
  final bool required;
}
