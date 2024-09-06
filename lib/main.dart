import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:ucccc/firebase_options.dart';
import 'package:ucccc/ui/main_scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = (FlutterErrorDetails details) {
    FirebaseCrashlytics.instance.recordFlutterError(details);
    print(details.exception);
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MainScaffold(),
    );
  }
}

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   Widget build(BuildContext context) {
//     final DocumentReference<Map<String, dynamic>> counter = FirebaseFirestore.instance.collection('test').doc('counter');
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             StreamBuilder(
//               stream: counter.snapshots(),
//               builder: (context, snapshot) {
//                 return Text(
//                   snapshot.hasData ? '${snapshot.data!['value']} nulls' : 'Loading...',
//                   style: Theme.of(context).textTheme.headlineMedium,
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: MaterialButton(
//         onPressed: () async {
//           final int value = await counter.get().then((value) => value.data()!['value']);
//           await counter.set({'value': value + 1});
//         },
//         color: Theme.of(context).colorScheme.primary,
//         child: const Icon(Icons.add, size: 256),
//       ),
//     );
//   }
// }
