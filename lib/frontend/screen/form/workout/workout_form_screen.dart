import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:crux/backend/util/model/state_container.dart';
import 'package:crux/frontend/screen/form/hangboard/hangboard_form_screen.dart';
import 'package:crux/frontend/screen/form/workout/bloc/workout_form_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutFormScreenArguments {
//  final CruxUser cruxUser;
  final CruxWorkout cruxWorkout;

  WorkoutFormScreenArguments({
//    @required this.cruxUser,
    @required this.cruxWorkout,
  });
}

class WorkoutFormScreen extends StatefulWidget {
  static const routeName = '/workoutForm';

  final WorkoutFormBloc workoutFormScreenBloc;

//  final CruxUser cruxUser;
  final CruxWorkout cruxWorkout;

  const WorkoutFormScreen({
    @required this.workoutFormScreenBloc,
//    @required this.cruxUser,
    @required this.cruxWorkout,
  });

  @override
  State<StatefulWidget> createState() =>
      _WorkoutFormScreenState(workoutFormBloc: workoutFormScreenBloc);
}

class _WorkoutFormScreenState extends State<WorkoutFormScreen> {
  final WorkoutFormBloc workoutFormBloc;

  _WorkoutFormScreenState({@required this.workoutFormBloc});

  static const Map<String, String> gridTileMap = {
    'Stretching': WorkoutFormScreen.routeName,
    'Campus Board': WorkoutFormScreen.routeName,
    'Hangboard': HangboardFormScreen.routeName,
    'Climbing': WorkoutFormScreen.routeName,
    'Core': WorkoutFormScreen.routeName,
    'Strength': WorkoutFormScreen.routeName
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: Key('workoutFormScaffold'),
        body: BlocProvider(
          create: (_) => workoutFormBloc,
          child: BlocListener<WorkoutFormBloc, WorkoutFormState>(
            listener: (context, state) {
              if (state is WorkoutFormUninitialized) {
                workoutFormBloc.add(WorkoutFormInitialized(cruxUser: StateContainer.of(context).cruxUser, workoutDate: widget.cruxWorkout.workoutDate));
              }
            },
            child: BlocBuilder<WorkoutFormBloc, WorkoutFormState>(
              cubit: workoutFormBloc,
              builder: (context, state) => CustomScrollView(
                slivers: <Widget>[
                  _buildAppBar(context),
                  SliverPadding(
                    padding: EdgeInsets.all(8.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [hangboardWorkoutListTile(context, state)],
                      ),
                    ),
                  )
                ],
              ),
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
        title: Text('Hangboard Workout'),
        subtitle: Text('${state.cruxWorkout?.hangboardWorkout?.workoutTitle ?? ''}'),
      ),
      subtitle: GestureDetector(
        child: Row(
          //todo: fucking around with this layout - can't seem to get bullets centered w/ row & col.
          //todo: also need to turn this into a bloc to stream state - added new exercise and it did not
          //todo: show up after navigating back. Think a bloc would solve this but double check to make sure.
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: state.cruxWorkout?.hangboardWorkout?.hangboardExercises
                      ?.map((exercise) => Text(
                            '${String.fromCharCode(0x2022)} ${exercise.exerciseTitle}',
                            textAlign: TextAlign.left,
                          ))
                      ?.toList() ??
                  [
                    Text('No hangboard workout created for selected day. Tap to start making one!'),
                  ],
            ),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(context, gridTileMap["Hangboard"],
              arguments: HangboardFormScreenArguments(cruxWorkout: state.cruxWorkout));
        },
      ),
    );
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
