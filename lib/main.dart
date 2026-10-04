import 'package:flutter/material.dart';
import 'main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AlWazirApp());
}

class AlWazirApp extends StatelessWidget {
  const AlWazirApp({super.key});

  static const Color gold = Color(0xFFD4AF37);
  static const Color background = Color(0xFF0D131A);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'الفهد',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: gold,
          brightness: Brightness.dark,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF18232C),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: gold,
              width: 1.5,
            ),
          ),
        ),
      ),
      home: const FahadStartScreen(),
    );
  }
}

class FahadStartScreen extends StatefulWidget {
  const FahadStartScreen({super.key});

  @override
  State<FahadStartScreen> createState() => _FahadStartScreenState();
}

class _FahadStartScreenState extends State<FahadStartScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;

  static const Color gold = Color(0xFFD4AF37);
  static const Color background = Color(0xFF0D131A);

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.94,
      end: 1.06,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _openLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const FahadLoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.15,
                  colors: [
                    Color(0xFF18232C),
                    Color(0xFF0D131A),
                  ],
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: CustomPaint(
              painter: FahadBackgroundPainter(),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 24,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 190,
                        height: 190,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: gold,
                            width: 3,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x55D4AF37),
                              blurRadius: 45,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'الفهد',
                            style: TextStyle(
                              color: gold,
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),

                    const Text(
                      'الفهد',
                      style: TextStyle(
                        color: gold,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'الفهد أداء وتميز',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 45),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _openLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: gold,
                          foregroundColor: Colors.black,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'بدء',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      'تواصل • خصوصية • أداء',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FahadLoginScreen extends StatefulWidget {
  const FahadLoginScreen({super.key});

  @override
  State<FahadLoginScreen> createState() => _FahadLoginScreenState();
}

class _FahadLoginScreenState extends State<FahadLoginScreen> {
  final TextEditingController phoneController = TextEditingController();

  String countryCode = '+967';
  bool loading = false;

  static const Color gold = Color(0xFFD4AF37);
  static const Color background = Color(0xFF0D131A);

  final List<String> countryCodes = const [
    '+967',
    '+966',
    '+20',
    '+971',
    '+974',
    '+965',
    '+968',
    '+962',
    '+964',
    '+90',
    '+1',
    '+44',
  ];

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void _continue() {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      _showMessage('أدخل رقم الجوال أولاً');
      return;
    }

    if (phone.length < 6) {
      _showMessage('تحقق من رقم الجوال');
      return;
    }

    setState(() {
      loading = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const MainHomeScreen(),
        ),
      );
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF101820),
        title: const Text(
          'تسجيل الدخول',
          style: TextStyle(
            color: gold,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 35),

              const Icon(
                Icons.phone_android_rounded,
                color: gold,
                size: 75,
              ),

              const SizedBox(height: 25),

              const Text(
                'مرحبًا بك في الفهد',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'أدخل رقم جوالك للمتابعة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 35),

              Row(
                children: [
                  Container(
                    height: 58,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF18232C),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: countryCode,
                        dropdownColor: const Color(0xFF18232C),
                        iconEnabledColor: gold,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        items: countryCodes.map(
                          (code) {
                            return DropdownMenuItem<String>(
                              value: code,
                              child: Text(code),
                            );
                          },
                        ).toList(),
                        onChanged: (value) {
                          if (value == null) return;

                          setState(() {
                            countryCode = value;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'رقم الجوال',
                        hintTextDirection: TextDirection.rtl,
                        prefixIcon: Icon(
                          Icons.phone_outlined,
                          color: gold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              Text(
                'سيتم استخدام الرقم مع مفتاح الدولة: $countryCode',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 35),

              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: loading ? null : _continue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gold,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: loading
                      ? const SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(
                              Colors.black,
                            ),
                          ),
                        )
                      : const Text(
                          'متابعة',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'باستمرارك أنت توافق على شروط استخدام الفهد وسياسة الخصوصية.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FahadBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += 45) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i - size.height, size.height),
        paint,
      );
    }

    for (double i = 0; i < size.height; i += 45) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i + size.width),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
