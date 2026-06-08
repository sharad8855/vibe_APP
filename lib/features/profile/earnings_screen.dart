part of '../../main.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  String _selectedFilter = 'All'; // 'All', 'Sales', 'Withdrawals'
  
  double _availableBalance = 4600.0;
  double _withdrawnAmount = 25000.0;
  
  // Custom Transaction Data Model internally mapped as Map
  late List<Map<String, dynamic>> _transactions;

  @override
  void initState() {
    super.initState();
    _transactions = [
      {
        'id': 'TXN-908123',
        'type': 'withdrawal',
        'title': 'Withdrawal to Bank',
        'subtitle': 'HDFC Bank • Account ending in 4829',
        'amount': 15000.0,
        'date': 'June 05, 2026',
        'status': 'Completed',
      },
      {
        'id': 'TXN-907101',
        'type': 'sale',
        'title': 'Summer Vibes',
        'subtitle': '600 new uses (Creator Fund)',
        'amount': 1200.0,
        'date': 'June 04, 2026',
        'status': 'Completed',
      },
      {
        'id': 'TXN-906045',
        'type': 'sale',
        'title': 'Wanderlust Journey',
        'subtitle': '200 new uses (Creator Fund)',
        'amount': 400.0,
        'date': 'June 03, 2026',
        'status': 'Completed',
      },
      {
        'id': 'TXN-905188',
        'type': 'withdrawal',
        'title': 'Withdrawal to Bank',
        'subtitle': 'HDFC Bank • Account ending in 4829',
        'amount': 10000.0,
        'date': 'May 28, 2026',
        'status': 'Completed',
      },
      {
        'id': 'TXN-904222',
        'type': 'sale',
        'title': 'Summer Vibes',
        'subtitle': '1,200 new uses (Creator Fund)',
        'amount': 2400.0,
        'date': 'May 25, 2026',
        'status': 'Completed',
      },
      {
        'id': 'TXN-903114',
        'type': 'sale',
        'title': 'Wanderlust Journey',
        'subtitle': '900 new uses (Creator Fund)',
        'amount': 1800.0,
        'date': 'May 18, 2026',
        'status': 'Completed',
      },
      {
        'id': 'TXN-902049',
        'type': 'sale',
        'title': 'Summer Vibes',
        'subtitle': '4,400 new uses (Creator Fund)',
        'amount': 8800.0,
        'date': 'May 10, 2026',
        'status': 'Completed',
      },
      {
        'id': 'TXN-901844',
        'type': 'sale',
        'title': 'Summer Vibes',
        'subtitle': '5,000 new uses (Creator Fund)',
        'amount': 10000.0,
        'date': 'April 15, 2026',
        'status': 'Completed',
      },
      {
        'id': 'TXN-900892',
        'type': 'sale',
        'title': 'Wanderlust Journey',
        'subtitle': '700 new uses (Creator Fund)',
        'amount': 1400.0,
        'date': 'April 22, 2026',
        'status': 'Completed',
      },
      {
        'id': 'TXN-899451',
        'type': 'sale',
        'title': 'Summer Vibes',
        'subtitle': '1,300 new uses (Creator Fund)',
        'amount': 2600.0,
        'date': 'March 20, 2026',
        'status': 'Completed',
      },
      {
        'id': 'TXN-898101',
        'type': 'sale',
        'title': 'Wanderlust Journey',
        'subtitle': '500 new uses (Creator Fund)',
        'amount': 1000.0,
        'date': 'March 05, 2026',
        'status': 'Completed',
      },
    ];
  }

  void _showNotification(String message) {
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

  void _openWithdrawModal() {
    if (_availableBalance <= 0) {
      _showNotification('No balance available for withdrawal');
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return _WithdrawModal(
          availableBalance: _availableBalance,
          onWithdrawConfirm: (double amount, String account, String ifsc) {
            setState(() {
              _availableBalance -= amount;
              _withdrawnAmount += amount;
              _transactions.insert(0, {
                'id': 'TXN-${math.Random().nextInt(900000) + 100000}',
                'type': 'withdrawal',
                'title': 'Withdrawal to Bank',
                'subtitle': 'Bank • Account ending in ${account.substring(math.max(0, account.length - 4))}',
                'amount': amount,
                'date': 'Today',
                'status': 'Completed',
              });
            });
            _showNotification('Withdrawal of ₹${amount.toStringAsFixed(0)} processed successfully!');
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double totalRevenue = _availableBalance + _withdrawnAmount;

    final filteredList = _transactions.where((txn) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Sales') return txn['type'] == 'sale';
      if (_selectedFilter == 'Withdrawals') return txn['type'] == 'withdrawal';
      return true;
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
                                'Earnings',
                                style: GoogleFonts.poppins(
                                  color: EditoColors.dark,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  height: 1.15,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Track your revenue, sales, and payouts',
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

                      // Premium Wallet Overview Card
                      _buildWalletCard(totalRevenue),
                      const SizedBox(height: 25),

                      // Section Title: Performance Trend
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Monthly Trend',
                            style: GoogleFonts.poppins(
                              color: EditoColors.dark,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Last 6 Months',
                            style: GoogleFonts.inter(
                              color: EditoColors.body.withValues(alpha: 0.6),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Curve trend chart widget
                      Container(
                        height: 200,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE7E1F7)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x066C63FF),
                              offset: Offset(0, 8),
                              blurRadius: 24,
                            ),
                          ],
                        ),
                        child: const _EarningsChart(),
                      ),
                      const SizedBox(height: 16),

                      // Info box explaining creator fund
                      _buildCreatorFundInfo(),
                      const SizedBox(height: 25),

                      // Transaction History Header with Filter Pills
                      Text(
                        'Transaction History',
                        style: GoogleFonts.poppins(
                          color: EditoColors.dark,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Filter Row
                      Row(
                        children: [
                          _FilterPill(
                            label: 'All',
                            selected: _selectedFilter == 'All',
                            count: _transactions.length,
                            onTap: () => setState(() => _selectedFilter = 'All'),
                          ),
                          const SizedBox(width: 8),
                          _FilterPill(
                            label: 'Sales',
                            selected: _selectedFilter == 'Sales',
                            count: _transactions.where((t) => t['type'] == 'sale').length,
                            onTap: () => setState(() => _selectedFilter = 'Sales'),
                          ),
                          const SizedBox(width: 8),
                          _FilterPill(
                            label: 'Withdrawals',
                            selected: _selectedFilter == 'Withdrawals',
                            count: _transactions.where((t) => t['type'] == 'withdrawal').length,
                            onTap: () => setState(() => _selectedFilter = 'Withdrawals'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Transactions list
                      if (filteredList.isEmpty)
                        _buildEmptyTransactions()
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final txn = filteredList[index];
                            return _TransactionItem(txn: txn);
                          },
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

  Widget _buildWalletCard(double totalRevenue) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F1A1C), Color(0xFF1B3833)], // Deep premium dark green/black
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF22B37D).withValues(alpha: 0.2),
            offset: const Offset(0, 10),
            blurRadius: 26,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background graphic glow
          Positioned(
            right: -30,
            bottom: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF22B37D).withValues(alpha: 0.15),
                    const Color(0xFF22B37D).withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Available Balance',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFA6E3CE),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '₹${_availableBalance.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        color: Color(0xFF22B37D),
                        size: 26,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Revenue',
                            style: GoogleFonts.inter(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${totalRevenue.toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(width: 1, height: 32, color: Colors.white.withValues(alpha: 0.1)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Withdrawn',
                            style: GoogleFonts.inter(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${_withdrawnAmount.toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                ElevatedButton(
                  onPressed: _availableBalance > 0 ? _openWithdrawModal : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22B37D),
                    disabledBackgroundColor: const Color(0xFF1F2F2B),
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.white.withValues(alpha: 0.3),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.account_balance_rounded, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Withdraw to Bank',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
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

  Widget _buildCreatorFundInfo() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F8EF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFC4ECCF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: Color(0xFF168F54),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Earnings Rate: ₹2.00 per template use. Updates occur in real-time as users create videos from your assets.',
              style: GoogleFonts.inter(
                color: const Color(0xFF116D3F),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTransactions() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EditoColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.receipt_long_rounded,
            color: Color(0xFFC2EED5),
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            'No transactions found',
            style: GoogleFonts.poppins(
              color: EditoColors.dark,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Transactions of this type will appear here.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: EditoColors.body.withValues(alpha: 0.6),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Transaction Item Component
// ─────────────────────────────────────────────────────────────

class _TransactionItem extends StatelessWidget {
  const _TransactionItem({required this.txn});

  final Map<String, dynamic> txn;

  @override
  Widget build(BuildContext context) {
    final isSale = txn['type'] == 'sale';
    final amountText = isSale ? '+₹${txn['amount'].toStringAsFixed(0)}' : '-₹${txn['amount'].toStringAsFixed(0)}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EditoColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x04000000),
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isSale ? const Color(0xFFE8F8EF) : const Color(0xFFFFF0F2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSale ? Icons.trending_up_rounded : Icons.account_balance_wallet_rounded,
              color: isSale ? const Color(0xFF22B37D) : const Color(0xFFFF3356),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  txn['title'] as String,
                  style: GoogleFonts.poppins(
                    color: EditoColors.dark,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  txn['subtitle'] as String,
                  style: GoogleFonts.inter(
                    color: EditoColors.body.withValues(alpha: 0.65),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amountText,
                style: GoogleFonts.poppins(
                  color: isSale ? const Color(0xFF22B37D) : const Color(0xFFFF3356),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                txn['date'] as String,
                style: GoogleFonts.inter(
                  color: EditoColors.body.withValues(alpha: 0.6),
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Custom Paint Line Chart Widget
// ─────────────────────────────────────────────────────────────

class _EarningsChart extends StatelessWidget {
  const _EarningsChart();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _EarningsChartPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _EarningsChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFECE7FA)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final double height = size.height;
    final double width = size.width;

    // Draw horizontal grid lines
    const int gridCount = 3;
    for (int i = 0; i <= gridCount; i++) {
      final y = height * (i / gridCount) * 0.8; // leave space for bottom text
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }

    // Data points representing monthly creator fund earnings (Jan, Feb, Mar, Apr, May, Jun)
    // Relative values scaling from 0 to 1
    final List<double> values = [0.15, 0.3, 0.65, 0.5, 0.58, 0.78];
    final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

    final double chartHeight = height * 0.8;
    final int dataCount = values.length;
    final double stepX = width / (dataCount - 1);

    final List<Offset> points = [];
    for (int i = 0; i < dataCount; i++) {
      final double x = i * stepX;
      // Invert Y coordinate since 0,0 is top left
      final double y = chartHeight - (values[i] * chartHeight);
      points.add(Offset(x, y));
    }

    // Draw area gradient under the curve
    if (points.isNotEmpty) {
      final pathFill = Path()..moveTo(points.first.dx, chartHeight);
      
      // Bezier curve approximation
      for (int i = 0; i < points.length; i++) {
        if (i == 0) {
          pathFill.lineTo(points[i].dx, points[i].dy);
        } else {
          final prevPoint = points[i - 1];
          final controlPoint1 = Offset(prevPoint.dx + stepX / 2, prevPoint.dy);
          final controlPoint2 = Offset(points[i].dx - stepX / 2, points[i].dy);
          pathFill.cubicTo(
            controlPoint1.dx, controlPoint1.dy,
            controlPoint2.dx, controlPoint2.dy,
            points[i].dx, points[i].dy,
          );
        }
      }
      pathFill.lineTo(points.last.dx, chartHeight);
      pathFill.close();

      final fillPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x3322B37D), Color(0x0022B37D)],
        ).createShader(Rect.fromLTWH(0, 0, width, chartHeight))
        ..style = PaintingStyle.fill;

      canvas.drawPath(pathFill, fillPaint);
    }

    // Draw main line path
    final pathLine = Path();
    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        pathLine.moveTo(points[i].dx, points[i].dy);
      } else {
        final prevPoint = points[i - 1];
        final controlPoint1 = Offset(prevPoint.dx + stepX / 2, prevPoint.dy);
        final controlPoint2 = Offset(points[i].dx - stepX / 2, points[i].dy);
        pathLine.cubicTo(
          controlPoint1.dx, controlPoint1.dy,
          controlPoint2.dx, controlPoint2.dy,
          points[i].dx, points[i].dy,
        );
      }
    }

    final linePaint = Paint()
      ..color = const Color(0xFF22B37D)
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(pathLine, linePaint);

    // Draw data points and month labels
    final pointPaint = Paint()
      ..color = const Color(0xFF22B37D)
      ..style = PaintingStyle.fill;
    final pointOutlinePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < points.length; i++) {
      // Draw point circle
      canvas.drawCircle(points[i], 4.5, pointPaint);
      canvas.drawCircle(points[i], 4.5, pointOutlinePaint);

      // Month Label text
      textPainter.text = TextSpan(
        text: months[i],
        style: GoogleFonts.inter(
          color: const Color(0xFF9898B3),
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(points[i].dx - textPainter.width / 2, chartHeight + 6),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────
// Interactive Bank Withdrawal Modal Bottom Sheet
// ─────────────────────────────────────────────────────────────

class _WithdrawModal extends StatefulWidget {
  const _WithdrawModal({
    required this.availableBalance,
    required this.onWithdrawConfirm,
  });

  final double availableBalance;
  final Function(double amount, String account, String ifsc) onWithdrawConfirm;

  @override
  State<_WithdrawModal> createState() => _WithdrawModalState();
}

class _WithdrawModalState extends State<_WithdrawModal> {
  final _amountController = TextEditingController();
  final _accountController = TextEditingController(text: '102983749829');
  final _ifscController = TextEditingController(text: 'HDFC0000123');

  bool _loading = false;
  bool _success = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    // Default withdraw amount to max balance
    _amountController.text = widget.availableBalance.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _accountController.dispose();
    _ifscController.dispose();
    super.dispose();
  }

  void _submit() {
    final amountString = _amountController.text.trim();
    final accountString = _accountController.text.trim();
    final ifscString = _ifscController.text.trim();

    if (amountString.isEmpty || accountString.isEmpty || ifscString.isEmpty) {
      setState(() => _errorText = 'All fields are required.');
      return;
    }

    final double? parsedAmount = double.tryParse(amountString);
    if (parsedAmount == null || parsedAmount <= 0) {
      setState(() => _errorText = 'Enter a valid amount.');
      return;
    }

    if (parsedAmount > widget.availableBalance) {
      setState(() => _errorText = 'Insufficient available balance.');
      return;
    }

    setState(() {
      _loading = true;
      _errorText = null;
    });

    // Simulate network delay for verification
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _success = true;
      });
      // Confirm withdrawal callback
      widget.onWithdrawConfirm(parsedAmount, accountString, ifscString);
      
      // Auto close dialog after success display
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        Navigator.of(context).pop();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Account for keyboard overlay in bottom sheet
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: EditoColors.border,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 18),

          if (_success) ...[
            const SizedBox(height: 20),
            const Center(
              child: CircleAvatar(
                radius: 36,
                backgroundColor: Color(0xFFE8F8EF),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF22B37D),
                  size: 48,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Withdrawal Requested!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: EditoColors.dark,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'The funds will reach your account shortly.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: EditoColors.body.withValues(alpha: 0.7),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 25),
          ] else if (_loading) ...[
            const SizedBox(height: 40),
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF22B37D),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Processing Transaction...',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: EditoColors.dark,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 40),
          ] else ...[
            Text(
              'Withdraw to Bank Account',
              style: GoogleFonts.poppins(
                color: EditoColors.dark,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Transfer your available balance to your bank account',
              style: GoogleFonts.inter(
                color: EditoColors.body.withValues(alpha: 0.75),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),

            // Amount Input
            _buildTextField(
              label: 'Withdrawal Amount (₹)',
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: false),
              prefix: const Icon(Icons.currency_rupee_rounded, size: 16, color: Color(0xFF22B37D)),
            ),
            const SizedBox(height: 14),

            // Bank Account Input
            _buildTextField(
              label: 'Bank Account Number',
              controller: _accountController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 14),

            // IFSC Input
            _buildTextField(
              label: 'IFSC Code',
              controller: _ifscController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 8),

            if (_errorText != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  _errorText!,
                  style: GoogleFonts.inter(
                    color: const Color(0xFFFF3356),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],

            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22B37D),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Text(
                'Confirm Withdrawal',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    Widget? prefix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: EditoColors.body.withValues(alpha: 0.8),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          style: GoogleFonts.inter(
            color: EditoColors.dark,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            prefixIcon: prefix != null
                ? Padding(padding: const EdgeInsets.only(right: 6), child: prefix)
                : null,
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            filled: true,
            fillColor: const Color(0xFFF7F8FC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFECEBFF)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFECEBFF)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: EditoColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
