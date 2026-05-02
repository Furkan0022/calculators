import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const OzgunHesapMakinesiApp());
}

class OzgunHesapMakinesiApp extends StatelessWidget {
  const OzgunHesapMakinesiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scientific Calculator',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF2E3440),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF88C0D0),
          secondary: Color(0xFFA3BE8C),
          error: Color(0xFFBF616A),
          surface: Color(0xFF3B4252),
        ),
      ),
      home: const HesapMakinesiEkrani(),
    );
  }
}

class HesapMakinesiEkrani extends StatefulWidget {
  const HesapMakinesiEkrani({super.key});

  @override
  State<HesapMakinesiEkrani> createState() => _HesapMakinesiEkraniState();
}

class _HesapMakinesiEkraniState extends State<HesapMakinesiEkrani> {
  String _girilenIfade = '';
  String _sonuc = '0';

  void _onButtonPressed(String text) {
    setState(() {
      if (text == 'C') {
        _girilenIfade = '';
        _sonuc = '0';
      } else if (text == '⌫') {
        if (_girilenIfade.isNotEmpty) {
          _girilenIfade = _girilenIfade.substring(0, _girilenIfade.length - 1);
        }
      } else if (text == '=') {
        _calculateResult();
      } else {
        _girilenIfade += text;
      }
    });
  }

  void _calculateResult() {
    String finalExpression = _girilenIfade;
    finalExpression = finalExpression.replaceAll('×', '*');
    finalExpression = finalExpression.replaceAll('÷', '/');

    try {
      Parser p = Parser();
      Expression exp = p.parse(finalExpression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      setState(() {
        _sonuc = eval.toString();
        if (_sonuc.endsWith('.0')) {
          _sonuc = _sonuc.substring(0, _sonuc.length - 2);
        }
      });
    } catch (e) {
      setState(() {
        _sonuc = "Error";
      });
    }
  }

  Widget _buildButton(String text, {Color? color, double width = 1}) {
    return Expanded(
      flex: width.toInt(),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox(
          height: 70,
          child: ElevatedButton(
            onPressed: () => _onButtonPressed(text),
            style: ElevatedButton.styleFrom(
              backgroundColor: color ?? Theme.of(context).colorScheme.surface,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: Text(text, style: const TextStyle(fontSize: 18)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(_girilenIfade, style: const TextStyle(fontSize: 24, color: Colors.white60)),
                    const SizedBox(height: 10),
                    Text(_sonuc, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(children: [_buildButton('sin('), _buildButton('cos('), _buildButton('tan('), _buildButton('log(')]),
                  Row(children: [_buildButton('sqrt('), _buildButton('^'), _buildButton('('), _buildButton(')')]),
                  Row(children: [_buildButton('7'), _buildButton('8'), _buildButton('9'), _buildButton('÷', color: Theme.of(context).colorScheme.primary)]),
                  Row(children: [_buildButton('4'), _buildButton('5'), _buildButton('6'), _buildButton('×', color: Theme.of(context).colorScheme.primary)]),
                  Row(children: [_buildButton('1'), _buildButton('2'), _buildButton('3'), _buildButton('-', color: Theme.of(context).colorScheme.primary)]),
                  Row(children: [_buildButton('0'), _buildButton('.'), _buildButton('⌫', color: Theme.of(context).colorScheme.error), _buildButton('+', color: Theme.of(context).colorScheme.primary)]),
                  Row(children: [_buildButton('C', color: Theme.of(context).colorScheme.error, width: 2), _buildButton('=', color: Theme.of(context).colorScheme.secondary, width: 2)]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}