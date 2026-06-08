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

            // التعديل الأول: الصورة بقت دائرة تماماً
            Container(
              height: 220, 
              width: 220,
              decoration: BoxDecoration(
                color: Colors.transparent, 
                shape: BoxShape.circle, 
                border: Border.all(color: borderColor), 
                boxShadow: [
                  if (!isDarkMode) BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, spreadRadius: 1) 
                ]
              ),
              child: ClipOval( 
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

            const Expanded(child: SizedBox()), 

            // التعديل التاني: العداد بدون الإطار
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
                color: Colors.transparent, 
                padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                child: Text(
                  mainCounter.toString(), 
                  style: TextStyle(color: textColor, fontSize: 60, letterSpacing: 6, fontWeight: FontWeight.w300),
                ),
              ),
            ),

            const SizedBox(height: 50),

            // التعديل التالت: توسيط زرار الضغط
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
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
            ),

            const SizedBox(height: 55),
          ],
        ),
      ),
    );
  }
