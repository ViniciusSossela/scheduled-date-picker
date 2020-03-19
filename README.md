# Scheduled Date Picker

The scheduled date picker is a set of widgets that allows scheduling date. This can be useful in many scenarios, for scheduled tasks for example;

## Demo
![animated image](https://raw.githubusercontent.com/ViniciusSossela/scheduled-date-picker/master/doc/schedule_date_picker.gif?raw=true)     


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
