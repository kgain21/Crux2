import 'package:bloc/bloc.dart';
import 'package:crux/backend/bloc/dashboard/dashboard_event.dart';

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
    }
    else if (event is DepthUnitChanged) {
      return _mapDepthUnitChangedToState(event);
    }
    else if (event is HandsChanged) {
      return _mapHandsChangedToState(event);
    }
    else if (event is HoldChanged) {
      return _mapHoldChangedToState(event);
    }
    else if (event is FingerConfigurationChanged) {
      return _mapFingerConfigurationChangedToState(event);
    }
    else if (event is DepthChanged) {
      return _mapDepthChangedToState(event);
    }
    else if (event is TimeOffChanged) {
      return _mapTimeOffChangedToState(event);
    }
    else if (event is TimeOnChanged) {
      return _mapTimeOnChangedToState(event);
    }
    else if (event is HangsPerSetChanged) {
      return _mapHangsPerSetChangedToState(event);
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
    yield state.update(hold: event.hold);
  }

  Stream<HangboardFormState> _mapFingerConfigurationChangedToState(FingerConfigurationChanged event) async* {
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
}
