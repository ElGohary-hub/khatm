import 'package:flutter/material.dart';

void main() {
  runApp(const TasbeehApp());
}

class TasbeehApp extends StatelessWidget {
  const TasbeehApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasbeeh Counter',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const TasbeehHomeScreen(),
    );
  }
}

class TasbeehHomeScreen extends StatefulWidget {
  const TasbeehHomeScreen({super.key});

  @override
  _TasbeehHomeScreenState createState() => _TasbeehHomeScreenState();
}

class _TasbeehHomeScreenState extends State<TasbeehHomeScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // شريط الحالة العلوي (Header)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E), // لون خلفية داكن للحاوية
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.wb_sunny_rounded, color: Colors.yellow, size: 28), // أيقونة الشمس
                  const Text(
                    'ما نقص مال من صدقة',
                    style: TextStyle(
                      fontFamily: 'Cairo', // تأكد من إضافة هذا الخط في pubspec.yaml
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.star, color: Colors.yellow, size: 28), // أيقونة النجمة
                  IconButton(
                    icon: const Icon(Icons.dark_mode_rounded, color: Colors.white, size: 28), // تبديل الوضع
                    onPressed: () {
                      // أضف منطق تبديل وضع الإضاءة هنا
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // قسم الصورة العلوي "غزة"
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 250, // اضبط الارتفاع حسب الحاجة
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                image: const DecorationImage(
                  // استبدل بمسار أصول صورة غزة
                  image: AssetImage('assets/images/gaza_header.png'), 
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // نص الذكر
            const Center(
              child: Text(
                'استغفر الله العظيم',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // قسم العداد (0000)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF333333)), // لون إطار داكن
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  _counter.toString().padLeft(4, '0'), // عداد رقمي (0000)
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Digital-7', // أضف خط العداد الرقمي
                  ),
                ),
              ),
            ),
            const Spacer(),
            // الزر السفلي (زر التسبيح الرئيسي)
            Container(
              margin: const EdgeInsets.only(bottom: 32),
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0xFF222222), Colors.black],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    offset: Offset(0, 10),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Center(
                child: InkWell(
                  onTap: _incrementCounter,
                  onLongPress: _resetCounter, // إعادة تعيين العداد عند الضغط المطول
                  borderRadius: BorderRadius.circular(60),
                  child: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: SizedBox.shrink(), // يجعل الزر غير مرئي
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
