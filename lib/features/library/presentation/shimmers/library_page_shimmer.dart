import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/app_shimmer_box.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class LibraryPageShimmer extends StatelessWidget {
  const LibraryPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              SizeConfig.w(0.045),
              SizeConfig.h(0.025),
              SizeConfig.w(0.045),
              SizeConfig.h(0.018),
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                AppShimmerBox(
                  width: SizeConfig.w(0.36),
                  height: SizeConfig.h(0.025),
                ),
                const Spacer(),
                AppShimmerBox(
                  width: SizeConfig.w(0.105),
                  height: SizeConfig.w(0.105),
                  borderRadius: 999,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.045)),
            child: AppShimmerBox(
              width: double.infinity,
              height: SizeConfig.h(0.058),
              borderRadius: 14,
            ),
          ),
          SizedBox(height: SizeConfig.h(0.018)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.045)),
            child: Row(
              textDirection: TextDirection.rtl,
              children: List.generate(3, (index) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                      end: index == 2 ? 0 : SizeConfig.w(0.018),
                    ),
                    child: AppShimmerBox(
                      width: double.infinity,
                      height: SizeConfig.h(0.045),
                      borderRadius: 18,
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: SizeConfig.h(0.022)),
          SizedBox(
            height: SizeConfig.h(0.22),
            child: ListView.separated(
              reverse: true,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.045)),
              itemCount: 3,
              separatorBuilder: (_, _) => SizedBox(width: SizeConfig.w(0.028)),
              itemBuilder: (_, _) => AppShimmerBox(
                width: SizeConfig.w(0.36),
                height: SizeConfig.h(0.205),
                borderRadius: 18,
              ),
            ),
          ),
          SizedBox(height: SizeConfig.h(0.014)),
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.045)),
              itemCount: 4,
              separatorBuilder: (_, _) => SizedBox(height: SizeConfig.h(0.014)),
              itemBuilder: (_, _) => const _LibraryItemShimmer(),
            ),
          ),
        ],
      ),
    );
  }
}

class _LibraryItemShimmer extends StatelessWidget {
  const _LibraryItemShimmer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.h(0.115).clamp(90.0, 112.0),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          AppShimmerBox(
            width: SizeConfig.w(0.205).clamp(72.0, 88.0),
            height: SizeConfig.h(0.095).clamp(72.0, 88.0),
            borderRadius: 14,
          ),
          SizedBox(width: SizeConfig.w(0.025)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppShimmerBox(
                  width: double.infinity,
                  height: SizeConfig.h(0.016),
                ),
                SizedBox(height: SizeConfig.h(0.011)),
                AppShimmerBox(
                  width: SizeConfig.w(0.48),
                  height: SizeConfig.h(0.012),
                ),
                SizedBox(height: SizeConfig.h(0.014)),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    AppShimmerBox(
                      width: SizeConfig.w(0.19),
                      height: SizeConfig.h(0.024),
                      borderRadius: 6,
                    ),
                    const Spacer(),
                    AppShimmerBox(
                      width: SizeConfig.w(0.2),
                      height: SizeConfig.h(0.012),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
