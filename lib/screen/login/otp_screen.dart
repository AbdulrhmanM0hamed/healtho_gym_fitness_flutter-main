// import 'package:flutter/material.dart';
// import 'package:healtho_gym/common/color_extension.dart';
// import 'package:healtho_gym/common_widget/round_button.dart';
// import 'package:healtho_gym/screen/login/name_screen.dart';
// import 'package:otp_text_field_v2/otp_field_v2.dart';
// import 'package:otp_timer_button/otp_timer_button.dart';

// class OTPScreen extends StatefulWidget {
//   const OTPScreen({super.key});

//   @override
//   State<OTPScreen> createState() => _OTPScreenState();
// }

// class _OTPScreenState extends State<OTPScreen> {
//   OtpFieldControllerV2 txtOTP = OtpFieldControllerV2();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 30),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(
//                 height: 30,
//               ),
//               Text(
//                 "Enter The code that was send to your\nEntered Mobile Number",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: TColor.primaryText,
//                   fontSize: 14,
//                 ),
//               ),
//               const SizedBox(
//                 height: 35,
//               ),
//               OTPTextFieldV2(
//                 controller: txtOTP,
//                 length: 4,
//                 width: context.width * 0.7,
//                 textFieldAlignment: MainAxisAlignment.spaceAround,
//                 fieldWidth: 50,
//                 fieldStyle: FieldStyle.box,
//                 outlineBorderRadius: 30,
//                 style: TextStyle(
//                   fontSize: 25,
//                   fontWeight: FontWeight.w500,
//                   color: TColor.primaryText,
//                 ),
//                 onChanged: (pin) {
//                   print("Changed: " + pin);
//                 },
//                 onCompleted: (pin) {
//                   print("Completed: " + pin);
//                 },
//               ),
//               const SizedBox(
//                 height: 35,
//               ),
//               RoundButton(title: "VERIFY", isPadding: false, onPressed: () {
//                 context.push(const NameScreen() );
//               }),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   TextButton(
//                     onPressed: () {
//                       context.pop();
//                     },
//                     child: Text(
//                       "Change Number",
//                       style: TextStyle(
//                         color: TColor.placeholder,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//                   OtpTimerButton(
//                     onPressed: () {},
//                     text: const Text(
//                       "Resend OTP",
//                       style: TextStyle(
//                         color: Color(0xff8E44AD),
//                         fontSize: 12,
//                       ),
//                     ),
//                     duration: 60,
//                     backgroundColor: TColor.primaryText,
//                     buttonType: ButtonType.text_button,
//                   )
//                 ],
//               ),
//               const Spacer()
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
