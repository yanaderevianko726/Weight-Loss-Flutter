import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../utils/constant.dart';

class CommonQuestionsController extends GetxController {
  final List<String> appQueList = [
    "txtAboutAppQue1".tr,
    "txtAboutAppQue2".tr,
    "txtAboutAppQue3".tr
  ];
  final List<String> workoutQueList = [
    "txtAboutWorkoutQue1".tr,
    "txtAboutWorkoutQue2".tr,
    "txtAboutWorkoutQue3".tr
  ];
  final List<String> paymentQueList = [
    "txtAboutPaymentQue1".tr,
    "txtAboutPaymentQue2".tr,
    "txtAboutPaymentQue3".tr,
    "txtAboutPaymentQue4".tr,
    "txtAboutPaymentQue5".tr
  ];

  final List<String> appAnsList = [
    "txtAboutAppAns1".tr,
    "txtAboutAppAns2".tr,
    "txtAboutAppAns3".tr
  ];
  final List<String> workoutAnsList = [
    "txtAboutWorkoutAns1".tr,
    "txtAboutWorkoutAns2".tr,
    "txtAboutWorkoutAns3".tr
  ];
  final List<String> paymentAnsList = [
    "txtAboutPaymentAns1".tr,
    "txtAboutPaymentAns2".tr,
    "txtAboutPaymentAns3".tr,
    "txtAboutPaymentAns4".tr,
    "txtAboutPaymentAns5".tr
  ];

  String selectedTab = Constant.app;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void onInit() {
    itemPositionsListener.itemPositions.addListener(() {
      int pos = itemPositionsListener.itemPositions.value.first.index;
      if (pos == 0) {
        selectedTab = Constant.app;
      } else if (pos == 1) {
        selectedTab = Constant.workOut;
      } else if (pos == 2) {
        selectedTab = Constant.payment;
      }
      update([
        Constant.idChangeCommonQuestionList,
        Constant.idCommonQuestionsChip
      ]);
    });
    super.onInit();
  }

  onItemChip(String type) {
    selectedTab = type;
    if (selectedTab == Constant.app) {
      itemScrollController.jumpTo(index: 0);
    } else if (selectedTab == Constant.workOut) {
      itemScrollController.jumpTo(index: 1);
    } else if (selectedTab == Constant.payment) {
      itemScrollController.jumpTo(index: 2);
    }
    update([Constant.idCommonQuestionsChip]);
  }
}
