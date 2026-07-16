import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class MyProfileFolderMoreMenuButton extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MyProfileFolderMoreMenuButton({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      tooltip: '',
      color: Theme.of(context).cardColor,
      icon: Icon(
        Icons.more_horiz_rounded,
        color: AppPalette.greyMedium,
        size: SizeConfig.h(0.027),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: (value) {
        if (value == 'edit') onEdit();
        if (value == 'delete') onDelete();
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(
                Icons.edit_outlined,
                size: SizeConfig.h(0.023),
                color: appColors.primaryToPrimaryDark,
              ),
              SizedBox(width: SizeConfig.w(0.02)),
              CustomTextWidget(
                'تعديل المجلد',
                fontSize: SizeConfig.text(0.03),
                color: appColors.blackTogreyMedium,
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(
                Icons.delete_outline_rounded,
                size: SizeConfig.h(0.023),
                color: AppPalette.red,
              ),
              SizedBox(width: SizeConfig.w(0.02)),
              CustomTextWidget(
                'حذف المجلد',
                fontSize: SizeConfig.text(0.03),
                color: appColors.blackTogreyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}