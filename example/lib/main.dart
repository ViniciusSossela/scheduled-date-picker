import 'package:flutter/material.dart';
import 'package:scheduled_date_picker/scheduled_date_picker.dart';

void main() {
  runApp(SampleApp());
}

class SampleApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SampleAppState();
  }
}

class SampleAppState extends State<SampleApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Sample App')),
        body: ScheduledDatePicker(
          defaultLocale: 'pt',
          initialType: ScheduledDateType.CUSTOMIZED,
          initialWeekDays: [WeekDay.SEG, WeekDay.QUA, WeekDay.SEX],
          initialStartDate: DateTime.now().add(Duration(days: 5)),
          initialEndDate: DateTime.now().add(Duration(days: 15)),
          onStartDateChanged: (startDate) => print(startDate.toString()),
          onEndDateChanged: (endDate) => print(endDate.toString()),
          onScheduleDateChanged: (scheduleDate) =>
              print(scheduleDate.toString()),
          onTypeChanged: (type) => print(type.toString()),
          onWeekDaysChanged: (weekDays) =>
              print(weekDays.join(', ').toString()),
        ),
      ),
    );
  }
}
