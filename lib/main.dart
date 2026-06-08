import 'dart:async';
import 'dart:convert'; 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'خاتم', 
      theme: ThemeData(fontFamily: 'Cairo'),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const TasbeehScreen(),
    );
  }
}

class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({super.key});

  @override
  _TasbeehScreenState createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen> with AutomaticKeepAliveClientMixin {
  bool isFirstText = true;
  Timer? _timer;

  int mainCounter = 0;
  int currentIndex = 0;
  bool isDarkMode = true; 
  Map<String, int> totalCounts = {}; // متغير لحفظ المجموع الكلي

  List<Map<String, dynamic>> dhikrList = [
    {"text": "استغفر الله العظيم", "target": 33},
    {"text": "سبحان الله", "target": 33},
    {"text": "سبحان الله وبحمده سبحان الله العظيم", "target": 33},
    {"text": "الحمد لله", "target": 33},
    {"text": "الله اكبر", "target": 33},
    {"text": "الله اكبر ولله الحمد", "target": 33},
    {"text": "اللهم صلِّ علي محمد وآل محمد", "target": 33},
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    loadSavedData(); 
    
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        isFirstText = !isFirstText;
      });
    });
  }

  Future<void> loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      mainCounter = prefs.getInt('counter') ?? 0;
      currentIndex = prefs.getInt('index') ?? 0;
      isDarkMode = prefs.getBool('isDarkMode') ?? true;
      // تحميل البيانات الكلية
      totalCounts = Map<String, int>.from(jsonDecode(prefs.getString('totalCounts') ?? '{}'));
      
      String? savedList = prefs.getString('dhikrList');
      if (savedList != null) {
        List<dynamic> decodedList = jsonDecode(savedList);
        dhikrList = decodedList.map((item) => Map<String, dynamic>.from(item)).toList();
      }
    });
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('counter', mainCounter);
    prefs.setInt('index', currentIndex);
    prefs.setBool('isDarkMode', isDarkMode);
    prefs.setString('dhikrList', jsonEncode(dhikrList));
    // حفظ البيانات الكلية
    prefs.setString('totalCounts', jsonEncode(totalCounts));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void incrementCounter() {
    HapticFeedback.lightImpact();
    SystemSound.play(SystemSoundType.click); 

    setState(() {
      mainCounter++;
      // تسجيل العدد في المجموع الكلي
      String text = dhikrList[currentIndex]["text"];
      totalCounts[text] = (totalCounts[text] ?? 0) + 1;
      
      if (mainCounter >= dhikrList[currentIndex]["target"]) {
        currentIndex = (currentIndex + 1) % dhikrList.length;
        mainCounter = 0; 
        HapticFeedback.heavyImpact(); 
      }
      saveData(); 
    });
  }

  // عرض الإحصائيات (الضغطة المطولة)
  void showTotalStats() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        title: Text("سجل إنجازاتك", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: dhikrList.length,
            itemBuilder: (context, index) {
              String text = dhikrList[index]["text"];
              return ListTile(
                title: Text(text, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                trailing: Text("${totalCounts[text] ?? 0}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18)),
              );
            },
          ),
        ),
      ),
    );
  }

  void deleteDhikr(int index) {
    if (dhikrList.length == 1) return;
    setState(() {
      dhikrList.removeAt(index);
      if (currentIndex >= dhikrList.length) currentIndex = 0;
      saveData(); 
    });
    Navigator.pop(context);
    showDhikrMenu();
  }

  void addNewDhikr(BuildContext context) {
    TextEditingController textController = TextEditingController();
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text("إضافة ذكر جديد"),
      content: TextField(controller: textController),
      actions: [
        TextButton(onPressed: () {
          setState(() { dhikrList.add({"text": textController.text, "target": 33}); saveData(); });
          Navigator.pop(context); Navigator.pop(context); showDhikrMenu();
        }, child: const Text("إضافة"))
      ],
    ));
  }

  void showDhikrMenu() {
    showModalBottomSheet(context: context, builder: (context) => Stack(
      children: [
        ListView.builder(
          itemCount: dhikrList.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(dhikrList[index]["text"]),
            onTap: () { setState(() { currentIndex = index; mainCounter = 0; }); Navigator.pop(context); },
          ),
        ),
        Positioned(
          bottom: 20, right: 20,
          child: FloatingActionButton(onPressed: () => addNewDhikr(context), child: const Icon(Icons.add)),
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Color bgColor = isDarkMode ? Colors.black : Colors.grey[50]!;
    Color textColor = isDarkMode ? Colors.white : Colors.black87;
    Color boxColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    Color borderColor = isDarkMode ? Colors.white30 : Colors.black26;

    return Scaffold(
      backgroundColor: bgColor, 
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 35),
            Container(
              height: 210, width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(color: Colors.transparent, border: Border.all(color: borderColor), borderRadius: BorderRadius.circular(18)),
              child: ClipRRect(borderRadius: BorderRadius.circular(17), child: Image.asset('gaza.png', fit: BoxFit.cover)),
            ),
            const Expanded(child: SizedBox()), 
            GestureDetector(
              onTap: showDhikrMenu, 
              child: Padding(padding: const EdgeInsets.all(25), child: Text(dhikrList[currentIndex]["text"], textAlign: TextAlign.center, style: TextStyle(color: textColor, fontSize: 26, fontWeight: FontWeight.bold))),
            ),
            // العداد: ضغطة واحدة تصفير، مطولة إحصائيات
            GestureDetector(
              onTap: () { setState(() { mainCounter = 0; saveData(); }); },
              onLongPress: showTotalStats,
              child: Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(color: boxColor, borderRadius: BorderRadius.circular(25)),
                child: Text("$mainCounter", style: TextStyle(color: textColor, fontSize: 52)),
              ),
            ),
            const SizedBox(height: 50),
            GestureDetector(onTap: incrementCounter, child: const Icon(Icons.add_circle, size: 80, color: Colors.green)),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
