part of '../../main.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _ProfileHeader(),
        const SizedBox(height: 22),
        const _ProfileSummaryCard(),
        const SizedBox(height: 16),
        const _ProfileProBanner(),
        const SizedBox(height: 28),
        const _ProfileSectionTitle('Creator Tools'),
        const SizedBox(height: 10),
        _ProfileMenuGroup(
          items: [
            _ProfileMenuData(
              icon: Icons.add_rounded,
              title: 'Create Template',
              subtitle: 'Edit a video and publish it as a template',
              color: EditoColors.primary,
              tint: const Color(0xFFE6DBFF),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const CreateTemplateScreen(),
                  ),
                );
              },
            ),
            const _ProfileMenuData(
              icon: Icons.folder_rounded,
              title: 'My Templates',
              subtitle: 'View and manage your published templates',
              color: EditoColors.primary,
              tint: Color(0xFFDCD3FF),
            ),
            const _ProfileMenuData(
              icon: Icons.bar_chart_rounded,
              title: 'Earnings',
              subtitle: 'Track your earnings and withdrawals',
              color: Color(0xFF22B37D),
              tint: Color(0xFFA9EBCF),
            ),
            const _ProfileMenuData(
              icon: Icons.shopping_bag_outlined,
              title: 'Purchases',
              subtitle: 'View your purchased templates',
              color: EditoColors.accent,
              tint: Color(0xFFFFD8E1),
            ),
            const _ProfileMenuData(
              icon: Icons.bookmark_rounded,
              title: 'Saved Templates',
              subtitle: 'Templates you saved for later',
              color: Color(0xFF2015F0),
              tint: Color(0xFFD8E0FF),
            ),
          ],
        ),
        const SizedBox(height: 28),
        const _ProfileSectionTitle('Account'),
        const SizedBox(height: 10),
        _ProfileMenuGroup(
          items: [
            const _ProfileMenuData(
              icon: Icons.person_outline_rounded,
              title: 'Account Settings',
              subtitle: 'Manage your personal information',
              color: Color(0xFF2015F0),
              tint: Color(0xFFD9E1FF),
            ),
            const _ProfileMenuData(
              icon: Icons.shield_rounded,
              title: 'Privacy & Security',
              subtitle: 'Manage your privacy and security',
              color: EditoColors.primary,
              tint: Color(0xFFE1D4FF),
            ),
            const _ProfileMenuData(
              icon: Icons.question_mark_rounded,
              title: 'Help & Support',
              subtitle: 'Get help and contact support',
              color: Color(0xFFF7AE14),
              tint: Color(0xFFFFE6A6),
            ),
            _ProfileMenuData(
              icon: Icons.logout_rounded,
              title: 'Logout',
              subtitle: 'Log out from your account',
              color: const Color(0xFF8589A8),
              tint: const Color(0xFFE3E5F1),
              onTap: () => showEditoLogoutDialog(context),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Page header
// ─────────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile',
                style: GoogleFonts.poppins(
                  color: EditoColors.dark,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage your account, templates and more',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: EditoColors.body.withValues(alpha: 0.72),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _ProfileActionButton(
          icon: Icons.notifications_none_rounded,
          showDot: true,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const NotificationsScreen(),
              ),
            );
          },
        ),
        const SizedBox(width: 10),
        _ProfileActionButton(
          icon: Icons.settings_outlined,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
            );
          },
        ),
      ],
    );
  }
}

class _ProfileActionButton extends StatelessWidget {
  const _ProfileActionButton({
    required this.icon,
    this.showDot = false,
    this.onTap,
  });

  final IconData icon;
  final bool showDot;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: EditoColors.white.withValues(alpha: 0.70),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: EditoColors.border),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                offset: Offset(0, 6),
                blurRadius: 16,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, color: EditoColors.dark, size: 24),
              if (showDot)
                const Positioned(
                  right: 10,
                  top: 9,
                  child: CircleAvatar(
                    radius: 4,
                    backgroundColor: EditoColors.accent,
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
// Summary card  —  avatar | name / username / badge | Edit Profile
//                  ─────────── stats row ───────────
// ─────────────────────────────────────────────────────────────

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: EditoColors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7E1F7)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D6C63FF),
            offset: Offset(0, 9),
            blurRadius: 28,
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Avatar + info + button
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const _ProfileAvatar(),
              const SizedBox(width: 14),
              // Name / handle / badge
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Rohit Creative',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: EditoColors.dark,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.verified_rounded,
                          color: EditoColors.primary,
                          size: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '@rohitcreative',
                      style: GoogleFonts.inter(
                        color: EditoColors.body.withValues(alpha: 0.68),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Creator badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECDDFF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Creator',
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
              const SizedBox(width: 10),
              // Edit Profile button
              const _EditProfileButton(),
            ],
          ),
          const SizedBox(height: 20),
          // ── Stats divider row
          const _ProfileStatsRow(),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 84,
      height: 84,
      child: Stack(
        children: [
          Container(
            width: 74,
            height: 74,
            margin: const EdgeInsets.only(left: 2, top: 2),
            decoration: const BoxDecoration(
              color: Color(0xFFD5D9E0),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: CustomPaint(
                painter: _ProfileAvatarPainter(),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          // Camera badge
          Positioned(
            right: 0,
            bottom: 4,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: EditoColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
              ),
              child: const Icon(
                Icons.photo_camera_rounded,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFCED5DD), Color(0xFFF3F4F7)],
        ).createShader(Offset.zero & size),
    );
    canvas.drawCircle(
      Offset(center.dx, size.height * 0.37),
      17,
      Paint()..color = const Color(0xFFD19B6D),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, size.height * 0.25),
        width: 40,
        height: 22,
      ),
      Paint()..color = const Color(0xFF171722),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, size.height * 0.85),
          width: 76,
          height: 58,
        ),
        const Radius.circular(22),
      ),
      Paint()..color = const Color(0xFF15151F),
    );
    final smile = Path()
      ..moveTo(center.dx - 9, size.height * 0.45)
      ..quadraticBezierTo(
        center.dx,
        size.height * 0.52,
        center.dx + 9,
        size.height * 0.45,
      );
    canvas.drawPath(
      smile,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _EditProfileButton extends StatelessWidget {
  const _EditProfileButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: EditoColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: EditoColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            offset: Offset(0, 5),
            blurRadius: 14,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.edit_outlined, color: EditoColors.primary, size: 16),
          const SizedBox(width: 6),
          Text(
            'Edit Profile',
            style: GoogleFonts.poppins(
              color: EditoColors.dark,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStatsRow extends StatelessWidget {
  const _ProfileStatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _ProfileStat(value: '32', label: 'Templates')),
        _ProfileStatDivider(),
        Expanded(child: _ProfileStat(value: '68', label: 'Videos')),
        _ProfileStatDivider(),
        Expanded(child: _ProfileStat(value: '2.4K', label: 'Followers')),
        _ProfileStatDivider(),
        Expanded(child: _ProfileStat(value: '356', label: 'Following')),
      ],
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            color: EditoColors.dark,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            color: EditoColors.body.withValues(alpha: 0.72),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ProfileStatDivider extends StatelessWidget {
  const _ProfileStatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 34, color: EditoColors.border);
  }
}

// ─────────────────────────────────────────────────────────────
// Pro upgrade banner
// ─────────────────────────────────────────────────────────────

class _ProfileProBanner extends StatelessWidget {
  const _ProfileProBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF060944), Color(0xFF10115C)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2B060944),
            offset: Offset(0, 12),
            blurRadius: 28,
          ),
        ],
      ),
      child: Row(
        children: [
          // Crown icon
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF5B3DDB), Color(0xFF8D39FF)],
              ),
            ),
            child: const Icon(
              Icons.workspace_premium_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          // Text column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edito Pro',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Unlock premium templates, exclusive assets and more.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Upgrade button — intrinsic width, no fixed pixel
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: EditoColors.primary,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Upgrade Now',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white,
                  size: 20,
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
// Section title
// ─────────────────────────────────────────────────────────────

class _ProfileSectionTitle extends StatelessWidget {
  const _ProfileSectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        color: EditoColors.body.withValues(alpha: 0.78),
        fontSize: 15,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Menu group card
// ─────────────────────────────────────────────────────────────

class _ProfileMenuGroup extends StatelessWidget {
  const _ProfileMenuGroup({required this.items});

  final List<_ProfileMenuData> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: EditoColors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: EditoColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x07000000),
            offset: Offset(0, 8),
            blurRadius: 22,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          children: [
            for (var i = 0; i < items.length; i++) ...[
              _ProfileMenuRow(data: items[i]),
              if (i != items.length - 1)
                const Divider(height: 1, color: EditoColors.border),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuRow extends StatelessWidget {
  const _ProfileMenuRow({required this.data});

  final _ProfileMenuData data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: data.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              // Icon tile
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: data.tint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(data.icon, color: data.color, size: 24),
              ),
              const SizedBox(width: 14),
              // Title + subtitle
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
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      data.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: EditoColors.body.withValues(alpha: 0.72),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: EditoColors.body.withValues(alpha: 0.55),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────

class _ProfileMenuData {
  const _ProfileMenuData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.tint,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color tint;
  final VoidCallback? onTap;
}

// ─────────────────────────────────────────────────────────────
// Premium Logout Confirmation Dialog
// ─────────────────────────────────────────────────────────────

void showEditoLogoutDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE1E5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFFF3356),
                  size: 30,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Logout',
                style: GoogleFonts.poppins(
                  color: EditoColors.dark,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Are you sure you want to log out of your account?',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: EditoColors.body.withValues(alpha: 0.72),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: EditoColors.border),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(
                          color: EditoColors.dark,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF3356),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // pop dialog
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute<void>(
                            builder: (_) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Text(
                        'Logout',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
