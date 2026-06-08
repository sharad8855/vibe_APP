part of '../../main.dart';

class ProSubscriptionManager {
  static final ValueNotifier<bool> isProNotifier = ValueNotifier<bool>(false);

  static bool get isPro => isProNotifier.value;

  static void setPro(bool value) {
    isProNotifier.value = value;
  }
}

class ProSubscriptionSheet extends StatefulWidget {
  const ProSubscriptionSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ProSubscriptionSheet(),
    );
  }

  @override
  State<ProSubscriptionSheet> createState() => _ProSubscriptionSheetState();
}

class _ProSubscriptionSheetState extends State<ProSubscriptionSheet> {
  bool _isAnnual = false;
  String _selectedTier = 'Pro'; // 'Free', 'Pro', 'Studio'

  void _openCheckout() {
    final double price = _isAnnual
        ? (_selectedTier == 'Pro' ? 1599 : 3999)
        : (_selectedTier == 'Pro' ? 199 : 499);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (checkoutContext) => _CheckoutSheet(
        tierName: _selectedTier,
        price: price,
        isAnnual: _isAnnual,
        onSuccess: () {
          ProSubscriptionManager.setPro(true);
          Navigator.of(context).pop(); // Close paywall sheet
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
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

            // Title
            Text(
              'Unlock Edito Pro',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: EditoColors.dark,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Get unlimited access to premium tools, templates & 4K exports',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: EditoColors.body.withValues(alpha: 0.72),
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),

            // Monthly / Annual toggle
            _buildBillingToggle(),
            const SizedBox(height: 24),

            // Tier Cards
            _buildTierCard(
              id: 'Free',
              name: 'Basic Free',
              price: '₹0',
              billing: 'Free forever',
              features: [
                '5 basic templates/month',
                'Standard 1080p exports',
                'Watermark included in videos',
              ],
              color: const Color(0xFF8589A8),
            ),
            const SizedBox(height: 14),

            _buildTierCard(
              id: 'Pro',
              name: 'Edito Pro',
              price: _isAnnual ? '₹1,599' : '₹199',
              billing: _isAnnual ? '/ year (Save 33%)' : '/ month',
              features: [
                'Unlimited template generations',
                'Ultra-crisp 4K video exports',
                'Remove watermarks completely',
                'Early access to trending designs',
              ],
              color: EditoColors.primary,
              isPopular: true,
            ),
            const SizedBox(height: 14),

            _buildTierCard(
              id: 'Studio',
              name: 'Creator Studio',
              price: _isAnnual ? '₹3,999' : '₹499',
              billing: _isAnnual ? '/ year (Save 33%)' : '/ month',
              features: [
                'Everything in Edito Pro',
                'Template publishing revenue share',
                'Custom watermarks & branding',
                'Priority creator support',
              ],
              color: EditoColors.accent,
            ),
            const SizedBox(height: 28),

            // Continue Button
            ElevatedButton(
              onPressed: _selectedTier == 'Free'
                  ? () => Navigator.of(context).pop()
                  : _openCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedTier == 'Free'
                    ? const Color(0xFF8589A8)
                    : (_selectedTier == 'Pro' ? EditoColors.primary : EditoColors.accent),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Text(
                _selectedTier == 'Free' ? 'Continue with Free' : 'Choose ${_selectedTier == 'Pro' ? 'Edito Pro' : 'Creator Studio'}',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingToggle() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3FA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => setState(() => _isAnnual = false),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: !_isAnnual ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: !_isAnnual
                      ? const [
                          BoxShadow(
                            color: Color(0x08000000),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  'Monthly',
                  style: GoogleFonts.inter(
                    color: !_isAnnual ? EditoColors.primary : EditoColors.body,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => setState(() => _isAnnual = true),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _isAnnual ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: _isAnnual
                      ? const [
                          BoxShadow(
                            color: Color(0x08000000),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    Text(
                      'Yearly',
                      style: GoogleFonts.inter(
                        color: _isAnnual ? EditoColors.primary : EditoColors.body,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFECEF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '-33%',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFFF3356),
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTierCard({
    required String id,
    required String name,
    required String price,
    required String billing,
    required List<String> features,
    required Color color,
    bool isPopular = false,
  }) {
    final bool isSelected = _selectedTier == id;

    return GestureDetector(
      onTap: () => setState(() => _selectedTier = id),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE5E6F2),
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : const [
                  BoxShadow(
                    color: Color(0x04000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
        ),
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        color: isSelected ? color : EditoColors.dark,
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (isPopular)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'POPULAR',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      price,
                      style: GoogleFonts.poppins(
                        color: EditoColors.dark,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      billing,
                      style: GoogleFonts.inter(
                        color: EditoColors.body.withValues(alpha: 0.65),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFECEFF8)),
                const SizedBox(height: 12),
                for (final feature in features) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: isSelected ? color : const Color(0xFF8589A8),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: GoogleFonts.inter(
                            color: EditoColors.dark.withValues(alpha: 0.8),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Checkout Bottom Sheet
// ─────────────────────────────────────────────────────────────

class _CheckoutSheet extends StatefulWidget {
  const _CheckoutSheet({
    required this.tierName,
    required this.price,
    required this.isAnnual,
    required this.onSuccess,
  });

  final String tierName;
  final double price;
  final bool isAnnual;
  final VoidCallback onSuccess;

  @override
  State<_CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends State<_CheckoutSheet> {
  String _paymentMethod = 'UPI'; // 'UPI', 'Card', 'Netbanking'
  bool _isProcessing = false;
  bool _isSuccess = false;

  void _startPayment() {
    setState(() {
      _isProcessing = true;
    });

    Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _isSuccess = true;
      });

      Timer(const Duration(milliseconds: 1500), () {
        if (!mounted) return;
        Navigator.of(context).pop(); // Close checkout sheet
        widget.onSuccess(); // Trigger Pro update
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 24),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _isSuccess
            ? _buildSuccessContent()
            : (_isProcessing ? _buildProcessingContent() : _buildFormContent()),
      ),
    );
  }

  Widget _buildFormContent() {
    return Column(
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
          'Complete Checkout',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: EditoColors.dark,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 18),

        // Summary details box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F5FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE1D5FF)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.tierName,
                    style: GoogleFonts.poppins(
                      color: EditoColors.dark,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    widget.isAnnual ? 'Annual Subscription' : 'Monthly Subscription',
                    style: GoogleFonts.inter(
                      color: EditoColors.body.withValues(alpha: 0.75),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                '₹${widget.price.toInt()}',
                style: GoogleFonts.poppins(
                  color: EditoColors.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        Text(
          'Select Payment Method',
          style: GoogleFonts.poppins(
            color: EditoColors.dark,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),

        _buildPaymentOption(
          id: 'UPI',
          title: 'UPI (GPay / PhonePe)',
          icon: Icons.qr_code_scanner_rounded,
        ),
        const SizedBox(height: 10),
        _buildPaymentOption(
          id: 'Card',
          title: 'Credit / Debit Card',
          icon: Icons.credit_card_rounded,
        ),
        const SizedBox(height: 10),
        _buildPaymentOption(
          id: 'Netbanking',
          title: 'Net Banking',
          icon: Icons.account_balance_rounded,
        ),
        const SizedBox(height: 28),

        ElevatedButton(
          onPressed: _startPayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: EditoColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          child: Text(
            'Pay ₹${widget.price.toInt()} Securely',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required String id,
    required String title,
    required IconData icon,
  }) {
    final bool isSelected = _paymentMethod == id;
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? EditoColors.primary : const Color(0xFFE5E6F2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? EditoColors.primary : const Color(0xFF8589A8), size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  color: EditoColors.dark,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? EditoColors.primary : const Color(0xFFC4C2F4),
                  width: 2,
                ),
                color: isSelected ? EditoColors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 12)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 36),
        const SizedBox(
          width: 56,
          height: 56,
          child: CircularProgressIndicator(
            color: EditoColors.primary,
            strokeWidth: 4.5,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Processing Payment...',
          style: GoogleFonts.poppins(
            color: EditoColors.dark,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Please do not press back or close this sheet',
          style: GoogleFonts.inter(
            color: EditoColors.body.withValues(alpha: 0.65),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 36),
      ],
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 36),
        Container(
          width: 76,
          height: 76,
          decoration: const BoxDecoration(
            color: Color(0xFFE8F8EF),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF1BB676),
              size: 48,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Subscription Active!',
          style: GoogleFonts.poppins(
            color: EditoColors.dark,
            fontSize: 21,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Welcome to Edito Pro. Unlock complete access.',
          style: GoogleFonts.inter(
            color: EditoColors.body.withValues(alpha: 0.65),
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 36),
      ],
    );
  }
}
