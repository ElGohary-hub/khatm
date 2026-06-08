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
            const SizedBox(height: 15),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      isDarkMode ? Icons.light_mode : Icons.dark_mode, 
                      color: isDarkMode ? Colors.amber : Colors.indigo
                    ),
                    onPressed: () {
                      setState(() {
                        isDarkMode = !isDarkMode;
                        saveData(); 
                      });
                    },
                  ),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: boxColor,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: borderColor),
                      // الشادو المرجعي (نفس اللي هيتم تطبيقه تحت بالمللي)
                      boxShadow: [
                        if (!isDarkMode) BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, spreadRadius: 1)
                      ]
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 10),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 600), 
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                          child: Text(
                            isFirstText ? "مَا نَقَصَ مَالٌ مِنْ صَدَقَةٍ" : "الصدقة جسر إلى الجَنَّةِ",
                            key: ValueKey<bool>(isFirstText),
                            style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48), 
                ],
              ),
            ),

            const SizedBox(height: 35),

            // التعديل الأول: مستطيل غزة (بيضاوي + نفس الظل والحدود)
            Container(
              height: 210,
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: Colors.transparent, 
                border: Border.all(color: borderColor), // نفس الحد بالمللي
                borderRadius: BorderRadius.circular(150), // شكل بيضاوي متناسق
                boxShadow: [
                  if (!isDarkMode) BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, spreadRadius: 1) // نفس الظل بالمللي
                ]
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(150), // شكل بيضاوي عشان يقص الصورة من جوا
                child: Image.asset(
                  'gaza.png', 
                  fit: BoxFit.cover, 
                  errorBuilder: (context, error, stackTrace) {
                     return Center(
                       child: Icon(Icons.mosque, size: 80, color: isDarkMode ? Colors.white30 : Colors.black26),
                     );
                  }
                ),
              ),
            ),

            // Expanded الأول: بيزق الأذكار لتحت عشان تبقى في النص
            const Expanded(child: SizedBox()), 

            GestureDetector(
              onTap: showDhikrMenu, 
              onLongPress: showDhikrMenu, 
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Text(
                  dhikrList[currentIndex]["text"],
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textColor, fontSize: 30, fontWeight: FontWeight.bold, height: 1.4),
                ),
              ),
            ),

            // Expanded التاني: بيزق الأذكار لفوق عشان تتمركز بالضبط في النص بين الصورة والعداد
            const Expanded(child: SizedBox()), 

            // التعديل التاني: العداد (بيضاوي + نفس الظل والحدود)
            GestureDetector(
              onTap: () {
                HapticFeedback.vibrate(); 
                setState(() {
                  mainCounter = 0;
                  saveData(); 
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("تم تصفير العداد"), duration: Duration(seconds: 1)),
                );
              },
              onLongPress: showTotalStats, 
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[950] : Colors.white,
                  border: Border.all(color: borderColor), // نفس الحد بالمللي
                  borderRadius: BorderRadius.circular(150), // شكل بيضاوي متناسق
                  boxShadow: [
                    if (!isDarkMode) BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, spreadRadius: 1) // نفس الظل بالمللي
                  ]
                ),
                child: Text(
                  mainCounter.toString(), 
                  style: TextStyle(color: textColor, fontSize: 52, letterSpacing: 6, fontWeight: FontWeight.w300),
                ),
              ),
            ),

            const SizedBox(height: 50),

            GestureDetector(
              onTap: incrementCounter,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: isDarkMode 
                        ? [Colors.grey[800]!, Colors.black] 
                        : [Colors.white, Colors.grey[300]!],
                    radius: 0.85,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.15),
                      spreadRadius: 3,
                      blurRadius: 15,
                      offset: const Offset(0, 5)
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: isDarkMode ? Colors.white12 : Colors.black12, width: 1.5),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 55),
          ],
        ),
      ),
    );
  }
