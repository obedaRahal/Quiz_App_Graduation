import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/laboratory/domain/entities/test_by_interest_response_entity.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/widget/laboratory_exam_session_card.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_cubit.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_state.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/test_tab/other_profile_tests_filter_section.dart';

class OtherProfileTestsTab extends StatelessWidget {
  const OtherProfileTestsTab({super.key});

  static const List<TestByInterestEntity> mockOtherProfileTests = [
    TestByInterestEntity(
      id: 1,
      title: 'جلسة امتحانية أولى',
      description:
          'هذه الجلسة الامتحانية تحتوي على مجموعة أسئلة متنوعة لتقييم مستوى الطالب في هذا المجال.',
      interests: [
        TestInterestEntity(id: 1, name: 'الرياضيات'),
        TestInterestEntity(id: 2, name: 'الفيزياء'),
      ],
      questionCount: 89,
      difficultyLevel: 'متوسط',
      price: 180,
      averageRating: 4.5,
      publishedAgo: 'منذ 5 أيام',
    ),
    TestByInterestEntity(
      id: 2,
      title: 'جلسة امتحانية ثانية',
      description:
          'اختبار تدريبي مناسب للمراجعة السريعة قبل الامتحان النهائي مع أسئلة متنوعة.',
      interests: [
        TestInterestEntity(id: 3, name: 'البرمجة'),
        TestInterestEntity(id: 4, name: 'الخوارزميات'),
      ],
      questionCount: 50,
      difficultyLevel: 'سهل',
      price: 0,
      averageRating: 3.9,
      publishedAgo: 'منذ يومين',
    ),
    TestByInterestEntity(
      id: 3,
      title: 'جلسة امتحانية ثالثة',
      description:
          'اختبار متقدم يحتوي على أسئلة تحتاج إلى تركيز وتحليل عميق ومناسب للمستوى العالي.',
      interests: [
        TestInterestEntity(id: 5, name: 'هياكل البيانات'),
        TestInterestEntity(id: 6, name: 'قواعد البيانات'),
      ],
      questionCount: 120,
      difficultyLevel: 'صعب',
      price: 1280,
      averageRating: 4.8,
      publishedAgo: 'منذ أسبوع',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtherProfileCubit, OtherProfileState>(
      buildWhen: (previous, current) =>
          previous.selectedTestsFilter != current.selectedTestsFilter,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            OtherProfileTestsFilterSection(
              selectedFilter: state.selectedTestsFilter,
              onFilterSelected: context
                  .read<OtherProfileCubit>()
                  .changeSelectedTestsFilter,
            ),

            SizedBox(height: SizeConfig.h(0.018)),

            Column(
              children: mockOtherProfileTests.map((test) {
                return Padding(
                  padding: EdgeInsets.only(bottom: SizeConfig.h(0.014)),
                  child: LaboratoryExamSessionCard(
                    item: test,
                    horizonMargin: 0,
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
