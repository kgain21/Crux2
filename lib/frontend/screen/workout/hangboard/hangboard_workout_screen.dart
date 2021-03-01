import 'package:crux/backend/repository/workout/model/hangboard_exercise.dart';
import 'package:crux/backend/repository/workout/model/hangboard_workout.dart';
import 'package:crux/frontend/screen/workout/hangboard/bloc/exercise/hangboard_exercise_bloc.dart';
import 'package:crux/frontend/screen/workout/hangboard/bloc/workout/hangboard_workout_bloc.dart';
import 'package:crux/frontend/screen/workout/hangboard/bloc/workout/hangboard_workout_event.dart';
import 'package:crux/frontend/screen/workout/hangboard/bloc/workout/hangboard_workout_state.dart';
import 'package:crux/frontend/screen/workout/hangboard/dots_indicator.dart';
import 'package:crux/frontend/screen/workout/hangboard/hangboard_page.dart';
import 'package:crux/frontend/screen/workout/timer/bloc/timer_bloc.dart';
import 'package:crux/frontend/util_widget/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HangboardWorkoutScreenArguments {
  final HangboardWorkout hangboardWorkout;

  HangboardWorkoutScreenArguments({
    @required this.hangboardWorkout,
  });
}

class HangboardWorkoutScreen extends StatefulWidget {
  static const routeName = '/hangboardWorkout';

  final HangboardWorkoutBloc hangboardWorkoutBloc;
  final HangboardExerciseBloc hangboardExerciseBloc;
  final TimerBloc timerBloc;
  final HangboardWorkout hangboardWorkout;

  const HangboardWorkoutScreen({
    @required this.hangboardWorkoutBloc,
    @required this.hangboardExerciseBloc,
    @required this.timerBloc,
    @required this.hangboardWorkout,
  });

  @override
  State<StatefulWidget> createState() => _HangboardWorkoutScreenState();
}

class _HangboardWorkoutScreenState extends State<HangboardWorkoutScreen> {
  static const _kCurve = Curves.ease;
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kViewportFraction = 0.7;

  ValueNotifier<double> selectedIndex = ValueNotifier<double>(0.0);
  PageController _controller;
  int _pageCount;
  double _currentPageValue;
  bool _isEditing;
  bool _preferencesClearedFlag;

  _HangboardWorkoutScreenState();

  @override
  void initState() {
    super.initState();

    _currentPageValue = 0.0;
    _isEditing = false;
//    _preferencesClearedFlag = false;

    /// [_controller] is 0 indexed but snapshot is not; add 1 to snapshot
    /// index to create a [newExercisePage].
    _pageCount = 0;

    _controller = new PageController(keepPage: false /*initialPage: _index - 2*/);
    _controller.addListener(() {
      setState(() {
        _currentPageValue = _controller.page;
      });
    });
  }

  @override
  void dispose() {
    widget.hangboardWorkoutBloc.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('hangboardWorkoutScreenScaffold'),
      appBar: AppBar(
        elevation: 8.0,
        actions: <Widget>[buildPopupMenuButton()],
        //TODO: Add action menu that allows you to reset all exercises (clear sharedPrefs)
      ),
      body: BlocBuilder<HangboardWorkoutBloc, HangboardWorkoutState>(
          cubit: widget.hangboardWorkoutBloc,
          builder: (context, state) {
            if (state is HangboardWorkoutLoadInProgress) {
              widget.hangboardWorkoutBloc
                  .add(HangboardWorkoutLoaded(hangboardWorkout: widget.hangboardWorkout));

              return LoadingIndicator();
            }

            if (state is HangboardWorkoutEditInProgress) {
              _isEditing = true;
            } else {
              _isEditing = false;
            }

            return exercisePageView(widget.hangboardWorkout, context);
          }),
    );
  }

  Center exercisePageView(HangboardWorkout hangboardWorkout, BuildContext context) {
    int exerciseCount = 0;
    var exerciseList = hangboardWorkout.hangboardExercises.toList();
    exerciseCount = exerciseList.length;

    _pageCount = exerciseCount; // + 1;

    return Center(
      child: new Container(
        color: Theme.of(context).canvasColor,
        child: GestureDetector(
          onLongPress: () {
            widget.hangboardWorkoutBloc.add(ExerciseTileLongPressed(hangboardWorkout));
          },
          onTap: () {
            widget.hangboardWorkoutBloc.add(ExerciseTileTapped(hangboardWorkout));
          },
          child: Stack(
            children: <Widget>[
              PageView.custom(
                childrenDelegate: SliverChildBuilderDelegate(
                  (context, index) {
//                    if (index == hangboardWorkout.hangboardExercises.length) {
//                      return newExercisePage();
//                    } else {
                    return animatedHangboardPage(index, hangboardWorkout.hangboardExercises[index]);
//                    }
                  },
                  childCount: hangboardWorkout.hangboardExercises.length,
                ),
                controller: _controller,
//                children: createPageList(hangboardWorkout),
              ),
              dotsIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> createPageList(HangboardWorkout hangboardWorkout) {
    final List<Widget> pages = <Widget>[];
//    double pictureHeight = MediaQuery.of(context).size.height * 0.6;
//    double pictureWidth = MediaQuery.of(context).size.width * 0.6;

    for (int i = 0; i < _pageCount; i++) {
      Widget child;
//
//      if (i == hangboardWorkout.hangboardExercises.length) {
//        child = newExercisePage();
//      } else {
        child = animatedHangboardPage(i, hangboardWorkout.hangboardExercises[i]);
//      }

      /*  var alignment = Alignment.center
          .add(Alignment((selectedIndex.value - i) * _kViewportFraction, 0.0));
      var resizeFactor =
          (1 - (((selectedIndex.value - i).abs() * 0.3).clamp(0.0, 1.0)));

      if (_zoomOut) {
        pages.add(Container(
          child: AspectRatio(
            aspectRatio: _kViewportFraction,
            child: child,
          ),
        ));
      } else {*/
      pages.add(Container(
        child: child,
      ));
//      }
    }

    return pages;
  }

  Widget newExercisePage() {
//    todo: do I want this anymore? just adds more complexity to this already complex screen
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
//        GestureDetector(
//          onTap: () {
//            Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) {
//                return ExerciseForm(
//                  workoutTitle: widget.hangboardWorkoutTitle,
//                  firestoreHangboardWorkoutsRepository: widget.hangboardWorkoutsRepository,
//                );
//              }),
//            );
//          },
//          child: Icon(
//            Icons.add,
//            size: MediaQuery.of(context).size.width / 5.0,
//          ),
//        ),
        Text(
          'Add New Exercise',
          style: TextStyle(fontSize: MediaQuery.of(context).size.width / 14.0),
        ),
      ],
    );
  }

  Widget animatedHangboardPage(int index, HangboardExercise hangboardExercise) {
    /// Last page should always be a [newExercisePage()]. This index will always
    /// be greater than the current exercises list so this must be checked first
    if (index == _currentPageValue.floor()) {
      return Transform(
        transform: Matrix4.identity()..rotateX(_currentPageValue - index),
        child: Stack(
          children: <Widget>[
            HangboardExercisePage(
              workoutTitle: widget.hangboardWorkout.workoutTitle,
              index: index,
              hangboardExercise: hangboardExercise,
              hangboardExerciseBloc: widget.hangboardExerciseBloc,
              timerBloc: widget.timerBloc,
            ),
            _isEditing ? exerciseDeleteButton(hangboardExercise) : null,
          ].where(notNull).toList(),
        ),
      );
    } else if (index == _currentPageValue.floor() + 1) {
      return Transform(
        transform: Matrix4.identity()..rotateY(_currentPageValue - index),
        child: Stack(
          children: <Widget>[
            HangboardExercisePage(
              workoutTitle: hangboardExercise.exerciseTitle,
              index: index,
              hangboardExercise: hangboardExercise,
              hangboardExerciseBloc: widget.hangboardExerciseBloc,
              timerBloc: widget.timerBloc,
            ),
            _isEditing ? exerciseDeleteButton(hangboardExercise) : null,
          ].where(notNull).toList(),
        ),
      );
    }

    return Stack(
      children: <Widget>[
        HangboardExercisePage(
          workoutTitle: hangboardExercise.exerciseTitle,
          index: index,
          hangboardExercise: hangboardExercise,
          hangboardExerciseBloc: widget.hangboardExerciseBloc,
          timerBloc: widget.timerBloc,
        ),
        _isEditing ? exerciseDeleteButton(hangboardExercise) : null,
      ].where(notNull).toList(),
    );
  }

  Padding exerciseDeleteButton(HangboardExercise hangboardExercise) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          IconButton(
            color: Colors.black,
            icon: Icon(Icons.cancel),
            onPressed: () {
              widget.hangboardWorkoutBloc.add(HangboardWorkoutExerciseDeleted(hangboardExercise));
              //TODO: ask user for delete confirmation
            },
          ),
        ],
      ),
    );
  }

  bool notNull(Object o) => o != null;

  Widget dotsIndicator() {
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: DotsIndicator(
            color: Theme.of(context).primaryColorLight,
            controller: /*_zoomOut ? _zoomController :*/ _controller,
            itemCount: _pageCount,
            onPageSelected: (int page) {
              _controller.animateToPage(
                page,
                duration: _kDuration,
                curve: _kCurve,
              );
            },
          ),
        ),
      ),
    );
  }

  PopupMenuButton<String> buildPopupMenuButton() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        //TODO: switch statement for more menuButtons
        if (value == 'reset workout') {
          SharedPreferences.getInstance().then((preferences) {
            preferences.getKeys().forEach((key) {
//              if (key.contains(widget.hangboardWorkoutTitle)) preferences.remove(key);
            });
            setState(() {
              _preferencesClearedFlag = !_preferencesClearedFlag;
            });
          });
        } else if (value == 'clear sharedPreferences') {
          SharedPreferences.getInstance().then((preferences) {
            preferences.clear();
          });
        } else {
          SharedPreferences.getInstance().then((preferences) {
            print('----------------------------------------------------');
            preferences.getKeys().forEach((key) => print('$key: ${preferences.get(key)}\n'));
            print('----------------------------------------------------');
          });
        }
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuItem<String>>[
          new PopupMenuItem(
            child: new Text('Reset Workout'),
            value: 'reset workout',
          ),
          new PopupMenuItem(
            child: new Text('Clear SharedPreferences'),
            value: 'clear sharedPreferences',
          ),
          new PopupMenuItem(
            child: new Text('Print SharedPreferences'),
            value: 'print sharedPreferences',
          ),
        ];
      },
    );
  }

  void nextPageCallback() {
    _controller.nextPage(duration: _kDuration, curve: _kCurve);
  }
}
