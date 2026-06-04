part of '../../main.dart';

class _PrivacyCard extends StatelessWidget {
  const _PrivacyCard();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 298,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
        decoration: BoxDecoration(
          color: EditoColors.white.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(17),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0E6C63FF),
              offset: Offset(0, 14),
              blurRadius: 35,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 47,
              height: 47,
              decoration: const BoxDecoration(
                color: Color(0xFFE2DCFF),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: EditoColors.primary,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Icon(
                    Icons.lock_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 17),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.inter(
                    color: EditoColors.body.withValues(alpha: 0.76),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.45,
                  ),
                  children: const [
                    TextSpan(text: "We'll never share your number\n"),
                    TextSpan(text: 'with anyone. See our '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: EditoColors.primary,
                        fontWeight: FontWeight.w800,
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
}
