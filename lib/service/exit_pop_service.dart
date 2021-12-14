// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExitPopService extends StatelessWidget {
  final Widget page;
  const ExitPopService(this.page, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<bool> exitDialogShow() async {
      return await showDialog(
          context: context,
          builder: (BuildContext buildContext) {
            return AlertDialog(
              title: const Text("Warning !"),
              content: const Text("Are your want to Exit ?"),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (Platform.isIOS) {
                      print("Platform Is iOS");
                      exit(0);
                    } else if (Platform.isAndroid) {
                      print("Platform Is Android");
                      SystemNavigator.pop();
                    } else {
                      SystemNavigator.pop();
                    }
                  },
                  child: const Text("Yes"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No"),
                ),
              ],
            );
          });
    }

    return WillPopScope(child: page, onWillPop: exitDialogShow);
  }
}










// class ExitPopUp extends StatelessWidget {
//   final page;
//   ExitPopUp(this.page);

//   @override
//   Widget build(BuildContext context) {
//     Future<bool> showExitPopUp() async {
//       return await showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(20.0))),
//               backgroundColor: Color.fromRGBO(0, 68, 69, .5),
//               title: Text("Confirm", style: TextStyle(color: Colors.white)),
//               content: Text("Do you want to Exit ?",
//                   style: TextStyle(color: Colors.white)),
//               actions: <Widget>[
//                 ElevatedButton(
//                     child: Text(
//                       "No",
//                       style: TextStyle(color: Colors.yellow[100]),
//                     ),
//                     onPressed: () {
//                       Navigator.pop(context, false);
//                     }),
//                 ElevatedButton(
//                     child: Text("Yes",
//                         style: TextStyle(color: Colors.yellow[100])),
//                     onPressed: () {
//                       SystemNavigator.pop();
//                     })
//               ],
//             );
//           });
//     }

//     return WillPopScope(child: page, onWillPop: showExitPopUp);
//   }
// }
// //
// //

// class DialogShowService {
//   showExitPopUp(context) async {
//     return await showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(20.0))),
//             backgroundColor: Color.fromRGBO(0, 68, 69, .5),
//             title: Text("Confirm", style: TextStyle(color: Colors.white)),
//             content: Text("Do you want to Exit ?",
//                 style: TextStyle(color: Colors.white)),
//             actions: <Widget>[
//               ElevatedButton(
//                   child: Text(
//                     "No",
//                     style: TextStyle(color: Colors.yellow[100]),
//                   ),
//                   onPressed: () {
//                     Navigator.pop(context, false);
//                   }),
//               ElevatedButton(
//                   child:
//                       Text("Yes", style: TextStyle(color: Colors.yellow[100])),
//                   onPressed: () {
//                     SystemNavigator.pop();
//                   })
//             ],
//           );
//         });
//   }
// }
