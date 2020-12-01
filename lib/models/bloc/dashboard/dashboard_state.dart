part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoadDataState extends DashboardState {
  DashboardLoadDataState(this.stepsTodayBarData);

  final List<BarChartGroupData> stepsTodayBarData;
  @override
  List<Object> get props => [stepsTodayBarData];
}
