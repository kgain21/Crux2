import 'package:crux/backend/bloc/dashboard/dashboard_bloc.dart';
import 'package:crux/backend/bloc/dashboard/dashboard_event.dart';
import 'package:crux/backend/bloc/dashboard/dashboard_state.dart';
import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:crux/frontend/screen/workout_form_screen.dart';
import 'package:crux/frontend/util_widget/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  final CruxUser cruxUser;
  final DashboardBloc dashboardBloc;

  const DashboardScreen({@required this.cruxUser, @required this.dashboardBloc});

  @override
  _DashboardScreenState createState() => _DashboardScreenState(dashboardBloc, cruxUser);
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  final DashboardBloc dashboardBloc;
  final CruxUser cruxUser;

  TabController _tabController;
  ScrollController _scrollController;
  CalendarController _calendarController;

  int _tabIndex = 1;

  _DashboardScreenState(this.dashboardBloc, this.cruxUser);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      initialIndex: 1,
      vsync: this,
    );
    _calendarController = CalendarController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).accentColor,
      child: SafeArea(
        child: Scaffold(
          key: Key('dashboardScaffold'),
          body: BlocListener<DashboardBloc, DashboardState>(
            key: Key('dashboardBlocListener'),
            bloc: dashboardBloc,
            listener: _listenForDashboardBlocState,
            child: BlocBuilder<DashboardBloc, DashboardState>(
                key: Key('dashboardBlocBuilder'),
                bloc: dashboardBloc,
                builder: (context, state) {
                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: <Widget>[
                      _buildAppBar(context, state),
                      _buildTabBar(),
                      if (_tabIndex == 0) SliverToBoxAdapter(child: Placeholder()),
                      if (_tabIndex == 1) _buildTableCalendar(state),
                      if (_tabIndex == 2) _buildListView(),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }

  void _listenForDashboardBlocState(BuildContext context, DashboardState state) {
    if (state is DashboardDateChangeError) {
      Scaffold.of(context).showSnackBar(SnackBar(
        key: Key('workoutLookupError'),
        content: Text('Workout lookup failed. Please check your connection and try again.'),
        duration: Duration(seconds: 5),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
  }

  SliverAppBar _buildAppBar(BuildContext context, DashboardState dashboardState) {
    return SliverAppBar(
      centerTitle: true,
      title: Text(
        'Workout for ${DateFormat('MMMMEEEEd').format(_calendarController.selectedDay ?? DateTime.now())}',
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
          child: _buildAppBarContent(dashboardState, context),
          decoration: BoxDecoration(
            //todo: make this common?
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

  Widget _buildAppBarContent(DashboardState state, BuildContext context) {
    if (state is DashboardUninitialized) {
      dashboardBloc.add(CalendarDateChanged(cruxUser: cruxUser, selectedDate: DateTime.now()));
    }
    if (state is DashboardDateChangeInProgress) {
      return LoadingIndicator(
        color: Theme.of(context).primaryColor,
      );
    } else if (state is DashboardDateChangeSuccess) {
      return Column(
        children: <Widget>[
          Text('Current Exercise: '),
          Text('Get Started'),
          Icon(Icons.play_arrow),
          Icon(Icons.pause),
          Text('Total Time: 1:34:56'),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      );
    } else if (state is DashboardDateChangeNotFound) {
      if (state.selectedDate.subtract(Duration(hours: 12)).difference(DateTime.now().subtract(Duration(days: 1))).isNegative) {
        return Column(
          key: Key('noWorkoutFoundAppBar'),
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('No Workout found for ${DateFormat('MMMMEEEEd').format(state.selectedDate)}.'),
          ],
        );
      } else {
        return Column(
          key: Key('noWorkoutFoundAppBarCreateNew'),
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('No Workout found for ${DateFormat('MMMMEEEEd').format(state.selectedDate)}.'),
            Text('Would you like to create a new workout for this date?'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                child: Text(
                  'CREATE NEW WORKOUT',
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    WorkoutFormScreen.routeName,
                    arguments: WorkoutFormScreenArguments(cruxUser, state.selectedDate),
                  );
                },
              ),
            ),
          ],
        );
      }
    } else {
      return Container();
    }
  }

  SliverPersistentHeader _buildTabBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        tabBar: TabBar(
          labelColor: Colors.black87,
          unselectedLabelColor: Colors.grey,
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.account_circle),
            ),
            Tab(
              icon: Icon(Icons.calendar_today),
            ),
            Tab(
              icon: Icon(Icons.fitness_center),
            ),
          ],
          onTap: (index) => setState(() {
            _tabIndex = index;
          }),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return ExpansionTile(
            key: PageStorageKey<int>(index),
            title: Text('Exercise Type $index'),
            initiallyExpanded: true,
            children: <Widget>[
              Text('Child 1'),
              Text('Child 2'),
              Text('Child 3'),
              Text('Child 4'),
            ],
          );
        },
        childCount: 150,
      ),
    );
  }

  bool notNull(Object o) => o != null;

  Widget _buildTableCalendar(DashboardState state) {
    return SliverToBoxAdapter(
      child: TableCalendar(
        initialSelectedDay: state.selectedDate ?? DateTime.now(),
        availableGestures: AvailableGestures.horizontalSwipe,
        headerStyle: HeaderStyle(
          centerHeaderTitle: true,
          formatButtonVisible: false,
        ),
        daysOfWeekStyle: DaysOfWeekStyle(weekendStyle: TextStyle(color: const Color(0xFF616161))),
        calendarStyle: CalendarStyle(
          weekendStyle: const TextStyle(),
          outsideDaysVisible: false,
          outsideStyle: const TextStyle(),
          outsideWeekendStyle: const TextStyle(),
        ),
        calendarController: _calendarController,
        onDaySelected: (dateTime, events) {
          dashboardBloc.add(CalendarDateChanged(cruxUser: cruxUser, selectedDate: dateTime));
        },
      ),
    );
  }

  void _noWorkoutFoundDialog(BuildContext context, DashboardDateChangeNotFound state) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            key: Key('noWorkoutFoundDialog'),
            title:
                Text('No Workout found for ${DateFormat('MMMMEEEEd').format(state.selectedDate)}.'),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black54),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            ],
          );
        });
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate({@required this.tabBar});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: tabBar,
      color: Colors.white,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class DashboardScreenArguments {
  final CruxUser cruxUser;

  DashboardScreenArguments(this.cruxUser);
}
