import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ucccc/ui/main_scaffold.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(milliseconds: 3500), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainScaffold()));
    });
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(color: Colors.white),
          child: SizedBox(
            width: double.infinity,
            child: Letters(),
          ),
        ),
      );
}

class Letters extends StatefulWidget {
  const Letters({super.key});

  @override
  State<Letters> createState() => _LettersState();
}

class _LettersState extends State<Letters> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Opacity(opacity: 0.25, child: Image(image: AssetImage('assets/ciastko.png'))),
        DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyLarge!.merge(const TextStyle(fontSize: 64)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('U'),
              for (int i = 0; i < 4; i++) const Text('C').animate().tint(color: Colors.greenAccent.withOpacity(0.25 * i)),
            ]
                .animate(interval: 400.milliseconds)
                .fade(duration: 400.milliseconds)
                .slideX(duration: 400.milliseconds, begin: -3),
          )
              .animate(delay: 2.seconds)
              .shake(duration: 500.milliseconds)
              .then()
              .slideY(duration: 500.milliseconds, begin: 0, end: 5, curve: Curves.easeInCubic),
        ),
        Transform.rotate(angle: pi, child: const Opacity(opacity: 0.25, child: Image(image: AssetImage('assets/ciastko.png')))),
      ],
    );
  }
}
