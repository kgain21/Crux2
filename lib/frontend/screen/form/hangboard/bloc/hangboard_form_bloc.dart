import 'package:bloc/bloc.dart';
import 'package:crux/backend/repository/workout/base_workout_repository.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:crux/backend/repository/workout/model/hangboard_exercise.dart';
import 'package:crux/model/finger_configuration.dart';
import 'package:crux/model/hold.dart';
import 'package:crux/util/null_util.dart';
import 'package:crux/util/string_format_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import 'hangboard_form_event.dart';
import 'hangboard_form_state.dart';

class HangboardFormBloc extends Bloc<HangboardFormEvent, HangboardFormState> {
  final BaseWorkoutRepository baseWorkoutRepository;

  HangboardFormBloc({@required this.baseWorkoutRepository});

  @override
  get initialState => HangboardFormState.initial();

  @override
  Stream<Transition<HangboardFormEvent, HangboardFormState>> transformEvents(eventStream, next) {
    /// Non text box fields don't need debounce
    final nonDebounceStream = eventStream.where((event) {
      return (event is NonDebounceEvent);
    });

    /// Debounce any field with a text box to delay validation
    final debounceStream = eventStream.where((event) {
      return (event is DebounceEvent);
    }).debounceTime(Duration(milliseconds: 500));

    return super.transformEvents(MergeStream([nonDebounceStream, debounceStream]), next);
  }

  @override
  Stream<HangboardFormState> mapEventToState(event) {
    if (event is ResistanceUnitChanged) {
      return _mapResistanceUnitChangedToState(event);
    } else if (event is DepthUnitChanged) {
      return _mapDepthUnitChangedToState(event);
    } else if (event is HandsChanged) {
      return _mapHandsChangedToState(event);
    } else if (event is HangProtocolChanged) {
      return _mapHangProtocolChangedToState(event);
    } else if (event is HoldChanged) {
      return _mapHoldChangedToState(event);
    } else if (event is FingerConfigurationChanged) {
      return _mapFingerConfigurationChangedToState(event);
    } else if (event is DepthChanged) {
      return _mapDepthChangedToState(event);
    } else if (event is RestDurationChanged) {
      return _mapRestDurationChangedToState(event);
    } else if (event is RepDurationChanged) {
      return _mapRepDurationChangedToState(event);
    } else if (event is HangsPerSetChanged) {
      return _mapHangsPerSetChangedToState(event);
    } else if (event is BreakDurationChanged) {
      return _mapBreakDurationChangedToState(event);
    } else if (event is ShowRestDurationChanged) {
      return _mapShowRestDurationChangedToState(event);
    } else if (event is NumberOfSetsChanged) {
      return _mapNumberOfSetsChangedToState(event);
    } else if (event is ShowResistanceChanged) {
      return _mapShowResistanceChangedToState(event);
    } else if (event is ResistanceChanged) {
      return _mapResistanceChangedToState(event);
    } else if (event is ResetFlags) {
      return _mapResetFlagsToState(event);
    } else if (event is InvalidSave) {
      return _mapInvalidSaveToState(event);
    } else if (event is ValidSave) {
      return _mapValidSaveToState(event);
    }
    return null;
  }

  Stream<HangboardFormState> _mapResistanceUnitChangedToState(ResistanceUnitChanged event) async* {
    yield state.update(resistanceUnit: event.resistanceUnit);
  }

  Stream<HangboardFormState> _mapDepthUnitChangedToState(DepthUnitChanged event) async* {
    yield state.update(depthUnit: event.depthUnit);
  }

  Stream<HangboardFormState> _mapHandsChangedToState(HandsChanged event) async* {
    yield state.update(hands: event.hands);
  }

  Stream<HangboardFormState> _mapHangProtocolChangedToState(HangProtocolChanged event) async* {
    yield state.update(hangProtocol: event.hangProtocol);
  }

  /// Logic to alter form fields shown based on hold selected.
  /// By default, all fields and values will be removed. Holds only add what they need when
  /// selected.
  Stream<HangboardFormState> _mapHoldChangedToState(HoldChanged event) async* {
    bool showFingerConfigurations = false;
    bool showDepth = false;

    // Either show all fingerConfigurations or none - wasn't able to find a way to 'reset'
    // DropDownButton when given different list indices that didn't line up.
    List<FingerConfiguration> availableFingerConfigurations;

    if (event.hold == Hold.POCKET) {
      showFingerConfigurations = true;
      availableFingerConfigurations = FingerConfiguration.values;
    } else if (event.hold == Hold.OPEN_HAND || event.hold == Hold.HALF_CRIMP) {
      showFingerConfigurations = true;
      availableFingerConfigurations = FingerConfiguration.values;
      showDepth = true;
    } else if (event.hold == Hold.FULL_CRIMP) {
      showDepth = true;
    }

    yield state.update(
      hold: event.hold,
      showFingerConfiguration: showFingerConfigurations,
      availableFingerConfigurations: Nullable(availableFingerConfigurations),
      fingerConfiguration: Nullable(null),
      showDepth: showDepth,
      depth: Nullable(null),
    );
  }

  Stream<HangboardFormState> _mapFingerConfigurationChangedToState(
      FingerConfigurationChanged event) async* {
    yield state.update(fingerConfiguration: Nullable(event.fingerConfiguration));
  }

  Stream<HangboardFormState> _mapDepthChangedToState(DepthChanged event) async* {
    if(doubleFieldInvalid(event.depth)) {
      yield state.update(validDepth: false);
    } else {
      yield state.update(depth: Nullable(event.depth), validDepth: true,);
    }
  }

  Stream<HangboardFormState> _mapRestDurationChangedToState(RestDurationChanged event) async* {
    if (integerFieldInvalid(event.restDuration)) {
      yield state.update(validRestDuration: false);
    } else {
      yield state.update(restDuration: Nullable(event.restDuration), validRestDuration: true);
    }
  }

  Stream<HangboardFormState> _mapRepDurationChangedToState(RepDurationChanged event) async* {
    if (integerFieldInvalid(event.repDuration)) {
      yield state.update(validRepDuration: false);
    } else {
      yield state.update(
        repDuration: event.repDuration,
        validRepDuration: true,
      );
    }
  }

  Stream<HangboardFormState> _mapHangsPerSetChangedToState(HangsPerSetChanged event) async* {
    if (integerFieldInvalid(event.hangsPerSet)) {
      yield state.update(validHangsPerSet: false);
    } else {
      yield state.update(
        hangsPerSet: event.hangsPerSet,
        validHangsPerSet: true,
      );
    }
  }

  Stream<HangboardFormState> _mapBreakDurationChangedToState(BreakDurationChanged event) async* {
    if (integerFieldInvalid(event.breakDuration)) {
      yield state.update(validBreakDuration: false);
    } else {
      yield state.update(breakDuration: event.breakDuration, validBreakDuration: true);
    }
  }

  Stream<HangboardFormState> _mapShowRestDurationChangedToState(
      ShowRestDurationChanged event) async* {
    yield state.update(
      showRestDuration: event.showRestDuration,
      restDuration: Nullable(null),
    );
  }

  Stream<HangboardFormState> _mapNumberOfSetsChangedToState(NumberOfSetsChanged event) async* {
    if (integerFieldInvalid(event.numberOfSets)) {
      yield state.update(validNumberOfSets: false);
    } else {
      // always set to valid to remove previous validation errors
      yield state.update(numberOfSets: event.numberOfSets, validNumberOfSets: true);
    }
  }

  Stream<HangboardFormState> _mapShowResistanceChangedToState(ShowResistanceChanged event) async* {
    yield state.update(
      showResistance: event.showResistance,
      resistance: Nullable(null),
      // remove resistance on hide so old values don't get added accidentally
      validResistance:
          true, // validate so removed resistance doesn't show validation error and prevent save
    );
  }

  Stream<HangboardFormState> _mapResistanceChangedToState(ResistanceChanged event) async* {
    // resistanceChanged can only come from resistance text input; any null/0 values from there should be
    // considered invalid since the input field must be toggled on to reach that state.
    if (event.resistance == null || event.resistance == 0) {
      yield state.update(
        validResistance: false,
        resistance: Nullable(null),
      );
    } else {
      // always set to valid to remove previous validation errors
      yield state.update(resistance: Nullable(event.resistance), validResistance: true);
    }
  }

  Stream<HangboardFormState> _mapResetFlagsToState(ResetFlags event) async* {
    yield state.update(
      isSuccess: false,
      isFailure: false,
      isDuplicate: false,
    );
  }

  Stream<HangboardFormState> _mapInvalidSaveToState(InvalidSave event) async* {
    yield state.update(autoValidate: true);
  }

  Stream<HangboardFormState> _mapValidSaveToState(ValidSave event) async* {
    try {
      var exerciseTitle = StringFormatUtil.createHangboardExerciseTitle(
        hold: state.hold,
        hands: state.hands,
        fingerConfiguration: state.fingerConfiguration,
        depth: state.depth,
        depthUnit: state.depthUnit,
        hangProtocol: state.hangProtocol,
      );
      yield state.update(exerciseTitle: exerciseTitle);

      HangboardExercise hangboardExercise = state.toHangboardExercise();

      if (_isDuplicate(hangboardExercise, event)) {
        yield state.update(isDuplicate: true, isSuccess: false, isFailure: false);
      }

      CruxWorkout workout = event.cruxWorkout
          .rebuild((cw) => cw.hangboardWorkout.hangboardExercises.add(hangboardExercise));

      var updatedWorkout = await baseWorkoutRepository.updateWorkout(event.cruxUser, workout);

      if (updatedWorkout != null) {
        yield state.update(isSuccess: true, isFailure: false, isDuplicate: false);
      } else {
        yield state.update(isFailure: true, isSuccess: false, isDuplicate: false);
      }
    } catch (e) {
      yield state.update(isFailure: true, isSuccess: false, isDuplicate: false);
    }
  }

  /// Check for duplicate exercises iterating through [hangboardExercises] and using overridden
  /// equality operator from [HangboardExercise].
  bool _isDuplicate(HangboardExercise hangboardExercise, ValidSave event) {
    if(event.cruxWorkout.hangboardWorkout == null) {
      return false;
    }

    for (var exercise in event.cruxWorkout.hangboardWorkout.hangboardExercises) {
      if (hangboardExercise == exercise) {
        return true;
      }
    }

    return false;
  }

  bool integerFieldInvalid(int field) => field == null || field.isNegative || field == 0;
  bool doubleFieldInvalid(double field) => field == null || field.isNegative || field == 0;
}
