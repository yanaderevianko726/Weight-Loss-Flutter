import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class InAppController extends GetxController{
  RxInt index = 0.obs;

  onChange(int value){
    index.value = value;
    update();
  }
}