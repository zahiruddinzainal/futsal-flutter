import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:futsal/book.dart';
import 'package:futsal/login.dart';
import 'package:futsal/models/booking.dart';
import 'package:futsal/profile.dart';
import 'package:futsal/query.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetable_view/timetable_view.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

Future<List<Booking>> fetchBookings() async {
  var response = await http.get(Uri.http('futsal.test', '/api/courts'));
  return (json.decode(response.body) as List)
      .map((e) => Booking.fromJson(e))
      .toList();
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2023, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        print("choosed date" + picked.toIso8601String());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QueryDate(),
            // Pass the arguments as part of the RouteSettings. The
            // DetailScreen reads the arguments from these settings.
            settings: RouteSettings(
              arguments: picked.toIso8601String(),
            ),
          ),
        );
      });
    }
  }

  String selectedCourt = "1";
  String selectedBookingDate = "";

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Today'),
          backgroundColor: Colors.purple[900],
          leading: new IconButton(
            icon: new Icon(Icons.date_range),
            color: Colors.white60,
            iconSize: 20,
            onPressed: () {
              _selectDate(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: new Icon(Icons.add),
              color: Colors.white60,
              iconSize: 20,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookCourt(),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.logout),
              color: Colors.white60,
              iconSize: 20,
              // onPressed: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => Profile(),
              //     ),
              //   );
              // },
              onPressed: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.remove("email");
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) {
                  return Login();
                }));
              },
            ),
          ],
        ),
        body: FutureBuilder<List<Booking>>(
          future: fetchBookings(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Booking> bookings = snapshot.data as List<Booking>;
              return TimetableView(
                timetableStyle: TimetableStyle(
                  timeItemTextColor: Colors.grey,
                  timelineItemColor: Colors.white,
                  showTimeAsAMPM: true,
                ),
                laneEventsList: _buildLaneEvents(bookings),
                onEventTap: onEventTapCallBack,
                onEmptySlotTap: onTimeSlotTappedCallBack,
              );
            }
            if (snapshot.hasError) {
              print(snapshot.error.toString());
              return Text('error');
            }
            return CircularProgressIndicator();
          },
        ));
  }

  List<LaneEvents> _buildLaneEvents(bookings) {
    return [
      LaneEvents(
        lane: Lane(
            name: 'Court 1',
            laneIndex: 1,
            textStyle: TextStyle(color: Colors.grey)),
        events: [
          for (var i = 0; i < bookings.length; i++)
            if (bookings[i].court == 1) eventCourt1(i, bookings),
        ],
      ),
      LaneEvents(
        lane: Lane(
            name: 'Court 2',
            laneIndex: 2,
            textStyle: TextStyle(color: Colors.grey)),
        events: [
          for (var i = 0; i < bookings.length; i++)
            if (bookings[i].court == 2) eventCourt2(i, bookings),
        ],
      ),
      // LaneEvents(
      //   lane: Lane(name: 'Court 2', laneIndex: 2),
      //   events: [
      //     event(),
      //   ],
      // ),
    ];
  }

  void onEventTapCallBack(TableEvent event) {
    print(
        "Event Clicked!! LaneIndex ${event.laneIndex} Title: ${event.title} StartHour: ${event.startTime.hour} EndHour: ${event.endTime.hour}");
  }

  void onTimeSlotTappedCallBack(
      int laneIndex, TableEventTime start, TableEventTime end) {
    print(
        "Empty Slot Clicked !! LaneIndex: $laneIndex StartHour: ${start.hour} EndHour: ${end.hour}");
  }
}

eventCourt1(i, bookings) {
  return TableEvent(
    eventId: bookings[i].id,
    title: "Booked by " + bookings[i].name.toString(),
    laneIndex: 1,
    startTime: TableEventTime(
        hour: bookings[i].startHour, minute: bookings[i].startMinute),
    endTime: TableEventTime(
        hour: bookings[i].endHour, minute: bookings[i].endMinute),
    backgroundColor: Colors.deepPurple,
  );
}

eventCourt2(i, bookings) {
  return TableEvent(
    eventId: bookings[i].id,
    title: "Booked by " + bookings[i].name.toString(),
    laneIndex: 1,
    startTime: TableEventTime(
        hour: bookings[i].startHour, minute: bookings[i].startMinute),
    endTime: TableEventTime(
        hour: bookings[i].endHour, minute: bookings[i].endMinute),
    backgroundColor: Colors.amber,
  );
}
