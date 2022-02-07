import 'package:flutter/material.dart';

import 'models/station.dart';
import 'models/user.dart';

class _InheritedStateContainer extends InheritedWidget {
  final StateContainerState data;

  const _InheritedStateContainer({
    required this.data,
    required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}

class StateContainer extends StatefulWidget {
  final Widget child;
  final User? user;
  final List<Station>? stationList;

  const StateContainer({
    Key? key,
    required this.child,
    this.user,
    this.stationList,
  }) : super(key: key);

  static StateContainerState of(BuildContext context) {
    return (context
                .dependOnInheritedWidgetOfExactType<_InheritedStateContainer>()
            as _InheritedStateContainer)
        .data;
  }

  @override
  StateContainerState createState() => StateContainerState();
}

class StateContainerState extends State<StateContainer> {
  late User user;
  late List<Station> stationList;

  void updateUser(User _user) async {
    setState(() {
      user = _user;
    });
  }

  void updateStationList(List<Station> _stationList) async {
    setState(() {
      stationList = _stationList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}
