import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _carController;
  late AnimationController _textController;
  late Animation<Offset> _carAnimation;
  late Animation<double> _carScaleAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;
  final Color _appBlue = const Color.fromRGBO(25, 118, 210, 1);

  @override
  void initState() {
    super.initState();

    // Car animation controller
    _carController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    // Car movement animation
    _carAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0.0),
      end: const Offset(0.0, 0.0), // Stop in the middle
    ).animate(CurvedAnimation(
      parent: _carController,
      curve: Curves.easeOutQuart, // More dramatic deceleration
    ));

    // Car scale animation (slight bounce effect when stopping)
    _carScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.0),
        weight: 80,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.15),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.15, end: 1.0),
        weight: 10,
      ),
    ]).animate(_carController);

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Text opacity animation
    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));

    // Text slide animation
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    ));

    // Start the car animation as soon as the screen loads
    _carController.forward();

    // Show text after car animation completes
    _carController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Slight delay before showing text
      }
    });
  }

  @override
  void dispose() {
    _carController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _appBlue,
      body: Container(
        decoration: BoxDecoration(
          // Subtle gradient background
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _appBlue,
              _appBlue.withOpacity(0.85),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Car animation with scale effect
              AnimatedBuilder(
                animation: _carController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _carScaleAnimation.value,
                    child: SlideTransition(
                      position: _carAnimation,
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Stack(
                          children: [
                            // Car shadow
                            Positioned(
                              bottom: 0,
                              left: 10,
                              right: 10,
                              child: Container(
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Car icon
                            Positioned.fill(
                              child: Icon(
                                Icons.directions_car,
                                color: Colors.white,
                                size: 80,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 40),
              // Text animation
              SlideTransition(
                position: _textSlideAnimation,
                child: FadeTransition(
                  opacity: _textOpacityAnimation,
                  child: Text(
                    'HustleDrive',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
