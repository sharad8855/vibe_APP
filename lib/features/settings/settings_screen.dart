part of '../../main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                  padding: const EdgeInsets.fromLTRB(17, 18, 17, 145),
                  sliver: SliverList.list(
                    children: const [
                      _SettingsHeader(),
                      SizedBox(height: 22),
                      _SettingsSectionTitle('Account'),
                      SizedBox(height: 12),
                      _SettingsGroup(
                        items: [
                          _SettingsItemData(
                            icon: Icons.person_outline_rounded,
                            title: 'Edit Profile',
                            subtitle: 'Update your name, photo and bio',
                          ),
                          _SettingsItemData(
                            icon: Icons.email_outlined,
                            title: 'Email',
                            subtitle: 'rohitcreative@gmail.com',
                          ),
                          _SettingsItemData(
                            icon: Icons.lock_outline_rounded,
                            title: 'Password',
                            subtitle: 'Change your password',
                          ),
                          _SettingsItemData(
                            icon: Icons.phone_outlined,
                            title: 'Phone Number',
                            subtitle: '+91 98765 43210',
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      _SettingsSectionTitle('Preferences'),
                      SizedBox(height: 12),
                      _SettingsGroup(
                        items: [
                          _SettingsItemData(
                            icon: Icons.notifications_none_rounded,
                            title: 'Notifications',
                            subtitle: 'Manage push and in-app notifications',
                            trailing: _SettingsTrailing.toggleOn,
                          ),
                          _SettingsItemData(
                            icon: Icons.palette_outlined,
                            title: 'Appearance',
                            subtitle: 'Choose your app theme',
                            value: 'System',
                            trailing: _SettingsTrailing.valueDropdown,
                          ),
                          _SettingsItemData(
                            icon: Icons.language_rounded,
                            title: 'Language',
                            subtitle: 'Select your preferred language',
                            value: 'English',
                            trailing: _SettingsTrailing.valueDropdown,
                          ),
                          _SettingsItemData(
                            icon: Icons.file_download_outlined,
                            title: 'Download Quality',
                            subtitle: 'Choose video quality for downloads',
                            value: '1080p',
                            trailing: _SettingsTrailing.valueDropdown,
                          ),
                          _SettingsItemData(
                            icon: Icons.smart_display_outlined,
                            title: 'Auto Play',
                            subtitle: 'Auto play videos in browse',
                            trailing: _SettingsTrailing.toggleOn,
                          ),
                          _SettingsItemData(
                            icon: Icons.settings_input_antenna_rounded,
                            title: 'Data Saver',
                            subtitle: 'Reduce data usage on mobile network',
                            trailing: _SettingsTrailing.toggleOff,
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      _SettingsSectionTitle('Creator & Content'),
                      SizedBox(height: 12),
                      _SettingsGroup(
                        items: [
                          _SettingsItemData(
                            icon: Icons.library_books_outlined,
                            title: 'Default Template Settings',
                            subtitle: 'Set default preferences for templates',
                          ),
                          _SettingsItemData(
                            icon: Icons.shield_outlined,
                            title: 'Content Preferences',
                            subtitle: 'Manage content filters and preferences',
                          ),
                          _SettingsItemData(
                            icon: Icons.copyright_rounded,
                            title: 'Watermark',
                            subtitle: 'Manage your watermark on videos',
                            value: 'Edit',
                            trailing: _SettingsTrailing.valueChevron,
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      _SettingsSectionTitle('Storage & Cache'),
                      SizedBox(height: 12),
                      _SettingsGroup(
                        items: [
                          _SettingsItemData(
                            icon: Icons.delete_outline_rounded,
                            title: 'Clear Cache',
                            subtitle: 'Free up storage space',
                            value: '256 MB',
                            trailing: _SettingsTrailing.valueChevron,
                          ),
                          _SettingsItemData(
                            icon: Icons.folder_open_rounded,
                            title: 'Manage Downloads',
                            subtitle: 'View and manage downloaded files',
                            value: '1.2 GB',
                            trailing: _SettingsTrailing.valueChevron,
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      _SettingsSectionTitle('Support & About'),
                      SizedBox(height: 12),
                      _SettingsGroup(
                        items: [
                          _SettingsItemData(
                            icon: Icons.help_outline_rounded,
                            title: 'Help & Support',
                            subtitle: 'Get help and contact support',
                          ),
                          _SettingsItemData(
                            icon: Icons.info_outline_rounded,
                            title: 'About Edito',
                            subtitle: 'App version, terms and policies',
                            value: 'v1.0.0',
                            trailing: _SettingsTrailing.valueChevron,
                          ),
                        ],
                      ),
                      SizedBox(height: 13),
                      _SettingsLogoutRow(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 17,
            right: 17,
            bottom: 26,
            child: _HomeBottomNav(
              selectedIndex: 3,
              onSelected: (index) {
                if (index != 3) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: EditoColors.white.withValues(alpha: 0.70),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: EditoColors.border),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x09000000),
                        offset: Offset(0, 8),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    color: EditoColors.dark,
                    size: 34,
                  ),
                ),
              ),
            ),
          ),
          Text(
            'Settings',
            style: GoogleFonts.poppins(
              color: EditoColors.dark,
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSectionTitle extends StatelessWidget {
  const _SettingsSectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        color: EditoColors.body.withValues(alpha: 0.82),
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.items});

  final List<_SettingsItemData> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: EditoColors.white.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: EditoColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            offset: Offset(0, 8),
            blurRadius: 24,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Column(
          children: [
            for (var i = 0; i < items.length; i++) ...[
              _SettingsRow(data: items[i]),
              if (i != items.length - 1)
                const Divider(height: 1, color: EditoColors.border),
            ],
          ],
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.data});

  final _SettingsItemData data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 74,
      child: Row(
        children: [
          const SizedBox(width: 18),
          Container(
            width: 47,
            height: 47,
            decoration: BoxDecoration(
              color: const Color(0xFFE9DFFF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(data.icon, color: EditoColors.primary, size: 27),
          ),
          const SizedBox(width: 17),
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
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
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
              ],
            ),
          ),
          const SizedBox(width: 10),
          _SettingsTrailingWidget(data: data),
          const SizedBox(width: 18),
        ],
      ),
    );
  }
}

class _SettingsTrailingWidget extends StatelessWidget {
  const _SettingsTrailingWidget({required this.data});

  final _SettingsItemData data;

  @override
  Widget build(BuildContext context) {
    return switch (data.trailing) {
      _SettingsTrailing.toggleOn => const _SettingsSwitch(isOn: true),
      _SettingsTrailing.toggleOff => const _SettingsSwitch(isOn: false),
      _SettingsTrailing.valueDropdown => _SettingsValue(
        value: data.value,
        showDropdown: true,
      ),
      _SettingsTrailing.valueChevron => _SettingsValue(
        value: data.value,
        showChevron: true,
        highlighted: true,
      ),
      _SettingsTrailing.chevron => Icon(
        Icons.chevron_right_rounded,
        color: EditoColors.body.withValues(alpha: 0.70),
        size: 27,
      ),
    };
  }
}

class _SettingsValue extends StatelessWidget {
  const _SettingsValue({
    required this.value,
    this.showDropdown = false,
    this.showChevron = false,
    this.highlighted = false,
  });

  final String value;
  final bool showDropdown;
  final bool showChevron;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            color: highlighted
                ? EditoColors.primary
                : EditoColors.body.withValues(alpha: 0.84),
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (showDropdown || showChevron) const SizedBox(width: 8),
        if (showDropdown)
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: EditoColors.body.withValues(alpha: 0.78),
            size: 22,
          ),
        if (showChevron)
          Icon(
            Icons.chevron_right_rounded,
            color: EditoColors.body.withValues(alpha: 0.70),
            size: 27,
          ),
      ],
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  const _SettingsSwitch({required this.isOn});

  final bool isOn;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 30,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isOn ? EditoColors.primary : const Color(0xFFE1E0F0),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Align(
        alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x18000000),
                offset: Offset(0, 2),
                blurRadius: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsLogoutRow extends StatelessWidget {
  const _SettingsLogoutRow();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => showEditoLogoutDialog(context),
        borderRadius: BorderRadius.circular(13),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF4F5),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: const Color(0xFFFFC6CC)),
          ),
          child: Row(
            children: [
              const SizedBox(width: 18),
              Container(
                width: 47,
                height: 47,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE1E5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFFF3356),
                  size: 27,
                ),
              ),
              const SizedBox(width: 17),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Logout',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFFF3356),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Log out from your account',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFFF3356),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFFF3356),
                size: 27,
              ),
              const SizedBox(width: 18),
            ],
          ),
        ),
      ),
    );
  }
}

enum _SettingsTrailing {
  chevron,
  toggleOn,
  toggleOff,
  valueDropdown,
  valueChevron,
}

class _SettingsItemData {
  const _SettingsItemData({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.value = '',
    this.trailing = _SettingsTrailing.chevron,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final _SettingsTrailing trailing;
}
