import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:crux/backend/util/model/state_container.dart';
import 'package:crux/frontend/screen/form/hangboard/hangboard_form_screen.dart';
import 'package:crux/frontend/screen/form/workout/bloc/workout_form_bloc.dart';
import 'package:crux/frontend/screen/form/workout/bloc/workout_form_event.dart';
import 'package:crux/frontend/screen/form/workout/bloc/workout_form_state.dart';
import 'package:crux/frontend/screen/workout/hangboard/hangboard_workout_screen.dart';
import 'package:crux/frontend/util_widget/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutFormScreenArguments {
  final CruxWorkout cruxWorkout;

  WorkoutFormScreenArguments({
    @required this.cruxWorkout,
  });
}

class WorkoutFormScreen extends StatefulWidget {
  static const routeName = '/workoutForm';

  final WorkoutFormBloc workoutFormBloc;

  final CruxWorkout cruxWorkout;

  const WorkoutFormScreen({
    @required this.workoutFormBloc,
    @required this.cruxWorkout,
  });

  @override
  State<StatefulWidget> createState() => _WorkoutFormScreenState(workoutFormBloc: workoutFormBloc);
}

class _WorkoutFormScreenState extends State<WorkoutFormScreen> {
  final WorkoutFormBloc workoutFormBloc;

  _WorkoutFormScreenState({@required this.workoutFormBloc});

  static const Map<String, String> gridTileMap = {
    'Stretching': WorkoutFormScreen.routeName,
    'Campus Board': WorkoutFormScreen.routeName,
    'Hangboard Workout': HangboardWorkoutScreen.routeName,
    'Hangboard Form': HangboardFormScreen.routeName,
    'Climbing': WorkoutFormScreen.routeName,
    'Core': WorkoutFormScreen.routeName,
    'Strength': WorkoutFormScreen.routeName
  };

  @override
  void dispose() {
    workoutFormBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        //todo: can I wrap this in a blocking future so that it happens no matter what?
        workoutFormBloc.add(WorkoutFormClosed());
        return Future.value((workoutFormBloc.state is WorkoutFormUninitialized));
        //todo: ^ tthis is not working - bloc gets disposed but state remains what it was initialized to.
        //todo: Worried that DI of bloc instance might be wrong approach - need a new instance every time we
        //todo: open the screen? I'd like to avoid that somehow if possible - uninitialize state when leaving
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          key: Key('workoutFormScaffold'),
          body: BlocProvider(
            create: (_) => workoutFormBloc
              ..add(WorkoutFormInitialized(
                  cruxUser: StateContainer.of(context).cruxUser,
                  workoutDate: widget.cruxWorkout.workoutDate)),
            child: BlocListener<WorkoutFormBloc, WorkoutFormState>(
              listener: (context, state) {
                if (state is WorkoutFormUninitialized) {
                  workoutFormBloc.add(WorkoutFormInitialized(
                      cruxUser: StateContainer.of(context).cruxUser,
                      workoutDate: widget.cruxWorkout.workoutDate));
                }
                //todo: error snackbar?
              },
              child: BlocBuilder<WorkoutFormBloc, WorkoutFormState>(
                  cubit: workoutFormBloc,
                  builder: (context, state) {
                    if (state is WorkoutFormUninitialized ||
                        state is WorkoutFormInitializationInProgress) {
                      return LoadingIndicator(color: Theme.of(context).accentColor);
                    } else {
                      return CustomScrollView(
                        slivers: <Widget>[
//                  _buildAppBar(context),
                          SliverPadding(
                            padding: EdgeInsets.all(8.0),
                            sliver: SliverList(
                              delegate: SliverChildListDelegate(
                                [hangboardWorkoutListTile(context, state)],
                              ),
                            ),
                          )
                        ],
                      );
                    }
                  }),
            ),
          ),
        ),
      ),
    );
  }

  ListTile hangboardWorkoutListTile(BuildContext context, WorkoutFormState state) {
    return ListTile(
      tileColor: Theme.of(context).accentColor,
      key: Key('hangboardWorkoutTile'),
      title: GridTileBar(
        title: Text(
          'Hangboard Workout',
          style: TextStyle(fontSize: Theme.of(context).textTheme.headline6.fontSize),
        ),
        subtitle: Text('${state.cruxWorkout?.hangboardWorkout?.workoutTitle ?? ''}'),
      ),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        children: mapWorkoutContent(state) ?? noWorkoutFoundContent(context, state),
      ),
    );
  }

  List<Widget> mapWorkoutContent(WorkoutFormState state) {
    List<Widget> widgets = state.cruxWorkout?.hangboardWorkout?.hangboardExercises
        // ignore: unnecessary_cast
        ?.map((exercise) => Row(
              children: [
                Text(
                  '${String.fromCharCode(0x2022)} ${exercise.exerciseTitle}',
//                  textAlign: TextAlign.left,
                ),
              ],
            ) as Widget)
        ?.toList();

    widgets?.add(
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
        child: RaisedButton(
          onPressed: () {
            Navigator.pushNamed(context, gridTileMap["Hangboard"],
                arguments: HangboardWorkoutScreenArguments(
                  hangboardWorkout: state.cruxWorkout.hangboardWorkout,
                ));
          },
          child: Text('START WORKOUT'),
        ),
      ),
    );

    return widgets;
  }

  List<Widget> noWorkoutFoundContent(BuildContext context, WorkoutFormState state) {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20.0),
        child: Text('No hangboard workout created yet.'),
      ),
      RaisedButton(
        onPressed: () {
          Navigator.pushNamed(context, HangboardFormScreen.routeName,
              arguments: HangboardFormScreenArguments(
                cruxWorkout: state.cruxWorkout,
              ));
        },
        child: Text('GET STARTED'),
      ),
    ];
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      centerTitle: true,
      title: Text(
        'Create your workout',
      ),
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).accentColor,
      stretch: true,
      pinned: true,
      expandedHeight: MediaQuery.of(context).size.height / 3.0,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        stretchModes: <StretchMode>[
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
          StretchMode.fadeTitle,
        ],
        background: DecoratedBox(
//          child: _buildAppBarContent(dashboardState, context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            gradient: LinearGradient(
              begin: Alignment(0.0, 1.0),
              end: Alignment(0.0, -1.0),
              colors: <Color>[
                Color(0x30000000),
                Color(0x00000000),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
