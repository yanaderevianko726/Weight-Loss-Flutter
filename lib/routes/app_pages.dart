import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:women_lose_weight_flutter/ui/home_detail/bindings/home_diet_binding.dart';
import 'package:women_lose_weight_flutter/ui/home_detail/bindings/home_plan_detail_binding.dart';
import 'package:women_lose_weight_flutter/ui/home_detail/views/home_diets_screen.dart';
import 'package:women_lose_weight_flutter/ui/home_detail/views/home_exercises_screen.dart';

import '../ui/about/bindings/about_binding.dart';
import '../ui/about/views/about_screen.dart';
import '../ui/access_all_features/bindings/access_all_features_binding.dart';
import '../ui/access_all_features/views/access_all_features.dart';
import '../ui/choose_height/bindings/choose_height_binding.dart';
import '../ui/choose_height/views/choose_height_screen.dart';
import '../ui/choose_target_weight/bindings/choose_target_weight_binding.dart';
import '../ui/choose_target_weight/views/choose_target_weight_screen.dart';
import '../ui/choose_weight/bindings/choose_weight_binding.dart';
import '../ui/choose_weight/views/choose_weight_screen.dart';
import '../ui/choose_your_plan/bindings/choose_your_plan_binding.dart';
import '../ui/choose_your_plan/views/choose_your_plan_screen.dart';
import '../ui/common_questions/bindings/common_questions_binding.dart';
import '../ui/common_questions/views/common_questions_screen.dart';
import '../ui/completed/bindings/completed_binding.dart';
import '../ui/completed/views/completed_screen.dart';
import '../ui/create_new_password/bindings/create_new_password_binding.dart';
import '../ui/create_new_password/views/create_new_password_screen.dart';
import '../ui/days_plan_detail/bindings/days_plan_detail_binding.dart';
import '../ui/days_plan_detail/views/days_plan_detail_screen.dart';
import '../ui/diet_adjust/bindings/diet_adjust_binding.dart';
import '../ui/diet_adjust/bindings/diet_adjust_detail_binding.dart';
import '../ui/diet_adjust/views/diet_detail_create.dart';
import '../ui/diet_adjust/views/diets_adjust_details_screen.dart';
import '../ui/diet_adjust/views/diets_adjust_screen.dart';
import '../ui/edit_plan/bindings/edit_plan_binding.dart';
import '../ui/edit_plan/views/edit_plan_screen.dart';
import '../ui/email_verified/bindings/email_verified_binding.dart';
import '../ui/email_verified/views/email_verified_screen.dart';
import '../ui/enter_otp/bindings/enter_otp_binding.dart';
import '../ui/enter_otp/views/enter_otp_screen.dart';
import '../ui/exercise_list/bindings/exercise_list_binding.dart';
import '../ui/exercise_list/views/exercise_list_screen.dart';
import '../ui/fast_work_out/bindings/fast_work_out_binding.dart';
import '../ui/fast_work_out/views/fast_work_out_screen.dart';
import '../ui/fast_work_out_detail/bindings/fast_work_out_detail_binding.dart';
import '../ui/fast_work_out_detail/views/fast_work_out_detail_screen.dart';
import '../ui/history/bindings/history_binding.dart';
import '../ui/history/views/history_screen.dart';
import '../ui/home/bindings/home_binding.dart';
import '../ui/home/views/home_screen.dart';
import '../ui/home_detail/bindings/home_detail_binding.dart';
import '../ui/home_detail/bindings/home_diet_detail_binding.dart';
import '../ui/home_detail/bindings/home_diet_detail_dashboard_binding.dart';
import '../ui/home_detail/views/home_detail_screen.dart';
import '../ui/home_detail/views/home_diet_detail_dashboard_screen.dart';
import '../ui/home_detail/views/home_diet_detail_screen.dart';
import '../ui/me/bindings/me_binding.dart';
import '../ui/me/views/me_screen.dart';
import '../ui/my_profile/bindings/my_profile_binding.dart';
import '../ui/my_profile/views/my_profile_screen.dart';
import '../ui/perform_exercise/bindings/perform_exercise_binding.dart';
import '../ui/perform_exercise/views/perform_exercise_screen.dart';
import '../ui/plan/bindings/plan_binding.dart';
import '../ui/plan/views/plan_screen.dart';
import '../ui/recent/bindings/recent_binding.dart';
import '../ui/recent/views/recent_screen.dart';
import '../ui/reminder/bindings/reminder_binding.dart';
import '../ui/reminder/views/reminder_screen.dart';
import '../ui/report/bindings/report_binding.dart';
import '../ui/report/views/report_screen.dart';
import '../ui/rest/bindings/rest_binding.dart';
import '../ui/rest/views/rest_screen.dart';
import '../ui/rest_day/bindings/rest_day_binding.dart';
import '../ui/rest_day/views/rest_day_screen.dart';
import '../ui/sign_in/bindings/sign_in_binding.dart';
import '../ui/sign_in/views/sign_in_screen.dart';
import '../ui/sign_up/bindings/sign_up_binding.dart';
import '../ui/sign_up/views/sign_up_screen.dart';
import '../ui/turn_on_water/bindings/turn_on_water_binding.dart';
import '../ui/turn_on_water/views/turn_on_water_screen.dart';
import '../ui/verify_your_account/bindings/verify_your_account_binding.dart';
import '../ui/verify_your_account/views/verify_your_account_screen.dart';
import '../ui/voice_options/bindings/voice_options_binding.dart';
import '../ui/voice_options/views/voice_options_screen.dart';
import '../ui/water_tracker/bindings/water_tracker_binding.dart';
import '../ui/water_tracker/views/water_tracker_screen.dart';
import '../ui/well_done/bindings/well_done_binding.dart';
import '../ui/well_done/views/well_done_screen.dart';
import '../ui/whats_your_goal/bindings/whats_your_goal_binding.dart';
import '../ui/whats_your_goal/views/whats_your_goal_screen.dart';
import '../ui/your_plan/bindings/your_plan_binding.dart';
import '../ui/your_plan/views/your_plan_screen.dart';
import '../utils/color.dart';
import 'app_routes.dart';

class AppPages {
  static var list = [
    GetPage(
      name: AppRoutes.initial,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: AppColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: ChooseYourPlanScreen(),
          );
        },
      ),
      binding: ChooseYourPlanBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: AppColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: HomeScreen(),
          );
        },
      ),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.chooseYourPlan,
      page: () => ChooseYourPlanScreen(),
      binding: ChooseYourPlanBinding(),
    ),
    GetPage(
      name: AppRoutes.chooseWeight,
      page: () => ChooseWeightScreen(),
      binding: ChooseWeightBinding(),
    ),
    GetPage(
      name: AppRoutes.chooseTargetWeight,
      page: () => ChooseTargetWeightScreen(),
      binding: ChooseTargetWeightBinding(),
    ),
    GetPage(
      name: AppRoutes.chooseHeight,
      page: () => ChooseHeightScreen(),
      binding: ChooseHeightBinding(),
    ),
    GetPage(
      name: AppRoutes.yourPlan,
      page: () => YourPlanScreen(),
      binding: YourPlanBinding(),
    ),
    GetPage(
      name: AppRoutes.plan,
      page: () => PlanScreen(),
      binding: PlanBinding(),
    ),
    GetPage(
      name: AppRoutes.whatsYourGoal,
      page: () => WhatsYourGoalScreen(),
      binding: WhatsYourGoalBinding(),
    ),
    GetPage(
      name: AppRoutes.me,
      page: () => MeScreen(),
      binding: MeBinding(),
    ),
    GetPage(
      name: AppRoutes.wellDoneDone,
      page: () => const WellDoneScreen(),
      binding: WellDoneBinding(),
    ),
    GetPage(
      name: AppRoutes.turnOnWater,
      page: () => TurnOnWaterScreen(),
      binding: TurnOnWaterBinding(),
    ),
    GetPage(
      name: AppRoutes.waterTracker,
      page: () => const WaterTrackerScreen(),
      binding: WaterTrackerBinding(),
    ),
    GetPage(
      name: AppRoutes.fastWorkOut,
      page: () => FastWorkOutScreen(),
      binding: FastWorkOutBinding(),
    ),
    GetPage(
      name: AppRoutes.recent,
      page: () => const RecentScreen(),
      binding: RecentBinding(),
    ),
    GetPage(
      name: AppRoutes.dietAdjustPage,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: AppColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: DietAdjustScreen(),
          );
        },
      ),
      binding: DietAdjustBinding(),
    ),
    GetPage(
      name: AppRoutes.dietAdjustDetail,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: AppColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: DietAdjustDetailsScreen(),
          );
        },
      ),
      binding: DietAdjustDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.dietDetailCreatePage,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return const AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: AppColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: DietDetailCreateScreen(),
          );
        },
      ),
      binding: DietAdjustBinding(),
    ),
    GetPage(
      name: AppRoutes.dietsPage,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: AppColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: DietsScreen(),
          );
        },
      ),
      binding: HomeDietsBinding(),
    ),
    GetPage(
      name: AppRoutes.exercisesPage,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: AppColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: ExercisesScreen(),
          );
        },
      ),
      binding: HomePlanDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.dietDetail,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: AppColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: HomeDietDetailScreen(),
          );
        },
      ),
      binding: HomeDietDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.dietDetailDashboard,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: AppColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: HomeDietDetailDashboard(),
          );
        },
      ),
      binding: HomeDietDetailDashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.homeDetail,
      page: () => HomeDetailScreen(),
      binding: HomeDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.reminder,
      page: () => ReminderScreen(),
      binding: ReminderBinding(),
    ),
    GetPage(
      name: AppRoutes.myProfile,
      page: () => const MyProfileScreen(),
      binding: MyProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.voiceOptions,
      page: () => VoiceOptionsScreen(),
      binding: VoiceOptionsBinding(),
    ),
    GetPage(
      name: AppRoutes.commonQuestions,
      page: () => CommonQuestionsScreen(),
      binding: CommonQuestionsBinding(),
    ),
    GetPage(
      name: AppRoutes.daysPlanDetail,
      page: () => DaysPlanDetailScreen(),
      binding: DaysPlanDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.fastWorkOutDetail,
      page: () => FastWorkOutDetailScreen(),
      binding: FastWorkOutDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.report,
      page: () => ReportScreen(),
      binding: ReportBinding(),
    ),
    GetPage(
      name: AppRoutes.exerciseList,
      page: () => ExerciseListScreen(),
      binding: ExerciseListBinding(),
    ),
    GetPage(
      name: AppRoutes.editPlan,
      page: () => EditPlanScreen(),
      binding: EditPlanBinding(),
    ),
    GetPage(
      name: AppRoutes.performExercise,
      page: () => PerformExerciseScreen(),
      binding: PerformExerciseBinding(),
    ),
    GetPage(
      name: AppRoutes.rest,
      page: () => RestScreen(),
      binding: RestBinding(),
    ),
    GetPage(
      name: AppRoutes.restDay,
      page: () => RestDayScreen(),
      binding: RestDayBinding(),
    ),
    GetPage(
      name: AppRoutes.history,
      page: () => HistoryScreen(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: AppRoutes.about,
      page: () => const AboutScreen(),
      binding: AboutBinding(),
    ),
    GetPage(
      name: AppRoutes.completed,
      page: () => CompletedScreen(),
      binding: CompletedBinding(),
    ),
    GetPage(
      name: AppRoutes.signIn,
      page: () => const SignInScreen(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: AppRoutes.signUp,
      page: () => const SignUpScreen(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const CreateNewPasswordScreen(),
      binding: CreateNewPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.verifyYourAccount,
      page: () => const VerifyYourAccountScreen(),
      binding: VerifyYourAccountBinding(),
    ),
    GetPage(
      name: AppRoutes.enterOtp,
      page: () => const EnterOtpScreen(),
      binding: EnterOtpBinding(),
    ),
    GetPage(
      name: AppRoutes.emailVerified,
      page: () => const EmailVerifiedScreen(),
      binding: EmailVerifiedBinding(),
    ),
    GetPage(
      name: AppRoutes.accessAllFeature,
      page: () => const AccessAllFeaturesScreen(),
      binding: AccessAllFeaturesBinding(),
    ),
  ];
}
