// import 'package:flutter/material.dart';

// class TransactionList extends StatefulWidget {
//   @override
//   _TransactionListState createState() => _TransactionListState();
// }

// class _TransactionListState extends State<TransactionList> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
//       itemCount: entries.length,
//       itemBuilder: (BuildContext context, int index) {
//         return Stack(
//           children: <Widget>[
//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 0,
//               color: Colors.blue[100],
//               child: Container(
//                 height: 130,
//                 width: MediaQuery.of(context).size.width,
//                 child: Column(
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         '${entries[index]}',
//                         style: style,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 0,
//               right: 0,
//               child: IconButton(
//                 color: Colors.redAccent,
//                 splashColor: Colors.white,
//                 onPressed: () {
//                   setState(() {
//                     entries.removeAt(index);
//                   });
//                 },
//                 icon: Icon(Icons.close),
//               ),
//             ),
//           ],
//         );
//       },
//       separatorBuilder: (BuildContext context, int index) => const Divider(
//         height: 5,
//         color: Colors.black12,
//       ),
//     );
//   }
// }