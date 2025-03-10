import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void init() {
  // Register FirebaseAuth instance ////////////////////////////////////////////
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Register FirebaseFirestore instance ///////////////////////////////////////
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // Register FirebaseMessaging instance ///////////////////////////////////////
  getIt.registerLazySingleton<FirebaseMessaging>(
    () => FirebaseMessaging.instance,
  );

  // Auth Feature //////////////////////////////////////////////////////////////
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
  //////////////////////////////////////////////////////////////////////////////

  // Events Feature ////////////////////////////////////////////////////////////
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
  //////////////////////////////////////////////////////////////////////////////

  // Profile Feature ///////////////////////////////////////////////////////////
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
  //////////////////////////////////////////////////////////////////////////////
}
