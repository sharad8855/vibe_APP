part of '../../main.dart';

class PreviewCustomizeScreen extends StatefulWidget {
  const PreviewCustomizeScreen({super.key, required this.template});

  final TemplateData template;

  @override
  State<PreviewCustomizeScreen> createState() => _PreviewCustomizeScreenState();
}

class _PreviewCustomizeScreenState extends State<PreviewCustomizeScreen> {
  late Map<String, (String, String)> _assetsData;
  
  String _selectedQuality = '1080p (Full HD)';
  String _selectedLength = '30 Seconds';
  String _selectedRatio = '9:16 (Vertical)';

  @override
  void initState() {
    super.initState();
    final isWedding = widget.template.category == 'WEDDING';
    if (isWedding) {
      _assetsData = {
        'Bride Video': ('Bride.mp4', '00:15  •  45 MB'),
        'Groom Video': ('Groom.mp4', '00:14  •  38 MB'),
        'Couple Photo': ('Couple.jpg', '1920 x 1280  •  2.4 MB'),
        'Couple Name': ('Rahul & Priya', 'Font: Poppins SemiBold\nColor: #E91E63'),
        'Logo (Optional)': ('${widget.template.creator}.png', '512 x 512  •  120 KB'),
      };
    } else {
      final categoryName = _titleCase(widget.template.category);
      _assetsData = {
        '$categoryName Video': ('$categoryName.mp4', '00:15  •  45 MB'),
        'Cover Photo': ('Cover.jpg', '1920 x 1280  •  2.4 MB'),
        'Title Text': (widget.template.title, 'Font: Poppins SemiBold\nColor: #6C63FF'),
        'Logo (Optional)': ('${widget.template.creator}.png', '512 x 512  •  120 KB'),
      };
    }
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
        } else if (title.contains('Photo')) {
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

  void _showSettingsBottomSheet(String title, List<String> options, String currentValue, ValueChanged<String> onSelected) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: EditoColors.dark,
                ),
              ),
              const SizedBox(height: 12),
              const Divider(color: EditoColors.border),
              for (final opt in options)
                ListTile(
                  title: Text(
                    opt,
                    style: GoogleFonts.inter(
                      fontWeight: opt == currentValue ? FontWeight.w800 : FontWeight.w600,
                      color: opt == currentValue ? EditoColors.primary : EditoColors.dark,
                    ),
                  ),
                  trailing: opt == currentValue
                      ? const Icon(Icons.check_rounded, color: EditoColors.primary)
                      : null,
                  onTap: () {
                    onSelected(opt);
                    Navigator.of(context).pop();
                  },
                ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
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
                      const _PreviewCustomizeHeader(),
                      const SizedBox(height: 42),
                      const _PreviewFlowSteps(),
                      const SizedBox(height: 38),
                      const _PreviewIntro(),
                      const SizedBox(height: 20),
                      _ReviewContentCard(
                        template: widget.template,
                        assetsData: _assetsData,
                        onEditAsset: _onEditAsset,
                      ),
                      const SizedBox(height: 28),
                      _VideoSettingsCard(
                        quality: _selectedQuality,
                        length: _selectedLength,
                        ratio: _selectedRatio,
                        onSelectQuality: () => _showSettingsBottomSheet(
                          'Select Video Quality',
                          ['720p (HD)', '1080p (Full HD)', '4K (Ultra HD)'],
                          _selectedQuality,
                          (val) => setState(() => _selectedQuality = val),
                        ),
                        onSelectLength: () => _showSettingsBottomSheet(
                          'Select Video Length',
                          ['15 Seconds', '30 Seconds', '45 Seconds', '60 Seconds'],
                          _selectedLength,
                          (val) => setState(() => _selectedLength = val),
                        ),
                        onSelectRatio: () => _showSettingsBottomSheet(
                          'Select Aspect Ratio',
                          ['9:16 (Vertical)', '16:9 (Horizontal)', '1:1 (Square)'],
                          _selectedRatio,
                          (val) => setState(() => _selectedRatio = val),
                        ),
                      ),
                      const SizedBox(height: 22),
                      const _AiMagicCard(),
                      const SizedBox(height: 48),
                      const _SecureDataNote(),
                      const SizedBox(height: 27),
                      _GenerateVideoButton(
                        template: widget.template,
                        assetsData: _assetsData,
                        quality: _selectedQuality,
                        length: _selectedLength,
                        ratio: _selectedRatio,
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

class _PreviewCustomizeHeader extends StatelessWidget {
  const _PreviewCustomizeHeader();

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
                'Preview & Customize',
                style: GoogleFonts.poppins(
                  color: EditoColors.dark,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Review your content and make final adjustments',
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
        ],
      ),
    );
  }
}

class _PreviewFlowSteps extends StatelessWidget {
  const _PreviewFlowSteps();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _PreviewStep(
            icon: Icons.check_rounded,
            label: 'Upload Assets',
            complete: true,
          ),
        ),
        _ActiveFlowLine(),
        Expanded(
          child: _PreviewStep(number: '2', label: 'Customize', active: true),
        ),
        _ActiveFlowLine(),
        Expanded(
          child: _PreviewStep(number: '3', label: 'Preview'),
        ),
        _ActiveFlowLine(),
        Expanded(
          child: _PreviewStep(number: '4', label: 'Generate'),
        ),
      ],
    );
  }
}

class _PreviewStep extends StatelessWidget {
  const _PreviewStep({
    required this.label,
    this.number,
    this.icon,
    this.active = false,
    this.complete = false,
  });

  final String label;
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
          radius: 22,
          backgroundColor: highlighted
              ? EditoColors.primary
              : const Color(0xFFE1E3EE),
          child: icon == null
              ? Text(
                  number ?? '',
                  style: GoogleFonts.poppins(
                    color: highlighted ? Colors.white : EditoColors.body,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                )
              : Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 14),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            color: highlighted ? EditoColors.primary : EditoColors.body,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _ActiveFlowLine extends StatelessWidget {
  const _ActiveFlowLine();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 34),
        child: Container(
          height: 2,
          decoration: BoxDecoration(
            color: EditoColors.primary.withValues(alpha: 0.22),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

class _PreviewIntro extends StatelessWidget {
  const _PreviewIntro();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review Your Content',
          style: GoogleFonts.poppins(
            color: EditoColors.dark,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Make sure everything looks perfect before generating your video.',
          style: GoogleFonts.inter(
            color: EditoColors.body.withValues(alpha: 0.78),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ReviewContentCard extends StatelessWidget {
  const _ReviewContentCard({
    required this.template,
    required this.assetsData,
    required this.onEditAsset,
  });

  final TemplateData template;
  final Map<String, (String, String)> assetsData;
  final ValueChanged<String> onEditAsset;

  @override
  Widget build(BuildContext context) {
    final rows = template.category == 'WEDDING'
        ? [
            _ReviewAssetData(
              icon: Icons.videocam_outlined,
              title: 'Bride Video',
              filename: assetsData['Bride Video']?.$1 ?? 'Bride.mp4',
              meta: assetsData['Bride Video']?.$2 ?? '00:15  •  45 MB',
              color: EditoColors.primary,
              tint: const Color(0xFFF1ECFF),
              template: template,
            ),
            _ReviewAssetData(
              icon: Icons.videocam_outlined,
              title: 'Groom Video',
              filename: assetsData['Groom Video']?.$1 ?? 'Groom.mp4',
              meta: assetsData['Groom Video']?.$2 ?? '00:14  •  38 MB',
              color: EditoColors.primary,
              tint: const Color(0xFFF1ECFF),
              template: template,
              reversed: true,
            ),
            _ReviewAssetData(
              icon: Icons.image_outlined,
              title: 'Couple Photo',
              filename: assetsData['Couple Photo']?.$1 ?? 'Couple.jpg',
              meta: assetsData['Couple Photo']?.$2 ?? '1920 x 1280  •  2.4 MB',
              color: const Color(0xFF22B37D),
              tint: const Color(0xFFE8F8EF),
              template: template,
            ),
            _ReviewAssetData(
              icon: Icons.text_fields_rounded,
              title: 'Couple Name',
              filename: assetsData['Couple Name']?.$1 ?? 'Rahul & Priya',
              meta: assetsData['Couple Name']?.$2 ?? 'Font: Poppins SemiBold\nColor: #E91E63',
              color: const Color(0xFF3478F6),
              tint: const Color(0xFFEAF3FF),
              textOnly: true,
            ),
            _ReviewAssetData(
              icon: Icons.verified_outlined,
              title: 'Logo (Optional)',
              filename: assetsData['Logo (Optional)']?.$1 ?? '${template.creator}.png',
              meta: assetsData['Logo (Optional)']?.$2 ?? '512 x 512  •  120 KB',
              color: const Color(0xFFFF9800),
              tint: const Color(0xFFFFF2DE),
              logo: true,
            ),
          ]
        : [
            _ReviewAssetData(
              icon: Icons.videocam_outlined,
              title: '${_titleCase(template.category)} Video',
              filename: assetsData['${_titleCase(template.category)} Video']?.$1 ?? '${_titleCase(template.category)}.mp4',
              meta: assetsData['${_titleCase(template.category)} Video']?.$2 ?? '00:15  •  45 MB',
              color: EditoColors.primary,
              tint: const Color(0xFFF1ECFF),
              template: template,
            ),
            _ReviewAssetData(
              icon: Icons.image_outlined,
              title: 'Cover Photo',
              filename: assetsData['Cover Photo']?.$1 ?? 'Cover.jpg',
              meta: assetsData['Cover Photo']?.$2 ?? '1920 x 1280  •  2.4 MB',
              color: const Color(0xFF22B37D),
              tint: const Color(0xFFE8F8EF),
              template: template,
            ),
            _ReviewAssetData(
              icon: Icons.text_fields_rounded,
              title: 'Title Text',
              filename: assetsData['Title Text']?.$1 ?? template.title,
              meta: assetsData['Title Text']?.$2 ?? 'Font: Poppins SemiBold\nColor: #6C63FF',
              color: const Color(0xFF3478F6),
              tint: const Color(0xFFEAF3FF),
              textOnly: true,
            ),
            _ReviewAssetData(
              icon: Icons.verified_outlined,
              title: 'Logo (Optional)',
              filename: assetsData['Logo (Optional)']?.$1 ?? '${template.creator}.png',
              meta: assetsData['Logo (Optional)']?.$2 ?? '512 x 512  •  120 KB',
              color: const Color(0xFFFF9800),
              tint: const Color(0xFFFFF2DE),
              logo: true,
            ),
          ];

    return Container(
      decoration: BoxDecoration(
        color: EditoColors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(13),
        boxShadow: const [
          BoxShadow(
            color: Color(0x07000000),
            offset: Offset(0, 8),
            blurRadius: 22,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Column(
          children: [
            for (var i = 0; i < rows.length; i++) ...[
              _ReviewContentRow(
                data: rows[i],
                onEdit: () => onEditAsset(rows[i].title),
              ),
              if (i != rows.length - 1)
                const Divider(height: 1, color: EditoColors.border),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReviewContentRow extends StatelessWidget {
  const _ReviewContentRow({required this.data, required this.onEdit});

  final _ReviewAssetData data;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final icon = Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: data.tint,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(data.icon, color: data.color, size: 30),
    );

    final title = Text(
      data.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.poppins(
        color: EditoColors.dark,
        fontSize: 15,
        fontWeight: FontWeight.w800,
      ),
    );

    final details = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.filename,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            color: EditoColors.dark,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          data.meta,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            color: EditoColors.body.withValues(alpha: 0.80),
            fontSize: 13,
            fontWeight: FontWeight.w700,
            height: 1.35,
          ),
        ),
      ],
    );

    Widget previewBox(double width, double height) {
      return SizedBox(
        width: width,
        height: height,
        child: data.textOnly
            ? const SizedBox.shrink()
            : data.logo
            ? _LogoPreview(label: data.filename)
            : _AssetPreview(template: data.template!, reversed: data.reversed),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 560) {
          return Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    icon,
                    const SizedBox(width: 12),
                    Expanded(child: title),
                    const SizedBox(width: 8),
                    _EditAssetButton(onTap: onEdit),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    previewBox(104, 76),
                    const SizedBox(width: 12),
                    Expanded(child: details),
                  ],
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 18),
              icon,
              const SizedBox(width: 17),
              SizedBox(width: 126, child: title),
              const SizedBox(width: 18),
              previewBox(136, 74),
              const SizedBox(width: 20),
              Expanded(child: details),
              const SizedBox(width: 12),
              _EditAssetButton(onTap: onEdit),
              const SizedBox(width: 20),
            ],
          ),
        );
      },
    );
  }
}

class _AssetPreview extends StatelessWidget {
  const _AssetPreview({required this.template, this.reversed = false});

  final TemplateData template;
  final bool reversed;

  @override
  Widget build(BuildContext context) {
    final preview = TemplateData(
      title: template.title,
      category: template.category,
      rating: template.rating,
      creator: template.creator,
      duration: template.duration,
      price: template.price,
      color: reversed ? template.secondaryColor : template.color,
      secondaryColor: reversed ? template.color : template.secondaryColor,
      overlayText: template.overlayText,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
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
                  Colors.black.withValues(alpha: 0.42),
                ],
              ),
            ),
          ),
          const Center(
            child: Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoPreview extends StatelessWidget {
  const _LogoPreview({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 74,
        height: 74,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Center(
          child: Text(
            label.substring(0, 1).toUpperCase(),
            style: GoogleFonts.poppins(
              color: const Color(0xFFFFB72C),
              fontSize: 34,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _EditAssetButton extends StatelessWidget {
  const _EditAssetButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        width: 99,
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFD),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: EditoColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.edit_outlined, color: EditoColors.primary, size: 19),
            const SizedBox(width: 9),
            Text(
              'Edit',
              style: GoogleFonts.inter(
                color: EditoColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoSettingsCard extends StatelessWidget {
  const _VideoSettingsCard({
    required this.quality,
    required this.length,
    required this.ratio,
    required this.onSelectQuality,
    required this.onSelectLength,
    required this.onSelectRatio,
  });

  final String quality;
  final String length;
  final String ratio;
  final VoidCallback onSelectQuality;
  final VoidCallback onSelectLength;
  final VoidCallback onSelectRatio;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 25),
      decoration: BoxDecoration(
        color: EditoColors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(13),
        boxShadow: const [
          BoxShadow(
            color: Color(0x07000000),
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1ECFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.settings_outlined,
                  color: EditoColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Video Settings',
                  style: GoogleFonts.poppins(
                    color: EditoColors.dark,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EFFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Recommended',
                  style: GoogleFonts.inter(
                    color: EditoColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: _SettingSelect(
                  label: 'Video Quality',
                  value: quality,
                  onTap: onSelectQuality,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SettingSelect(
                  label: 'Video Length',
                  value: length,
                  onTap: onSelectLength,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SettingSelect(
                  label: 'Aspect Ratio',
                  value: ratio,
                  active: true,
                  onTap: onSelectRatio,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingSelect extends StatelessWidget {
  const _SettingSelect({
    required this.label,
    required this.value,
    required this.onTap,
    this.active = false,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: EditoColors.dark,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 11),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 58,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFD),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: active ? const Color(0xFFD8C8FF) : EditoColors.border,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      style: GoogleFonts.inter(
                        color: active ? EditoColors.primary : EditoColors.dark,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: active ? EditoColors.primary : EditoColors.dark,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AiMagicCard extends StatelessWidget {
  const _AiMagicCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EAFF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color: EditoColors.primary,
            size: 33,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Magic',
                  style: GoogleFonts.poppins(
                    color: EditoColors.dark,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Our AI will automatically sync your clips, apply transitions, effects and music to create a stunning video.',
                  style: GoogleFonts.inter(
                    color: EditoColors.dark,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Icon(
            Icons.auto_fix_high_rounded,
            color: EditoColors.primary.withValues(alpha: 0.78),
            size: 42,
          ),
        ],
      ),
    );
  }
}

class _GenerateVideoButton extends StatelessWidget {
  const _GenerateVideoButton({
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
              builder: (_) => PreviewTemplateScreen(
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
          height: 86,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF5A2EFF), Color(0xFF8E43FF)],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x306C63FF),
                offset: Offset(0, 12),
                blurRadius: 26,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Generate Video',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 23,
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
              const SizedBox(height: 7),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'Estimated time: 1-2 minutes',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
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

class _ReviewAssetData {
  const _ReviewAssetData({
    required this.icon,
    required this.title,
    required this.filename,
    required this.meta,
    required this.color,
    required this.tint,
    this.template,
    this.reversed = false,
    this.textOnly = false,
    this.logo = false,
  });

  final IconData icon;
  final String title;
  final String filename;
  final String meta;
  final Color color;
  final Color tint;
  final TemplateData? template;
  final bool reversed;
  final bool textOnly;
  final bool logo;
}
