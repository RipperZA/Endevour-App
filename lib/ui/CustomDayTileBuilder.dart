import 'package:calendarro/calendarro.dart';
import 'package:calendarro/date_utils.dart';
import 'package:endevour/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomDayTileBuilder extends DayTileBuilder {
  Color todayHighlightColor;

  CustomDayTileBuilder({this.todayHighlightColor});

  @override
  Widget build(BuildContext context, DateTime date, DateTimeCallback onTap) {
    return CustomColorCalendarroDayItem(
        date: date,
        calendarroState: Calendarro.of(context),
        onTap: onTap,
        todayHighlightColor: todayHighlightColor);
  }
}

class CustomColorCalendarroDayItem extends StatelessWidget {
  CustomColorCalendarroDayItem(
      {this.date, this.calendarroState, this.onTap, this.todayHighlightColor});

  DateTime date;
  CalendarroState calendarroState;
  DateTimeCallback onTap;
  Color todayHighlightColor;

  @override
  Widget build(BuildContext context) {

    determineTileColour() {
      if (Constants.holidays.contains(date.toString().substring(5, 10) )) {
        return publicHolidayColour;
      } else if (date.weekday == DateTime.saturday) {
        return saturdayColour;
      } else if (date.weekday == DateTime.sunday) {
        return sundayColour;
      } else {
        return weekdayColour;
      }
    }

    bool isWeekend = DateUtils.isWeekend(date);
//    var textColor = isWeekend ? Colors.grey : Colors.black;
    var textColor = determineTileColour();
    bool isToday = DateUtils.isToday(date);
    calendarroState = Calendarro.of(context);

    bool daySelected = calendarroState.isDateSelected(date);

    BoxDecoration boxDecoration;
    if (daySelected) {
      boxDecoration = BoxDecoration(color:themeColour, shape: BoxShape.circle);
    } else if (isToday) {
      boxDecoration =
          BoxDecoration(color: todayHighlightColor, shape: BoxShape.circle);
    }

    return Expanded(
        child: GestureDetector(
      child: Container(
          height: 40.0,
          decoration: boxDecoration,
          child: Center(
              child: Text(
            "${date.day}",
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor),
          ))),
      onTap: handleTap,
      behavior: HitTestBehavior.translucent,
    ));
  }

  void handleTap() {
    if (onTap != null) {
      onTap(date);
    }

    calendarroState.setSelectedDate(date);
    calendarroState.setCurrentDate(date);
  }
}
