part of '../../main.dart';

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        gradient: const LinearGradient(
          colors: [Color(0xFF6D32FF), EditoColors.primary],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x306C63FF),
            offset: Offset(0, 14),
            blurRadius: 28,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(17),
          onTap: onTap,
          child: SizedBox(
            height: 66,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: EditoColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Positioned(
                  right: 27,
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: EditoColors.white,
                    size: 31,
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
