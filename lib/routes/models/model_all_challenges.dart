// To parse this JSON data, do
//
//     final modelAllChallenge = modelAllChallengeFromJson(jsonString);

import 'dart:convert';


ModelAllChallenge modelAllChallengeFromJson(String str) =>
    ModelAllChallenge.fromJson(json.decode(str));

String modelAllChallengeToJson(ModelAllChallenge data) =>
    json.encode(data.toJson());

class ModelAllChallenge {
  ModelAllChallenge({
    required this.data,
  });

  final Data data;

  factory ModelAllChallenge.fromJson(Map<String, dynamic> json) =>
      ModelAllChallenge(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.success,
    required this.challenges,
    required this.error,
  });

  final int success;
  final List<Challenge> challenges;
  final String error;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        success: json["success"],
        challenges: List<Challenge>.from(
            json["challenges"].map((x) => Challenge.fromJson(x))),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "challenges": List<dynamic>.from(challenges.map((x) => x.toJson())),
        "error": error,
      };
}

class Challenge {
  Challenge({
    required this.challengesId,
    required this.challengesName,
    required this.image,
    required this.description,
    required this.totalweek,
    required this.totaldays,
    required this.totaldayscompleted,
  });

  final String challengesId;
  final String challengesName;
  final String image;
  final String description;
  final int totalweek;
  final int totaldays;
  final int totaldayscompleted;

  factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
        challengesId: json["challenges_id"],
        challengesName: json["challenges_name"],
        image: json["image"],
        description: json["description"],
        totalweek: json["totalweek"],
        totaldays: json["totaldays"],
        totaldayscompleted: json["totaldayscompleted"],
      );

  Map<String, dynamic> toJson() => {
        "challenges_id": challengesId,
        "challenges_name": challengesName,
        "image": image,
        "description": description,
        "totalweek": totalweek,
        "totaldays": totaldays,
        "totaldayscompleted": totaldayscompleted,
      };
}

