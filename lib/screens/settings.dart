import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // Widget buildCar(Car car, int index) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: kgrey,
  //       borderRadius: BorderRadius.all(
  //         Radius.circular(15),
  //       ),
  //     ),
  //     padding: EdgeInsets.all(16),
  //     margin: EdgeInsets.only(
  //         right: index != null ? 16 : 0, left: index == 0 ? 16 : 0),
  //     width: 220, // Augmenter la largeur du conteneur
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       children: [
  //         Align(
  //           alignment: Alignment.centerRight,
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: kPrimaryColor,
  //               borderRadius: BorderRadius.all(
  //                 Radius.circular(15),
  //               ),
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           height: 8,
  //         ),
  //         Container(
  //           height: 120,
  //           child: Center(
  //             child: Hero(
  //               tag: car.vehiclesTitle,
  //               child: Image.asset(
  //                 car.image[0],
  //                 fit: BoxFit.fitWidth,
  //               ),
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           height: 20,
  //         ),
  //         Text(
  //           '${car.vehiclesTitle} ',
  //           style: TextStyle(
  //             fontSize: 22,
  //             fontWeight: FontWeight.bold,
  //             height: 1,
  //           ),
  //         ),
  //         SizedBox(
  //           height: 8,
  //         ),
  //         Text(
  //           'serie :  ${car.modelYear}',
  //           style: TextStyle(fontSize: 18),
  //         ),
  //         // SizedBox(
  //         //   height: 8,
  //         // ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: <Widget>[
  //             for (int i = 1; i <= 5; i++)
  //               Icon(
  //                 Icons.star,
  //                 color: i <= 3 ? yellow : Colors.white,
  //               ),
  //             const SizedBox(width: 12),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
