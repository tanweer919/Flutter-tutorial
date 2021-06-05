import 'package:flutter/cupertino.dart';
import 'dart:math' show Random;

class Country {
  String name;
  String region;
  String code;
  Color backgroundColor;
  Country(
      {this.name,
      this.region,
      this.code,
      this.backgroundColor});
  Country.fromJson({String countryCode, Map<String, dynamic> data})
      : this.code = countryCode,
        this.name = data["country"],
        this.region = data["region"],
        this.backgroundColor =
            Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
}
