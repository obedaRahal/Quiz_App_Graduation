import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/app_shimmer_box.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class LaboratoryPageShimmer extends StatelessWidget {
  const LaboratoryPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              SizeConfig.w(0.035),
              SizeConfig.h(0.02),
              SizeConfig.w(0.035),
              SizeConfig.h(0.016),
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                AppShimmerBox(
                  width: SizeConfig.w(0.34),
                  height: SizeConfig.h(0.026),
                ),
                const Spacer(),
                AppShimmerBox(
                  width: SizeConfig.w(0.11),
                  height: SizeConfig.w(0.11),
                  borderRadius: 999,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
            child: AppShimmerBox(
              width: double.infinity,
              height: SizeConfig.h(0.058),
              borderRadius: 14,
            ),
          ),
          SizedBox(height: SizeConfig.h(0.014)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.035)),
            child: Row(
              textDirection: TextDirection.rtl,
              children: List.generate(4, (index) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                      end: index == 3 ? 0 : SizeConfig.w(0.015),
                    ),
                    child: AppShimmerBox(
                      width: double.infinity,
                      height: SizeConfig.h(0.043),
                      borderRadius: 18,
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: SizeConfig.h(0.015)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.025)),
            child: AppShimmerBox(
              width: double.infinity,
              height: SizeConfig.h(0.4),
              borderRadius: 22,
            ),
          ),
          SizedBox(height: SizeConfig.h(0.022)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.04)),
            child: Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppShimmerBox(
                  width: SizeConfig.w(0.38),
                  height: SizeConfig.h(0.02),
                ),
                AppShimmerBox(
                  width: SizeConfig.w(0.14),
                  height: SizeConfig.h(0.014),
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.h(0.014)),
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (_, _) => SizedBox(height: SizeConfig.h(0.014)),
              itemBuilder: (_, _) => Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.035)),
                child: AppShimmerBox(
                  width: double.infinity,
                  height: SizeConfig.h(0.17),
                  borderRadius: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
