import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class StudyPlanMotivationBanner extends StatefulWidget {
  const StudyPlanMotivationBanner({super.key});

  @override
  State<StudyPlanMotivationBanner> createState() =>
      _StudyPlanMotivationBannerState();
}

class _StudyPlanMotivationBannerState extends State<StudyPlanMotivationBanner> {
  static const List<String> _phrases = [
    'كل خطوة صغيرة اليوم تقرّبك من هدفك الكبير.',
    'خطة واضحة، تركيز أفضل، ونتائج أقوى.',
    'لا تنتظر الحماس، ابدأ وسيأتي الحماس لاحقًا.',
    'ساعات الدراسة القليلة المنتظمة تصنع فرقًا كبيرًا.',
    'التقدم أهم من الكمال، أكمل طريقك.',
  ];

  late final String _selectedPhrase;

  @override
  void initState() {
    super.initState();

    _selectedPhrase = _phrases[Random().nextInt(_phrases.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,

      children: [
        CustomAppImage(path: AppImage.studyplan, ),
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: SizeConfig.w(0.02)),
          child: CustomTextWidget(
            
            _selectedPhrase,
            maxLines: 3,
            color: AppPalette.black,
            fontFamily: AppFont.elMessiriBold,
            fontSize: SizeConfig.text(0.05),
          ),
        ),
      ],
    );
  }
}
