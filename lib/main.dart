import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:walking_counter/models/bloc/dashboard/dashboard_bloc.dart';
import 'package:walking_counter/models/repositories/walk_counter_repository.dart';
import 'package:walking_counter/models/walk_counter_model.dart';
import 'package:walking_counter/screens/dashboard_screen.dart';
import 'package:walking_counter/screens/walking_counter_screen.dart';

import 'models/bloc/walk_counter/walk_counter_bloc.dart';

void main() {
  runApp(WalkCounter());
}

class WalkCounter extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Walking Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
                WalkCounterBloc(PedometerStream(), WalkCounterRepository()),
          ),
          BlocProvider(
            create: (_) => DashboardBloc(WalkCounterRepository()),
          ),
        ],
        child: HomePage(title: 'Walking Counter'),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 2,
                effect: ExpandingDotsEffect(
                  activeDotColor: Colors.blue,
                  dotHeight: 10,
                  dotWidth: 10,
                  expansionFactor: 4,
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 156,
              child: PageView(
                controller: _pageController,
                children: [
                  WalkingCounterScreen(),
                  DashboardScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
