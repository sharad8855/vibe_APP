part of '../../main.dart';

class TemplateSubmittedScreen extends StatelessWidget {
  const TemplateSubmittedScreen({super.key});

  void _handleBackToMyTemplates(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => const HomeScreen(initialIndex: 3), // Index 3 is Profile
      ),
      (route) => false,
    );
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const MyTemplatesScreen(),
      ),
    );
    
    // Show a helpful snackbar indicating success
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Template submitted successfully! Under review.',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }



  void _showGuidelinesNotification(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening creator guidelines...',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
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
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 160),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Custom Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _UseHeaderButton(
                        icon: Icons.chevron_left_rounded,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      GestureDetector(
                        onTap: () => _handleBackToMyTemplates(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFDCCCFF)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.folder_open_outlined,
                                color: EditoColors.primary,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Go to My Templates',
                                style: GoogleFonts.inter(
                                  color: EditoColors.primary,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Sparkly Confetti Checkmark Graphics
                  const _SparklyCheckIndicator(),
                  const SizedBox(height: 18),

                  // Primary Titles
                  Text(
                    'Template Submitted Successfully!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: EditoColors.dark,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Your template has been submitted and is under review.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: EditoColors.body.withValues(alpha: 0.76),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Current Status Container Card
                  const _CurrentStatusCard(),
                  const SizedBox(height: 20),

                  // Template Preview Section Title
                  Text(
                    'Template Preview',
                    style: GoogleFonts.poppins(
                      color: EditoColors.dark,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Preview Detail Row Card
                  const _TemplatePreviewDetailsCard(),
                  const SizedBox(height: 20),

                  // What's Next Process Section
                  const _TemplateSubmittedWhatsNextCard(),
                  const SizedBox(height: 20),

                  // Tips Card Panel
                  _buildTipsCard(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Bottom Buttons Sticky Footer
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Back to My Templates button
                _GradientFolderButton(
                  label: 'Back to My Templates',
                  onTap: () => _handleBackToMyTemplates(context),
                ),
                const SizedBox(height: 10),
                // Share with Friends Button
                OutlinedButton.icon(
                  onPressed: () => showShareSheet(
                    context,
                    title: 'My Custom Template',
                    sheetTitle: 'Share Template',
                  ),
                  icon: const Icon(Icons.share_outlined, size: 18, color: EditoColors.primary),
                  label: Text(
                    'Share with Friends',
                    style: GoogleFonts.poppins(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: EditoColors.primary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    side: const BorderSide(color: Color(0xFFDCCCFF), width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    backgroundColor: Colors.white.withValues(alpha: 0.5),
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
  // Tips Panel Builder
  // ─────────────────────────────────────────────────────────────
  Widget _buildTipsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F5FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5DEFF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline_rounded,
            color: EditoColors.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips to get approved faster',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF5A4DDF),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Make sure your template preview is clear and all slots are correctly defined.',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF675BEE),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: () => _showGuidelinesNotification(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              side: const BorderSide(color: Color(0xFFBCA9FF)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              backgroundColor: Colors.white,
            ),
            child: Text(
              'View Guidelines',
              style: GoogleFonts.inter(
                color: EditoColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Sparkly Confetti Graphics
// ─────────────────────────────────────────────────────────────
class _SparklyCheckIndicator extends StatelessWidget {
  const _SparklyCheckIndicator();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sparkle 1: Top-Left Purple Swoosh Mockup
          Positioned(
            left: 105,
            top: 24,
            child: Transform.rotate(
              angle: -0.4,
              child: const Icon(Icons.bolt_rounded, color: Color(0xFF6C63FF), size: 16),
            ),
          ),
          // Sparkle 2: Mid-Left Yellow diamond
          Positioned(
            left: 135,
            top: 68,
            child: const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 12),
          ),
          // Sparkle 3: Top-Right Rocket visual
          Positioned(
            right: 110,
            top: 28,
            child: Transform.rotate(
              angle: 0.5,
              child: const Icon(Icons.rocket_launch_rounded, color: Color(0xFF9C27B0), size: 16),
            ),
          ),
          // Sparkle 4: Mid-Right Yellow diamond
          Positioned(
            right: 135,
            top: 68,
            child: const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 12),
          ),

          // Central circle checkmark
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF22B37D), Color(0xFF1BB676)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF22B37D).withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 48,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Current Status Card Component
// ─────────────────────────────────────────────────────────────
class _CurrentStatusCard extends StatelessWidget {
  const _CurrentStatusCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          // Clock visual box
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Color(0xFFECE9FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.access_time_filled_rounded,
              color: Color(0xFF5A4DDF),
              size: 26,
            ),
          ),
          const SizedBox(width: 14),

          // Status textual details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Status',
                  style: GoogleFonts.inter(
                    color: EditoColors.body.withValues(alpha: 0.65),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Pending Review',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF4C3CC4),
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "We'll notify you once your template is approved.",
                  style: GoogleFonts.inter(
                    color: EditoColors.body.withValues(alpha: 0.72),
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Badge hourglass
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF1ECFF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFDDD3FF)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.hourglass_empty_rounded,
                  color: EditoColors.primary,
                  size: 13,
                ),
                const SizedBox(width: 4),
                Text(
                  'In Review',
                  style: GoogleFonts.inter(
                    color: EditoColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
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
// Template Preview Details Component
// ─────────────────────────────────────────────────────────────
class _TemplatePreviewDetailsCard extends StatelessWidget {
  const _TemplatePreviewDetailsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preview Aspect Ratio Visual Left
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 130,
              height: 100,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1607190074257-dd4b7af0309f?w=800&auto=format&fit=crop&q=80',
                    fit: BoxFit.cover,
                  ),
                  Container(color: Colors.black.withValues(alpha: 0.15)),
                  Center(
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.black.withValues(alpha: 0.6),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Metadata Table Right
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Royal Wedding Moments',
                  style: GoogleFonts.poppins(
                    color: EditoColors.dark,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),

                // Table Rows
                _buildMetadataTableRow(Icons.access_time_rounded, 'Duration', '30 sec'),
                const Divider(height: 8, color: Color(0xFFF1EEFF)),
                _buildMetadataTableRow(Icons.insert_drive_file_outlined, 'Slots', '5'),
                const Divider(height: 8, color: Color(0xFFF1EEFF)),
                _buildMetadataTableRow(Icons.hd_outlined, 'Resolution', '1080p'),
                const Divider(height: 8, color: Color(0xFFF1EEFF)),
                _buildMetadataTableRow(Icons.hexagon_outlined, 'Category', 'Wedding'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataTableRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          color: EditoColors.body.withValues(alpha: 0.65),
          size: 13.5,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            color: EditoColors.body.withValues(alpha: 0.65),
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.inter(
            color: EditoColors.dark,
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Whats Next Flow Component
// ─────────────────────────────────────────────────────────────
class _TemplateSubmittedWhatsNextCard extends StatelessWidget {
  const _TemplateSubmittedWhatsNextCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F8EF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC6F2D6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What's Next?",
            style: GoogleFonts.poppins(
              color: const Color(0xFF199361),
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),

          // Steps list row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildProcessStepItem(
                  Icons.assignment_turned_in_outlined,
                  'Under Review',
                  'Our team will review your template (1-2 days).',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: SizedBox(
                  width: 32,
                  height: 1,
                  child: CustomPaint(painter: _TemplateSubmittedDottedLinePainter()),
                ),
              ),
              Expanded(
                child: _buildProcessStepItem(
                  Icons.notifications_none_rounded,
                  'Get Notified',
                  "You'll receive a notification once it's approved.",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: SizedBox(
                  width: 32,
                  height: 1,
                  child: CustomPaint(painter: _TemplateSubmittedDottedLinePainter()),
                ),
              ),
              Expanded(
                child: _buildProcessStepItem(
                  Icons.rocket_launch_outlined,
                  'Go Live',
                  'Your template will be live and users can start using it.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProcessStepItem(IconData icon, String title, String subtitle) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: Icon(icon, color: const Color(0xFF1BB676), size: 18),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: EditoColors.dark,
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          maxLines: 3,
          style: GoogleFonts.inter(
            color: EditoColors.body.withValues(alpha: 0.72),
            fontSize: 9.5,
            fontWeight: FontWeight.w600,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _TemplateSubmittedDottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 3, dashSpace = 3, startX = 0;
    final paint = Paint()
      ..color = const Color(0xFF1BB676).withValues(alpha: 0.5)
      ..strokeWidth = 1.5;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────
// Gradient Button Class with Left Folder icon
// ─────────────────────────────────────────────────────────────
class _GradientFolderButton extends StatelessWidget {
  const _GradientFolderButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF6D32FF), EditoColors.primary],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x306C63FF),
            offset: Offset(0, 10),
            blurRadius: 20,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: SizedBox(
            height: 56,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Positioned(
                  left: 20,
                  child: Icon(
                    Icons.folder_open_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Positioned(
                  right: 20,
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
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
