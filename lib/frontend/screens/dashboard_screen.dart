import 'package:crux/model/crux_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    _calendarController = CalendarController();
    _scrollController = ScrollController()
      ..addListener(() {
        _scrollController.position;
      });
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
              if (_tabIndex == 0) _buildListView(),
              if (_tabIndex == 1) _buildTableCalendar(),
              if (_tabIndex == 2) _buildListView(),
            ],
          ),
        ),
      ),
    );
  }

  SliverAppBar buildAppBar(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).accentColor,
      stretch: true,
      pinned: true,
      expandedHeight: 300.0,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: <StretchMode>[
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
          StretchMode.fadeTitle,
        ],
        background: DecoratedBox(
          child: Column(
            children: <Widget>[
              Text('Get Started'),
            ],
            mainAxisSize: MainAxisSize.max,
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
          return ListTile(
            title: Text('Tile $index'),
          );
        },
        childCount: 15,
      ),
    );
  }

  bool notNull(Object o) => o != null;

  Widget _buildTableCalendar() {
    return SliverToBoxAdapter(
      child: TableCalendar(
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
