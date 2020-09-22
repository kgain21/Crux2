import 'package:bloc/bloc.dart';
import 'package:crux/backend/bloc/dashboard/dashboard_event.dart';

import 'hangboard_form_event.dart';
import 'hangboard_form_state.dart';

class HangboardFormBloc extends Bloc<HangboardFormEvent, HangboardFormState> {

  HangboardFormBloc();

  @override
  get initialState => HangboardFormUninitialized();

  @override
  Stream<HangboardFormState> mapEventToState(event) {
    if (event is CalendarDateChanged) {
      return _mapCalendarDateChangedToState();
    }
    return null;
  }

  Stream<HangboardFormState> _mapCalendarDateChangedToState() async* {
//    yield DashboardDateChangeInProgress();

//    var date = event.selectedDate;
    try {
//      CruxWorkout cruxWorkout = await workoutRepository.findWorkoutByDate(date, event.cruxUser);

//      if (null != cruxWorkout) {
//        yield DashboardDateChangeSuccess(selectedDate: date, cruxWorkout: cruxWorkout);
//      } else {
//        yield DashboardDateChangeNotFound(selectedDate: date);
//      }
    } catch (error) {
//      log('Failed to retrieve CruxWorkout.', error: error);
//      yield DashboardDateChangeError(selectedDate: date);
    }
  }
}
