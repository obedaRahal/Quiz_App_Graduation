import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/app_shimmer_box.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class StudyPlanHomeShimmer extends StatelessWidget {
  const StudyPlanHomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          SizeConfig.w(0.03),
          SizeConfig.h(0.03),
          SizeConfig.w(0.03),
          0,
        ),
        child: Column(
          children: [
            Row(
              textDirection: TextDirection.rtl,
              children: [
                AppShimmerBox(
                  width: SizeConfig.w(0.4),
                  height: SizeConfig.h(0.026),
                ),
                const Spacer(),
                AppShimmerBox(
                  width: SizeConfig.w(0.115),
                  height: SizeConfig.w(0.115),
                  borderRadius: 999,
                ),
              ],
            ),
            SizedBox(height: SizeConfig.h(0.02)),
            AppShimmerBox(
              width: double.infinity,
              height: SizeConfig.h(0.105),
              borderRadius: 14,
            ),
            SizedBox(height: SizeConfig.h(0.022)),
            Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppShimmerBox(
                      width: SizeConfig.w(0.34),
                      height: SizeConfig.h(0.019),
                    ),
                    SizedBox(height: SizeConfig.h(0.009)),
                    AppShimmerBox(
                      width: SizeConfig.w(0.23),
                      height: SizeConfig.h(0.013),
                    ),
                  ],
                ),
                AppShimmerBox(
                  width: SizeConfig.w(0.26),
                  height: SizeConfig.h(0.04),
                  borderRadius: 10,
                ),
              ],
            ),
            SizedBox(height: SizeConfig.h(0.018)),
            Row(
              textDirection: TextDirection.rtl,
              children: [
                _CircleBox(size: SizeConfig.w(0.07)),
                SizedBox(width: SizeConfig.w(0.012)),
                ...List.generate(7, (index) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.w(0.004),
                      ),
                      child: _CircleBox(size: SizeConfig.w(0.095)),
                    ),
                  );
                }),
                SizedBox(width: SizeConfig.w(0.012)),
                _CircleBox(size: SizeConfig.w(0.07)),
              ],
            ),
            SizedBox(height: SizeConfig.h(0.025)),
            const _SectionHeaderShimmer(),
            SizedBox(height: SizeConfig.h(0.016)),
            AppShimmerBox(
              width: double.infinity,
              height: SizeConfig.h(0.17),
              borderRadius: 12,
            ),
            SizedBox(height: SizeConfig.h(0.03)),
            Align(
              alignment: Alignment.centerRight,
              child: AppShimmerBox(
                width: SizeConfig.w(0.38),
                height: SizeConfig.h(0.02),
              ),
            ),
            SizedBox(height: SizeConfig.h(0.016)),
            ...List.generate(3, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: SizeConfig.h(0.012)),
                child: AppShimmerBox(
                  width: double.infinity,
                  height: SizeConfig.h(0.105),
                  borderRadius: 12,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _SectionHeaderShimmer extends StatelessWidget {
  const _SectionHeaderShimmer();

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppShimmerBox(width: SizeConfig.w(0.34), height: SizeConfig.h(0.02)),
        AppShimmerBox(
          width: SizeConfig.w(0.25),
          height: SizeConfig.h(0.038),
          borderRadius: 8,
        ),
      ],
    );
  }
}

class _CircleBox extends StatelessWidget {
  final double size;

  const _CircleBox({required this.size});

  @override
  Widget build(BuildContext context) {
    return AppShimmerBox(width: size, height: size, borderRadius: 999);
  }
}
