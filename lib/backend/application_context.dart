import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/backend/repository/workout/firestore_workout_repository.dart';
import 'package:crux/backend/serialization/serializers.dart';
import 'package:crux/backend/service/authentication/google_sign_in_authentication_service.dart';
import 'package:crux/backend/util/injector/injector.dart';
import 'package:crux/frontend/screen/authentication/bloc/authentication_bloc.dart';
import 'package:crux/frontend/screen/dashboard/bloc/dashboard_bloc.dart';
import 'package:crux/frontend/screen/form/hangboard/bloc/hangboard_form_bloc.dart';
import 'package:crux/frontend/screen/form/workout/bloc/workout_form_screen_bloc.dart';
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

    injector.map((i) => AuthenticationBloc(
        authenticationService: injector.get<GoogleSignInAuthenticationService>()));
    /* Authentication */

    /* Dashboard */
    injector.map((i) {
      Firestore.instance.settings(persistenceEnabled: true);
      return Firestore.instance;
    }, isSingleton: true);
    injector.map((i) => serializers, isSingleton: true);

    injector.map(
        (i) => FirestoreWorkoutRepository(
            firestore: injector.get<Firestore>(), serializers: injector.get<Serializers>()),
        isSingleton: true);

    injector.map((i) => DashboardBloc(
          workoutRepository: injector.get<FirestoreWorkoutRepository>(),
        ));
    /* Dashboard */

    /* Workout Form */
    injector.map((i) => WorkoutFormBloc(), isSingleton: true);
    /* Workout Form */

    /* Hangboard Form*/
    injector.map((i) =>
        HangboardFormBloc(baseWorkoutRepository: injector.get<FirestoreWorkoutRepository>()));
    /* Hangboard Form*/
    return injector;
  }
}
