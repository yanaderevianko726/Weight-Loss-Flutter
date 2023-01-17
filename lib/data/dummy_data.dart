
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DummyData {
  static String loginBox = "login_key_";
  static String isLogin = "is_login_key_";
  static String isIntro = "is_intro_key_";
  static String exercise_key = "workout_key_";
  static String customPlanKey = "customPlan_key_";

  // static setLogin( bool login) async {
  //   var box = Hive.box(loginBox);
  //
  //     box.put(isLogin ,login);
  //
  // }
  //
  // static getLogin() async {
  //   var box = Hive.box(loginBox);
  //
  //
  //
  //  return box.get(isLogin) ?? false;
  //
  //
  //
  // }




  static Future<SharedPreferences> getPrefInstance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences;
  }

  static setDuration(String key, int value,{String? customPlanId}) async {
    var box = Hive.box(exercise_key);

    box.put(exercise_key + key, value);

    if(customPlanId!=null){
      box.put(customPlanKey + key, customPlanId);
    }

    SharedPreferences preferences = await getPrefInstance();
    preferences.setInt(exercise_key + key, value);
  }



  static Future<String> getCustomPlanId(String key) async {
    var box = Hive.box(exercise_key);

    var id = box.get(customPlanKey + key);

    return id == null ? '' : id;
  }


  static Future<int> getDuration(String key) async {
    var box = Hive.box(exercise_key);

    var duration = box.get(exercise_key + key);

    print("duration===$duration");

    if (duration == null) {
      box.put(exercise_key + key, 10);
    }

    return duration == null ? 10 : duration;
  }

  static Future<void> removeAllData() async {
    Hive.box(exercise_key).clear();
  }


  static Future<void> removeExercise(String key) async {
    var box = Hive.box(exercise_key);


    box.delete(exercise_key+key);
    box.delete(customPlanKey+key);

  }

//
//
//  saveExerciseKeyList(Map episodesList) async {
//    SharedPreferences pathEpisodesList = await SharedPreferences.getInstance();
//    // Map<String, dynamic> json = {'list': episodesList};
//    pathEpisodesList.setString('EpisodesList', jsonEncode(episodesList));
//
//
//  }
//
//
//
//
// Future<Map<String,int>> getExerciseKeyList() async {
//    SharedPreferences pathEpisodesList = await SharedPreferences.getInstance();
//    Map<String,int> episodesData =Map<String,int>();
//
//    if(pathEpisodesList.getString(exercise_key) == null){
//      return episodesData;
//    }else{
//
//
//
//
//      episodesData = await Map<String, int>.from(jsonDecode(pathEpisodesList.getString(exercise_key)??''));
//
//    }
//
//
//    return episodesData;
//
//    // Map map = await jsonDecode(pathEpisodesList.getString(exercise_key)??'');
//
//    // if (pathEpisodesList.getString(exercise_key) == "[]") {
//    // } else {
//    //   var episodesData = await json.decode(pathEpisodesList.getString(exercise_key));
//    //   return episodesData;
//    // }
//  }
//   Future<int> getDurationFromKey(String key) async {
//
//
//    Map<String,int> episodesData = await getExerciseKeyList();
//
//
//    if(episodesData[key] == null){
//      episodesData[key] =10;
//      return 10;
//    }else{
//
//      return episodesData[key] as int ;
//    }
//
//
//
//
//  }

}
