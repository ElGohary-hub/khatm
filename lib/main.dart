import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: TasbeehScreen()));
}

class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({super.key});
  @override
  _TasbeehScreenState createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen> {
  int mainCounter = 0;
  int currentIndex = 0;
  Map<String, int> totalCounts = {};
  List<Map<String, dynamic>> dhikrList = [
    {"text": "استغفر الله العظيم", "target": 33},
    {"text": "سبحان الله", "target": 33},
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      mainCounter = prefs.getInt('counter') ?? 0;
      totalCounts = Map<String, int>.from(jsonDecode(prefs.getString('totalCounts') ?? '{}'));
    });
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('counter', mainCounter);
    prefs.setString('totalCounts', jsonEncode(totalCounts));
  }

  void _showStats() {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text("الإجمالي"),
      content: Column(mainAxisSize: MainAxisSize.min, children: dhikrList.map((d) => Text("${d['text']}: ${totalCounts[d['text']] ?? 0}")).toList()),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 40),
                // الصورة (غزة)
                Container(height: 200, width: 300, child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.asset('gaza.png', fit: BoxFit.cover))),
                const Spacer(),
                // العداد الأنيق
                GestureDetector(
                  onTap: () { setState(() { mainCounter = 0; _save(); }); },
                  onLongPress: _showStats,
                  child: CircleAvatar(radius: 60, backgroundColor: Colors.grey[900], child: Text("$mainCounter", style: const TextStyle(fontSize: 40, color: Colors.white))),
                ),
                const SizedBox(height: 20),
                // الكارت البروفشنال للذكر
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white24)),
                  child: Text(dhikrList[currentIndex]["text"], style: const TextStyle(fontSize: 22, color: Colors.white)),
                ),
                const Spacer(),
              ],
            ),
            // الزر الدائري تحت على اليمين
            Positioned(
              bottom: 30, right: 30,
              child: GestureDetector(
                onTap: () { /* كود الإضافة */ },
                child: Container(
                  width: 60, height: 60,
                  decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                  child: const Icon(Icons.add, color: Colors.white, size: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
