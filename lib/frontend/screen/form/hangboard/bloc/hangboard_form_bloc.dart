import 'package:bloc/bloc.dart';
import 'package:crux/backend/repository/workout/base_workout_repository.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:crux/backend/repository/workout/model/hangboard_exercise.dart';
import 'package:crux/model/finger_configuration.dart';
import 'package:crux/model/hold_enum.dart';
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
    } else if (event is HoldChanged) {
      return _mapHoldChangedToState(event);
    } else if (event is FingerConfigurationChanged) {
      return _mapFingerConfigurationChangedToState(event);
    } else if (event is DepthChanged) {
      return _mapDepthChangedToState(event);
    } else if (event is RestDurationChanged) {
      return _mapTimeOffChangedToState(event);
    } else if (event is RepDurationChanged) {
      return _mapTimeOnChangedToState(event);
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

  ///
  Stream<HangboardFormState> _mapHoldChangedToState(HoldChanged event) async* {
    bool showFingerConfigurations = false;
    bool showDepth = false;
    double depth = state.depth;
    List<FingerConfiguration> availableFingerConfigurations;
    FingerConfiguration fingerConfiguration = state.fingerConfiguration;

    if (event.hold == Hold.POCKET) {
      availableFingerConfigurations = FingerConfiguration.values.sublist(0, 7);
      showFingerConfigurations = true;
    } else if (event.hold == Hold.OPEN_HAND || event.hold == Hold.HALF_CRIMP) {
      showFingerConfigurations = true;
      availableFingerConfigurations = FingerConfiguration.values.sublist(4);
      showDepth = true;
    } else if (event.hold == Hold.FULL_CRIMP) {
      showDepth = true;
    } else {
      fingerConfiguration = null;
      depth = null;
    }

    yield state.update(
      hold: event.hold,
      showFingerConfiguration: showFingerConfigurations,
      availableFingerConfigurations: Nullable(availableFingerConfigurations),
      // todo - leaving these null for now. Test UI to see if nulling out all the time is better vs. only removing for particular holds
      // basically saying WHENEVER a hold changes, remove depth/fingerConfig so old values don't remain set in the state by accident.
      // this would force the user to redo values in some cases - need to test if this makes sense all the time vs. just for some cases
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
    //todo: old project has non-negative validation - double check if this can just be handled by
    //todo: making text box not support negative numbers
    yield state.update(depth: Nullable(event.depth));
  }

  Stream<HangboardFormState> _mapTimeOffChangedToState(RestDurationChanged event) async* {
    //todo: same; make sure null values can't get through? think about what's optional/not
    yield state.update(restDuration: Nullable(event.restDuration));
  }

  Stream<HangboardFormState> _mapTimeOnChangedToState(RepDurationChanged event) async* {
    //todo: same; make sure null values can't get through? think about what's optional/not
    yield state.update(repDuration: event.repDuration);
  }

  Stream<HangboardFormState> _mapHangsPerSetChangedToState(HangsPerSetChanged event) async* {
    //todo: same; make sure null values can't get through? think about what's optional/not
    yield state.update(hangsPerSet: event.hangsPerSet);
  }

  Stream<HangboardFormState> _mapBreakDurationChangedToState(BreakDurationChanged event) async* {
    //todo: same; make sure null values can't get through? think about what's optional/not
    yield state.update(breakDuration: event.breakDuration);
  }

  Stream<HangboardFormState> _mapShowRestDurationChangedToState(
      ShowRestDurationChanged event) async* {
    yield state.update(
      showRestDuration: event.showRestDuration,
      restDuration: Nullable(null),
    );
  }

  Stream<HangboardFormState> _mapNumberOfSetsChangedToState(NumberOfSetsChanged event) async* {
    //todo: same; make sure null values can't get through? think about what's optional/not
    yield state.update(numberOfSets: event.numberOfSets);
  }

  Stream<HangboardFormState> _mapShowResistanceChangedToState(ShowResistanceChanged event) async* {
    yield state.update(
      showResistance: event.showResistance,
      resistance: Nullable(null),
    );
  }

  Stream<HangboardFormState> _mapResistanceChangedToState(ResistanceChanged event) async* {
    if (null != event.resistance && event.resistance.isNegative) {
      yield state.update(validResistance: false);
    } else {
      yield state.update(resistance: Nullable(event.resistance));
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
    for (var exercise in event.cruxWorkout.hangboardWorkout.hangboardExercises) {
      if (hangboardExercise == exercise) {
        return true;
      }
    }

    return false;
  }
}
