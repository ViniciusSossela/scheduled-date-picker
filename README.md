# Scheduled Date Picker

Scheduled date picker is a set of widget that allow to schedule date. This can be usefull in many cenarios, for scheduled tasks for example;

## Demo
<img src="https://github.com/ViniciusSossela/scheduled-date-picker/blob/master/docs/schedule_date_picker.gif" width="300">

## Getting Started

### Installation

Add to `pubspec.yaml` in `dependencies` 

```
  scheduled_date_picker: ^1.0.0
```

### Usage

More usage details can be found on example folder

```
new ScheduledDatePicker(
    defaultLocale: 'pt',
    onStartDateChanged: (startDate) => print(startDate.toString()),
    onEndDateChanged: (endDate) => print(endDate.toString()),
    onScheduleDateChanged: (scheduleDate) =>
        print(scheduleDate.toString()),
    onTypeChanged: (type) => print(type.toString()),
    onWeekDaysChanged: (weekDays) =>
        print(weekDays.join(', ').toString()),
);
```
