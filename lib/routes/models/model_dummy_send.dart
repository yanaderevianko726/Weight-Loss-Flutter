import 'package:flutter/material.dart';

class ModelDummySend {
  String id;
  String name;
  String sendParam;
  String serviceName;
  String image;
  String type;
  String desc;
  Color color;
  bool? isCenter;

  ModelDummySend(this.id, this.name, this.serviceName, this.sendParam,
      this.color, this.image, this.isCenter, this.desc, this.type);
}
