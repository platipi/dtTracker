import 'dart:math';

import 'package:dt_tracker_user/pages/unit_page/widgets/change_sp.dart';
import 'package:dt_tracker_user/pages/widgets/rect_button.dart';
import 'package:dt_tracker_user/utilities/data/data_functions.dart';
import 'package:dt_tracker_user/utilities/data/data_types.dart';
import 'package:dt_tracker_user/utilities/data/unit.dart';
import 'package:dt_tracker_user/utilities/data/unit_health.dart';
import 'package:dt_tracker_user/utilities/globals.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

class AddUnitState extends StatefulWidget {
  const AddUnitState({super.key});

  @override
  AddUnitWidget createState() => AddUnitWidget();
}

class AddUnitWidget extends State<AddUnitState> {
  final _controller = PageController();
  int curPageIndex = 0;
  int pagesLength = 3;
  List<ArmorLocation> armor = [
    ArmorLocation.blank(),
    ArmorLocation.blank(),
    ArmorLocation.blank(),
    ArmorLocation.blank(),
    ArmorLocation.blank(),
    ArmorLocation.blank()
  ];
  List<bool> changed = List.filled(6, false);

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      onPageChanged: ((index) {
        curPageIndex = index;
      }),
      children: [
        AddUnitPage(index: 0, children: [
          GestureDetector(
              onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return changeSpWidget(armor, 10, (() {}));
                  }),
              child: Text(
                'Armor',
                style: TextStyle(fontSize: fontSize * 2),
              )),
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
            children: armor.mapIndexedAndLast((index, location, last) {
              return Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 90,
                        ),
                        Text(
                          locationToString(index),
                          style: TextStyle(fontSize: fontSize * 1.5),
                        ),
                        Row(children: [
                          Checkbox(
                              value: armor[index].isHard,
                              onChanged: ((value) {
                                setState(() {
                                  armor[index].isHard = !armor[index].isHard;
                                });
                              })),
                          Text('Hard'),
                          SizedBox(
                            width: 10,
                          )
                        ])
                      ]),
                  Row(
                    children: [
                      ExpandedRectButton('0', (() {
                        changeSp(false, 0, location);
                      }), smallButtonHeight),
                      ExpandedRectButton('v', (() {
                        changeSp(true, -5, location);
                      }), smallButtonHeight),
                      ExpandedRectButton('-', (() {
                        changeSp(true, -1, location);
                      }), smallButtonHeight),
                      TextButton(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.all(0),
                            minimumSize: Size(30, 30)),
                        onPressed: (() {
                          //hard enter value
                        }),
                        child: Text(
                          '${armor[index].maxSp}',
                          style: TextStyle(
                              color: Colors.black, fontSize: fontSize * 1.25),
                        ),
                      ),
                      ExpandedRectButton('+', (() {
                        setState(() {
                          changeSp(true, 1, location);
                        });
                      }), smallButtonHeight),
                      ExpandedRectButton('^', (() {
                        changeSp(true, 5, location);
                      }), smallButtonHeight),
                      ExpandedRectButton('14', (() {
                        changeSp(false, 14, location);
                      }), smallButtonHeight),
                    ],
                  ),
                ],
              );
            }).toList(),
          )))
        ]),
        AddUnitPage(
          index: 1,
          children: [],
        ),
        AddUnitPage(
          index: 2,
          children: [],
        ),
      ],
    );
  }

  void changeSp(bool increment, int value, ArmorLocation location) {
    setState(() {
      if (!increment) {
        location.setSp(value);
      } else {
        var newVal = location.maxSp + value;
        newVal = max(0, newVal);
        location.setSp(newVal);
      }
    });
  }

  Widget AddUnitPage({required List<Widget> children, required int index}) {
    return Column(
      children: [
        const SizedBox(
          height: 40,
        ),
        Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              //Align(
              //alignment: Alignment.center,
              //child:
              Expanded(
                  child: Column(
                children: children,
              )),
              //),
              //Align(
              //alignment: Alignment.bottomCenter,
              //child:
              Row(
                children: [
                  if (index != 0)
                    ExpandedRectButton('<', () {
                      _controller.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    }, bigButtonHeight),
                  ExpandedRectButton('Finish', () {}, bigButtonHeight),
                  if (index != pagesLength - 1)
                    ExpandedRectButton('>', () {
                      _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    }, bigButtonHeight)
                ],
              )
              // ExpanRectButton(
              //   Text('>'),
              //   onPressed: () {},
              //   width: 50,
              //   height: 230,
              // ),
              //)
            ])),
      ],
    );
  }
}
