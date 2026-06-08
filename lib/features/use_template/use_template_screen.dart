part of '../../main.dart';

class UseTemplateScreen extends StatefulWidget {
  const UseTemplateScreen({super.key, required this.template});

  final TemplateData template;

  @override
  State<UseTemplateScreen> createState() => _UseTemplateScreenState();
}

class _UseTemplateScreenState extends State<UseTemplateScreen> {
  final Map<String, String> _uploadedFiles = {};
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {}); // Updates form validation visually as user types
  }

  bool get _isFormValid {
    final isWedding = widget.template.category == 'WEDDING';
    if (isWedding) {
      return _uploadedFiles.containsKey('Bride Video') &&
             _uploadedFiles.containsKey('Groom Video') &&
             _uploadedFiles.containsKey('Couple Photo') &&
             _textController.text.trim().isNotEmpty;
    } else {
      final categoryName = _titleCase(widget.template.category);
      return _uploadedFiles.containsKey('$categoryName Video') &&
             _uploadedFiles.containsKey('Cover Photo') &&
             _textController.text.trim().isNotEmpty;
    }
  }

  void _onUploadAsset(String assetTitle, String fileExtension, String defaultSize) {
    setState(() {
      final randomNum = math.Random().nextInt(89) + 10;
      final ext = fileExtension.toLowerCase();
      _uploadedFiles[assetTitle] = '${assetTitle.replaceAll(' ', '_').toLowerCase()}_v$randomNum.$ext ($defaultSize)';
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$assetTitle uploaded successfully!',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF22B37D),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onClearAsset(String assetTitle) {
    setState(() {
      _uploadedFiles.remove(assetTitle);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Removed $assetTitle',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onContinue() {
    if (!_isFormValid) {
      final isWedding = widget.template.category == 'WEDDING';
      final List<String> missing = [];
      if (isWedding) {
        if (!_uploadedFiles.containsKey('Bride Video')) missing.add('Bride Video');
        if (!_uploadedFiles.containsKey('Groom Video')) missing.add('Groom Video');
        if (!_uploadedFiles.containsKey('Couple Photo')) missing.add('Couple Photo');
        if (_textController.text.trim().isEmpty) missing.add('Couple Name');
      } else {
        final categoryName = _titleCase(widget.template.category);
        if (!_uploadedFiles.containsKey('$categoryName Video')) missing.add('$categoryName Video');
        if (!_uploadedFiles.containsKey('Cover Photo')) missing.add('Cover Photo');
        if (_textController.text.trim().isEmpty) missing.add('Title Text');
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Missing: ${missing.join(', ')}',
            style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.white),
          ),
          backgroundColor: EditoColors.accent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PreviewCustomizeScreen(template: widget.template),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWedding = widget.template.category == 'WEDDING';
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
              title: '${_titleCase(widget.template.category)} Video',
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
                        _UploadAssetRow(
                          data: assetRows[i],
                          uploadedPath: _uploadedFiles[assetRows[i].title],
                          onUpload: () {
                            final ext = assetRows[i].title.contains('Photo') || assetRows[i].title.contains('Logo') ? 'PNG' : 'MP4';
                            final size = assetRows[i].title.contains('Photo') || assetRows[i].title.contains('Logo') ? '3.8 MB' : '48.5 MB';
                            _onUploadAsset(assetRows[i].title, ext, size);
                          },
                          onClear: () => _onClearAsset(assetRows[i].title),
                          textController: assetRows[i].inputHint != null ? _textController : null,
                        ),
                        if (i != assetRows.length - 1)
                          const SizedBox(height: 10),
                      ],
                      const SizedBox(height: 34),
                      _UploadTipsCard(template: widget.template),
                      const SizedBox(height: 62),
                      const _SecureDataNote(),
                      const SizedBox(height: 31),
                      _UploadContinueButton(
                        template: widget.template,
                        isValid: _isFormValid,
                        onTap: _onContinue,
                      ),
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
  const _UploadAssetRow({
    required this.data,
    required this.uploadedPath,
    required this.onUpload,
    required this.onClear,
    this.textController,
  });

  final _UploadAssetData data;
  final String? uploadedPath;
  final VoidCallback onUpload;
  final VoidCallback onClear;
  final TextEditingController? textController;

  @override
  Widget build(BuildContext context) {
    final isUploaded = uploadedPath != null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 45,
          child: Padding(
            padding: const EdgeInsets.only(top: 18),
            child: Center(
              child: CircleAvatar(
                radius: 14,
                backgroundColor: isUploaded ? const Color(0xFFE8F8EF) : const Color(0xFFE9DFFF),
                child: isUploaded
                    ? const Icon(Icons.check_rounded, color: Color(0xFF22B37D), size: 14)
                    : Text(
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
        ),
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            decoration: BoxDecoration(
              color: EditoColors.white.withValues(alpha: 0.86),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isUploaded ? const Color(0xFFCBEEDD) : const Color(0xFFF1EEFF),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isUploaded ? const Color(0x0522B37D) : const Color(0x06000000),
                  offset: const Offset(0, 8),
                  blurRadius: 22,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 66,
                      height: 66,
                      decoration: BoxDecoration(
                        color: isUploaded ? const Color(0xFFE8F8EF) : data.tint,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(
                        isUploaded ? Icons.check_circle_outline_rounded : data.icon,
                        color: isUploaded ? const Color(0xFF22B37D) : data.color,
                        size: 34,
                      ),
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
                              if (data.required && !isUploaded)
                                Text(
                                  '  *',
                                  style: GoogleFonts.poppins(
                                    color: EditoColors.accent,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              if (isUploaded)
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F8EF),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'READY',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF22B37D),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              if (!data.required && !isUploaded)
                                Text(
                                  '  Optional',
                                  style: GoogleFonts.inter(
                                    color: EditoColors.body.withValues(alpha: 0.78),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isUploaded ? uploadedPath! : data.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              color: isUploaded ? const Color(0xFF22B37D) : EditoColors.body.withValues(alpha: 0.78),
                              fontSize: 13,
                              fontWeight: isUploaded ? FontWeight.w800 : FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 5),
                          if (!isUploaded)
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
                data.inputHint == null
                    ? _UploadActionRowButton(
                        data: data,
                        isUploaded: isUploaded,
                        onUpload: onUpload,
                        onClear: onClear,
                      )
                    : _UploadInputField(
                        hint: data.inputHint!,
                        controller: textController!,
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _UploadActionRowButton extends StatelessWidget {
  const _UploadActionRowButton({
    required this.data,
    required this.isUploaded,
    required this.onUpload,
    required this.onClear,
  });

  final _UploadAssetData data;
  final bool isUploaded;
  final VoidCallback onUpload;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    if (isUploaded) {
      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onUpload,
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F3F8),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: const Color(0xFFDDDCE5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.sync_rounded, color: EditoColors.dark, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Replace File',
                      style: GoogleFonts.inter(
                        color: EditoColors.dark,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onClear,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F3),
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: const Color(0xFFFFD1D8)),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Color(0xFFFF3B30),
                size: 22,
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onUpload,
          child: Container(
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
        ),
        const SizedBox(height: 18),
        GestureDetector(
          onTap: onUpload,
          child: RichText(
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
        ),
      ],
    );
  }
}

class _UploadInputField extends StatefulWidget {
  const _UploadInputField({
    required this.hint,
    required this.controller,
  });

  final String hint;
  final TextEditingController controller;

  @override
  State<_UploadInputField> createState() => _UploadInputFieldState();
}

class _UploadInputFieldState extends State<_UploadInputField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateCounter);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateCounter);
    super.dispose();
  }

  void _updateCounter() {
    if (mounted) setState(() {});
  }

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
            child: TextField(
              controller: widget.controller,
              style: GoogleFonts.inter(
                color: EditoColors.dark,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
              maxLength: 30,
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: GoogleFonts.inter(
                  color: EditoColors.body.withValues(alpha: 0.5),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                border: InputBorder.none,
                counterText: '',
              ),
            ),
          ),
          Text(
            '${widget.controller.text.length}/30',
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
  const _UploadContinueButton({
    required this.template,
    required this.isValid,
    required this.onTap,
  });

  final TemplateData template;
  final bool isValid;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isValid ? 1.0 : 0.6,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            height: 75,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: isValid
                    ? [const Color(0xFF5A2EFF), const Color(0xFF7B35FF)]
                    : [const Color(0xFF88849E), const Color(0xFFA59EC2)],
              ),
              boxShadow: isValid
                  ? const [
                      BoxShadow(
                        color: Color(0x306C63FF),
                        offset: Offset(0, 12),
                        blurRadius: 26,
                      ),
                    ]
                  : null,
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
