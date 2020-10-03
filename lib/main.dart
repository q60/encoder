import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'dart:math';

void main() => runApp(MyApp());

class MainTheme {
  static const Color _colorTextMain       = Color(0xFFBFC7D5);
  static const Color _colorTextHeaderBack = Color(0xFF939EDE);
  static const Color _colorTextHeaderFore = Color(0xFF292D3E);
  static const Color _colorIcon           = Color(0xFFFF5370);
  static const Color _colorDarkMain       = Color(0xFF292D3E);
}

class Encoders {
  String rot13(toEncodeText) {
    String encodedText = '';
    toEncodeText.runes.forEach(
      (int rune) {
        int charNormal = String
          .fromCharCode(rune)
          .codeUnitAt(0);
        int charUpper = String
          .fromCharCode(rune)
          .toUpperCase()
          .codeUnitAt(0);
        if (charUpper <= 77 && 65 <= charUpper) {
          encodedText += String.fromCharCode(charNormal + 13);
        } else if (charUpper <= 90 && 77 <= charUpper) {
          encodedText += String.fromCharCode(charNormal - 13);
        } else {
          encodedText += String.fromCharCode(charNormal);
        }
      }
    );
    return encodedText;
  }

  String reverse(toEncodeText) {
    String encodedText = '';
    encodedText = toEncodeText
      .split('')
      .reversed
      .join('');
    return encodedText;
  }

  String encodeBaseN(toEncodeText, _base) {
    String encodedText = '';
    toEncodeText
      .runes
      .forEach(
        (rune) {
          encodedText += rune
            .toRadixString(_base)
            .toUpperCase()
            + ' ';
        }
    );
    encodedText = encodedText
      .substring(
        0,
        encodedText.length - 1,
    );
    return encodedText;
  }

  String encodeBase64(toEncodeText) {
    String encodedText = '';
    encodedText = base64.encode(
      utf8.encode(toEncodeText)
    );
    return encodedText;
  }

  String uri(toEncodeText) {
    String encodedText = '';
    encodedText = Uri.encodeFull(toEncodeText);
    return encodedText;
  }

  String randomCase(toEncodeText) {
    String encodedText = '';
    toEncodeText.split('').forEach(
      (letter) {
        var rng = new Random();
        int _caseChance = rng.nextInt(2);
        switch (_caseChance) {
          case 0: {
            encodedText += letter.toLowerCase();
            break;
          }
          case 1: {
            encodedText += letter.toUpperCase();
            break;
          }
        }
      }
    );
    return encodedText;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encoder',
      home: DefaultForm(),
    );
  }
}

class DefaultForm extends StatefulWidget {
  @override
  _DefaultFormState createState() => _DefaultFormState();
}

class _DefaultFormState extends State<DefaultForm> {
  final encodedController  = TextEditingController();
  final toEncodeController = TextEditingController();

  var textEncoders = new Encoders();

  String dropdownVal = 'Choose method';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainTheme._colorDarkMain,
      appBar: AppBar(
        title: Center(
          child: Text(
            'Encoder',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: MainTheme._colorTextHeaderFore,
            ),
          ),
        ),
        backgroundColor: MainTheme._colorTextHeaderBack,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget> [
            TextFormField(
              minLines: 3,
              maxLines: 5,
              controller: toEncodeController,
              cursorColor: MainTheme._colorTextHeaderBack,
              cursorWidth: 1,
              style: TextStyle(
                color: MainTheme._colorTextMain,
              ),
              decoration: InputDecoration(
                labelText: 'Enter text to encode',
                labelStyle: TextStyle(
                  color: MainTheme._colorTextHeaderBack,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.backspace,
                    color: MainTheme._colorIcon,
                  ),
                  onPressed:
                    () {
                      toEncodeController.text = '';
                      encodedController.text  = '';
                    },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(9),
                  ),
                )
              ),
              onChanged: (text) {
                String toEncodeText = text;
                String encodedText = '';
                switch (dropdownVal) {
                  case 'ROT13': {
                    encodedText = textEncoders.rot13(toEncodeText);
                    break;
                  }
                  case 'Reverse': {
                    encodedText = textEncoders.reverse(toEncodeText);
                    break;
                  }
                  case 'Decimal': {
                    encodedText = textEncoders.encodeBaseN(toEncodeText, 10);
                    break;
                  }
                  case 'Hexadecimal': {
                    encodedText = textEncoders.encodeBaseN(toEncodeText, 16);
                    break;
                  }
                  case 'Binary': {
                    encodedText = textEncoders.encodeBaseN(toEncodeText, 2);
                    break;
                  }
                  case 'Octal': {
                    encodedText = textEncoders.encodeBaseN(toEncodeText, 8);
                    break;
                  }
                  case 'Base64': {
                    encodedText = textEncoders.encodeBase64(toEncodeText);
                    break;
                  }
                  case 'URI': {
                    encodedText = textEncoders.uri(toEncodeText);
                    break;
                  }
                  case 'Random case': {
                    encodedText = textEncoders.randomCase(toEncodeText);
                    break;
                  }
                  default: {
                    encodedText = 'Please, choose method.';
                  }
                }
                encodedController.text = encodedText;
              },
            ),
            SizedBox(
              height: 22.5,
            ),
            Container(
              child: DropdownButton<String>(
                value: dropdownVal,
                style: TextStyle(
                  color: MainTheme._colorTextMain,
                ),
                icon: Icon(
                  Icons.subdirectory_arrow_left,
                  color: MainTheme._colorIcon,
                ),
                items: <String>[
                  'Choose method',
                  'Base64',
                  'Binary',
                  'Decimal',
                  'Hexadecimal',
                  'Octal',
                  'Random case',
                  'Reverse',
                  'ROT13',
                  'URI',
                ]
                    .map<DropdownMenuItem<String>>(
                        (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }
                )
                    .toList(),
                onChanged: (String newVal) {
                  setState(
                    () {
                      dropdownVal = newVal;
                    }
                  );
                  String toEncodeText = toEncodeController.text;
                  String encodedText = '';
                  switch (dropdownVal) {
                    case 'ROT13': {
                      encodedText = textEncoders.rot13(toEncodeText);
                      break;
                    }
                    case 'Reverse': {
                      encodedText = textEncoders.reverse(toEncodeText);
                      break;
                    }
                    case 'Decimal': {
                      encodedText = textEncoders.encodeBaseN(toEncodeText, 10);
                      break;
                    }
                    case 'Hexadecimal': {
                      encodedText = textEncoders.encodeBaseN(toEncodeText, 16);
                      break;
                    }
                    case 'Binary': {
                      encodedText = textEncoders.encodeBaseN(toEncodeText, 2);
                      break;
                    }
                    case 'Octal': {
                      encodedText = textEncoders.encodeBaseN(toEncodeText, 8);
                      break;
                    }
                    case 'Base64': {
                      encodedText = textEncoders.encodeBase64(toEncodeText);
                      break;
                    }
                    case 'URI': {
                      encodedText = textEncoders.uri(toEncodeText);
                      break;
                    }
                    case 'Random case': {
                      encodedText = textEncoders.randomCase(toEncodeText);
                      break;
                    }
                    default: {
                      encodedText = 'Please, choose a method.';
                    }
                  }
                  encodedController.text = encodedText;
                },
                underline: Container(
                  height: 0,
                ),
                dropdownColor: MainTheme._colorDarkMain,
              ),
            ),
            SizedBox(
              height: 22.5,
            ),
            TextFormField(
              minLines: 3,
              maxLines: 5,
              controller: encodedController,
              cursorColor: MainTheme._colorTextHeaderBack,
              cursorWidth: 1,
              style: TextStyle(
                color: MainTheme._colorTextMain,
              ),
              decoration: InputDecoration(
                labelText: 'Your encoded text',
                labelStyle: TextStyle(
                  color: MainTheme._colorTextHeaderBack,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                      Icons.backspace,
                      color: MainTheme._colorIcon,
                  ),
                  onPressed:
                    () {
                      encodedController.text = '';
                    },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(9),
                  )
                )
              ),
            ),
          ]
        ),
      ),
    );
  }
}
