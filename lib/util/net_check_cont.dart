import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class GetXNetworkManager extends GetxController
{

  RxBool isNetwork = false.obs;
  ConnectivityResult? connectionResult;
  ConnectivityResult connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();


  @override
  onInit() {
    initConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.onInit();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    result = await _connectivity.checkConnectivity();
    return _updateConnectionStatus(result);
  }


  updateConnectionStatus(ConnectivityResult result) {
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    connectionStatus = result;
    print("result===${result}");

    if (connectionStatus == ConnectivityResult.mobile) {
      isNetwork(true);
    } else if (connectionStatus == ConnectivityResult.wifi) {
      isNetwork(true);
    }else{
      isNetwork(false);
    }
    update();
  }

  static Future<bool> checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      return true;
    }
    return false;
  }
}






// int connectionType = 0;
//   final Connectivity _connectivity = Connectivity();
//   late StreamSubscription _streamSubscription;
//
//   @override
//   void onInit() {
//     super.onInit();
//     GetConnectionType();
//     _streamSubscription = _connectivity.onConnectivityChanged.listen(_updateState);
//   }
//   Future<void>GetConnectionType() async{
//     var connectivityResult;
//     try{
//       connectivityResult = await (_connectivity.checkConnectivity());
//     }on PlatformException catch(e){
//       print(e);
//     }
//     return _updateState(connectivityResult);
//   }
//
//   _updateState(ConnectivityResult result)
//   {
//     switch(result)
//     {
//       case ConnectivityResult.wifi:
//         connectionType=1;
//         update();
//         break;
//       case ConnectivityResult.mobile:
//         connectionType=2;
//         update();
//         break;
//       case ConnectivityResult.none:
//         connectionType=0;
//         update();
//         break;
//       default: Get.snackbar('Network Error', 'Failed to get Network Status');
//       break;
//     }
//   }
//   @override
//   void onClose() {
//     _streamSubscription.cancel();
//   }
//
// }