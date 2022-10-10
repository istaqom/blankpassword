import 'dart:math';

import 'package:blankpassword/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GeneratePasswordWidget extends StatefulWidget {
  const GeneratePasswordWidget({super.key});

  @override
  State<GeneratePasswordWidget> createState() => _GeneratePasswordWidgetState();
}

class _GeneratePasswordWidgetState extends State<GeneratePasswordWidget> {
  String? generatedPassword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generate Password"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, generatedPassword);
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            child: const Text("Select"),
          ),
        ],
      ),
      body: AppContainer(
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GeneratePasswordPageWidget(
              onGeneratePassword: (val) {
                generatedPassword = val;
              },
            ),
          ),
        ),
      ),
    );
  }
}

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

  final minLength =
      o.minUpperCase + o.minLowerCase + o.minNumber + o.minSpecial;
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

class GeneratePasswordPageWidget extends StatefulWidget {
  const GeneratePasswordPageWidget(
      {super.key, required this.onGeneratePassword});

  final Function(String) onGeneratePassword;

  @override
  State<GeneratePasswordPageWidget> createState() =>
      GeneratePasswordPageWidgetState();
}

class GeneratePasswordPageWidgetState
    extends State<GeneratePasswordPageWidget> {
  String generatedPassword = "";
  GeneratePasswordOption options = GeneratePasswordOption();
  var lengthController = TextEditingController(text: "1");

  @override
  void initState() {
    super.initState();

    lengthController.text = options.length.toString();
    lengthController.addListener(() {
      options.length = int.tryParse(lengthController.text) ?? 1;
      applyGeneratedPassword();
    });

    applyGeneratedPassword();
  }

  void applyGeneratedPassword() {
    setGeneratedPassword(generatePassword(options));
  }

  void setGeneratedPassword(String password) {
    setState(() {
      generatedPassword = password;
      widget.onGeneratePassword(password);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          generatedPassword,
          style: const TextStyle(
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        ElevatedButton(
          child: const Text("Generate Password"),
          onPressed: () {
            applyGeneratedPassword();
          },
        ),
        TextButton(
            child: const Text("Copy Password"),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: generatedPassword)).then(
                (_) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Password copied to clipboard")));
                },
              );
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Length"),
            const SizedBox(width: 10),
            Flexible(
              child: TextField(controller: lengthController),
            ),
            Expanded(
              child: Slider(
                min: 1,
                max: 128,
                value: double.tryParse(lengthController.text) ?? 1,
                onChanged: (val) {
                  setState(() {
                    lengthController.text = val.round().toString();
                  });
                },
              ),
            )
          ],
        ),
        TextToggle(
          value: options.upperCase,
          title: "A-Z",
          onChanged: (val) {
            options.upperCase = val;
            applyGeneratedPassword();
          },
        ),
        TextToggle(
          value: options.lowerCase,
          title: "a-z",
          onChanged: (val) {
            options.lowerCase = val;
            applyGeneratedPassword();
          },
        ),
        TextToggle(
          value: options.number,
          title: "0-9",
          onChanged: (val) {
            options.number = val;
            applyGeneratedPassword();
          },
        ),
        TextToggle(
          value: options.special,
          title: "!@#\$%^&*",
          onChanged: (val) {
            options.special = val;
            applyGeneratedPassword();
          },
        ),
      ],
    );
  }
}

class TextToggle extends StatelessWidget {
  const TextToggle(
      {super.key,
      required this.value,
      required this.title,
      required this.onChanged});

  final String title;
  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title),
        const Spacer(),
        Switch(
          value: value,
          onChanged: onChanged,
        )
      ],
    );
  }
}
