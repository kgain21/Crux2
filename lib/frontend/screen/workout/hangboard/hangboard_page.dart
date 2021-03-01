import 'dart:math';

import 'package:crux/backend/repository/timer/timer_direction.dart';
import 'package:crux/backend/repository/workout/model/hangboard_exercise.dart';
import 'package:crux/frontend/screen/workout/hangboard/bloc/exercise/hangboard_exercise_bloc.dart';
import 'package:crux/frontend/screen/workout/hangboard/bloc/exercise/hangboard_exercise_event.dart';
import 'package:crux/frontend/screen/workout/hangboard/bloc/exercise/hangboard_exercise_state.dart';
import 'package:crux/frontend/screen/workout/hangboard/exercise_tile.dart';
import 'package:crux/frontend/screen/workout/timer/bloc/timer_bloc.dart';
import 'package:crux/frontend/screen/workout/timer/bloc/timer_event.dart';
import 'package:crux/frontend/screen/workout/timer/bloc/timer_state.dart';
import 'package:crux/frontend/screen/workout/timer/circular_timer.dart';
import 'package:crux/frontend/util_widget/loading_indicator.dart';
import 'package:crux/util/string_format_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HangboardExercisePage extends StatefulWidget {
  final int index;

  final String workoutTitle;
  final HangboardExercise hangboardExercise;

  final TimerBloc timerBloc;
  final HangboardExerciseBloc hangboardExerciseBloc;

  final Map snackBarMessages = {
    'setComplete': 'Set Complete!',
    'exerciseComplete': 'Exercise Complete!',
  };

  HangboardExercisePage({
    @required this.index,
    @required this.workoutTitle,
    @required this.hangboardExercise,
    @required this.timerBloc,
    @required this.hangboardExerciseBloc,
  });

  @override
  State<HangboardExercisePage> createState() => _HangboardExercisePageState();
}

class _HangboardExercisePageState extends State<HangboardExercisePage>
    with SingleTickerProviderStateMixin {
  AnimationController _timerController;

  @override
  void initState() {
    _timerController = AnimationController(
        vsync: this,
        value: 1.0,
        duration: Duration(seconds: widget.hangboardExercise.restDuration),
        reverseDuration: Duration(seconds: widget.hangboardExercise.repDuration));

    super.initState();
  }

  @override
  void dispose() {
//    _timerBloc.add(DisposeTimer());
//    _hangboardExerciseBloc.add(DisposeHangboardExercise());
    widget.timerBloc.close();
    widget.hangboardExerciseBloc.close();
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => widget.hangboardExerciseBloc,
      child: BlocListener(
        cubit: widget.hangboardExerciseBloc,
        listener: (BuildContext context, HangboardExerciseState state) {
          if (state.currentHangsPerSet == 0) {
            _showGenericSnackBar(context, widget.snackBarMessages['setComplete']);
          } else if (state.currentHangsPerSet == 0 && state.currentNumberOfSets == 0) {
            _showGenericSnackBar(context, widget.snackBarMessages['exerciseComplete']);
          }
        },
        child: BlocBuilder(
          cubit: widget.hangboardExerciseBloc,
          builder: (BuildContext context, HangboardExerciseState state) {
//            if (state is HangboardExercisePreferencesCleared) {}
            if (state.hangboardExerciseType == HangboardExerciseType.LOADING) {
              widget.hangboardExerciseBloc
                  .add(HangboardExerciseLoaded(hangboardExercise: widget.hangboardExercise));

              return LoadingIndicator();
            } else {
              return _buildHangboardPage(state);
            }
          },
        ),
      ),
    );
  }

  Container _buildHangboardPage(state) {
    return Container(
      child: ListView(
        children: <Widget>[
          _titleTile(state),
          _workoutTimerTile(state),
          IntrinsicHeight(
            child: Row(
              children: <Widget>[
                _hangsAndResistanceTile(state),
                _setsTile(state),
              ],
            ),
          ),
          _notesTile(state),
        ],
      ),
    );
  }

  Widget _titleTile(HangboardExerciseState state) {
    return ExerciseTile(
      tileColor: Theme.of(context).accentColor,
      child: Container(
        height: MediaQuery.of(context).size.width / 6.0,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width / 35,
            MediaQuery.of(context).size.height / 70,
            MediaQuery.of(context).size.width / 35,
            MediaQuery.of(context).size.height / 70,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${state.exerciseTitle}',
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 18.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _workoutTimerTile(HangboardExerciseState hangboardState) {
    return BlocProvider(
      create: (context) => widget.timerBloc,
      child: BlocBuilder(
        cubit: widget.timerBloc,
        builder: (BuildContext context, TimerState timerState) {
          if (timerState is TimerLoadInProgress) {
            widget.timerBloc.add(TimerLoaded(
              exerciseTitle: widget.hangboardExercise.exerciseTitle,
              duration: widget.hangboardExercise.repDuration,
              isTimerRunning: false,
            ));
            return LoadingIndicator();
          }
          if (timerState is TimerLoadSuccess) {
            VoidCallback timerControllerCallback =
                _determineTimerAnimation(hangboardState, timerState);

            if (timerState.timer.isTimerRunning) {
              timerControllerCallback();
            }

            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.width / 1.2,
              ),
              child: ExerciseTile(
                child: Stack(
                  children: <Widget>[
                    _workoutTimer(context, timerControllerCallback, timerState),
                    _timerSwitchButtons(hangboardState),
                  ],
                ),
              ),
            );
          } else {
            return _loadingScreen();
          }
        },
      ),
    );
  }

  /// Creates the function for animating the timer based on the current state
  /// of the timer and hangboardWorkout. When the function completes, an event
  /// is dispatched to update the state.
  ///
  /// This was extracted out of the [CircularTimer] so that the [HangboardExercisePage]
  /// could also make use of the animation controller. It ended up being easier
  /// to define the controller at a higher level and pass it down to the timer.
  VoidCallback _determineTimerAnimation(
      HangboardExerciseState hangboardExerciseState, TimerLoadSuccess timerState) {
    _timerController.value = timerState.controllerStartValue;

    if (timerState.timer.direction == TimerDirection.COUNTERCLOCKWISE) {
      _timerController.reverseDuration = Duration(seconds: timerState.timer.duration);
      return () {
        _timerController.reverse().whenComplete(() {
          if (_timerController.status == AnimationStatus.dismissed) {
            widget.hangboardExerciseBloc.add(HangboardExerciseReverseComplete(
              timerState.timer,
              widget.timerBloc,
            ));
          }
        }).catchError((error) {
          print('Timer failed animating counterclockwise: $error');
          _timerController.stop(canceled: false);
        });
      };
    } else {
      _timerController.duration = Duration(seconds: timerState.timer.duration);
      return () {
        _timerController.forward().whenComplete(() {
          if (_timerController.status == AnimationStatus.completed) {
            widget.hangboardExerciseBloc.add(HangboardExerciseForwardComplete(
              timerState.timer,
              widget.timerBloc,
            ));
          }
        }).catchError((error) {
          print('Timer failed animating clockwise: $error');
          _timerController.stop(canceled: false);
        });
      };
    }
  }

  /// Positions and scales the [CircularTimer] for the [HangboardExercisePage]
  Positioned _workoutTimer(
      BuildContext context, VoidCallback timerControllerCallback, TimerLoadSuccess timerState) {
    return Positioned(
      top: 0.0,
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.width / 1.4,
            ),
            child: CircularTimer(
              timerController: _timerController,
              timerControllerCallback: timerControllerCallback,
              timerState: timerState,
            ),
          ),
        ],
      ),
    );
  }

  Positioned _timerSwitchButtons(HangboardExerciseState hangboardState) {
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
//          color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
          child: BlocBuilder<HangboardExerciseBloc, HangboardExerciseState>(
            buildWhen: (previousState, state) =>
                state.hangboardExerciseType == HangboardExerciseType.SWITCH_BUTTON_PRESSED,
            builder: (context, state) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    size: MediaQuery.of(context).size.width / 15.0,
                  ),
                  onPressed: () {
                    widget.hangboardExerciseBloc.add(HangboardExerciseForwardSwitchButtonPressed(
                      widget.timerBloc,
                    ));
                  },
                ),
                IconButton(
                  icon: Icon(
                    IconData(
                      0xe5d5,
                      fontFamily: 'MaterialIcons',
                      matchTextDirection: true,
                    ),
                    size: MediaQuery.of(context).size.width / 15.0,
                    textDirection: TextDirection.rtl,
                  ),
                  onPressed: () {
                    widget.hangboardExerciseBloc.add(HangboardExerciseReverseSwitchButtonPressed(
                      widget.timerBloc,
                    ));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _hangsAndResistanceTile(HangboardExerciseState state) {
    var currentHangsPerSet = state.currentHangsPerSet;
    return Container(
//      color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2.0),
      child: ExerciseTile(
        edgeInsets: const EdgeInsets.only(left: 8.0, top: 8.0, right: 4.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  currentHangsPerSet < state.originalHangsPerSet
                      ? IconButton(
                          icon: Icon(
                            Icons.arrow_drop_up,
                            size: MediaQuery.of(context).size.width / 15.0,
                          ),
                          onPressed: () {
                            if (currentHangsPerSet != state.originalHangsPerSet) {
                              _timerController.stop(canceled: false);
                              widget.hangboardExerciseBloc
                                  .add(HangboardExerciseIncreaseNumberOfHangsButtonPressed(
                                widget.timerBloc,
                              ));
                            }
                          })
                      : IconButton(
                          /// Placeholder button that does nothing
                          /// (can't go higher than originalNumberOfHangs)
                          onPressed: () => null,
                          icon: Icon(
                            Icons.arrow_drop_up,
                            size: MediaQuery.of(context).size.width / 15.0,
                            color: Theme.of(context).primaryColorLight,
                          ),
                        ),
                  Text(
                    '$currentHangsPerSet',
                    style: TextStyle(fontSize: 30.0),
                  ),
                  currentHangsPerSet > 0
                      ? IconButton(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            size: MediaQuery.of(context).size.width / 15.0,
                          ),
                          onPressed: () {
                            if (currentHangsPerSet != 0) {
                              _timerController.stop(canceled: false);
                              widget.hangboardExerciseBloc
                                  .add(HangboardExerciseDecreaseNumberOfHangsButtonPressed(
                                widget.timerBloc,
                              ));
                            }
                          },
                        )
                      : IconButton(
                          /// Placeholder button that does nothing
                          /// (can't go lower than originalNumberOfHangs)
                          onPressed: () => null,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            size: MediaQuery.of(context).size.width / 15.0,
                            color: Theme.of(context).primaryColorLight,
                          ),
                        ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      StringFormatUtil.formatHangsAndResistance(
                          currentHangsPerSet, state.resistance.toInt(), state.resistanceUnit),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: MediaQuery.of(context).size.width / 20.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _setsTile(HangboardExerciseState state) {
    var currentNumberOfSets = state.currentNumberOfSets;

    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2.0),
      child: ExerciseTile(
        edgeInsets: const EdgeInsets.only(left: 4.0, top: 8.0, right: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  currentNumberOfSets < state.originalNumberOfSets
                      ? IconButton(
                          icon: Icon(
                            Icons.arrow_drop_up,
                            size: MediaQuery.of(context).size.width / 15.0,
                          ),
                          onPressed: () {
                            if (currentNumberOfSets != state.originalNumberOfSets) {
                              _timerController.stop(canceled: false);
                              widget.hangboardExerciseBloc
                                  .add(HangboardExerciseIncreaseNumberOfSetsButtonPressed(
                                widget.timerBloc,
                              ));
                            }
                          },
                        )
                      : IconButton(
                          onPressed: () => null,
                          icon: Icon(
                            Icons.arrow_drop_up,
                            size: MediaQuery.of(context).size.width / 15.0,
                            color: Theme.of(context).primaryColorLight,
                          ),
                        ),
                  Text(
                    '$currentNumberOfSets',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 12.0,
                    ),
                  ),
                  currentNumberOfSets > 0
                      ? IconButton(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            size: MediaQuery.of(context).size.width / 15.0,
                          ),
                          onPressed: () {
                            if (currentNumberOfSets != 0) {
                              _timerController.stop(canceled: false);
                              widget.hangboardExerciseBloc
                                  .add(HangboardExerciseDecreaseNumberOfSetsButtonPressed(
                                widget.timerBloc,
                              ));
                            }
                          },
                        )
                      : IconButton(
                          onPressed: () => null,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            size: MediaQuery.of(context).size.width / 15.0,
                            color: Theme.of(context).primaryColorLight,
                          ),
                        ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      currentNumberOfSets == 1 ? ' Set' : ' Sets',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: MediaQuery.of(context).size.width / 20.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _notesTile(HangboardExerciseState state) {
    return ExerciseTile(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Notes: ',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            TextField(),
          ],
        ),
      ),
    );
  }

  Widget _loadingScreen() {
    return Column(
      children: <Widget>[
        /*Empty to help avoid any flickering from quick loads*/
      ],
    );
  }

  void _showGenericSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(fontSize: 25.0, color: Theme.of(context).accentColor),
            ),
          ],
        ),
      ),
    );
  }
}
