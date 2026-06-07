import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Cairo'),
      builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child!),
      home: const TasbeehScreen(),
    );
  }
}

class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({super.key});
  @override
  _TasbeehScreenState createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen> {
  int mainCounter = 0;
  int currentIndex = 0;
  bool isDarkMode = true;
  Map<String, int> totalCounts = {};
  List<Map<String, dynamic>> dhikrList = [
    {"text": "استغفر الله العظيم", "target": 33},
    {"text": "سبحان الله", "target": 33},
    {"text": "الحمد لله", "target": 33},
    {"text": "الله اكبر", "target": 33},
  ];

  @override
  void initState() {
    super.initState();
    loadSavedData();
  }

  Future<void> loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      mainCounter = prefs.getInt('counter') ?? 0;
      currentIndex = prefs.getInt('index') ?? 0;
      isDarkMode = prefs.getBool('isDarkMode') ?? true;
      totalCounts = Map<String, int>.from(jsonDecode(prefs.getString('totalCounts') ?? '{}'));
      String? savedList = prefs.getString('dhikrList');
      if (savedList != null) {
        dhikrList = List<Map<String, dynamic>>.from(jsonDecode(savedList).map((x) => Map<String, dynamic>.from(x)));
      }
    });
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('counter', mainCounter);
    prefs.setInt('index', currentIndex);
    prefs.setBool('isDarkMode', isDarkMode);
    prefs.setString('totalCounts', jsonEncode(totalCounts));
    prefs.setString('dhikrList', jsonEncode(dhikrList));
  }

  void incrementCounter() {
    HapticFeedback.lightImpact();
    setState(() {
      mainCounter++;
      String currentText = dhikrList[currentIndex]["text"];
      totalCounts[currentText] = (totalCounts[currentText] ?? 0) + 1;
      if (mainCounter >= dhikrList[currentIndex]["target"]) {
        currentIndex = (currentIndex + 1) % dhikrList.length;
        mainCounter = 0;
        HapticFeedback.heavyImpact();
      }
      saveData();
    });
  }

  void showStatistics() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        title: const Text("سجل الإنجازات الكلي", style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(width: double.maxFinite, child: ListView.builder(
          shrinkWrap: true,
          itemCount: dhikrList.length,
          itemBuilder: (context, index) {
            String text = dhikrList[index]["text"];
            return Card(
              color: isDarkMode ? Colors.grey[850] : Colors.grey[100],
              child: ListTile(
                title: Text(text, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                trailing: Text("${totalCounts[text] ?? 0}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            );
          },
        )),
      ),
    );
  }

  void showDhikrMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        builder: (context, scrollController) => Stack(
          children: [
            ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: dhikrList.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(dhikrList[index]["text"], style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                onTap: () { setState(() { currentIndex = index; mainCounter = 0; }); Navigator.pop(context); },
              ),
            ),
            Positioned(
              bottom: 20, right: 20,
              child: FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: () { /* أضف هنا كود إضافة ذكر جديد */ },
                child: const Icon(Icons.add),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = isDarkMode ? Colors.white : Colors.black87;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Container(height: 200, width: 300, child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.asset('gaza.png', fit: BoxFit.cover))),
            const Spacer(),
            GestureDetector(
              onTap: () { setState(() { mainCounter = 0; saveData(); }); },
              onLongPress: showStatistics,
              child: CircleAvatar(radius: 60, backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[200], child: Text("$mainCounter", style: TextStyle(fontSize: 40, color: textColor))),
            ),
            const Spacer(),
            GestureDetector(onTap: showDhikrMenu, child: Text(dhikrList[currentIndex]["text"], style: TextStyle(fontSize: 22, color: textColor))),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: incrementCounter, child: const Icon(Icons.add)),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
