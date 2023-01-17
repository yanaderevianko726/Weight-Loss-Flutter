import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/model_edit_profile.dart';
import '../../models/userdetail_model.dart';
import '../../util/color_category.dart';
import '../../util/constant_url.dart';
import '../../util/constant_widget.dart';
import '../../util/constants.dart';
import '../../util/pref_data.dart';
import '../../util/widgets.dart';
import 'package:get/get.dart';

import '../controller/controller.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Future<bool> _requestPop() {
    Get.back();

    return new Future.value(false);
  }

  SettingController controller = Get.put(SettingController());
  XFile? _image;
  String? imageUrl;
  int age = 0;
  int height = 0;
  int weight = 0;
  String? state;
  int intensivelyPosition = 0;
  int timeInWeekPosition = 0;
  String gender = "Male";
  String address = "dsddsd";
  String city = "sdsd";
  String country = "sdsd";
  final editForm = GlobalKey<FormState>();
  RegExp emaailExpress = new RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  Future getImage(int type) async {
    XFile? pickedImage = await ImagePicker().pickImage(
        source: type == 1 ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 50);
    return pickedImage;
  }

  getProfileImage() {
    if (_image != null) {
      return Image.file(
        File(_image!.path),
        width: 100.h,
        height: 100.h,
      );
    } else if (imageUrl != null) {
      return Image.network(ConstantUrl.uploadUrl + imageUrl!,
          width: 100.h, height: 100.h);
    } else {
      return Image.asset(Constants.assetsImagePath + "profile_imge.png",
          width: 100.h, height: 100.h);
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    String s = await PrefData.getUserDetail();
    if (s.isNotEmpty) {
      UserDetail userDetail = await ConstantUrl.getUserDetail();

      setState(() {
        controller.phoneNumberController.text = userDetail.mobile!;
        controller.nameController.text = userDetail.firstName!;
        controller.emailController.text = userDetail.email!;
        age = int.parse(userDetail.age!);
        height = int.parse(userDetail.height!);
        weight = int.parse(userDetail.weight!);

        if (userDetail.state == null) {
          state = "";
        } else {
          state = userDetail.state!;
        }

        if (userDetail.intensively != null &&
            userDetail.intensively!.isNotEmpty) {
          intensivelyPosition = int.parse(userDetail.intensively!);
        }

        if (userDetail.timeInWeek != null &&
            userDetail.timeInWeek!.isNotEmpty) {
          timeInWeekPosition = int.parse(userDetail.timeInWeek!);
        }
        print(
            "intensively----${userDetail.intensively}----${userDetail.timeInWeek}");

        gender = userDetail.gender!;

        address = userDetail.address!;
        city = userDetail.city!;
        country = userDetail.country!;

        print("imageURl----${userDetail.gender}");
        if (userDetail.image != null) {
          if (userDetail.image!.isNotEmpty) {
            imageUrl = userDetail.image;
          }
        }

        print("imageURl----${userDetail.image}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Form(
        key: editForm,
        child: Scaffold(
          backgroundColor: bgDarkWhite,
          bottomNavigationBar: Container(
            padding: EdgeInsets.only(right: 20.h, bottom: 60.h, left: 20.h),
            child: getButton(context, accentColor, "Save", Colors.white, () {
              if(editForm.currentState!.validate()){
                checkNetwork();
              }
            }, 20.sp,
                weight: FontWeight.w700,
                buttonHeight: 60.h,
                borderRadius: BorderRadius.circular(22.h)),
          ),
          body: SafeArea(
            child: ConstantWidget.getPaddingWidget(
              EdgeInsets.symmetric(horizontal: 20.h),
              Column(
                children: [
                  ConstantWidget.getVerSpace(23.h),
                  buildAppBar(),
                  ConstantWidget.getVerSpace(50.h),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      // Container(
                      //   child: getAssetImage("profile.png",
                      //       height: 100.h, width: 100.h),
                      // ),
                      ClipOval(
                        child: Material(
                          child: getProfileImage(),
                        ),
                      ),
                      Positioned(
                          child: GestureDetector(
                        onTap: () async {
                          final tmpFile = await getImage(2);
                          setState(() {
                            _image = tmpFile;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.h, vertical: 8.h),
                          height: 36.h,
                          width: 36.h,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50.h),
                              boxShadow: [
                                BoxShadow(
                                    color: containerShadow,
                                    blurRadius: 32,
                                    offset: Offset(-2, 5))
                              ]),
                          child: getSvgImage("edit.svg"),
                        ),
                      ))
                    ],
                  ),
                  ConstantWidget.getVerSpace(40.h),
                  ConstantWidget.getDefaultTextFiledWithLabel(
                      context, "Full Name", controller.nameController,
                      isEnable: false,
                      height: 50.h,
                      withprefix: true,
                      image: "profile.svg", validator: (username) {
                    if (username == null || username.isEmpty) {
                      return "Please enter usrename.";
                    }
                    return null;
                  }),
                  ConstantWidget.getVerSpace(20.h),
                  ConstantWidget.getDefaultTextFiledWithLabel(
                      context, "Email", controller.emailController,
                      isEnable: false,
                      height: 50.h,
                      withprefix: true,
                      image: "mail.svg", validator: (email) {
                    if (email == null || email.isEmpty) {
                      return "Please enter email";
                    }
                    if (!emaailExpress.hasMatch(email)) {
                      return "Please enter valid email.";
                    }
                    return null;
                  }),
                  ConstantWidget.getVerSpace(20.h),
                  ConstantWidget.getDefaultTextFiledWithLabel(
                      context, "Phone Number", controller.phoneNumberController,
                      isEnable: false,
                      height: 50.h,
                      withprefix: true,
                      image: "mail.svg", validator: (number) {
                    if (number == null || number.isEmpty) {
                      return "Please enter phone number.";
                    }
                    return null;
                  },
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return Row(
      children: [
        InkWell(
            onTap: () {
              _requestPop();
            },
            child: getSvgImage("arrow_left.svg", height: 24.h, width: 24.h)),
        ConstantWidget.getHorSpace(12.h),
        getCustomText("Edit Profile", textColor, 1, TextAlign.start,
            FontWeight.w700, 22.sp)
      ],
    );
  }

  Future<void> checkNetwork() async {
    bool isNetwork = await ConstantUrl.getNetwork();
    if (isNetwork) {
      uploadBitmap();
    } else {
      getNoInternet(context);
    }
  }

  void uploadBitmap() async {
    String s = await PrefData.getUserDetail();
    if (s.isNotEmpty) {
      UserDetail userDetail = await ConstantUrl.getUserDetail();

      String deviceId = await ConstantUrl.getDeviceId();
      String session = await PrefData.getSession();

      var request =
          http.MultipartRequest("POST", Uri.parse(ConstantUrl.urlEditProfile));
      request.fields[ConstantUrl.paramUserId] = userDetail.userId!;
      request.fields[ConstantUrl.paramSession] = session;
      request.fields[ConstantUrl.paramDeviceId] = deviceId;
      request.fields[ConstantUrl.paramFirstName] =
          controller.nameController.text;
      request.fields[ConstantUrl.paramLastName] = "sdsd";
      request.fields[ConstantUrl.paramMobile] = userDetail.mobile!;
      request.fields[ConstantUrl.paramCity] = "sdsd";
      request.fields[ConstantUrl.paramCountry] = "sdsds";
      request.fields[ConstantUrl.paramAddress] = "dsd";
      request.fields[ConstantUrl.paramAge] = age.toString();
      request.fields[ConstantUrl.paramGender] = gender;
      request.fields[ConstantUrl.paramHeight] = height.toString();
      request.fields[ConstantUrl.paramWeight] = weight.toString();
      request.fields[ConstantUrl.paramState] = state!;
      request.fields[ConstantUrl.paramTimeInWeek] =
          timeInWeekPosition.toString();
      request.fields[ConstantUrl.paramIntensively] =
          intensivelyPosition.toString();

      if (_image != null) {
        var pic = await http.MultipartFile.fromPath(
            ConstantUrl.paramImage, _image!.path);
        request.files.add(pic);
      }
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);

        Map<String, dynamic> map = json.decode(responseString);

        EditProfileModel editModel = EditProfileModel.fromJson(map);
        print("response------$responseString");
        print("editModel------$editModel");

        if (editModel.data!.success == 1) {
          print("response------12$responseString");

          if (editModel.data!.editProfile != null) {
            PrefData.setUserDetail("");
            PrefData.setUserDetail(json.encode(editModel.data!.editProfile));
            _requestPop();
          }
        }
      }
    }
  }
}
