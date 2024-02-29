import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const CalculatorHomePage(),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  const CalculatorHomePage({Key? key}) : super(key: key);

  @override
  _CalculatorHomePageState createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String _output = '',_answer='';
  bool _flag=false;

  void _onPressed(String buttonText) {
    setState(() {
      if(buttonText=="AC"){
        _output='';
        _answer='';
        _flag=false;
      }
      else if (buttonText == '⌫') {
        _output = _output.isNotEmpty ? _output.substring(0, _output.length - 1) : '';
        if(_output.isEmpty) {
          _answer='';
          _flag=false;
        }
        else if(_flag){
          String lastC=_output[_output.length-1];
          if(lastC=='+'||lastC=='-'||lastC=='*'||lastC=='/'||lastC=='%')  return;
          _answer=_calculateOutput(_output);
        }
      } else if (buttonText == '=') {
        _output = _calculateOutput(_output);
        _answer=_output;
      }
      else if(buttonText=='+'||buttonText=='-'||buttonText=='*'||buttonText=='/'||buttonText=='/'){
        _output+=buttonText;
        _flag=true;
      }
      else {
        _output += buttonText;
        if(_flag) _answer=_calculateOutput(_output);
      }
    });
  }

  bool isInteger(num value) =>
      value is int || value == value.roundToDouble();

  String _calculateOutput(String input) {
    if(input.isEmpty) return '';
    final Parser p = Parser();
    final Expression exp = p.parse(input);
    final ContextModel cm = ContextModel();
    final double eval = exp.evaluate(EvaluationType.REAL, cm);
    final num ans=num.parse(eval.toStringAsFixed(8));
    String answer=ans.toString();
    if(isInteger(eval)) answer=answer.substring(0,answer.length-2);
    return answer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: Text(
                _output,
                style: const TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: Text(
                _answer,
                style: const TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
              _buildButton('=',color: Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String buttonText, {Color color = Colors.black}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2, // Set button width
      height: MediaQuery.of(context).size.width * 0.2, // Set button height
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => _onPressed(buttonText),
        child: Text(
          buttonText,
          textAlign: TextAlign.center, // Center the text horizontally
          style: const TextStyle(
            fontSize: 24.0,
            color: Colors.white,
            height: 1.0, // Center the text vertically
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(color),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0), // Ensure the button is perfectly round
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.all(20.0),
          ),
        ),
      ),
    );
  }

}
