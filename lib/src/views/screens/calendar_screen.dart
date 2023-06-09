import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_pptik/src/extentions/int_extensions.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../features/calendar/provider/all_events_provider.dart';
import '../../models/event_model.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late CalendarController _calendarController;
  String _getMonthName(int month) {
    switch (month) {
      case 01:
        return 'January';
      case 02:
        return 'February';
      case 03:
        return 'March';
      case 04:
        return 'April';
      case 05:
        return 'May';
      case 06:
        return 'June';
      case 07:
        return 'July';
      case 08:
        return 'August';
      case 09:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      default:
        return 'December';
    }
  }

  Widget scheduleHeaderViewBuilder(
      BuildContext context, ScheduleViewMonthHeaderDetails details) {
    final String monthName = _getMonthName(details.date.month);
    return Stack(
      children: [
        Image(
            image: ExactAssetImage('assets/images/$monthName.png'),
            fit: BoxFit.cover,
            width: details.bounds.width,
            height: details.bounds.height),
        Positioned(
          left: 55,
          right: 0,
          top: 20,
          bottom: 0,
          child: Text(
            '$monthName ${details.date.year}',
            style: const TextStyle(fontSize: 18),
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    _calendarController = CalendarController();
    super.initState();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(allEventProvider);
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Calendar'),
      ),
      child: events.when(
        data: (data) {
          return SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SfCalendar(
                cellEndPadding: 5,
                allowAppointmentResize: true,
                allowedViews: const [
                  CalendarView.schedule,
                  CalendarView.month,
                ],
                headerHeight: 60,
                onTap: (detail) {},
                headerStyle: CalendarHeaderStyle(
                    backgroundColor:
                        CupertinoTheme.of(context).barBackgroundColor,
                    textStyle: CupertinoTheme.of(context)
                        .textTheme
                        .textStyle
                        .copyWith(fontSize: 18)),
                controller: _calendarController,
                dataSource: EventsDataSource(data),
                view: CalendarView.month,
                initialDisplayDate: DateTime.now(),
                showDatePickerButton: true,
                showCurrentTimeIndicator: true,
                monthViewSettings: MonthViewSettings(
                  agendaStyle: AgendaStyle(
                    appointmentTextStyle: CupertinoTheme.of(context)
                        .textTheme
                        .textStyle
                        .copyWith(color: Colors.white),
                    dateTextStyle: CupertinoTheme.of(context)
                        .textTheme
                        .textStyle
                        .copyWith(fontSize: 12),
                    dayTextStyle:
                        CupertinoTheme.of(context).textTheme.textStyle,
                  ),
                  agendaItemHeight: 40,
                  showAgenda: true,
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment,
                ),
                scheduleViewMonthHeaderBuilder: scheduleHeaderViewBuilder,
                scheduleViewSettings: ScheduleViewSettings(
                  appointmentTextStyle:
                      CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                            color: Colors.white,
                          ),
                ),
              ),
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text(error.toString()),
          );
        },
        loading: () {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        },
      ),
    );
  }
}

class EventsDataSource extends CalendarDataSource {
  EventsDataSource(List<EventModel> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    int time = appointments![index].timestart;
    return time.toDate();
  }

  @override
  getEndTime(int index) {
    if (appointments![index].timeduration != 0) {
      int time = appointments![index].timestart;
      Duration duration =
          Duration(milliseconds: appointments![index].timeduration * 1000);
      return time.toDate().add(duration);
    } else {
      int time = appointments![index].timestart;
      return time.toDate();
    }
  }

  @override
  String getSubject(int index) {
    return appointments![index].name;
  }
}
