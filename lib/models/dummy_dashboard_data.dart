import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DummyDashboardData {
  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 7;

  List<BarChartGroupData> rawBarGroups7;
  List<BarChartGroupData> showingBarGroups7;

  List<BarChartGroupData> rawBarGroups30;
  List<BarChartGroupData> showingBarGroups30;

  List<BarChartGroupData> rawBarGroupsToday;
  List<BarChartGroupData> showingBarGroupsToday;

  int touchedGroupIndex;

  DummyDashboardData() {
    final items7 = List<BarChartGroupData>.generate(
      7,
      (index) {
        double steps = getRandomSteps();
        return makeGroupData(index, steps, calculateCalories(steps), width);
      },
    );

    final items30 = List<BarChartGroupData>.generate(
      30,
      (index) {
        double steps = getRandomSteps();
        return makeGroupData(index, steps, calculateCalories(steps), 2);
      },
    );
    final itemsOne = List<BarChartGroupData>.generate(
      1,
      (index) {
        double steps = getRandomSteps();
        return makeGroupData(index, steps, calculateCalories(steps), 20);
      },
    );

    rawBarGroups7 = items7;

    showingBarGroups7 = rawBarGroups7;

    rawBarGroups30 = items30;

    showingBarGroups30 = rawBarGroups30;

    rawBarGroupsToday = itemsOne;

    showingBarGroupsToday = rawBarGroupsToday;
  }

  double calculateCalories(double steps) {
    return steps * 0.4;
  }

  double getRandomSteps() {
    Random random = new Random();
    int randomNumber = random.nextInt(1000);
    return randomNumber.roundToDouble();
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2, double barSize) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors: [leftBarColor],
        width: barSize,
      ),
      BarChartRodData(
        y: y2,
        colors: [rightBarColor],
        width: barSize,
      ),
    ]);
  }
}
