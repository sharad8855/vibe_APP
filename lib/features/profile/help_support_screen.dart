part of '../../main.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _faqs = [
    {
      'question': 'How do I withdraw my earnings?',
      'answer': 'You can withdraw your available balance at any time on the Earnings screen. Payouts are sent directly to your registered bank account and usually clear within 2-3 business days.',
    },
    {
      'question': 'What is the Creator Fund rate?',
      'answer': 'The Creator Fund rewards template creators. You earn a flat rate of ₹2.00 for every video exported by users using your published templates.',
    },
    {
      'question': 'How do I publish a template?',
      'answer': 'Go to Profile > Create Template, select your video, define slot properties, review detections, and submit. Our curation team will review and publish it within 24 hours.',
    },
    {
      'question': 'How do I upgrade to Edito Pro?',
      'answer': 'Tap the "Upgrade Now" button on the Pro Banner in your Profile screen. Edito Pro unlocks premium assets, higher export quality (4K), and removing watermark tools.',
    },
    {
      'question': 'Is my bank information secure?',
      'answer': 'Yes! All bank details and transaction requests are encrypted end-to-end and managed through our secure payment gateway partners.',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openChatSupport() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return const _SupportChatDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredFaqs = _faqs.where((faq) {
      final q = faq['question']!.toLowerCase();
      final a = faq['answer']!.toLowerCase();
      final s = _searchQuery.toLowerCase();
      return q.contains(s) || a.contains(s);
    }).toList();

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
                                'Help & Support',
                                style: GoogleFonts.poppins(
                                  color: EditoColors.dark,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  height: 1.15,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "We're here to help you build better",
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
                      const SizedBox(height: 25),

                      // Search bar
                      _buildSearchBar(),
                      const SizedBox(height: 25),

                      // Quick Contact Grid
                      _buildContactGrid(),
                      const SizedBox(height: 30),

                      // FAQs Header
                      Text(
                        'Frequently Asked Questions',
                        style: GoogleFonts.poppins(
                          color: EditoColors.dark,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // FAQ Accordion Card
                      if (filteredFaqs.isEmpty)
                        _buildEmptyFaqs()
                      else
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: EditoColors.border),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Column(
                              children: [
                                for (var i = 0; i < filteredFaqs.length; i++) ...[
                                  ExpansionTile(
                                    shape: const Border(),
                                    collapsedShape: const Border(),
                                    backgroundColor: Colors.transparent,
                                    collapsedBackgroundColor: Colors.transparent,
                                    title: Text(
                                      filteredFaqs[i]['question']!,
                                      style: GoogleFonts.poppins(
                                        color: EditoColors.dark,
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                        child: Text(
                                          filteredFaqs[i]['answer']!,
                                          style: GoogleFonts.inter(
                                            color: EditoColors.body.withValues(alpha: 0.76),
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w600,
                                            height: 1.45,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (i != filteredFaqs.length - 1)
                                    const Divider(height: 1, color: EditoColors.border),
                                ],
                              ],
                            ),
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

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (val) => setState(() => _searchQuery = val),
      style: GoogleFonts.inter(
        color: EditoColors.dark,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Search FAQs or articles...',
        hintStyle: GoogleFonts.inter(
          color: EditoColors.body.withValues(alpha: 0.5),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(Icons.search_rounded, color: EditoColors.body.withValues(alpha: 0.5), size: 20),
        prefixIconConstraints: const BoxConstraints(minWidth: 44),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear_rounded, size: 18),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.75),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE7E1F7)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE7E1F7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: EditoColors.primary),
        ),
      ),
    );
  }

  Widget _buildContactGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 1.35,
      children: [
        _buildContactCard(
          title: 'Live Chat',
          subtitle: 'Chat with support agent',
          icon: Icons.chat_bubble_outline_rounded,
          color: const Color(0xFF22B37D),
          tint: const Color(0xFFE8F8EF),
          onTap: _openChatSupport,
        ),
        _buildContactCard(
          title: 'Email Us',
          subtitle: 'Get help via email support',
          icon: Icons.mail_outline_rounded,
          color: EditoColors.primary,
          tint: const Color(0xFFF1ECFF),
          onTap: () {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Email client simulation triggered!',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
        _buildContactCard(
          title: 'Send Feedback',
          subtitle: 'Tell us how we can improve',
          icon: Icons.star_border_rounded,
          color: const Color(0xFFF7AE14),
          tint: const Color(0xFFFFF6DF),
          onTap: () {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Feedback submission dialog opened!',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
        _buildContactCard(
          title: 'Guides & Tuts',
          subtitle: 'Learn template builder tips',
          icon: Icons.play_lesson_outlined,
          color: const Color(0xFF2015F0),
          tint: const Color(0xFFEEEDFF),
          onTap: () {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Guides portal simulation triggered!',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildContactCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color tint,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: EditoColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x03000000),
              offset: Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: tint,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: EditoColors.dark,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: EditoColors.body.withValues(alpha: 0.65),
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyFaqs() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EditoColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            color: Color(0xFFE5E2F5),
            size: 40,
          ),
          const SizedBox(height: 10),
          Text(
            'No matching FAQs found',
            style: GoogleFonts.poppins(
              color: EditoColors.dark,
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try searching for other keywords or email us directly.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: EditoColors.body.withValues(alpha: 0.6),
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Simulated Support Chat Dialog
// ─────────────────────────────────────────────────────────────

class _SupportChatDialog extends StatefulWidget {
  const _SupportChatDialog();

  @override
  State<_SupportChatDialog> createState() => _SupportChatDialogState();
}

class _SupportChatDialogState extends State<_SupportChatDialog> {
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hello! Thanks for reaching out. How can I help you today?',
      'isMe': false,
      'time': '12:01 PM',
    }
  ];

  final _chatController = TextEditingController();

  void _sendMessage() {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'text': text,
        'isMe': true,
        'time': '12:02 PM',
      });
    });
    _chatController.clear();

    // Simulated reply delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        _messages.add({
          'text': "Thanks for your message! Our creator fund specialists will review this and respond shortly.",
          'isMe': false,
          'time': '12:02 PM',
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          width: double.infinity,
          height: 450,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Chat Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF22B37D), Color(0xFF1B8E62)],
                  ),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.support_agent_rounded, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Support Agent',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Online • Creator Helpdesk',
                            style: GoogleFonts.inter(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // Chat Messages list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    final isMe = msg['isMe'] as bool;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isMe ? const Color(0xFFEEF0FF) : const Color(0xFFF1F1F7),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(14),
                            topRight: const Radius.circular(14),
                            bottomLeft: Radius.circular(isMe ? 14 : 0),
                            bottomRight: Radius.circular(isMe ? 0 : 14),
                          ),
                        ),
                        child: Text(
                          msg['text'] as String,
                          style: GoogleFonts.inter(
                            color: isMe ? const Color(0xFF2015F0) : EditoColors.dark,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Chat Input Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0xFFECEBFF))),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _chatController,
                        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          hintStyle: GoogleFonts.inter(
                            color: EditoColors.body.withValues(alpha: 0.5),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send_rounded, color: Color(0xFF22B37D), size: 20),
                      onPressed: _sendMessage,
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
