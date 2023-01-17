import 'package:flutter/cupertino.dart';
import 'package:women_workout/util/color_category.dart';

import '../models/intro_model.dart';
import '../models/modal_activity.dart';
import '../models/modal_chart.dart';
import '../models/modal_custom_workout.dart';
import '../models/modal_select_workout.dart';

import '../models/model_country.dart';

class DataFile {
  static List<IntroModel> getIntroModel(BuildContext context) {
    List<IntroModel> introList = [];

    IntroModel mainModel = new IntroModel();
    mainModel.id = 1;
    mainModel.name = "Make Perfect Body BY Doing Daily Workouts.";
    mainModel.image = "intro_1.png";
    mainModel.svg = "shape_1.svg";
    mainModel.color = "#FFFFFF".toColor();
    // mainModel.desc =
    //     "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod ";
    introList.add(mainModel);

    mainModel = new IntroModel();
    mainModel.id = 2;
    mainModel.name = "Shot Strong Fitness Program.";
    mainModel.image = "intro_2.png";
    mainModel.svg = "shape_2.svg";
    mainModel.color = "#FFFFFF".toColor();

    // mainModel.desc =
    //     "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod ";
    introList.add(mainModel);

    mainModel = new IntroModel();
    mainModel.id = 3;
    mainModel.svg = "shape_3.svg";
    mainModel.name = "Healthy Muscular Sportswomen Standing.";
    mainModel.image = "intro_3.png";
    mainModel.color = "#FFFFFF".toColor();
    // mainModel.desc =
    //     "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod ";
    introList.add(mainModel);

    mainModel = new IntroModel();
    mainModel.id = 4;
    mainModel.svg = "shape_4.svg";
    mainModel.name = "Workout Anywhere";
    mainModel.image = "intro_4.png";
    mainModel.color = "#FFFFFF".toColor();
    // mainModel.desc =
    //     "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod ";
    introList.add(mainModel);

    return introList;
  }

  static List<ModelCountry> countryList = [
    ModelCountry("image_fghanistan.jpg", "Afghanistan (AF)", "+93"),
    ModelCountry("image_ax.jpg", "Aland Islands (AX)", "+358"),
    ModelCountry("image_albania.jpg", "Albania (AL)", "+355"),
    ModelCountry("image_andora.jpg", "Andorra (AD)", "+376"),
    ModelCountry("image_islands.jpg", "Aland Islands (AX)", "+244"),
    ModelCountry("image_angulia.jpg", "Anguilla (AL)", "+1"),
    ModelCountry("image_armenia.jpg", "Armenia (AN)", "+374"),
    ModelCountry("image_austia.jpg", "Austria (AT)", "+372"),
    ModelCountry("india.png", "India (IN)", "+91")
  ];

  static List<ModalCustomWorkout> customWorkoutLists = [
    ModalCustomWorkout("Workout-1", "14"),
    ModalCustomWorkout("Workout-2", "14"),
    ModalCustomWorkout("Workout-3", "14")
  ];

  static List<ModalSelectWorkout> selectWorkoutLists = [
    ModalSelectWorkout("Insane Six Pack", 10, false, 40),
    ModalSelectWorkout("Complex Core", 10, false, 40),
    ModalSelectWorkout("Strong Back", 10, false, 40),
    ModalSelectWorkout("Complex Lower Body", 10, false, 40),
    ModalSelectWorkout("Explosive Power Jumps", 10, false, 40),
    ModalSelectWorkout('Chest & Arm', 10, false, 40),
    ModalSelectWorkout("Shoulder & Upper Back", 10, false, 40)
  ];

  static List<ModalActivity> activitylists = [
    ModalActivity("Insane Six Pack", "Wed,13 june"),
    ModalActivity("Complex Core", "Fri,14 july"),
    ModalActivity("Strong Back", "Mon,13 june"),
    ModalActivity("Insane Six Pack", "Wed,13 june"),
    ModalActivity("Insane Six Pack", "Wed,13 june")
  ];


  static List<SalesData> salesLists = [
    SalesData('11 Jan', 0),
    SalesData('12 Feb', 28),
    SalesData('11 Mar', 34),
  ];
}
