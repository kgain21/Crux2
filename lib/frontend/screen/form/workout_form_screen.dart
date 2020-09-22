import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:crux/frontend/screen/form/hangboard_form_screen.dart';
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
        body: CustomScrollView(
          slivers: <Widget>[
            _buildAppBar(context),
            SliverPadding(
              padding: EdgeInsets.all(8.0),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return GridTile(
                      key: Key('${gridTileMap.values.toList()[index].replaceAll('/', '')}Tile'),
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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            color: Theme.of(context).accentColor,
                            /*gradient: LinearGradient(
                              begin: Alignment(0.0, 1.0),
                              end: Alignment(0.0, -1.0),
                              colors: <Color>[
                                Theme.of(context).accentColor,
                                Color(0x00000000),
                              ],
                            ),*/
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            gridTileMap.values.toList()[index],
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
              ),
            )
          ],
        ),
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

class WorkoutFormScreenArguments {
  final CruxUser cruxUser;
  final DateTime selectedDate;

  WorkoutFormScreenArguments(this.cruxUser, this.selectedDate);
}
