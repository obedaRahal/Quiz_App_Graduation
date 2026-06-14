import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_cubit.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_state.dart';

class CreateTestPublishSection extends StatelessWidget {
  const CreateTestPublishSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;
    return BlocBuilder<CreateTestCubit, CreateTestState>(
      buildWhen: (previous, current) {
        return previous.isPublished != current.isPublished ||
            previous.price != current.price ||
            previous.isEditMode != current.isEditMode ||
            previous.wasInitiallyPublished != current.wasInitiallyPublished;
      },
      builder: (context, state) {
        return Column(
          children: [
            Container(
              height: SizeConfig.h(0.062),
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.030)),
              decoration: BoxDecoration(
                color: isDark ? AppPalette.fieldColorNDark : AppPalette.white,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(
                  color: isDark
                      ? AppPalette.borderFieldColorNDark
                      : AppPalette.borderFieldColorNLight,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Icon(
                  //   Icons.public_rounded,
                  //   size: SizeConfig.text(0.056),
                  //   color: AppPalette.greyMedium,
                  // ),
                  CustomAppImage(
                    path: AppImage.earth,
                    color: AppPalette.greyMedium,
                  ),
                  SizedBox(width: SizeConfig.w(0.020)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget(
                        'نشر المحتوى',
                        fontSize: SizeConfig.text(0.032),
                        fontWeight: FontWeight.w900,
                        color: isDark
                            ? AppPalette.grey2Dark
                            : AppPalette.textColorInHome,
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: SizeConfig.h(0.002)),
                      CustomTextWidget(
                        'مشاركة هذا المحتوى الخاص بك للعامة ؟',
                        fontSize: SizeConfig.text(0.024),
                        fontWeight: FontWeight.w600,
                        color: AppPalette.greyMedium,
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),

                  const Spacer(),
                  SizedBox(
                    width: SizeConfig.w(0.12),
                    height: SizeConfig.h(0.035),
                    child: Transform.scale(
                      scale: 0.62,
                      child: Switch(
                        value: state.isPublished,
                        onChanged:
                            state.isEditMode && state.wasInitiallyPublished
                            ? null
                            : context
                                  .read<CreateTestCubit>()
                                  .changePublishStatus,

                        activeColor: isDark
                            ? AppPalette.black
                            : AppPalette.white,
                        activeTrackColor: appColors.primaryToPrimaryDark,

                        inactiveThumbColor: isDark
                            ? AppPalette.titleWhiteINDark
                            : AppPalette.white,

                        inactiveTrackColor: isDark
                            ? AppPalette.greyLightDark
                            : AppPalette.greyBorder,

                        trackOutlineColor:
                            WidgetStateProperty.resolveWith<Color?>((states) {
                              if (states.contains(WidgetState.selected)) {
                                return appColors.primaryToPrimaryDark;
                              }

                              return isDark
                                  ? AppPalette.borderFieldColorNDark
                                  : AppPalette.greyBorder;
                            }),

                        thumbColor: WidgetStateProperty.resolveWith<Color>((
                          states,
                        ) {
                          if (states.contains(WidgetState.selected)) {
                            return isDark
                                ? AppPalette.textWhiteINDark
                                : AppPalette.white;
                          }

                          return isDark
                              ? AppPalette.titleWhiteINDark
                              : AppPalette.white;
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (state.isPublished) ...[
              SizedBox(height: SizeConfig.h(0.012)),
             _PriceField(value: state.price),
            ],
          ],
        );
      },
    );
  }
}

class _PriceField extends StatefulWidget {
  final String value;

  const _PriceField({
    required this.value,
  });

  @override
  State<_PriceField> createState() => _PriceFieldState();
}

class _PriceFieldState extends State<_PriceField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _PriceField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value;
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    return SizedBox(
      height: SizeConfig.h(0.054),
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        textAlignVertical: TextAlignVertical.center,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: context.read<CreateTestCubit>().changePrice,
        style: TextStyle(
          fontSize: SizeConfig.text(0.030),
          fontWeight: FontWeight.w700,
          color: isDark
              ? AppPalette.textWhiteINDark
              : AppPalette.textColorInHome,
          fontFamily: AppFont.elMessiriRegular,
        ),
        decoration: InputDecoration(
          hintText: 'السعر',
          hintTextDirection: TextDirection.rtl,
          hintStyle: TextStyle(
            fontSize: SizeConfig.text(0.032),
            fontWeight: FontWeight.w700,
            color: AppPalette.greyMedium,
            fontFamily: AppFont.elMessiriRegular,
          ),
          filled: true,
          fillColor: isDark ? AppPalette.fieldColorNDark : AppPalette.white,
          contentPadding: EdgeInsets.only(
            right: SizeConfig.w(0.030),
            left: SizeConfig.w(0.020),
          ),
          suffixIcon: Container(
            width: SizeConfig.w(0.25),
            margin: EdgeInsets.only(left: SizeConfig.w(0.006)),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: isDark
                      ? AppPalette.grey2Dark
                      : AppPalette.borderFieldColorNLight,
                  width: 0.3,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomAppImage(path: AppImage.syria),
                SizedBox(width: SizeConfig.w(0.016)),
                CustomTextWidget(
                  'ليرة سورية',
                  fontSize: SizeConfig.text(0.032),
                  fontWeight: FontWeight.w800,
                  color: AppPalette.greyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(
              color: isDark
                  ? AppPalette.borderFieldColorNDark
                  : AppPalette.borderFieldColorNLight,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(
              color: appColors.primaryToPrimaryDark,
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}