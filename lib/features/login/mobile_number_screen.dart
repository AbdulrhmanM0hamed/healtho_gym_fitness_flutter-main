// import 'package:flutter/material.dart';
// import 'package:healtho_gym/common/color_extension.dart';
// import 'package:healtho_gym/common_widget/round_button.dart';
// import 'package:healtho_gym/common_widget/round_text_field.dart';
// import 'package:healtho_gym/screen/login/otp_screen.dart';

// class MobileNumberScreen extends StatefulWidget {
//   const MobileNumberScreen({super.key});

//   @override
//   State<MobileNumberScreen> createState() => _MobileNumberScreenState();
// }

// class _MobileNumberScreenState extends State<MobileNumberScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 30),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(
//                 height: 30,
//               ),
//               Text(
//                 "Enter You Mobile Number",
//                 style: TextStyle(
//                   color: TColor.primaryText,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               const RoundTextField(
//                 hintText: "i.e +91 9730627087",
//                 keyboardType: TextInputType.phone,
//               ),
//               const SizedBox(
//                 height: 40,
//               ),
//               RoundButton(title: "VERIFY", isPadding: false, onPressed: () {
//                 context.push( const OTPScreen());
//               }),
//               const Spacer()
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
