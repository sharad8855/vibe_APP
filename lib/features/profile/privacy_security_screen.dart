part of '../../main.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  bool _privateProfile = false;
  bool _showEarnings = true;
  bool _twoFactorAuth = false;

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
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
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
                  sliver: SliverList.list(
                    children: [
                      // Header
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
                                'Privacy & Security',
                                style: GoogleFonts.poppins(
                                  color: EditoColors.dark,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  height: 1.15,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Manage your data and account safety',
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
                      const SizedBox(height: 30),

                      // Privacy Settings Section
                      _buildSectionHeader('Privacy Settings'),
                      const SizedBox(height: 10),
                      Container(
                        decoration: _buildCardDecoration(),
                        child: Column(
                          children: [
                            _buildSwitchTile(
                              title: 'Private Profile',
                              subtitle: 'Only approved users can view your templates',
                              value: _privateProfile,
                              onChanged: (val) {
                                setState(() => _privateProfile = val);
                                _showFeedback(val ? 'Profile is now private.' : 'Profile is now public.');
                              },
                            ),
                            const Divider(height: 1, color: EditoColors.border),
                            _buildSwitchTile(
                              title: 'Public Earnings',
                              subtitle: 'Show total earnings on your public profile',
                              value: _showEarnings,
                              onChanged: (val) {
                                setState(() => _showEarnings = val);
                                _showFeedback(val ? 'Earnings are now public.' : 'Earnings are now hidden.');
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Security Settings Section
                      _buildSectionHeader('Security Settings'),
                      const SizedBox(height: 10),
                      Container(
                        decoration: _buildCardDecoration(),
                        child: Column(
                          children: [
                            _buildSwitchTile(
                              title: 'Two-Factor Authentication',
                              subtitle: 'Secure your account with a secondary code',
                              value: _twoFactorAuth,
                              onChanged: (val) {
                                setState(() => _twoFactorAuth = val);
                                _showFeedback(val ? '2FA enabled.' : '2FA disabled.');
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Active Sessions Section
                      _buildSectionHeader('Active Login Sessions'),
                      const SizedBox(height: 10),
                      Container(
                        decoration: _buildCardDecoration(),
                        child: Column(
                          children: [
                            _buildSessionTile(
                              device: 'iPhone 15 Pro Max',
                              location: 'Mumbai, India • Active Now',
                              icon: Icons.phone_android_rounded,
                              isCurrent: true,
                            ),
                            const Divider(height: 1, color: EditoColors.border),
                            _buildSessionTile(
                              device: 'Windows PC • Chrome',
                              location: 'Delhi, India • 2 hours ago',
                              icon: Icons.computer_rounded,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Data Management Section
                      _buildSectionHeader('Data Management'),
                      const SizedBox(height: 10),
                      Container(
                        decoration: _buildCardDecoration(),
                        child: Column(
                          children: [
                            _buildActionTile(
                              title: 'Clear Search History',
                              subtitle: 'Delete all past queries and searches',
                              icon: Icons.history_rounded,
                              onTap: () => _showFeedback('Search history cleared!'),
                            ),
                            const Divider(height: 1, color: EditoColors.border),
                            _buildActionTile(
                              title: 'Request Account Data',
                              subtitle: 'Download a full archive of your templates and details',
                              icon: Icons.downloading_rounded,
                              onTap: () => _showFeedback('Account archive request submitted!'),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        color: EditoColors.dark,
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: 0.85),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: EditoColors.border),
      boxShadow: const [
        BoxShadow(
          color: Color(0x04000000),
          offset: Offset(0, 6),
          blurRadius: 16,
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile.adaptive(
      activeColor: EditoColors.primary,
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: EditoColors.dark,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          color: EditoColors.body.withValues(alpha: 0.72),
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
        ),
      ),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildSessionTile({
    required String device,
    required String location,
    required IconData icon,
    bool isCurrent = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF0EDFF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: EditoColors.primary, size: 20),
      ),
      title: Row(
        children: [
          Text(
            device,
            style: GoogleFonts.poppins(
              color: EditoColors.dark,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (isCurrent) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F8EF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'CURRENT',
                style: GoogleFonts.inter(
                  color: const Color(0xFF168F54),
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ],
      ),
      subtitle: Text(
        location,
        style: GoogleFonts.inter(
          color: EditoColors.body.withValues(alpha: 0.7),
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: isCurrent
          ? null
          : IconButton(
              icon: const Icon(Icons.logout_rounded, color: EditoColors.muted, size: 18),
              onPressed: () => _showFeedback('Session terminated.'),
            ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFEEF0FF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF2015F0), size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: EditoColors.dark,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          color: EditoColors.body.withValues(alpha: 0.7),
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: EditoColors.muted),
      onTap: onTap,
    );
  }
}
