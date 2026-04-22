import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/home/presentation/managet/home_cubit/home_cubit.dart';
import 'package:quiz_app_grad/features/home/presentation/view/home_page.dart';
import 'package:quiz_app_grad/features/main_layout/presentation/manager/cubit/bottom_nav_cubit.dart';
import 'package:quiz_app_grad/features/main_layout/presentation/manager/cubit/bottom_nav_state.dart';
import 'package:quiz_app_grad/features/main_layout/presentation/widget/custom_bottom_nav_bar.dart';

class MainLayoutBody extends StatelessWidget {
  const MainLayoutBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, BottomNavState>(
      buildWhen: (previous, current) =>
          previous.currentIndex != current.currentIndex,
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state.currentIndex,
            children: [
              BlocProvider(create: (_) => HomeCubit(), child: const HomePage()),
              const Center(child: Text('المكتبة')),
              const Center(child: Text('المختبر')),
              const Center(child: Text('الخطة')),
            ],
          ),
          bottomNavigationBar: const CustomBottomNavBar(),
        );
      },
    );
  }
}
