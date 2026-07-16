import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_folder_editor/my_profile_folder_editor_cubit.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_folder_editor/my_profile_folder_editor_state.dart';

class MyProfileFolderColorPicker extends StatelessWidget {
  const MyProfileFolderColorPicker({super.key});

  static const colors = [
    '#5583FF',
    '#7D73E8',
    '#9463CF',
    '#A153B5',
    '#A7459B',
    '#F64A65',
    '#FF76B6',
    '#FF9883',
    '#FFC963',
    '#F9F871',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
        MyProfileFolderEditorCubit,
        MyProfileFolderEditorState>(
      buildWhen: (previous, current) =>
          previous.colorCode != current.colorCode,
      builder: (context, state) {
        return Wrap(
          textDirection: TextDirection.rtl,
          spacing: SizeConfig.w(0.1),
          runSpacing: SizeConfig.h(0.018),
          children: colors.map((hex) {
            final isSelected =
                state.colorCode.toLowerCase() == hex.toLowerCase();

            return GestureDetector(
              onTap: () {
                context
                    .read<MyProfileFolderEditorCubit>()
                    .colorChanged(hex);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: SizeConfig.w(0.075),
                height: SizeConfig.w(0.075),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _parseHexColor(hex),
                  border: Border.all(
                    color: isSelected
                        ? AppPalette.primary
                        : Colors.transparent,
                    width: 2.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: _parseHexColor(hex).withOpacity(0.35),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: SizeConfig.w(0.047),
                          height: SizeConfig.w(0.047),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppPalette.white,
                              width: 2,
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Color _parseHexColor(String value) {
    var hex = value.trim();
    if (hex.startsWith('#')) hex = hex.substring(1);
    if (hex.length == 6) hex = 'FF$hex';

    return Color(int.tryParse(hex, radix: 16) ?? 0xFF5582FF);
  }
}