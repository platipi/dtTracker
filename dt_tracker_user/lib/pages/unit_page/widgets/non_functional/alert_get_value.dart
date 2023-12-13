// import 'package:flutter/material.dart';

// String AlertGetValue(
//     {required BuildContext context,
//     required String title,
//     required Function updateParent,
//     MainAxisAlignment? actionsAlignment,
//     List<Widget>? actions}) {
//   String tempVal = '';
//   returnVal(String value) {
//     return value;
//   }

//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(builder: (context, setState) {
//           return AlertDialog(
//             title: Text(title),
//             content: Column(mainAxisSize: MainAxisSize.min, children: [
//               TextField(
//                 onChanged: (value) {
//                   setState(() {
//                     tempVal = value;
//                   });
//                 },
//               ),
//             ]),
//             actionsAlignment: actionsAlignment ?? MainAxisAlignment.start,
//             actions: actions ??
//                 [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context, 'Cancel'),
//                     child: const Text('Cancel'),
//                   ),
//                   if (tempVal.isNotEmpty)
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pop(context, 'Confirm');
//                         returnVal(tempVal);
//                         updateParent();
//                       },
//                       child: const Text('Confirm'),
//                     ),
//                 ],
//           );
//         });
//       });

//   return '';
// }
