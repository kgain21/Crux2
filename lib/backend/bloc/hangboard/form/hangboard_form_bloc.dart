import 'package:bloc/bloc.dart';
import 'package:crux/model/finger_configuration.dart';
import 'package:crux/model/hold_enum.dart';

import 'hangboard_form_event.dart';
import 'hangboard_form_state.dart';

class HangboardFormBloc extends Bloc<HangboardFormEvent, HangboardFormState> {
  HangboardFormBloc();

  @override
  get initialState => HangboardFormState.initial();

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
    } else if (event is TimeOffChanged) {
      return _mapTimeOffChangedToState(event);
    } else if (event is TimeOnChanged) {
      return _mapTimeOnChangedToState(event);
    } else if (event is HangsPerSetChanged) {
      return _mapHangsPerSetChangedToState(event);
    } else if (event is TimeBetweenSetsChanged) {
      return _mapTimeBetweenSetsChangedToState(event);
    } else if (event is NumberOfSetsChanged) {
      return _mapNumberOfSetsChangedToState(event);
    } else if (event is ResistanceChanged) {
      return _mapResistanceChangedToState(event);
    } else if (event is ResetFlags) {
      return _mapResetFlagsToState(event);
    } else if (event is InvalidSave) {
      return _mapInvalidSaveToState(event);
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

  Stream<HangboardFormState> _mapHoldChangedToState(HoldChanged event) async* {
    bool showFingerConfigurations = false;
    bool showDepth = false;
    double depth = state.depth;
    List<FingerConfiguration> availableFingerConfigurations = FingerConfiguration.values;
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
    }
    /*else {
      fingerConfiguration = null;
      depth = null;
    }*/

    yield state.update(
      hold: event.hold,
      showFingerConfiguration: showFingerConfigurations,
      availableFingerConfigurations: availableFingerConfigurations,
      // todo - leaving these null for now. Test UI to see if nulling out all the time is better vs. only removing for particular holds
      fingerConfiguration: null,
      showDepth: showDepth,
      depth: null,
    );
  }

  Stream<HangboardFormState> _mapFingerConfigurationChangedToState(
      FingerConfigurationChanged event) async* {
    yield state.update(fingerConfiguration: event.fingerConfiguration);
  }

  Stream<HangboardFormState> _mapDepthChangedToState(DepthChanged event) async* {
    //todo: old project has non-negative validation - double check if this can just be handled by
    //todo: making text box not support negative numbers
    yield state.update(depth: event.depth);
  }

  Stream<HangboardFormState> _mapTimeOffChangedToState(TimeOffChanged event) async* {
    //todo: same; make sure null values can't get through? think about what's optional/not
    yield state.update(timeOff: event.timeOff);
  }

  Stream<HangboardFormState> _mapTimeOnChangedToState(TimeOnChanged event) async* {
    //todo: same; make sure null values can't get through? think about what's optional/not
    yield state.update(timeOn: event.timeOn);
  }

  Stream<HangboardFormState> _mapHangsPerSetChangedToState(HangsPerSetChanged event) async* {
    //todo: same; make sure null values can't get through? think about what's optional/not
    yield state.update(hangsPersSet: event.hangsPerSet);
  }

  Stream<HangboardFormState> _mapTimeBetweenSetsChangedToState(
      TimeBetweenSetsChanged event) async* {
    //todo: same; make sure null values can't get through? think about what's optional/not
    yield state.update(timeBetweenSets: event.timeBetweenSets);
  }

  Stream<HangboardFormState> _mapNumberOfSetsChangedToState(NumberOfSetsChanged event) async* {
    //todo: same; make sure null values can't get through? think about what's optional/not
    yield state.update(numberOfSets: event.numberOfSets);
  }

  Stream<HangboardFormState> _mapResistanceChangedToState(ResistanceChanged event) async* {
    //todo: same; make sure null values can't get through? think about what's optional/not
    yield state.update(resistance: event.resistance);
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
}
