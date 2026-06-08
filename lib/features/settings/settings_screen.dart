part of '../../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _autoplayEnabled = true;
  bool _dataSaverEnabled = false;
  String _downloadQuality = '1080p';
  String _cacheSize = '256 MB';

  void _showQualitySelector() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(sheetContext).padding.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E6F2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Select Download Quality',
                style: GoogleFonts.poppins(
                  color: EditoColors.dark,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              _buildQualityOption('1080p', 'Full HD resolution - standard size'),
              const SizedBox(height: 8),
              _buildQualityOption('2K', 'Quad HD resolution - higher clarity'),
              const SizedBox(height: 8),
              _buildQualityOption('4K', 'Ultra HD resolution - maximum detail (Pro)'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQualityOption(String quality, String desc) {
    final bool isSelected = _downloadQuality == quality;
    return GestureDetector(
      onTap: () {
        setState(() {
          _downloadQuality = quality;
        });
        Navigator.of(context).pop();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF1ECFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? EditoColors.primary : const Color(0xFFE5E6F2),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quality,
                    style: GoogleFonts.poppins(
                      color: EditoColors.dark,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    desc,
                    style: GoogleFonts.inter(
                      color: EditoColors.body.withValues(alpha: 0.72),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: EditoColors.primary, size: 22),
          ],
        ),
      ),
    );
  }

  void _clearCache() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return _ClearCacheProgressDialog(
          onCompleted: () {
            setState(() {
              _cacheSize = '0 MB';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Cache cleared successfully!',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
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
                  padding: const EdgeInsets.fromLTRB(17, 18, 17, 145),
                  sliver: SliverList.list(
                    children: [
                      const _SettingsHeader(),
                      const SizedBox(height: 22),
                      const _SettingsSectionTitle('Account'),
                      const SizedBox(height: 12),
                      _SettingsGroup(
                        items: [
                          _SettingsItemData(
                            icon: Icons.person_outline_rounded,
                            title: 'Edit Profile',
                            subtitle: 'Update your name, photo and bio',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const AccountSettingsScreen(),
                                ),
                              );
                            },
                          ),
                          const _SettingsItemData(
                            icon: Icons.email_outlined,
                            title: 'Email',
                            subtitle: 'rohitcreative@gmail.com',
                          ),
                          const _SettingsItemData(
                            icon: Icons.lock_outline_rounded,
                            title: 'Password',
                            subtitle: 'Change your password',
                          ),
                          const _SettingsItemData(
                            icon: Icons.phone_outlined,
                            title: 'Phone Number',
                            subtitle: '+91 98765 43210',
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      const _SettingsSectionTitle('Preferences'),
                      const SizedBox(height: 12),
                      _SettingsGroup(
                        items: [
                          _SettingsItemData(
                            icon: Icons.notifications_none_rounded,
                            title: 'Notifications',
                            subtitle: 'Manage push and in-app notifications',
                            trailing: _notificationsEnabled
                                ? _SettingsTrailing.toggleOn
                                : _SettingsTrailing.toggleOff,
                            onTap: () {
                              setState(() {
                                _notificationsEnabled = !_notificationsEnabled;
                              });
                            },
                          ),
                          const _SettingsItemData(
                            icon: Icons.palette_outlined,
                            title: 'Appearance',
                            subtitle: 'Choose your app theme',
                            value: 'System',
                            trailing: _SettingsTrailing.valueDropdown,
                          ),
                          const _SettingsItemData(
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
                            value: _downloadQuality,
                            trailing: _SettingsTrailing.valueDropdown,
                            onTap: _showQualitySelector,
                          ),
                          _SettingsItemData(
                            icon: Icons.smart_display_outlined,
                            title: 'Auto Play',
                            subtitle: 'Auto play videos in browse',
                            trailing: _autoplayEnabled
                                ? _SettingsTrailing.toggleOn
                                : _SettingsTrailing.toggleOff,
                            onTap: () {
                              setState(() {
                                _autoplayEnabled = !_autoplayEnabled;
                              });
                            },
                          ),
                          _SettingsItemData(
                            icon: Icons.settings_input_antenna_rounded,
                            title: 'Data Saver',
                            subtitle: 'Reduce data usage on mobile network',
                            trailing: _dataSaverEnabled
                                ? _SettingsTrailing.toggleOn
                                : _SettingsTrailing.toggleOff,
                            onTap: () {
                              setState(() {
                                _dataSaverEnabled = !_dataSaverEnabled;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      const _SettingsSectionTitle('Creator & Content'),
                      const SizedBox(height: 12),
                      const _SettingsGroup(
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
                      const SizedBox(height: 25),
                      const _SettingsSectionTitle('Storage & Cache'),
                      const SizedBox(height: 12),
                      _SettingsGroup(
                        items: [
                          _SettingsItemData(
                            icon: Icons.delete_outline_rounded,
                            title: 'Clear Cache',
                            subtitle: 'Free up storage space',
                            value: _cacheSize,
                            trailing: _SettingsTrailing.valueChevron,
                            onTap: _clearCache,
                          ),
                          const _SettingsItemData(
                            icon: Icons.folder_open_rounded,
                            title: 'Manage Downloads',
                            subtitle: 'View and manage downloaded files',
                            value: '1.2 GB',
                            trailing: _SettingsTrailing.valueChevron,
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      const _SettingsSectionTitle('Support & About'),
                      const SizedBox(height: 12),
                      _SettingsGroup(
                        items: [
                          _SettingsItemData(
                            icon: Icons.help_outline_rounded,
                            title: 'Help & Support',
                            subtitle: 'Get help and contact support',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const HelpSupportScreen(),
                                ),
                              );
                            },
                          ),
                          const _SettingsItemData(
                            icon: Icons.info_outline_rounded,
                            title: 'About Edito',
                            subtitle: 'App version, terms and policies',
                            value: 'v1.0.0',
                            trailing: _SettingsTrailing.valueChevron,
                          ),
                        ],
                      ),
                      const SizedBox(height: 13),
                      const _SettingsLogoutRow(),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: data.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
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
                  mainAxisSize: MainAxisSize.min,
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
        ),
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
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final _SettingsTrailing trailing;
  final VoidCallback? onTap;
}

class _ClearCacheProgressDialog extends StatefulWidget {
  const _ClearCacheProgressDialog({required this.onCompleted});

  final VoidCallback onCompleted;

  @override
  State<_ClearCacheProgressDialog> createState() => _ClearCacheProgressDialogState();
}

class _ClearCacheProgressDialogState extends State<_ClearCacheProgressDialog> {
  double _progress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (!mounted) return;
      setState(() {
        _progress += 0.04;
        if (_progress >= 1.0) {
          _progress = 1.0;
          _timer?.cancel();
          Navigator.of(context).pop(); // Close dialog
          widget.onCompleted();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Clearing Cache',
        style: GoogleFonts.poppins(
          color: EditoColors.dark,
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: _progress,
            color: EditoColors.primary,
            backgroundColor: const Color(0xFFF1F3FA),
          ),
          const SizedBox(height: 14),
          Text(
            'Removing temporary files to free up space...',
            style: GoogleFonts.inter(
              color: EditoColors.body,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
