import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:flutter/widgets.dart';

class _InheritedStateContainer extends InheritedWidget {
  final StateContainerState data;

  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant _InheritedStateContainer oldWidget) => true;
}

class StateContainer extends StatefulWidget {
  final Widget child;
  final CruxUser cruxUser;

  StateContainer({
    @required this.child,
    this.cruxUser,
  });

  static StateContainerState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedStateContainer>().data;
  }

  @override
  State<StatefulWidget> createState() => StateContainerState(cruxUser: cruxUser);
}

class StateContainerState extends State<StateContainer> {
  CruxUser cruxUser;

  StateContainerState({
    this.cruxUser,
  });

  void updateCruxUser(CruxUser newCruxUser) {
    if (cruxUser != newCruxUser) {
      setState(() {
        cruxUser = newCruxUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedStateContainer(data: this, child: widget.child);
  }
}
