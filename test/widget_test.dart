import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart'; // Matematiksel ifadeleri hesaplamak için gerekli paket

void main() {
  runApp(const OzgunHesapMakinesiApp());
}

class OzgunHesapMakinesiApp extends StatelessWidget {
  const OzgunHesapMakinesiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Özgün Bilimsel Hesap Makinesi',
      theme: ThemeData.dark().copyWith(
        // Modern, koyu bir tema (Nordic-inspired)
        scaffoldBackgroundColor: const Color(0xFF2E3440), // Arka plan
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF88C0D0), // İşlev butonları rengi (açık mavi)
          secondary: Color(0xFFA3BE8C), // Eşittir butonu rengi (yeşil)
          error: Color(0xFFBF616A), // Silme butonları rengi (kırmızı)
          surface: Color(0xFF3B4252), // Numara butonları rengi (koyu gri)
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

  // Butonlara basıldığında çalışacak mantık
  void _butonBasildi(String butonMetni) {
    setState(() {
      if (butonMetni == 'C') {
        _girilenIfade = '';
        _sonuc = '0';
      } else if (butonMetni == '⌫') {
        if (_girilenIfade.isNotEmpty) {
          _girilenIfade = _girilenIfade.substring(0, _girilenIfade.length - 1);
        }
      } else if (butonMetni == '=') {
        _hesapla();
      } else if (['sin(', 'cos(', 'tan(', 'log(', 'sqrt(', '^'].contains(butonMetni)) {
        // Bilimsel işlevleri ekle
        _girilenIfade += butonMetni;
      } else {
        // Numaraları ve operatörleri ekle
        _girilenIfade += butonMetni;
      }
    });
  }

  // Matematiksel ifadeyi hesaplama mantığı
  void _hesapla() {
    String finalIfade = _girilenIfade;
    // math_expressions paketi için bazı operatörleri değiştirmemiz gerekebilir
    finalIfade = finalIfade.replaceAll('×', '*');
    finalIfade = finalIfade.replaceAll('÷', '/');

    try {
      Parser p = Parser();
      Expression exp = p.parse(finalIfade);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      setState(() {
        _sonuc = eval.toString();
        // Eğer sonuç tam sayıysa .0'ı kaldırabilirsin (isteğe bağlı)
        if (_sonuc.endsWith('.0')) {
          _sonuc = _sonuc.substring(0, _sonuc.length - 2);
        }
      });
    } catch (e) {
      setState(() {
        _sonuc = "Hata";
      });
    }
  }

  // Özel, şık bir buton widget'ı oluşturma
  Widget _buildButton(String text, {Color? color, double width = 1}) {
    return Expanded(
      flex: width.toInt(),
      child: Padding(
        padding: const EdgeInsets.all(4.0), // Butonlar arası boşluk
        child: Container(
          height: 70, // Buton yüksekliği
          child: ElevatedButton(
            onPressed: () => _butonBasildi(text),
            style: ElevatedButton.styleFrom(
              backgroundColor: color ?? Theme.of(context).colorScheme.surface,
              foregroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0), // Daha yuvarlak köşeler
              ),
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Text(text),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double outputHeight = screenHeight * 0.3; // Ekranın %30'u sonuç alanı

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bilimsel Hesaplama'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          // Girdi ve Sonuç Ekranı
          Container(
            height: outputHeight,
            padding: const EdgeInsets.all(20),
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Girilen matematiksel ifade
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true, // Sondan başla
                  child: Text(
                    _girilenIfade,
                    style: const TextStyle(fontSize: 28, color: Colors.white70),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 15),
                // Hesaplanan sonuç
                Text(
                  _sonuc,
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
          
          // Buton Paneli
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Satır 1: Bilimsel İşlevler
                  Row(
                    children: [
                      _buildButton('sin(', color: Theme.of(context).colorScheme.primary),
                      _buildButton('cos(', color: Theme.of(context).colorScheme.primary),
                      _buildButton('tan(', color: Theme.of(context).colorScheme.primary),
                      _buildButton('log(', color: Theme.of(context).colorScheme.primary),
                    ],
                  ),
                  // Satır 2: Bilimsel İşlevler + Operatörler
                  Row(
                    children: [
                      _buildButton('sqrt(', color: Theme.of(context).colorScheme.primary),
                      _buildButton('^', color: Theme.of(context).colorScheme.primary),
                      _buildButton('('),
                      _buildButton(')'),
                    ],
                  ),
                  // Satır 3: Numaralar 7-9 + Bölme
                  Row(
                    children: [
                      _buildButton('7'),
                      _buildButton('8'),
                      _buildButton('9'),
                      _buildButton('÷', color: Theme.of(context).colorScheme.primary),
                    ],
                  ),
                  // Satır 4: Numaralar 4-6 + Çarpma
                  Row(
                    children: [
                      _buildButton('4'),
                      _buildButton('5'),
                      _buildButton('6'),
                      _buildButton('×', color: Theme.of(context).colorScheme.primary),
                    ],
                  ),
                  // Satır 5: Numaralar 1-3 + Çıkarma
                  Row(
                    children: [
                      _buildButton('1'),
                      _buildButton('2'),
                      _buildButton('3'),
                      _buildButton('-', color: Theme.of(context).colorScheme.primary),
                    ],
                    
                  ),
                   // Satır 6: 0, Nokta, Silme, Toplama
                  Row(
                    children: [
                      _buildButton('0'),
                      _buildButton('.'),
                      _buildButton('⌫', color: Theme.of(context).colorScheme.error),
                      _buildButton('+', color: Theme.of(context).colorScheme.primary),
                    ],
                  ),
                  // Satır 7: Temizle ve Eşittir (Geniş Butonlar)
                  Row(
                    children: [
                      _buildButton('C', color: Theme.of(context).colorScheme.error, width: 2), // Genişlik 2 birim
                      _buildButton('=', color: Theme.of(context).colorScheme.secondary, width: 2), // Genişlik 2 birim
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}