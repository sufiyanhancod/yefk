// // File generated by FlutterFire CLI.
// // ignore_for_file: type=lint
// import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
// import 'package:flutter/foundation.dart'
//     show defaultTargetPlatform, kIsWeb, TargetPlatform;

// /// Default [FirebaseOptions] for use with your Firebase apps.
// ///
// /// Example:
// /// ```dart
// /// import 'firebase_options.dart';
// /// // ...
// /// await Firebase.initializeApp(
// ///   options: DefaultFirebaseOptions.currentPlatform,
// /// );
// /// ```
// class DefaultFirebaseOptions {
//   static FirebaseOptions get currentPlatform {
//     if (kIsWeb) {
//       return web;
//     }
//     switch (defaultTargetPlatform) {
//       case TargetPlatform.android:
//         return android;
//       case TargetPlatform.iOS:
//         return ios;
//       case TargetPlatform.windows:
//       case TargetPlatform.linux:
//       case TargetPlatform.macOS:
//         return web;
//       default:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions are not supported for this platform.',
//         );
//     }
//   }

//   static const FirebaseOptions web = FirebaseOptions(
//     apiKey: '',
//     appId: '',
//     messagingSenderId: '',
//     projectId: '',
//     authDomain: '',
//     storageBucket: '',
//     measurementId: '',
//   );

//   static const FirebaseOptions android = FirebaseOptions(
//     apiKey: '',
//     appId: '',
//     messagingSenderId: '',
//     projectId: '',
//     storageBucket: '',
//   );

//   static const FirebaseOptions ios = FirebaseOptions(
//     apiKey: '',
//     appId: '',
//     messagingSenderId: '',
//     projectId: '',
//     storageBucket: '',
//     iosBundleId: '',
//   );
// }
