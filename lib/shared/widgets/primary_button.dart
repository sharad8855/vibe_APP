part of '../../main.dart';

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({
    required this.label,
    required this.onTap,
    this.height = 66,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onTap;
  final double height;
  final bool isLoading;

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
          onTap: isLoading ? null : onTap,
          child: SizedBox(
            height: height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isLoading)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                else ...[
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      color: EditoColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Positioned(
                    right: 27,
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: EditoColors.white,
                      size: height * 0.47, // scales arrow icon size dynamically
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
