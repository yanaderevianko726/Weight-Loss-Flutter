import 'dart:convert';

ModelSetting modelSettingFromJson(String str) => ModelSetting.fromJson(json.decode(str));

String modelSettingToJson(ModelSetting data) => json.encode(data.toJson());

class ModelSetting {
  ModelSetting({
    required this.data,
  });

  final Data data;

  factory ModelSetting.fromJson(Map<String, dynamic> json) => ModelSetting(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.success,
    required this.setting,
    required this.error,
  });

  final int success;
  final Setting setting;
  final String error;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    success: json["success"],
    setting: Setting.fromJson(json["setting"]),
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "setting": setting.toJson(),
    "error": error,
  };
}

class Setting {
  Setting({
    required this.settingId,
    required this.challenges,
    required this.category,
    required this.discover,
    required this.quickworkout,
    required this.stretches,
  });

  final String settingId;
  final String challenges;
  final String category;
  final String discover;
  final String quickworkout;
  final String stretches;

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
    settingId: json["setting_id"],
    challenges: json["challenges"],
    category: json["category"],
    discover: json["discover"],
    quickworkout: json["quickworkout"],
    stretches: json["stretches"],
  );

  Map<String, dynamic> toJson() => {
    "setting_id": settingId,
    "challenges": challenges,
    "category": category,
    "discover": discover,
    "quickworkout": quickworkout,
    "stretches": stretches,
  };
}
