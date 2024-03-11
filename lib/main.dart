import 'dart:math';

import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart';

void main() {
  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(ThemeData.light(), ThemeMode.system),
      child: const CalculatorApp(),
    ),
  );
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        // Get the chosen theme mode from ThemeNotifier
        ThemeMode themeMode = themeNotifier.getThemeMode();

        return MaterialApp(
          theme: themeNotifier.getTheme(),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: Colors.blue,
            scaffoldBackgroundColor: Colors.black,
          ),
          themeMode: themeMode, // Use the specified theme mode
          home: const CalculatorHomePage(),
        );
      },
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  const CalculatorHomePage({super.key});

  @override
  CalculatorHomePageState createState() => CalculatorHomePageState();
}

class CalculatorHomePageState extends State<CalculatorHomePage> {
  String _output = '', _answer = '';
  bool _flag = false, _inverse = false, _areRowsVisible = false, _isRad = true;
  int openBracketsCount = 0, closeBracketsCount = 0;

  void _onPressed(String buttonText) {
    setState(() {
      if (buttonText == "AC") {
        _output = '';
        _answer = '';
        _flag = false;
        openBracketsCount = 0; // Reset the count of opening brackets
        closeBracketsCount = 0; // Reset the count of closing brackets
      } else if (buttonText == '⌫') {
        if (_output.isNotEmpty) {
          String lastChar = _output[_output.length - 1];
          if (lastChar == '(') {
            openBracketsCount--;
          } else if (lastChar == ')') {
            closeBracketsCount--;
          }
          _output = _output.substring(0, _output.length - 1);
        }

        if (_output.isEmpty) {
          _answer = '';
          _flag = false;
        } else if (_flag) {
          String lastC = _output[_output.length - 1];
          if (lastC == '+' ||
              lastC == '-' ||
              lastC == '*' ||
              lastC == '/' ||
              lastC == '%' ||
              lastC == '^' ||
              lastC == '!') return;
          _answer = _calculateOutput(_output);
        }
      } else if (buttonText == "Rad" || buttonText == "Deg") {
        _isRad = !_isRad;
        _answer = _calculateOutput(_output);
      } else if (buttonText == "sin" ||
          buttonText == "cos" ||
          buttonText == "tan") {
        _output += '$buttonText(';
        openBracketsCount++;
        _flag = true;
        _answer = _calculateOutput(_output);
      } else if (buttonText == "cosec") {
        _output += '1/sin(';
        openBracketsCount++;
        _flag = true;
        _answer = _calculateOutput(_output);
      } else if (buttonText == "sec") {
        _output += '1/cos(';
        openBracketsCount++;
        _flag = true;
        _answer = _calculateOutput(_output);
      } else if (buttonText == "cot") {
        _output += '1/tan(';
        openBracketsCount++;
        _flag = true;
        _answer = _calculateOutput(_output);
      } else if (buttonText == 'x²') {
        _output += '^2';
        _flag = true;
        _answer = _calculateOutput(_output);
      } else if (buttonText == 'e') {
        _output += e.toStringAsFixed(8);
        _flag = true;
        _answer = _calculateOutput(_output);
      } else if (buttonText == 'ln') {
        _output += 'ln';
        _flag = true;
        _answer = _calculateOutput(_output);
      } else if (buttonText == '10ˣ') {
        _output += '10^';
        _flag = true;
        _answer = _calculateOutput(_output);
      } else if (buttonText == 'log') {
        _output += 'log10(';
        openBracketsCount++;
        _flag = true;
        _answer = _calculateOutput(_output);
      } else if (buttonText == "INV") {
        _inverse = !_inverse;
      } else if (buttonText == '=') {
        _output = _calculateOutput(_output);
        _answer = '';
      } else if (buttonText == '+' ||
          buttonText == '-' ||
          buttonText == '*' ||
          buttonText == '/' ||
          buttonText == '/') {
        _output += buttonText;
        _flag = true;
      } else if (buttonText == '%') {
        _answer = _calculateOutput("$_output/100");
        _output += '%';
      } else if (buttonText == '√') {
        _output += 'sqrt(';
        openBracketsCount++;
        _flag = true;
      } else if (buttonText == 'π') {
        if (_output.isNotEmpty &&
            (_output[_output.length - 1].contains(RegExp(r'[0-9]')) ||
                _output[_output.length - 1] == ')')) {
          _output += '*';
        }
        _output += pi.toStringAsFixed(8);
        _flag = true;
        _answer = _calculateOutput(_output);
      } else if (buttonText == '^') {
        _output += '^';
        _flag = true;
      } else if (buttonText == "eˣ") {
        _output += "${e.toStringAsFixed(8)}^";
        _flag = true;
      } else if (buttonText == '!') {
        _output += '!';
        _flag = true;
        _answer = _calculateOutput(_output);
      } else if (buttonText == "()") {
        print('$_output-$openBracketsCount-$closeBracketsCount');
        // Add an opening parenthesis only if the last character is an operator or an open parenthesis
        if (_output.isEmpty ||
            _output.endsWith('+') ||
            _output.endsWith('-') ||
            _output.endsWith('*') ||
            _output.endsWith('/') ||
            _output.endsWith('(')) {
          _output += '(';
          openBracketsCount++;
        } else if (_output.isNotEmpty &&
            openBracketsCount > closeBracketsCount &&
            (_output[_output.length - 1] == '0' ||
                _output[_output.length - 1] == '1' ||
                _output[_output.length - 1] == '2' ||
                _output[_output.length - 1] == '3' ||
                _output[_output.length - 1] == '4' ||
                _output[_output.length - 1] == '5' ||
                _output[_output.length - 1] == '6' ||
                _output[_output.length - 1] == '7' ||
                _output[_output.length - 1] == '8' ||
                _output[_output.length - 1] == '9')) {
          // Add a closing parenthesis only if there are more open parentheses than closed ones and the last character is a digit
          _output += ')';
          closeBracketsCount++;
          _answer = _calculateOutput(_output);
        } else {
          _output += '*(';
          openBracketsCount++;
        }
        _flag = false;
      } else {
        if (_output.isNotEmpty && _output.endsWith(')')) {
          if (buttonText == '0' ||
              buttonText == '1' ||
              buttonText == '2' ||
              buttonText == '3' ||
              buttonText == '4' ||
              buttonText == '5' ||
              buttonText == '6' ||
              buttonText == '7' ||
              buttonText == '8' ||
              buttonText == '9') _output += '*';
        }
        _output += buttonText;
        if (_flag) _answer = _calculateOutput(_output);
      }
    });
  }

  bool isInteger(num value) => value is int || value == value.roundToDouble();

  String _calculateOutput(String input) {
    if (input.isEmpty) return '';

    if (_isRad) {
      input = input.replaceAll('sin(', 'sin($pi/180*');
      input = input.replaceAll('cos(', 'cos($pi/180*');
      input = input.replaceAll('tan(', 'tan($pi/180*');
    }

    try {
      final Parser p = Parser();
      final int missingBrackets = openBracketsCount - closeBracketsCount;

      if (missingBrackets > 0) {
        input += ')' * missingBrackets; // Append missing closing brackets
      }

      final Expression exp = p.parse(input);
      final ContextModel cm = ContextModel();
      final double eval = exp.evaluate(EvaluationType.REAL, cm);
      final num ans = num.parse(eval.toStringAsFixed(8));
      String answer = ans.toString();
      if (isInteger(eval)) answer = answer.substring(0, answer.length - 2);
      return answer;
    } catch (e) {
      return 'Error';
    }
  }

  Future<void> _showThemeSelectionDialog(BuildContext context) async {
    ThemeMode? selectedThemeMode =
        Provider.of<ThemeNotifier>(context, listen: false).getThemeMode();

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: const Text('Choose Theme'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RadioListTile<ThemeMode>(
                    title: const Text('Light'),
                    value: ThemeMode.light,
                    groupValue: selectedThemeMode,
                    onChanged: (ThemeMode? value) {
                      setState(() {
                        selectedThemeMode = value;
                      });
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Dark'),
                    value: ThemeMode.dark,
                    groupValue: selectedThemeMode,
                    onChanged: (ThemeMode? value) {
                      setState(() {
                        selectedThemeMode = value;
                      });
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('System Theme'),
                    value: ThemeMode.system,
                    groupValue: selectedThemeMode,
                    onChanged: (ThemeMode? value) {
                      setState(() {
                        selectedThemeMode = value;
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: selectedThemeMode == null
                      ? null
                      : () {
                          // Set the chosen theme mode
                          Provider.of<ThemeNotifier>(context, listen: false)
                              .setTheme(ThemeData.light(), selectedThemeMode!);
                          Navigator.of(context).pop(); // Close the dialog
                        },
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'History') {
                // Handle history action
              } else if (value == 'Choose Theme') {
                _showThemeSelectionDialog(context);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'History',
                child: Text('History'),
              ),
              const PopupMenuItem<String>(
                value: 'Choose Theme',
                child: Text('Choose Theme'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  _output,
                  style: const TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  _answer,
                  style: const TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildOperatorButton(_inverse ? 'x²' : '√'),
              _buildOperatorButton('π'),
              _buildOperatorButton('^'),
              _buildOperatorButton('!'),
              ToggleButtons(
                onPressed: (int index) {
                  setState(() {
                    _areRowsVisible = !_areRowsVisible;
                  });
                },
                isSelected: [_areRowsVisible],
                children: <Widget>[
                  Icon(_areRowsVisible
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down),
                ],
              ),
            ],
          ),
          if (_areRowsVisible)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _buildOperatorButton(_isRad ? 'Rad' : 'Deg'),
                    _buildOperatorButton(_inverse ? 'cosec' : 'sin'),
                    _buildOperatorButton(_inverse ? 'sec' : 'cos'),
                    _buildOperatorButton(_inverse ? 'cot' : 'tan'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _buildOperatorButton('INV'),
                    _buildOperatorButton('e'),
                    _buildOperatorButton(_inverse ? 'eˣ' : 'ln'),
                    _buildOperatorButton(_inverse ? '10ˣ' : 'log'),
                  ],
                ),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('AC', color: Colors.blue),
              _buildButton('()'),
              _buildButton('%'),
              _buildButton('/'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('7'),
              _buildButton('8'),
              _buildButton('9'),
              _buildButton('*'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('4'),
              _buildButton('5'),
              _buildButton('6'),
              _buildButton('-'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('1'),
              _buildButton('2'),
              _buildButton('3'),
              _buildButton('+'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('0'),
              _buildButton('.'),
              _buildButton('⌫'),
              _buildButton('=', color: Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String buttonText, {Color color = Colors.black}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2, // Set button width
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => _onPressed(buttonText),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(color),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  50.0), // Ensure the button is perfectly round
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(
                vertical: 8.0), // Adjust vertical padding here
          ),
        ),
        child: Text(
          buttonText,
          textAlign: TextAlign.center, // Center the text horizontally
          style: const TextStyle(
            fontSize: 24.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildOperatorButton(String operator) {
    return GestureDetector(
      onTap: () => _onPressed(operator),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          operator,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
