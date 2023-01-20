import 'package:flutter/material.dart';
import 'package:futsal/home.dart';
import 'dart:convert' as convert;
import 'constant.dart' as Constants;

import 'package:http/http.dart' as http;

class BookCourt extends StatefulWidget {
  const BookCourt({super.key});

  @override
  State<BookCourt> createState() => _BookCourtState();
}

class _BookCourtState extends State<BookCourt> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay timeOfDay = TimeOfDay.now();
  String _court = "Select court";
  String _date = "Select date to book";
  String _time = "Select time to book";

  String _courtValue = "-";
  String _dateValue = "-";
  String _timeValue = "";

  void _selectCourt() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 500,
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    // ElevatedButton(
                    //     onPressed: () => {
                    //           setState(() {
                    //             _court = "Selected court: Court 1";
                    //             _courtValue = "1";
                    //           }),
                    //           Navigator.pop(context)
                    //         },
                    //     child: Text("Court 1")),
                    InkWell(
                      onTap: () => {
                        setState(() {
                          _court = "Selected court: Court 1";
                          _courtValue = "1";
                        }),
                        Navigator.pop(context)
                      },
                      child: Image.asset(
                        width: 300,
                        height: 200,
                        'assets/court1.png',
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () => {
                        setState(() {
                          _court = "Selected court: Court 2";
                          _courtValue = "2";
                        }),
                        Navigator.pop(context)
                      },
                      child: Image.asset(
                        width: 300,
                        height: 200,
                        'assets/court2.png',
                      ),
                    )
                  ],
                )
              ],
            ));
      },
    );
  }

  bookCourt(court, name, date, time) async {
    var response = await http.get(Uri.http(Constants.LARAVEL_ENDPOINT_URL,
        '/api/courts/$court/name/$name/date/$date/time/$time'));
    print(response.body);
    if (response.body == "200") {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 250,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.done_all,
                    color: Colors.green,
                    size: 60,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Court $court has been booked'),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    child: const Text('Return to homepage'),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else if (response.body == "booked") {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 250,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.error_outline,
                    color: Colors.red[900],
                    size: 60,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Sorry, this period has been booked'),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[900],
                          minimumSize: Size.fromHeight(
                              40), // fromHeight use double.infinity as width and 40 is the height
                        ),
                        child: const Text('Close'),
                        onPressed: () => Navigator.pop(context)),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 250,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.error_outline,
                    color: Colors.red[900],
                    size: 60,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Please complete the booking form'),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[900],
                          minimumSize: Size.fromHeight(
                              40), // fromHeight use double.infinity as width and 40 is the height
                        ),
                        child: const Text('Close'),
                        onPressed: () => Navigator.pop(context)),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Future _selectTime(BuildContext context) async {
    var time = await showTimePicker(context: context, initialTime: timeOfDay);

    if (time != null) {
      setState(() {
        _time = "Selected time: ${time.hour}:${time.minute}";
        _timeValue = "${time.hour}:${time.minute}";
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2023, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        String _newDate = picked.day.toString() +
            "/" +
            picked.month.toString() +
            "/" +
            picked.year.toString();
        _date = "Chosen date: " + _newDate.toString();
        _dateValue = picked.toIso8601String();
        print("choosen date: " + _dateValue.toString());
        print("choosen date: " + picked.toIso8601String());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Court'),
        backgroundColor: Colors.purple[900],
      ),
      body: SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Text(
                      '$_court',
                      style: TextStyle(fontSize: 15),
                    ),
                    IconButton(
                      icon: new Icon(Icons.sports_soccer),
                      color: Colors.grey,
                      iconSize: 20,
                      onPressed: _selectCourt,
                    ),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Text(
                      '$_date',
                      style: TextStyle(fontSize: 15),
                    ),
                    IconButton(
                      icon: new Icon(Icons.calendar_today),
                      color: Colors.grey,
                      iconSize: 20,
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Text(
                      '$_time',
                      style: TextStyle(fontSize: 15),
                    ),
                    IconButton(
                      icon: new Icon(Icons.av_timer),
                      color: Colors.grey,
                      iconSize: 20,
                      onPressed: () {
                        _selectTime(context);
                      },
                    ),
                  ],
                )),
            Expanded(
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[900],
                        minimumSize: Size.fromHeight(
                            40), // fromHeight use double.infinity as width and 40 is the height
                      ),
                      onPressed: () => {
                        bookCourt(_courtValue, "zahir", _dateValue, _timeValue),
                      },
                      child: Text('Confirm Book'),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
