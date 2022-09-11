import 'dart:math';

import 'package:blankpassword/app.dart';
import 'package:flutter/material.dart';

class GeneratePasswordOption {
  var length = 16;
  var minUpperCase = 0;
  var upperCase = true;
  var minLowerCase = 0;
  var lowerCase = true;
  var minNumber = 0;
  var number = true;
  var minSpecial = 0;
  var special = true;
  var ambiguous = false;
}

enum Case { upper, lower, number, special, any }

String generatePassword(GeneratePasswordOption o) {
  var random = Random.secure();
  List<Case> positions = [];

  final minLength = o.minUpperCase + o.minLowerCase + o.minNumber + o.minSpecial;
  final length = max(minLength, o.length);

  add(bool add, int min, Case val) {
    if (add && min > 0) {
      for (var i = 0; i < min; ++i) {
        positions.add(val);
      }
    }
  }

  add(o.number, o.minNumber, Case.number);
  add(o.lowerCase, o.minLowerCase, Case.lower);
  add(o.upperCase, o.minUpperCase, Case.upper);
  add(o.special, o.minSpecial, Case.special);
  while (positions.length < length) {
    positions.add(Case.any);
  }
  positions.shuffle(random);

  var allCharSet = "";

  var lowerCaseCharSet = "abcdefghijkmnopqrstuvwxyz";
  if (o.ambiguous) {
    lowerCaseCharSet += "l";
  }
  if (o.lowerCase) {
    allCharSet += lowerCaseCharSet;
  }

  var upperCaseCharSet = "ABCDEFGHJKLMNPQRSTUVWXYZ";
  if (o.ambiguous) {
    upperCaseCharSet = "IO";
  }
  if (o.upperCase) {
    allCharSet += upperCaseCharSet;
  }

  var numberCharSet = "23456789";
  if (o.ambiguous) {
    numberCharSet += "01";
  }
  if (o.number) {
    allCharSet += numberCharSet;
  }

  var specialCharSet = "!@#\$%^&*";
  if (o.special) {
    allCharSet += specialCharSet;
  }

  var password = StringBuffer("");

  if (allCharSet.isEmpty) {
    return "";
  }

  for (var i = 0; i < length; ++i) {
    String positionChars;
    switch (positions[i]) {
      case Case.lower:
        positionChars = lowerCaseCharSet;
        break;
      case Case.upper:
        positionChars = upperCaseCharSet;
        break;
      case Case.number:
        positionChars = numberCharSet;
        break;
      case Case.special:
        positionChars = specialCharSet;
        break;
      case Case.any:
        positionChars = allCharSet;
        break;
    }

    final randomIndex = random.nextInt(positionChars.length - 1);
    password.write(positionChars[randomIndex]);
  }

  return password.toString();
}

