import 'package:crux/backend/blocs/user/models/crux_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';
  final CruxUser cruxUser;

  DashboardScreen({@required this.cruxUser});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollController;
  CalendarController _calendarController;

  int _tabIndex = 1;

  DateTime _selectedDay;

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
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              buildAppBar(context),
              buildTabBar(),
              if (_tabIndex == 0) SliverToBoxAdapter(child: Placeholder()),
              if (_tabIndex == 1) _buildTableCalendar(),
              if (_tabIndex == 2) _buildListView(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              new BottomNavigationBarItem(
                icon: new Icon(Icons.home),
                title: new Text('Home'),
              ),
              new BottomNavigationBarItem(
                icon: new Icon(Icons.menu),
                title: new Text('Menu'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverAppBar buildAppBar(BuildContext context) {
    return SliverAppBar(
//      floating: true, // allows appbar to expand from anywhere in the list - don't need this unless the list gets long enough
      centerTitle: true,
      title: Text(
          'Workout for ${DateFormat('MMMMEEEEd').format(_calendarController.selectedDay ?? DateTime.now())}'),
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).accentColor,
      stretch: true,
      pinned: true,
      expandedHeight: 300.0,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        stretchModes: <StretchMode>[
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
          StretchMode.fadeTitle,
        ],
        background: DecoratedBox(
          child: Column(
            children: <Widget>[
              Text('Current Exercise: '),
              Text('Get Started'),
              Icon(Icons.play_arrow),
              Icon(Icons.pause),
              Text('Total Time: 1:34:56'),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
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

  SliverPersistentHeader buildTabBar() {
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

  Widget _buildTableCalendar() {
    return SliverToBoxAdapter(
      child: TableCalendar(
        initialSelectedDay: _selectedDay ?? DateTime.now(),
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
          //todo: events = workout data from firebase?
          //todo: go to bloc to retrieve?
          setState(() {
            _selectedDay = dateTime;
          });
        },
      ),
    );
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
