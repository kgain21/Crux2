import 'package:bloc/bloc.dart';
import 'package:crux/backend/bloc/dashboard/dashboard_event.dart';
import 'package:crux/backend/bloc/dashboard/dashboard_state.dart';

class DashboardBloc extends Bloc {

  @override
  get initialState => DashboardUninitialized();

  @override
  Stream mapEventToState(event) {
    if(event is CalendarDateChanged) {
      return _mapCalendarDateChangedToState(event);
    }
    return null;
  }

  Stream _mapCalendarDateChangedToState(CalendarDateChanged event) async*{
    yield DashboardInitialized();
  }
}
