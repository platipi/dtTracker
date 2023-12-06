import 'package:dt_tracker_user/pages/mook.dart';
import 'package:dt_tracker_user/utilities/data/unit.dart';
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

  Unit example = Unit();

  List<NavBarItem> _items = [
    NavBarItem(widget: Icon(Icons.list), name: "Reference"),
    NavBarItem(widget: Icon(Icons.add), name: "Add"),
    NavBarItem(widget: Icon(Icons.person), name: "Mook 0"),
    NavBarItem(widget: Icon(Icons.person_2), name: "Mook 1"),
    NavBarItem(widget: Icon(Icons.person_4), name: "Mook 2"),
  ];

  List<Widget> _widgetOptions = <Widget>[
    // Mook(
    //   name: 'Quick Reference',
    // ),
    // Mook(
    //   name: 'New Mook',
    // ),
    UnitWidget(
      unit: Unit(),
    ),
    UnitWidget(
      unit: Unit(),
    ),
    UnitWidget(
      unit: Unit(),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
        bottomNavigationBar: ScrollableReorderableNavBar(
          onItemTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          onReorder: (oldIndex, newIndex) {
            final currItem = _items[_selectedIndex];
            if (oldIndex < newIndex) newIndex -= 1;
            final newItems = [..._items], item = newItems.removeAt(oldIndex);
            newItems.insert(newIndex, item);

            final currWidget = _widgetOptions[_selectedIndex];
            if (oldIndex < newIndex) newIndex -= 1;
            final newWidgets = [..._widgetOptions],
                widget = newWidgets.removeAt(oldIndex);
            newWidgets.insert(newIndex, widget);

            setState(() {
              _items = newItems;
              _widgetOptions = newWidgets;
              _selectedIndex = _items.indexOf(currItem);
            });
          },
          items: _items,
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
                      style: Theme.of(context).textTheme.bodyText1,
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
