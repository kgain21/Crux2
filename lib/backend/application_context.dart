import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/backend/bloc/authentication/authentication_bloc.dart';
import 'package:crux/backend/bloc/dashboard/dashboard_bloc.dart';
import 'package:crux/backend/repository/workout/firestore_workout_repository.dart';
import 'package:crux/backend/repository/workout/workout_repository.dart';
import 'package:crux/backend/service/authentication/google_sign_in_authentication_service.dart';
import 'package:crux/backend/util/injector/injector.dart';
import 'package:crux/backend/serialization/serializers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ApplicationContext {
  Injector initialize(Injector injector) {

    /* Authentication */
    injector.map((i) => CredentialManager(), isSingleton: true);
    injector.map((i) => FirebaseAuth.instance, isSingleton: true);
    injector.map((i) => GoogleSignIn(), isSingleton: true);

    injector.map(
        (i) => GoogleSignInAuthenticationService(
              credentialManager: injector.get<CredentialManager>(),
              firebaseAuth: injector.get<FirebaseAuth>(),
              googleSignIn: injector.get<GoogleSignIn>(),
            ),
        isSingleton: true);

    injector.map((injector) => AuthenticationBloc(
        authenticationService: injector.get<GoogleSignInAuthenticationService>()));
    /* Authentication */

    /* Dashboard */
    injector.map((injector) => Firestore.instance, isSingleton: true);
    injector.map((i) => serializers, isSingleton: true);
    injector.map(
        (i) => FirestoreWorkoutRepository(
            firestore: injector.get<Firestore>(), serializers: injector.get<Serializers>()),
        isSingleton: true, key: "FirestoreWorkoutRepository");
    injector.map((i) => DashboardBloc(
        workoutRepository: injector.get<BaseWorkoutRepository>(key: "FirestoreWorkoutRepository")));
    /* Dashboard */

    return injector;
  }
}
