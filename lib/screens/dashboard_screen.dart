import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 200,
            color: Colors.red,
          ),
          SizedBox(height: 30),
          Container(
            height: 200,
            color: Colors.red,
          ),
          SizedBox(height: 30),
          Container(
            height: 200,
            color: Colors.red,
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
