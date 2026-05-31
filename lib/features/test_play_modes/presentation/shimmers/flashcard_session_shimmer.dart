import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/app_shimmer_box.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class FlashcardSessionShimmer extends StatelessWidget {
  const FlashcardSessionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.h(0.018)),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.045)),
          child: Row(
            children: [
              AppShimmerBox(
                width: SizeConfig.w(0.24),
                height: SizeConfig.h(0.035),
                borderRadius: 20,
              ),
              const Spacer(),
              AppShimmerBox(
                width: SizeConfig.w(0.16),
                height: SizeConfig.h(0.045),
                borderRadius: 10,
              ),
            ],
          ),
        ),

        SizedBox(height: SizeConfig.h(0.018)),

        SizedBox(
          height: SizeConfig.w(0.03),
          child: ListView.separated(
            reverse: true,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.045)),
            itemCount: 20,
            separatorBuilder: (_, __) => SizedBox(width: SizeConfig.w(0.018)),
            itemBuilder: (_, __) {
              return AppShimmerBox(
                width: SizeConfig.w(0.035),
                height: SizeConfig.w(0.035),
                borderRadius: 50,
              );
            },
          ),
        ),

        SizedBox(height: SizeConfig.h(0.035)),

        Expanded(
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.14)),
                  child: Transform.rotate(
                    angle: 0.15,
                    child: const _FlashcardShimmerLayer(),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.125)),
                  child: Transform.rotate(
                    angle: 0.06,
                    child: const _FlashcardShimmerLayer(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.10)),
                child: const _MainFlashcardShimmer(),
              ),
            ],
          ),
        ),

        SizedBox(height: SizeConfig.h(0.03)),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.045)),
          child: Row(
            children: [
              Expanded(
                child: AppShimmerBox(
                  width: double.infinity,
                  height: SizeConfig.h(0.1),
                  borderRadius: 10,
                ),
              ),
              SizedBox(width: SizeConfig.w(0.07)),
              Expanded(
                child: AppShimmerBox(
                  width: double.infinity,
                  height: SizeConfig.h(0.1),
                  borderRadius: 10,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: SizeConfig.h(0.016)),
      ],
    );
  }
}

class _FlashcardShimmerLayer extends StatelessWidget {
  const _FlashcardShimmerLayer();

  @override
  Widget build(BuildContext context) {
    return AppShimmerBox(
      width: double.infinity,
      height: double.infinity,
      borderRadius: 20,
    );
  }
}

class _MainFlashcardShimmer extends StatelessWidget {
  const _MainFlashcardShimmer();

  @override
  Widget build(BuildContext context) {
    return AppShimmerBox(
      width: double.infinity,
      height: double.infinity,
      borderRadius: 20,
    );
  }
}