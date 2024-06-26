import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:scheduled_date_picker/src/week_day.dart';
import 'package:scheduled_date_picker/src/week_day_selector.dart';

enum ScheduledDateType { NOW, SCHEDULED, DAILY, CUSTOMIZED }

const ScheduledDateTypeValues = {
  ScheduledDateType.NOW: 'Agora',
  ScheduledDateType.SCHEDULED: 'Programado',
  ScheduledDateType.DAILY: 'Diária',
  ScheduledDateType.CUSTOMIZED: 'Personalizada',
};

class ScheduledDatePicker extends StatefulWidget {
  final String defaultLocale;
  final ScheduledDateType? initialType;
  final DateTime? initialScheduledDate;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final List<WeekDay>? initialWeekDays;
  final Function(ScheduledDateType?)? onTypeChanged;
  final Function(List<WeekDay>)? onWeekDaysChanged;
  final Function(DateTime?)? onStartDateChanged;
  final Function(DateTime?)? onEndDateChanged;
  final Function(DateTime?)? onScheduleDateChanged;

  const ScheduledDatePicker(
      {Key? key,
      required this.defaultLocale,
      this.onTypeChanged,
      this.onWeekDaysChanged,
      this.onStartDateChanged,
      this.onEndDateChanged,
      this.onScheduleDateChanged,
      this.initialType,
      this.initialScheduledDate,
      this.initialStartDate,
      this.initialEndDate,
      this.initialWeekDays,
      this.firstDate,
      this.lastDate})
      : super(key: key);
  @override
  _ScheduledDatePickerState createState() => _ScheduledDatePickerState();
}

class _ScheduledDatePickerState extends State<ScheduledDatePicker> {
  ScheduledDateType? _scheduledDateTypeSelected;
  List<WeekDay>? weekDaysSelected;
  DateTime? startDateSelected;
  DateTime? endDateSelected;
  DateTime? scheduledDate;

  final dropDownItems = [
    ScheduledDateType.NOW,
    ScheduledDateType.SCHEDULED,
    ScheduledDateType.DAILY,
    ScheduledDateType.CUSTOMIZED
  ];

  TextEditingController? _startDateController,
      _endDateController,
      _scheduledDateController;

  @override
  void dispose() {
    super.dispose();
    _startDateController?.dispose();
    _endDateController?.dispose();
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting(widget.defaultLocale);
    _scheduledDateTypeSelected = widget.initialType ?? ScheduledDateType.NOW;
    weekDaysSelected = widget.initialWeekDays;
    startDateSelected = widget.initialStartDate;
    endDateSelected = widget.initialEndDate;
    scheduledDate = widget.initialScheduledDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    _startDateController = TextEditingController(
        text: startDateSelected != null
            ? DateFormat.yMd(widget.defaultLocale).format(startDateSelected!)
            : '');
    _endDateController = TextEditingController(
        text: endDateSelected != null
            ? DateFormat.yMd(widget.defaultLocale).format(endDateSelected!)
            : '');
    _scheduledDateController = TextEditingController(
        text: scheduledDate != null
            ? DateFormat.yMd(widget.defaultLocale).format(scheduledDate!)
            : '');

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _scheduleTypeDropDown(),
          if (_scheduledDateTypeSelected != null)
            ..._scheduleDateComponentsByType()
        ],
      ),
    );
  }

  Widget _scheduleTypeDropDown() {
    return DropdownButtonFormField<ScheduledDateType>(
      isExpanded: true,
      decoration: InputDecoration(
        hintText: 'Programação',
        labelText: 'Programação',
      ),
      icon: Icon(Icons.date_range),
      value: _scheduledDateTypeSelected,
      items: dropDownItems.map((ScheduledDateType value) {
        return DropdownMenuItem<ScheduledDateType>(
          value: value,
          child: Text(ScheduledDateTypeValues[value]!),
        );
      }).toList(),
      onChanged: _onScheduleTypeChanged,
    );
  }

  _onScheduleTypeChanged(ScheduledDateType? scheduleType) async {
    if (scheduleType == ScheduledDateType.SCHEDULED) {
      final dateSelected = await _showDatePickerAndWaitDate(
          firstDate: widget.firstDate, lastDate: widget.lastDate);
      if (widget.onScheduleDateChanged != null)
        widget.onScheduleDateChanged!(dateSelected);
      setState(() => scheduledDate = dateSelected);
    }
    if (scheduleType == ScheduledDateType.NOW) {
      setState(() => scheduledDate = DateTime.now());
      if (widget.onScheduleDateChanged != null)
        widget.onScheduleDateChanged!(scheduledDate);
    } else {
      setState(() => startDateSelected = widget.firstDate ?? DateTime.now());
    }
    setState(() => _scheduledDateTypeSelected = scheduleType);
    if (widget.onTypeChanged != null) widget.onTypeChanged!(scheduleType);
  }

  List<Widget> _scheduleDateComponentsByType() {
    switch (_scheduledDateTypeSelected) {
      case ScheduledDateType.DAILY:
        return _startEndDatePicker();
      case ScheduledDateType.CUSTOMIZED:
        return _customizedScheduleComponents();
      default:
        return _scheduledDateComponents();
    }
  }

  List<Widget> _startEndDatePicker() {
    return [
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: InkWell(
              child: TextField(
                controller: _startDateController,
                decoration: InputDecoration(
                  hintText: 'Data início',
                  labelText: 'Data início',
                ),
                enabled: false,
              ),
              onTap: () async {
                final dateStartSelected = await _showDatePickerAndWaitDate(
                    initialDate: startDateSelected,
                    firstDate: widget.firstDate,
                    lastDate: widget.lastDate);
                setState(() => startDateSelected = dateStartSelected);
                if (widget.onStartDateChanged != null)
                  widget.onStartDateChanged!(dateStartSelected);
              },
            ),
          ),
          SizedBox(width: 20),
          Flexible(
            child: InkWell(
              child: TextField(
                controller: _endDateController,
                decoration: InputDecoration(
                  hintText: 'Data fim',
                  labelText: 'Data fim',
                ),
                enabled: false,
              ),
              onTap: () async {
                final dateEndSelected = await _showDatePickerAndWaitDate(
                    initialDate: endDateSelected,
                    firstDate: widget.firstDate,
                    lastDate: widget.lastDate);
                setState(() => endDateSelected = dateEndSelected);
                if (widget.onEndDateChanged != null)
                  widget.onEndDateChanged!(dateEndSelected);
              },
            ),
          ),
        ],
      )
    ];
  }

  List<Widget> _customizedScheduleComponents() {
    return [
      SizedBox(height: 30),
      Text(
        'Dias da semana',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      SizedBox(height: 5),
      WeekDaySelector(
        initialWeekDaysSelected: weekDaysSelected,
        onChanged: (weekDays) {
          weekDaysSelected = weekDays;
          if (widget.onWeekDaysChanged != null)
            widget.onWeekDaysChanged!(weekDays ?? []);
        },
      ),
      ..._startEndDatePicker()
    ];
  }

  List<Widget> _scheduledDateComponents() {
    return [
      SizedBox(height: 20),
      TextField(
        controller: _scheduledDateController,
        decoration: InputDecoration(
          hintText: 'Data programada',
          labelText: 'Data programada',
        ),
        readOnly: true,
        onTap: () async {
          final dateSelected = await _showDatePickerAndWaitDate(
              firstDate: widget.firstDate, lastDate: widget.lastDate);
          if (widget.onScheduleDateChanged != null)
            widget.onScheduleDateChanged!(dateSelected);
          setState(() => scheduledDate = dateSelected);
        },
      ),
    ];
  }

  Future<DateTime?> _showDatePickerAndWaitDate(
      {DateTime? initialDate, DateTime? firstDate, DateTime? lastDate}) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? (firstDate ?? DateTime.now()),
      firstDate: firstDate ?? DateTime(2018),
      lastDate: lastDate ?? DateTime(2030),
    );
    return selectedDate;
  }
}
