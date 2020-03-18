import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum WeekDay { SEG, TER, QUA, QUI, SEX, SAB, DOM }

class WeekDaySelector extends StatefulWidget {
  final Function(List<WeekDay> weekDays) onChanged;

  const WeekDaySelector({Key key, @required this.onChanged}) : super(key: key);
  @override
  _WeekDaySelectorState createState() => _WeekDaySelectorState();
}

class _WeekDaySelectorState extends State<WeekDaySelector> {
  final weekDays = <WeekDay>[
    WeekDay.SEG,
    WeekDay.TER,
    WeekDay.QUA,
    WeekDay.QUI,
    WeekDay.SEX,
    WeekDay.SAB,
    WeekDay.DOM
  ];

  final weekDaysLetters = {
    WeekDay.SEG: 'S',
    WeekDay.TER: 'T',
    WeekDay.QUA: 'Q',
    WeekDay.QUI: 'Q',
    WeekDay.SEX: 'S',
    WeekDay.SAB: 'S',
    WeekDay.DOM: 'D',
  };

  List<WeekDay> weekDaysSelected = [];

  _weekTapped(WeekDay weekDay) {
    setState(() {
      if (weekDaysSelected.contains(weekDay))
        weekDaysSelected.remove(weekDay);
      else
        weekDaysSelected.add(weekDay);
    });
    widget.onChanged(weekDaysSelected);
  }

  bool _isWeekDaySelected(WeekDay weekDay) =>
      weekDaysSelected.contains(weekDay);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: weekDays.map((weekDay) {
        bool isWeekDaySelected = _isWeekDaySelected(weekDay);
        return Padding(
          padding: const EdgeInsets.only(right: 5),
          child: GestureDetector(
            child: CircleAvatar(
              child: Text(
                weekDaysLetters[weekDay],
                style: TextStyle(
                  color: isWeekDaySelected ? Colors.white : Colors.black,
                ),
              ),
              backgroundColor: isWeekDaySelected
                  ? Colors.blue
                  : Colors.grey.withOpacity(0.3),
              foregroundColor: Colors.red,
            ),
            onTap: () => _weekTapped(weekDay),
          ),
        );
      }).toList(),
    );
  }
}
