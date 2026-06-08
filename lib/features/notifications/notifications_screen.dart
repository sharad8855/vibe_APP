part of '../../main.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const _newItems = [
    _NotificationData(
      icon: Icons.check_rounded,
      title: 'Template Approved',
      message:
          'Great news! Your template "Travel Vlog Intro" has been approved and is now live.',
      time: '2m ago',
      color: Color(0xFF35C987),
      tint: Color(0xFFC9F6E1),
      unread: true,
    ),
    _NotificationData(
      icon: Icons.shopping_cart_rounded,
      title: 'New Purchase',
      message:
          'Someone purchased your template "Cinematic Memories". You earned \u20B9199.',
      time: '1h ago',
      color: EditoColors.primary,
      tint: Color(0xFFE6DCFF),
      unread: true,
    ),
    _NotificationData(
      icon: Icons.account_balance_wallet_rounded,
      title: 'Earnings Update',
      message: 'Your earnings of \u20B9598 have been added to your wallet.',
      time: '2h ago',
      color: Color(0xFFF39C12),
      tint: Color(0xFFFFEAC4),
      unread: true,
    ),
    _NotificationData(
      icon: Icons.favorite_rounded,
      title: 'New Like',
      message: 'Your template "Royal Wedding Moments" got a new like.',
      time: '3h ago',
      color: Color(0xFFF13D92),
      tint: Color(0xFFFFE0F0),
      unread: true,
    ),
    _NotificationData(
      icon: Icons.chat_bubble_rounded,
      title: 'New Comment',
      message: 'A user commented on your template "Urban Style Intro".',
      time: '4h ago',
      color: Color(0xFF229AE8),
      tint: Color(0xFFD9F0FF),
      unread: true,
    ),
  ];

  static const _earlierItems = [
    _NotificationData(
      icon: Icons.cloud_upload_rounded,
      title: 'Template Published',
      message: 'Your template "Birthday Celebration" is now published.',
      time: 'Yesterday, 11:30 PM',
      color: EditoColors.primary,
      tint: Color(0xFFE6DCFF),
    ),
    _NotificationData(
      icon: Icons.file_download_done_rounded,
      title: 'Video Exported',
      message: 'Your video "Goa Trip 2024" has been exported successfully.',
      time: 'Yesterday, 9:15 PM',
      color: Color(0xFF28B676),
      tint: Color(0xFFDDF7EA),
    ),
    _NotificationData(
      icon: Icons.percent_rounded,
      title: 'Special Offer',
      message: 'Get 30% off on Edito Pro. Offer valid for a limited time!',
      time: '2 days ago',
      color: Color(0xFFF04E3E),
      tint: Color(0xFFFFDEDC),
    ),
    _NotificationData(
      icon: Icons.star_rounded,
      title: 'Milestone Achieved',
      message: 'Congratulations! Your template "Summer Vibes" reached 1K uses.',
      time: '3 days ago',
      color: Color(0xFFF4B217),
      tint: Color(0xFFFFEDC8),
    ),
    _NotificationData(
      icon: Icons.notifications_none_rounded,
      title: 'System Update',
      message: "We've updated our terms and conditions. Please review them.",
      time: '5 days ago',
      color: EditoColors.primary,
      tint: Color(0xFFE6DCFF),
    ),
    _NotificationData(
      icon: Icons.card_giftcard_rounded,
      title: 'Welcome to Edito',
      message:
          'Thanks for joining Edito! Start creating and sharing amazing videos.',
      time: '1 week ago',
      color: Color(0xFF1CBCC8),
      tint: Color(0xFFD8F8FB),
    ),
  ];

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
                      _NotificationsHeader(),
                      SizedBox(height: 39),
                      _NotificationFilters(),
                      SizedBox(height: 30),
                      _NotificationsSectionHeader(title: 'New'),
                      SizedBox(height: 15),
                      _NotificationsGroup(items: _newItems),
                      SizedBox(height: 31),
                      _NotificationsSectionHeader(
                        title: 'Earlier',
                        trailing: 'Mark all as read',
                      ),
                      SizedBox(height: 15),
                      _NotificationsGroup(items: _earlierItems),
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

class _NotificationsHeader extends StatelessWidget {
  const _NotificationsHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _NotificationHeaderButton(
              icon: Icons.chevron_left_rounded,
              onTap: () => Navigator.of(context).pop(),
              iconSize: 34,
            ),
          ),
          Text(
            'Notifications',
            style: GoogleFonts.poppins(
              color: EditoColors.dark,
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _NotificationHeaderButton(
              icon: Icons.settings_outlined,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const SettingsScreen(),
                  ),
                );
              },
              iconSize: 29,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationHeaderButton extends StatelessWidget {
  const _NotificationHeaderButton({
    required this.icon,
    required this.onTap,
    required this.iconSize,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double iconSize;

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
            boxShadow: const [
              BoxShadow(
                color: Color(0x09000000),
                offset: Offset(0, 8),
                blurRadius: 20,
              ),
            ],
          ),
          child: Icon(icon, color: EditoColors.dark, size: iconSize),
        ),
      ),
    );
  }
}

class _NotificationFilters extends StatelessWidget {
  const _NotificationFilters();

  static const filters = [
    'All',
    'Updates',
    'Earnings',
    'Likes & Comments',
    'System',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (var i = 0; i < filters.length; i++) ...[
            _NotificationFilterChip(label: filters[i], selected: i == 0),
            if (i != filters.length - 1) const SizedBox(width: 12),
          ],
        ],
      ),
    );
  }
}

class _NotificationFilterChip extends StatelessWidget {
  const _NotificationFilterChip({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: EdgeInsets.symmetric(horizontal: selected ? 37 : 27),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? EditoColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: selected ? EditoColors.primary : EditoColors.border,
          width: 1.3,
        ),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.inter(
          color: selected
              ? Colors.white
              : EditoColors.body.withValues(alpha: 0.86),
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _NotificationsSectionHeader extends StatelessWidget {
  const _NotificationsSectionHeader({required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.poppins(
              color: EditoColors.dark,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: GoogleFonts.inter(
              color: EditoColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
      ],
    );
  }
}

class _NotificationsGroup extends StatelessWidget {
  const _NotificationsGroup({required this.items});

  final List<_NotificationData> items;

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
              _NotificationRow(data: items[i]),
              if (i != items.length - 1)
                const Divider(height: 1, color: EditoColors.border),
            ],
          ],
        ),
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({required this.data});

  final _NotificationData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 22),
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: data.tint,
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, color: data.color, size: 31),
          ),
          const SizedBox(width: 21),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: EditoColors.dark,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.message,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: EditoColors.body.withValues(alpha: 0.82),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(right: 23),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.time,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: EditoColors.body.withValues(alpha: 0.78),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (data.unread) ...[
                  const SizedBox(height: 12),
                  const CircleAvatar(
                    radius: 6,
                    backgroundColor: EditoColors.primary,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationData {
  const _NotificationData({
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
    required this.color,
    required this.tint,
    this.unread = false,
  });

  final IconData icon;
  final String title;
  final String message;
  final String time;
  final Color color;
  final Color tint;
  final bool unread;
}
