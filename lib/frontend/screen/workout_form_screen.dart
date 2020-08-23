import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WorkoutFormScreen extends StatelessWidget {
  static const routeName = '/workoutForm';

  final CruxUser cruxUser;
  final DateTime selectedDate;

  const WorkoutFormScreen(this.cruxUser, this.selectedDate);

  static const Map<String, String> gridTileMap = {
    'Stretching': WorkoutFormScreen.routeName,
    'Campus Board': WorkoutFormScreen.routeName,
    'Hangboard': WorkoutFormScreen.routeName,
    'Climbing': WorkoutFormScreen.routeName,
    'Core': WorkoutFormScreen.routeName,
    'Strength': WorkoutFormScreen.routeName
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: Key('workoutFormScaffold'),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return GridTile(
                    header: Checkbox(
                      value: false,
                      onChanged: (selected) {
                        return null;
                      },
                    ),
                    footer: GridTileBar(
                      title: Text(gridTileMap.keys.toList()[index]),
                    ),
                    child: GestureDetector(
                      child: Container(
                        color: Theme.of(context).accentColor,
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                            gridTileMap.values.toList()[index],
//                            arguments: WorkoutFormScreenArguments(cruxUser, state.selectedDate),
                        );
                      },
                    ),
                  );
                },
                childCount: gridTileMap.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class WorkoutFormScreenArguments {
  final CruxUser cruxUser;
  final DateTime selectedDate;

  WorkoutFormScreenArguments(this.cruxUser, this.selectedDate);
}
