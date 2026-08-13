import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/database/cache/token_storage.dart';
import 'package:quiz_app_grad/core/database/cache/user_local_storage.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/services/device/login_device_metadata_service.dart';
import 'package:quiz_app_grad/core/services/notification/fcm_token.dart';
import 'package:quiz_app_grad/core/services/notification/local_votification_service.dart';
import 'package:quiz_app_grad/core/services/system/app_system_settings_service.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/auth_session.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/settings/data/models/settings_route_args.dart';
import 'package:quiz_app_grad/features/settings/domain/enums/settings_date_time_enums.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/settings/settings_cubit.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/settings/settings_state.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/theme_cubit/theme_cubit.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/change_password_bottom_sheet.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/contact_us_bottom_sheet.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/date_and_time_bottom_sheet.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/reminders_and_alerts_bottom_sheet.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/settings_profile_header.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/settings_switch_tile.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/settings_tile.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/social_accounts_bottom_sheet.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/home/study_plan_home_header.dart';
import 'package:quiz_app_grad/features/study_alarm/services/study_alarm_scheduler_service.dart';

class SettingsView extends StatefulWidget {
  final SettingsRouteArgs args;

  const SettingsView({super.key, required this.args});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _isCompletingLogout = false;

  final TextEditingController currentPasswordController =
      TextEditingController();

  final TextEditingController newPasswordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> _logout() async {
    final settingsCubit = context.read<SettingsCubit>();

    if (settingsCubit.state.isLoggingOut || _isCompletingLogout) {
      return;
    }

    setState(() {
      _isCompletingLogout = true;
    });

    debugPrint('============ SettingsView._logout ============');

    try {
      await sl<StudyAlarmSchedulerService>().cancelAllStudyAlarms();
    } catch (error, stackTrace) {
      debugPrint('× cancelling study alarms before logout failed: $error');
      debugPrint('→ stackTrace: $stackTrace');

      if (mounted) {
        setState(() {
          _isCompletingLogout = false;
        });
        showValidationTopSnackBar(
          context,
          title: 'تعذر تسجيل الخروج بأمان',
          message:
              'لم نتمكن من إلغاء المنبهات المجدولة. حاول تسجيل الخروج مرة أخرى.',
          type: AppValidationSnackBarType.error,
        );
      }
      return;
    }

    String? deviceId;
    try {
      final metadata = await sl<LoginDeviceMetadataService>().getMetadata();
      deviceId = metadata.deviceId;
    } catch (error) {
      debugPrint('⚠ could not read device metadata during logout: $error');
    }

    await settingsCubit.logout(
      fcmToken: FcmTokenStorage.getToken(),
      deviceId: deviceId,
      reportFailure: false,
    );

    await Future.wait([
      TokenStorage.clear(),
      FcmTokenStorage.clear(),
      UserLocalStorage.clear(),
    ]);

    sl<AuthSession>().markUnauthenticated();

    if (!mounted) {
      return;
    }

    context.goNamed(AppRouterName.welcome);
  }

  Future<void> _openNotificationSettings() async {
    try {
      await AppSystemSettingsService.openNotificationSettings();
    } catch (error) {
      if (!mounted) return;
      showValidationTopSnackBar(
        context,
        title: 'تعذر فتح الإعدادات',
        message: 'افتح إعدادات الجهاز ثم اختر إشعارات التطبيق.',
        type: AppValidationSnackBarType.error,
      );
    }
  }

  Future<void> _testNotification() async {
    try {
      await LocalNotificationService.showTestNotification();
      if (!mounted) return;
      // showValidationTopSnackBar(
      //   context,
      //   title: 'تم إرسال الإشعار',
      //   message: 'تحقق من مركز إشعارات جهازك لمشاهدة شكله.',
      //   type: AppValidationSnackBarType.success,
      // );
    } catch (error) {
      if (!mounted) return;
      showValidationTopSnackBar(
        context,
        title: 'تعذر عرض الإشعار',
        message: 'تأكد من منح التطبيق إذن الإشعارات ثم حاول مجددًا.',
        type: AppValidationSnackBarType.error,
      );
    }
  }

  Future<void> _testAlarm() async {
    try {
      await sl<StudyAlarmSchedulerService>().scheduleTestStudyAlarm();
      if (!mounted) return;
      showValidationTopSnackBar(
        context,
        title: 'تم إعداد المنبه',
        message: 'سيرن المنبه التجريبي خلال 3 ثوانٍ.',
        type: AppValidationSnackBarType.success,
      );
    } catch (error) {
      if (!mounted) return;
      showValidationTopSnackBar(
        context,
        title: 'تعذر إعداد المنبه',
        message: 'تحقق من أذونات المنبهات في إعدادات الجهاز وحاول مجددًا.',
        type: AppValidationSnackBarType.error,
      );
    }
  }

  void _showComingSoon(String feature) {
    showValidationTopSnackBar(
      context,
      title: feature,
      message: 'سيتم ربط هذه الميزة قريبًا.',
      type: AppValidationSnackBarType.hint,
    );
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (previous, current) {
        return previous.errorMessage != current.errorMessage &&
            current.hasError;
      },
      listener: (context, state) {
        showValidationTopSnackBar(
          context,
          title: state.errorTitle ?? 'خطأ',
          message: state.errorMessage ?? 'حدث خطأ ما.',
          type: AppValidationSnackBarType.error,
        );

        context.read<SettingsCubit>().clearError();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: SizeConfig.w(0.03),
              right: SizeConfig.w(0.03),
              top: SizeConfig.h(0.03),
            ),
            child: Column(
              children: [
                StudyPlanHomeHeader(
                  title: 'الإعدادات',
                  actionIcon: Icons.arrow_back_ios_rounded,
                  onActionTap: () {
                    context.pop();
                  },
                ),

                SizedBox(height: SizeConfig.h(0.015)),

                CustomBackgroundWithChild(
                  width: double.infinity,
                  backgroundColor: context.appColors.greyToGreyMediumDark,
                  borderRadius: BorderRadius.circular(16),
                  childHorizontalPad: SizeConfig.w(0.04),
                  childVerticalPad: SizeConfig.h(0.02),
                  child: SettingsProfileHeader(
                    name: widget.args.name,
                    email: widget.args.email,
                    imageUrl: widget.args.imageUrl,
                  ),
                ),

                SizedBox(height: SizeConfig.h(0.015)),

                Expanded(
                  child: BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, state) {
                      if (state.isLoading && !state.hasSettings) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final settings = state.settings;

                      return RefreshIndicator(
                        onRefresh: () {
                          return context.read<SettingsCubit>().getSettings();
                        },
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          children: [
                            SettingsTile(
                              title: 'التذكيرات والتنبيهات',
                              subtitle:
                                  'مركز الإشعارات - المنبه - التحكم بالتذكير للخطة الدراسية',
                              icon: Icons.notifications_outlined,
                              iconColor: Colors.green,
                              iconBackgroundColor: Colors.green.withValues(
                                alpha: .15,
                              ),
                              onTap: settings == null
                                  ? null
                                  : () {
                                      showRemindersAndAlertsBottomSheet(
                                        context: context,
                                        taskRemindersEnabled:
                                            settings.taskRemindersEnabled,
                                        onTaskRemindersChanged: (value) async {
                                          debugPrint(
                                            "============ SettingsView.toggleTaskReminders ============",
                                          );

                                          return context
                                              .read<SettingsCubit>()
                                              .setTaskRemindersEnabled(
                                                enabled: value,
                                              );
                                        },
                                        onOpenNotificationSettings: () {
                                          unawaited(
                                            _openNotificationSettings(),
                                          );
                                        },
                                        onTestNotification: () {
                                          unawaited(_testNotification());
                                        },
                                        onTestAlarm: () {
                                          unawaited(_testAlarm());
                                        },
                                      );
                                    },
                              bottomRadius: 0,
                            ),

                            SettingsTile(
                              title: 'التاريخ والوقت',
                              subtitle: settings == null
                                  ? 'بداية الأسبوع - تنسيق الوقت'
                                  : '${settings.weekStartsOn} - '
                                        '${settings.timeFormat}',
                              icon: Icons.calendar_month_outlined,
                              iconColor: Colors.green,
                              iconBackgroundColor: Colors.green.withValues(
                                alpha: .15,
                              ),
                              onTap:
                                  settings == null || state.isUpdatingDateTime
                                  ? null
                                  : () {
                                      var selectedWeekStartDay =
                                          weekStartDayFromApi(
                                            settings.weekStartsOn,
                                          );

                                      var selectedTimeFormat =
                                          appTimeFormatFromApi(
                                            settings.timeFormat,
                                          );

                                      showDateAndTimeBottomSheet(
                                        context: context,
                                        selectedWeekStartDay:
                                            selectedWeekStartDay,
                                        selectedTimeFormat: selectedTimeFormat,
                                        onWeekStartDayChanged: (day) async {
                                          debugPrint(
                                            'Requested week start: ${day.apiValue}',
                                          );

                                          final success = await context
                                              .read<SettingsCubit>()
                                              .updateDateTime(
                                                weekStartsOn: day.apiValue,
                                                timeFormat:
                                                    selectedTimeFormat.apiValue,
                                              );

                                          if (success) {
                                            selectedWeekStartDay = day;
                                          }

                                          return success;
                                        },
                                        onTimeFormatChanged: (format) async {
                                          debugPrint(
                                            'Requested time format: ${format.apiValue}',
                                          );

                                          final success = await context
                                              .read<SettingsCubit>()
                                              .updateDateTime(
                                                weekStartsOn:
                                                    selectedWeekStartDay
                                                        .apiValue,
                                                timeFormat: format.apiValue,
                                              );

                                          if (success) {
                                            selectedTimeFormat = format;
                                          }

                                          return success;
                                        },
                                      );
                                    },
                              topRadius: 0,
                            ),

                            SizedBox(height: SizeConfig.h(0.02)),

                            SettingsSwitchTile(
                              title: 'المظهر',
                              subtitle: settings == null
                                  ? 'يمكنك التبديل بين الخيار الليلي والنهاري'
                                  : _themeSubtitle(settings.themeMode),
                              icon: _themeIcon(settings?.themeMode),
                              iconColor: Colors.blue,
                              iconBackgroundColor: Colors.blue.withValues(
                                alpha: .15,
                              ),
                              value: _isDarkTheme(settings?.themeMode),
                              onChanged:
                                  settings == null || state.isUpdatingTheme
                                  ? null
                                  : (value) async {
                                      final serverThemeMode = value
                                          ? 'ليلي'
                                          : 'نهاري';

                                      final appThemeMode = value
                                          ? ThemeMode.dark
                                          : ThemeMode.light;

                                      debugPrint(
                                        "============ SettingsView.changeTheme ============",
                                      );

                                      debugPrint(
                                        "→ serverThemeMode: $serverThemeMode",
                                      );

                                      final success = await context
                                          .read<SettingsCubit>()
                                          .updateThemeMode(
                                            themeMode: serverThemeMode,
                                          );

                                      if (!context.mounted || !success) {
                                        return;
                                      }

                                      await context
                                          .read<ThemeCubit>()
                                          .changeTheme(appThemeMode);
                                    },
                              bottomRadius: 0,
                            ),

                            SettingsTile(
                              title: 'تأكيد المستوى العلمي',
                              subtitle:
                                  'يساعدك ذلك في الحصول على شارة تأكيد الحساب',
                              icon: Icons.school_outlined,
                              iconColor: Colors.blue,
                              iconBackgroundColor: Colors.blue.withValues(
                                alpha: .15,
                              ),
                              onTap: () {
                                debugPrint("go to  verify academic ");
                                context.pushNamed(
                                  AppRouterName.academicVerification,
                                );
                              },
                              // =>
                              // _showComingSoon('تأكيد المستوى العلمي'),
                              topRadius: 0,
                            ),

                            SizedBox(height: SizeConfig.h(0.02)),

                            SettingsTile(
                              title: 'الاختبارات المباعة',
                              subtitle:
                                  'قائمة مشتريات المستخدمين لعناصرك داخل التطبيق',
                              icon: Icons.groups_outlined,
                              iconColor: Colors.pink,
                              iconBackgroundColor: Colors.pink.withValues(
                                alpha: .15,
                              ),
                              onTap: () {
                                debugPrint(
                                  '============ SettingsView.openSoldTests ============',
                                );
                                debugPrint(
                                  '→ route: ${AppRouterName.soldTests}',
                                );

                                context.pushNamed(AppRouterName.soldTests);
                              },
                              //_showComingSoon('الاختبارات المباعة'),
                            ),

                            SizedBox(height: SizeConfig.h(0.02)),

                            SettingsTile(
                              title: 'الاختبارات المشتراة',
                              subtitle:
                                  'قائمة الاختبارات التي اشتريتها داخل التطبيق',
                              icon: Icons.shopping_bag_outlined,
                              iconColor: Colors.deepPurple,
                              iconBackgroundColor: Colors.deepPurple
                                  .withValues(alpha: .15),
                              onTap: () {
                                context.pushNamed(AppRouterName.purchasedTests);
                              },
                            ),

                            SizedBox(height: SizeConfig.h(0.02)),

                            SettingsTile(
                              title: 'تغيير كلمة المرور',
                              subtitle:
                                  'يمكنك تغير كلمة المرور الخاصة بك بكل سهولة',
                              icon: Icons.key_outlined,
                              iconColor: Colors.amber,
                              iconBackgroundColor: Colors.amber.withValues(
                                alpha: .15,
                              ),
                              onTap: () {
                                currentPasswordController.clear();
                                newPasswordController.clear();
                                confirmPasswordController.clear();

                                showChangePasswordBottomSheet(
                                  context: context,
                                  currentPasswordController:
                                      currentPasswordController,
                                  newPasswordController: newPasswordController,
                                  confirmPasswordController:
                                      confirmPasswordController,
                                  isLoading: state.isUpdatingPassword,
                                  onSubmit: () async {
                                    final success = await context
                                        .read<SettingsCubit>()
                                        .updatePassword(
                                          oldPassword: currentPasswordController
                                              .text
                                              .trim(),
                                          newPassword: newPasswordController
                                              .text
                                              .trim(),
                                          newPasswordConfirmation:
                                              confirmPasswordController.text
                                                  .trim(),
                                        );

                                    if (!context.mounted || !success) {
                                      return;
                                    }

                                    Navigator.of(context).pop();

                                    currentPasswordController.clear();
                                    newPasswordController.clear();
                                    confirmPasswordController.clear();
                                  },
                                );
                              },
                              bottomRadius: 0,
                            ),

                            SettingsTile(
                              title: 'تواصل معنا',
                              subtitle: 'للابلاغ عن أي مشاكل تقنية في التطبيق',
                              icon: Icons.support_agent_outlined,
                              iconColor: Colors.orange,
                              iconBackgroundColor: Colors.orange.withValues(
                                alpha: .15,
                              ),
                              onTap: () {
                                showContactUsBottomSheet(
                                  context: context,
                                  onGmailTap: () {
                                    _showComingSoon('التواصل عبر Gmail');
                                  },
                                  onOutlookTap: () {
                                    _showComingSoon('التواصل عبر Outlook');
                                  },
                                );
                              },
                              topRadius: 0,
                              bottomRadius: 0,
                            ),

                            SettingsTile(
                              title: 'حساباتنا على مواقع التواصل',
                              icon: Icons.public_outlined,
                              iconColor: Colors.orange,
                              iconBackgroundColor: Colors.orange.withValues(
                                alpha: .15,
                              ),
                              onTap: () {
                                showSocialAccountsBottomSheet(
                                  context: context,
                                  onFacebookTap: () {
                                    _showComingSoon('Facebook');
                                  },
                                  onInstagramTap: () {
                                    _showComingSoon('Instagram');
                                  },
                                  onTelegramTap: () {
                                    _showComingSoon('Telegram');
                                  },
                                  onYouTubeTap: () {
                                    _showComingSoon('YouTube');
                                  },
                                );
                              },
                              topRadius: 0,
                            ),

                            SizedBox(height: SizeConfig.h(0.02)),

                            SettingsTile(
                              title: 'تسجيل الخروج',
                              subtitle:
                                  'مغادرة التطبيق مع حفظ كامل معلوماتك وبيانتك',
                              icon: Icons.logout_rounded,
                              iconColor: Colors.red,
                              iconBackgroundColor: Colors.red.withValues(
                                alpha: .15,
                              ),
                              onTap: state.isLoggingOut || _isCompletingLogout
                                  ? null
                                  : _logout,
                            ),

                            SizedBox(height: SizeConfig.h(0.01)),
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: SizeConfig.h(0.025),
                              ),
                              child: Row(
                                textDirection: TextDirection.rtl,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: SettingsFooterActionButton(
                                      title: 'سياسة الخصوصية',
                                      icon: Icons.privacy_tip_outlined,
                                      onTap: () {
                                        debugPrint(
                                          '============ SettingsView.openPrivacyPolicy ============',
                                        );

                                        _showComingSoon('سياسة الخصوصية');
                                      },
                                    ),
                                  ),

                                  SizedBox(width: SizeConfig.w(0.025)),

                                  Flexible(
                                    child: SettingsFooterActionButton(
                                      title: 'من نحن',
                                      icon: Icons.info_outline_rounded,
                                      onTap: () {
                                        debugPrint(
                                          '============ SettingsView.openAboutUs ============',
                                        );

                                        _showComingSoon('من نحن');
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isDarkTheme(String? themeMode) {
    final normalizedThemeMode = themeMode?.trim().toLowerCase() ?? '';

    return normalizedThemeMode == 'ليلي' ||
        normalizedThemeMode == 'داكن' ||
        normalizedThemeMode == 'dark';
  }

  IconData _themeIcon(String? themeMode) {
    return _isDarkTheme(themeMode)
        ? Icons.dark_mode_outlined
        : Icons.wb_sunny_outlined;
  }

  String _themeSubtitle(String themeMode) {
    if (_isDarkTheme(themeMode)) {
      return 'المظهر الليلي مفعل حالياً';
    }

    return 'المظهر النهاري مفعل حالياً';
  }
}

class SettingsFooterActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const SettingsFooterActionButton({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.025),
            vertical: SizeConfig.h(0.005),
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppPalette.greyLight , width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: TextDirection.rtl,
            children: [
              Icon(
                icon,
                color: appColors.primaryToPrimaryDark,
                size: SizeConfig.text(0.047).clamp(18.0, 23.0).toDouble(),
              ),
              SizedBox(width: SizeConfig.w(0.015)),
              CustomTextWidget(
                title,
                color: appColors.blackToGrey2Dark,
                fontSize: SizeConfig.text(0.031).clamp(11.0, 14.0).toDouble(),
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
