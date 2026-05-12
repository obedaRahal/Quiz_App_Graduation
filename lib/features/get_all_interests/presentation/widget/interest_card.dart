// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
// import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
// import 'package:quiz_app_grad/core/utils/media_query_config.dart';
// import 'package:quiz_app_grad/features/get_all_interests/domain/entities/all_interests_response_entity.dart';

// class InterestCard extends StatelessWidget {
//   final InterestItemEntity interest;

//   const InterestCard({super.key, required this.interest});

//   Color _parseColor(String hex) {
//     try {
//       final cleanHex = hex.replaceAll('#', '');
//       return Color(int.parse('FF$cleanHex', radix: 16));
//     } catch (_) {
//       return AppPalette.greyMedium;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final iconColor = _parseColor(interest.iconColor);
//     final iconUrl = interest.iconSvg;

//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.026)),
//       decoration: BoxDecoration(
//         color: isDark ? AppPalette.fieldColorNDark : Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: isDark
//               ? AppPalette.borderFieldColorNDark
//               : const Color(0xFFEDEDED),
//           width: 1,
//         ),
//         boxShadow: [
//           if (!isDark)
//             BoxShadow(
//               color: Colors.black.withOpacity(0.035),
//               blurRadius: 10,
//               offset: const Offset(0, 3),
//             ),
//         ],
//       ),
//       child: Row(
//         textDirection: TextDirection.rtl,
//         children: [
//           SizedBox(
//             width: SizeConfig.w(0.075),
//             height: SizeConfig.w(0.075),
//             child: iconUrl.isEmpty
//                 ? Icon(
//                     Icons.category_rounded,
//                     color: iconColor,
//                     size: SizeConfig.text(0.055),
//                   )
//                 : SvgPicture.network(
//                     iconUrl,
//                     colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
//                     placeholderBuilder: (_) {
//                       return Icon(
//                         Icons.category_rounded,
//                         color: iconColor,
//                         size: SizeConfig.text(0.055),
//                       );
//                     },
//                     errorBuilder: (context, error, stackTrace) {
//                       return Icon(
//                         Icons.category_rounded,
//                         color: iconColor,
//                         size: SizeConfig.text(0.055),
//                       );
//                     },
//                   ),
//           ),
//           SizedBox(width: SizeConfig.w(0.018)),
//           Expanded(
//             child: CustomTextWidget(
//               interest.name,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               textAlign: TextAlign.right,
//               fontWeight: FontWeight.w600,
//               fontSize: SizeConfig.text(0.034),
//               color: isDark
//                   ? AppPalette.titleWhiteINDark
//                   : AppPalette.greyMedium,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/get_all_interests/domain/entities/all_interests_response_entity.dart';

class InterestCard extends StatelessWidget {
  final InterestItemEntity interest;
  final VoidCallback onTap;

  const InterestCard({
    super.key,
    required this.interest,
    required this.onTap,
  });

  Color _parseColor(String hex) {
    try {
      final cleanHex = hex.replaceAll('#', '');
      return Color(int.parse('FF$cleanHex', radix: 16));
    } catch (_) {
      return AppPalette.greyMedium;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = _parseColor(interest.iconColor);
    final iconUrl = interest.iconSvg;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.026)),
        decoration: BoxDecoration(
          color: isDark ? AppPalette.fieldColorNDark : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? AppPalette.borderFieldColorNDark
                : const Color(0xFFEDEDED),
            width: 1,
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            SizedBox(
              width: SizeConfig.w(0.075),
              height: SizeConfig.w(0.075),
              child: iconUrl.isEmpty
                  ? Icon(
                      Icons.category_rounded,
                      color: iconColor,
                      size: SizeConfig.text(0.055),
                    )
                  : SvgPicture.network(
                      iconUrl,
                      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                      placeholderBuilder: (_) => Icon(
                        Icons.category_rounded,
                        color: iconColor,
                        size: SizeConfig.text(0.055),
                      ),
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.category_rounded,
                        color: iconColor,
                        size: SizeConfig.text(0.055),
                      ),
                    ),
            ),
            SizedBox(width: SizeConfig.w(0.018)),
            Expanded(
              child: CustomTextWidget(
                interest.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                fontWeight: FontWeight.w600,
                fontSize: SizeConfig.text(0.034),
                color: isDark
                    ? AppPalette.titleWhiteINDark
                    : AppPalette.greyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}