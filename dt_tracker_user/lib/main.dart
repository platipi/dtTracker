import 'dart:math';

import 'package:dt_tracker_user/pages/add_unit_page.dart';
import 'package:dt_tracker_user/pages/quick_reference_page.dart';
import 'package:dt_tracker_user/pages/unit_page.dart';
import 'package:dt_tracker_user/utilities/data/unit.dart';
import 'package:dt_tracker_user/utilities/data/unit_health.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'utilities/firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:scrollable_reorderable_navbar/scrollable_reorderable_navbar.dart';

//chevron_compact_down for mook
//person for unit

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseDatabase database = FirebaseDatabase.instance;

  runApp(const MainState());
}

class MainState extends StatefulWidget {
  const MainState({super.key});

  @override
  State<StatefulWidget> createState() => MainView();
}

class MainView extends State<MainState> {
  int _selectedIndex = 0;

  List<Unit> units = [
    Unit('mook1', UnitHealth()),
    Unit('mook2', UnitHealth()),
    Unit('mook3', UnitHealth()),
  ];

  List<NavBarItem> items = [
    NavBarItem(widget: Icon(Icons.list), name: "Reference"),
    NavBarItem(widget: Icon(Icons.add), name: "Add"),
    //NavBarItem(widget: Icon(Icons.person), name: "Mook 0"),
  ];

  List<Widget> navPages = <Widget>[
    ReferenceWidget(),
    AddUnitWidget(),
    // UnitState(
    //   unit: Unit('mook1', UnitHealth()),
    // ),
    // UnitState(
    //   unit: Unit('mook2', UnitHealth()),
    // ),
    // UnitState(
    //   unit: Unit('mook3', UnitHealth()),
    // ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int getPostSwipeIndex(DragEndDetails details) {
    if (details.primaryVelocity == null) {
      return _selectedIndex;
    } else if (details.primaryVelocity! > 0) {
      return max(0, _selectedIndex - 1);
    } else if (details.primaryVelocity! < 0) {
      return min(items.length - 1, _selectedIndex + 1);
    } else {
      return _selectedIndex;
    }
  }

  @override
  void initState() {
    for (var unit in units) {
      items.add(NavBarItem(widget: Icon(Icons.person), name: unit.name));
      navPages.add(UnitState(unit: unit));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: GestureDetector(
                onHorizontalDragEnd: (details) {
                  _selectedIndex = getPostSwipeIndex(details);
                  setState(() {});
                },
                child: Container(
                    color: Colors.white,
                    child: navPages.elementAt(_selectedIndex)))),
        bottomNavigationBar: ScrollableReorderableNavBar(
          onItemTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          onReorder: (oldIndex, newIndex) {
            final currItem = items[_selectedIndex];
            if (oldIndex < newIndex) newIndex -= 1;
            final newItems = [...items], item = newItems.removeAt(oldIndex);
            newItems.insert(newIndex, item);

            final newWidgets = [...navPages],
                widget = newWidgets.removeAt(oldIndex);
            newWidgets.insert(newIndex, widget);

            setState(() {
              items = newItems;
              navPages = newWidgets;
              _selectedIndex = items.indexOf(currItem);
            });
          },
          items: items,
          selectedIndex: _selectedIndex,
          //onDelete: (index) => setState(() => _items.removeAt(index)),
          onDelete: (i) => (),
          deleteIndicationWidget: Container(
            padding: const EdgeInsets.only(bottom: 100),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: Axis.vertical,
                children: [
                  Text("Drag to reorder",
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center),
                  TextButton(onPressed: () {}, child: const Text("DONE"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
