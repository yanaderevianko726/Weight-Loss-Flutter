import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/ui/home_detail/controllers/home_diet_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:women_lose_weight_flutter/ui/report/controllers/report_controller.dart';
import '../../../utils/constant.dart';
import '../../../utils/preference.dart';
import 'home_diet_detail_controller.dart';
import 'package:date_format/date_format.dart';

class HomeDietDetailDashboardController extends GetxController {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  bool isLoading = false;

  dynamic arguments = Get.arguments;
  DietPlan? dietPlan;
  DietDetail? dietDetail;

  final ReportController _reportController = Get.find<ReportController>();

  @override
  void onInit() {
    _getArguments();
    super.onInit();
  }

  _getArguments() {
    if (arguments != null) {
      if (arguments[0] != null) {
        dietPlan = arguments[0];
      }
      if (arguments[1] != null) {
        dietDetail = arguments[1];
      }
      update([Constant.idDietDetailsDashboard]);
    }
  }

  onAddCart(DietDetail dietDetail) async {
    final myId = Preference.shared.getString(Preference.firebaseAuthUid);
    if(myId != null && myId != ''){
      isLoading = true;
      update([Constant.idDietDetailsDashboard]);

      String? key = dbRef.child('carts').push().key;

      CartClass cart = CartClass();
      cart.cartId = key!;
      cart.userId = myId;
      cart.dietDetailId = dietDetail.detailId;
      cart.dietDetailTitle = dietDetail.detailTitle;
      cart.dietDetailImage = dietDetail.detailImage;
      cart.dietDetailCalories = dietDetail.calories;
      cart.day = convertStringFromDateWithTime(DateTime.now());
      
      await dbRef.child('carts').child(key).set(<String, String>{
        "cartId": cart.cartId,
        "userId": cart.userId,
        "dietDetailId": cart.dietDetailId,
        "day": cart.day,
        "dietDetailTitle": cart.dietDetailTitle,
        "dietDetailImage": cart.dietDetailImage,
        "dietDetailCalories": cart.dietDetailCalories,
      });
      
      isLoading = false;
      update([Constant.idDietDetailsDashboard]);

      Get.back();
    }
  }

  refreshData() {
    _reportController.refreshData();
  }

  convertStringFromDateWithTime(DateTime todayDate) {
    return formatDate(
        todayDate, ['yyyy', ', ', MM.substring(1), ' ', dd, ', ', hh, ':', nn, ' ', am]);
  }
}

class CartClass {
  String cartId;
  String userId;
  String day;
  String dietDetailId;
  String dietDetailTitle;
  String dietDetailImage;
  String dietDetailCalories;

  CartClass({
    this.cartId = '',
    this.userId = '',
    this.day = '',
    this.dietDetailId ='',
    this.dietDetailTitle ='',
    this.dietDetailImage ='',
    this.dietDetailCalories ='',
  });

  fromMap(Map<String, dynamic> map){
      cartId = map['cartId'];
      userId = map['userId'] ?? '';
      day = map['day'] ?? '';
      dietDetailId = map['dietDetailId'] ?? '';
      dietDetailTitle = map['dietDetailTitle'] ?? '';
      dietDetailImage = map['dietDetailImage'] ?? '';
      dietDetailCalories = map['dietDetailCalories'] ?? '';
  }
}
