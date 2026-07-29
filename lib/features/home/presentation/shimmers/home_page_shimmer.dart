import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/app_shimmer_box.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class HomePageShimmer extends StatelessWidget {
  const HomePageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: SizeConfig.h(0.03)),
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.04)),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  AppShimmerBox(
                    width: SizeConfig.w(0.13),
                    height: SizeConfig.w(0.13),
                    borderRadius: 999,
                  ),
                  SizedBox(width: SizeConfig.w(0.025)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AppShimmerBox(
                          width: SizeConfig.w(0.34),
                          height: SizeConfig.h(0.018),
                        ),
                        SizedBox(height: SizeConfig.h(0.009)),
                        AppShimmerBox(
                          width: SizeConfig.w(0.22),
                          height: SizeConfig.h(0.012),
                        ),
                      ],
                    ),
                  ),
                  _CircleBox(size: SizeConfig.w(0.105)),
                  SizedBox(width: SizeConfig.w(0.018)),
                  _CircleBox(size: SizeConfig.w(0.105)),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.h(0.03)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.025)),
              child: AppShimmerBox(
                width: double.infinity,
                height: SizeConfig.h(0.19),
                borderRadius: 22,
              ),
            ),
            SizedBox(height: SizeConfig.h(0.025)),
            const _SectionTitleShimmer(),
            SizedBox(height: SizeConfig.h(0.016)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.036)),
              child: Row(
                textDirection: TextDirection.rtl,
                children: List.generate(4, (index) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(
                        end: index == 3 ? 0 : SizeConfig.w(0.018),
                      ),
                      child: AppShimmerBox(
                        width: double.infinity,
                        height: SizeConfig.h(0.04),
                        borderRadius: 18,
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: SizeConfig.h(0.018)),
            SizedBox(
              height: SizeConfig.h(0.34),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                reverse: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.04)),
                itemCount: 2,
                separatorBuilder: (_, _) =>
                    SizedBox(width: SizeConfig.w(0.025)),
                itemBuilder: (_, _) => AppShimmerBox(
                  width: SizeConfig.w(0.7),
                  height: SizeConfig.h(0.34),
                  borderRadius: 20,
                ),
              ),
            ),
            SizedBox(height: SizeConfig.h(0.025)),
            const _SectionTitleShimmer(),
            SizedBox(height: SizeConfig.h(0.016)),
            SizedBox(
              height: SizeConfig.h(0.105),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                reverse: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.04)),
                itemCount: 4,
                separatorBuilder: (_, _) =>
                    SizedBox(width: SizeConfig.w(0.025)),
                itemBuilder: (_, _) => AppShimmerBox(
                  width: SizeConfig.w(0.25),
                  height: SizeConfig.h(0.095),
                  borderRadius: 14,
                ),
              ),
            ),
            SizedBox(height: SizeConfig.h(0.025)),
            const _SectionTitleShimmer(),
            SizedBox(height: SizeConfig.h(0.015)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.04)),
              child: Row(
                textDirection: TextDirection.rtl,
                children: List.generate(3, (index) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(
                        end: index == 2 ? 0 : SizeConfig.w(0.025),
                      ),
                      child: Column(
                        children: [
                          AppShimmerBox(
                            width: SizeConfig.w(0.18),
                            height: SizeConfig.w(0.18),
                            borderRadius: 999,
                          ),
                          SizedBox(height: SizeConfig.h(0.01)),
                          AppShimmerBox(
                            width: SizeConfig.w(0.18),
                            height: SizeConfig.h(0.012),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitleShimmer extends StatelessWidget {
  const _SectionTitleShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.04)),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppShimmerBox(width: SizeConfig.w(0.38), height: SizeConfig.h(0.02)),
          AppShimmerBox(width: SizeConfig.w(0.16), height: SizeConfig.h(0.014)),
        ],
      ),
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
