import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final Future<FirebaseApp> initialization = Firebase.initializeApp(
  name: "fixlock-app",
  options: DefaultFirebaseOptions.currentPlatform,
);
