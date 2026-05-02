import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/views/details_of_test_view.dart';
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
              Center(child: InkWell(
                
                onTap: () {
                  context.pushNamed(AppRouterName.detailsOfTest);
                },
                child: Text("details of test" , 
                ),
              )),
              
            ],
          ),
          bottomNavigationBar: const CustomBottomNavBar(),
        );
      },
    );
  }
}
