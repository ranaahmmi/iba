import 'package:flutter/material.dart';
import 'package:iba/helper/style.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;

const Duration appDuration = Duration(milliseconds: 800);
const String defaulProfilePicUrl =
    'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500';

const formFieldHeightPadding = HeightBox(20);
const defaultpadding = HeightBox(20);

class Constatnts {
  List<String> generateRowOfMonths() {
    List<String> months = [];
    for (int i = 1; i <= 12; i++) {
      DateTime dateTime = DateTime(DateTime.now().year, i, 1);
      months.add(
        DateFormat('MMM').format(dateTime),
      );
    }
    return months;
  }

  List<int> generateListofYear() {
    int from = 1990;
    int to = DateTime.now().year + 1;
    return List<int>.generate(to - from, (index) {
      return from++;
    }).sortedBy(
      (a, b) => b.compareTo(a),
    );
  }

  String getDeviceType() {
    return Platform.isIOS ? 'ios' : 'android';
  }

  void showErrorTost(BuildContext context, String error,
      {Color bgColor = Colors.red}) {
    context.showToast(
        position: VxToastPosition.top,
        bgColor: bgColor.withOpacity(0.9),
        textColor: Colors.white,
        textSize: 14,
        msg: error);
  }

  Widget error(String e) {
    return Center(child: 'Error: $e'.text.center.red600.makeCentered());
  }

  InputDecoration appInputDucoration(String hint, Color color) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.grey),
      filled: true,
      fillColor: Colors.white,
      errorStyle: const TextStyle(fontSize: 10, height: 0.5),
      focusColor: AppColors.primaryColor,
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(99)),
        borderSide: BorderSide(color: AppColors.primaryColor, width: 2.0),
      ),
      contentPadding: const EdgeInsets.all(20.0),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: color.withOpacity(0.5), width: 1.0),
          borderRadius: const BorderRadius.all(
            Radius.circular(99.0),
          )),
    );
  }
}

// class ShimmerLoading {
//   Widget homeLoading() {
//     return Shimmer.fromColors(
//       baseColor: const Color.fromARGB(255, 221, 220, 220),
//       highlightColor: const Color.fromARGB(255, 245, 240, 240),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           40.heightBox,
//           ShimmerTitle(),
//           20.heightBox,
//           ShimmerRowWidget().h(200),
//           20.heightBox,
//           ShimmerTitle(),
//           10.heightBox,
//           Wrap(
//             crossAxisAlignment: WrapCrossAlignment.center,
//             spacing: 15.0,
//             runSpacing: 10.0,
//             children: [
//               for (int i = 0; i < 10; i++)
//                 Container(
//                   width: 60,
//                   height: 60.0,
//                   color: const Color.fromARGB(118, 255, 255, 255),
//                 ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
// class ShimmerRowWidget extends StatelessWidget {
//   const ShimmerRowWidget({
//     Key? key,
//   }) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Container(
//             width: 190.0,
//             height: 200.0,
//             color: const Color.fromARGB(118, 255, 255, 255),
//           ),
//           20.widthBox,
//           Container(
//             width: 190.0,
//             height: 200.0,
//             color: const Color.fromARGB(118, 255, 255, 255),
//           ),
//         ],
//       ),
//     );
//   }
// }
// class ShimmerTitle extends StatelessWidget {
//   const ShimmerTitle({
//     Key? key,
//   }) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Container(
//           width: double.infinity,
//           height: 8.0,
//           color: const Color.fromARGB(118, 255, 255, 255),
//         ),
//         const Padding(
//           padding: EdgeInsets.symmetric(vertical: 2.0),
//         ),
//         Container(
//           width: double.infinity,
//           height: 8.0,
//           color: const Color.fromARGB(118, 255, 255, 255),
//         ),
//         const Padding(
//           padding: EdgeInsets.symmetric(vertical: 2.0),
//         ),
//         Container(
//           width: 40.0,
//           height: 8.0,
//           color: const Color.fromARGB(118, 255, 255, 255),
//         ),
//       ],
//     );
//   }
// }