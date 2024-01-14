import 'package:flutter/material.dart';
import 'package:moveme/component/calendar/calendar_util.dart';
import 'package:moveme/theme.dart';

class CalendarTile extends StatelessWidget {
  final VoidCallback onDateSelected;
  final DateTime date;
  final String dayOfWeek;
  final bool isDayOfWeek;
  final bool isSelected;
  final TextStyle dayOfWeekStyles;
  final TextStyle dateStyles;
  final Widget child;

  CalendarTile({
    this.onDateSelected,
    this.date,
    this.child,
    this.dateStyles,
    this.dayOfWeek,
    this.dayOfWeekStyles,
    this.isDayOfWeek: false,
    this.isSelected: false,
  });

  Widget renderDateOrDayOfWeek(BuildContext context) {
    if (isDayOfWeek) {
      return new InkWell(
        child: new Container(
          alignment: Alignment.center,
          child: new Text(
            dayOfWeek,
            style: AppTextStyle.textWhiteSmall,
          ),
        ),
      );
    } else {
      return new InkWell(
        onTap: onDateSelected,
        child: new Container(
          decoration: isSelected
              ? new BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.colorBlueLight,
                )
              : new BoxDecoration(),
          alignment: Alignment.center,
          child: new Text(
            CalendarUtil.formatDay(date).toString(),
            style: isSelected ? AppTextStyle.textWhiteSmall : AppTextStyle.textWhiteExtraSmall,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return new InkWell(
        child: child,
        onTap: onDateSelected,
      );
    }
    return new Container(
      child: renderDateOrDayOfWeek(context),
    );
  }
}
