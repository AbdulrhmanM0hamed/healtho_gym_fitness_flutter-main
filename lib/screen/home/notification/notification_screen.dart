import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/screen/home/notification/notification_row.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  List notificationArr = [
      "New Exercises and Plans Updated",
      "You Just Consulted  with our Nutritioni..",
      "Your Mobile Number is Updated",
      "Health Tips - why Breathing is important",
      "You Just Complete the Pushups Ch...",

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.secondary,
        centerTitle: false,
        leading: Container(),
        leadingWidth: 20,
        title: const Text(
          "Notification",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        itemBuilder: (context, index) {

        return NotificationRow(title: notificationArr[index], onPressed: (){

        });
      }, separatorBuilder: (context, index) => const SizedBox(height: 15,) , itemCount: notificationArr.length),
    );
  }
}