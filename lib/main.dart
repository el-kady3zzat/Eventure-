import 'package:eventure/features/admin_Dashboard/presentation/pages/Admin_auth.dart';
import 'package:eventure/features/admin_Dashboard/presentation/pages/events_screen.dart';

import 'package:eventure/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kIsWeb) {
    runApp(AdminApp());
  }
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Admin Dashboard ',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: EventsScreen(),
      ),
    );
  }
}
