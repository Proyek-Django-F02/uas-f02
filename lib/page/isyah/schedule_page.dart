import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uas_f02/page/isyah/model.dart';
import 'package:uas_f02/page/isyah/repository.dart';

class SchedulePage extends StatefulWidget {
  final String name;
  final String urlImage;
  final String email;

  const SchedulePage({
    Key? key,
    required this.name,
    required this.email,
    required this.urlImage,
  }) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late String name;
  late Future<List> listActivity;
  late Map<DateTime, List<ScheduleActivity>> selectedActivities;

  Repository repository = Repository();
  // late Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  String dropdownValue = 'General';

  @override
  void initState() {
    // selectedEvents = {};
    name = widget.name;
    selectedActivities = {};
    getData(widget.name);
    print(name);
    super.initState();
  }

  List<ScheduleActivity> _getActivitiesfromDay(DateTime date) {
    print(selectedActivities.toString());
    return selectedActivities[date] ?? [];
  }

  Future<List> getData(name) async {
    Future<List> listActivity = repository.getData(name);

    for (ScheduleActivity activity in await listActivity) {
      DateTime date = DateTime(activity.year, activity.month, activity.day);

      if (selectedActivities[date] != null) {
        selectedActivities[date]!.add(activity);
      } else {
        selectedActivities[date] = [activity];
      }
    }

    // print(selectedActivities.toString());

    return listActivity;
  }

  _cancelForm() {
    _formKey.currentState!.reset();
    dropdownValue = 'General';
    _titleController.text = '';
    _descController.text = '';
    _startTimeController.text = '';
    _endTimeController.text = '';
    Navigator.pop(context);
    setState((){});
  }

  _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (selectedActivities[selectedDay] != null) {
        selectedActivities[selectedDay]!.add(
          ScheduleActivity(
              activity: _titleController.text,
              year: selectedDay.year,
              month: selectedDay.month,
              day: selectedDay.day,
              startTime: _startTimeController.text + ':00',
              endTime: _endTimeController.text + '00',
              type: dropdownValue,
              desc: _descController.text,
              name: name)
        );
      } else {
        selectedActivities[selectedDay] = [
          ScheduleActivity(
              activity: _titleController.text,
              year: selectedDay.year,
              month: selectedDay.month,
              day: selectedDay.day,
              startTime: _startTimeController.text + ':00',
              endTime: _endTimeController.text + '00',
              type: dropdownValue,
              desc: _descController.text,
              name: name)
        ];
      }
    }
    _formKey.currentState!.save();
    _formKey.currentState!.reset();
    dropdownValue = 'General';
    _titleController.text = '';
    _descController.text = '';
    _startTimeController.text = '';
    _endTimeController.text = '';
    Navigator.pop(context);
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Schedule"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: selectedDay,
            firstDay: DateTime(1990),
            lastDay: DateTime(2050),
            calendarFormat: format,
            onFormatChanged: (CalendarFormat _format) {
              setState(() {
                format = _format;
              });
            },
            startingDayOfWeek: StartingDayOfWeek.sunday,
            daysOfWeekVisible: true,

            //Day Changed
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              setState(() {
                selectedDay = selectDay;
                focusedDay = focusDay;
              });
              print(focusedDay);
            },
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDay, date);
            },

            eventLoader: _getActivitiesfromDay,

            //To style the Calendar
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape : BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                shape : BoxShape.circle,
              ),
              defaultDecoration: const BoxDecoration(
                shape : BoxShape.circle,
              ),
              weekendDecoration: const BoxDecoration(
                shape : BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),

          // Show Activities
          // Expanded(
          //     child:
          //     ListView.builder(
          //       scrollDirection: Axis.vertical,
          //       shrinkWrap: true,
          //       itemCount: _getEventsfromDay(selectedDay).length,
          //       itemBuilder: (BuildContext context, index) {
          //         return Dismissible(
          //           key: UniqueKey(),
          //           direction: DismissDirection.endToStart,
          //           onDismissed: (_) {
          //             setState(() {
          //               _getEventsfromDay(selectedDay).removeAt(index);
          //             });
          //           },
          //           child: Card(
          //             margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          //             child: Padding(
          //               padding: EdgeInsets.all(10),
          //               child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.stretch,
          //                 children: [
          //                   Row(
          //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                     children: [
          //                       Column(
          //                         crossAxisAlignment: CrossAxisAlignment.start,
          //                         children: [
          //                           Text(_getEventsfromDay(selectedDay)[index].startTime + " - " + _getEventsfromDay(selectedDay)[index].endTime, style: const TextStyle(color: Colors.lightBlueAccent)),
          //                           Text(_getEventsfromDay(selectedDay)[index].title, style: const TextStyle(fontWeight: FontWeight.bold)),
          //                         ],
          //                       ),
          //                       Text(_getEventsfromDay(selectedDay)[index].type, style: const TextStyle(color: Colors.lightBlueAccent)),
          //                     ],
          //                   ),
          //                   const SizedBox(height: 5),
          //                   if (_getEventsfromDay(selectedDay)[index].desc != '')
          //                     const Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
          //                   if (_getEventsfromDay(selectedDay)[index].desc != '')
          //                     Text(_getEventsfromDay(selectedDay)[index].desc),
          //                 ],
          //               ),
          //             )
          //           ),
          //           background: Container(
          //             color: Colors.red,
          //             margin: EdgeInsets.symmetric(horizontal: 15),
          //             alignment: Alignment.centerRight,
          //             child: Icon(
          //               Icons.delete,
          //               color: Colors.white,
          //             )
          //           )
          //         );
          //       }
          //     )
          // ),
          Expanded(
              child: FutureBuilder(
                  future: getData(name),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: _getActivitiesfromDay(selectedDay).length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                                key: UniqueKey(),
                                direction: DismissDirection.endToStart,
                                onDismissed: (_) {
                                  setState(() {
                                    _getActivitiesfromDay(selectedDay).removeAt(index);
                                  });
                                },
                                child: Card(
                                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(_getActivitiesfromDay(selectedDay)[index].startTime.toString() + " - " + _getActivitiesfromDay(selectedDay)[index].endTime.toString(), style: const TextStyle(color: Colors.lightBlueAccent)),
                                                  Text(_getActivitiesfromDay(selectedDay)[index].activity, style: const TextStyle(fontWeight: FontWeight.bold)),
                                                ],
                                              ),
                                              Text(_getActivitiesfromDay(selectedDay)[index].type, style: const TextStyle(color: Colors.lightBlueAccent)),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          if (_getActivitiesfromDay(selectedDay)[index].desc != '')
                                            const Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
                                          if (_getActivitiesfromDay(selectedDay)[index].desc != '')
                                            Text(_getActivitiesfromDay(selectedDay)[index].desc),
                                        ],
                                      ),
                                    )
                                ),
                                background: Container(
                                    color: Colors.red,
                                    margin: EdgeInsets.symmetric(horizontal: 15),
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    )
                                )
                            );
                          }
                      );
                    } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }
              ),
          )
        ],
      ),

      // Add Activity Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Add New Activity"),
            content:
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                          labelText: "Activity Title*"
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please type the activity's title";
                        }
                        return null;
                      }
                  ),
                  TextFormField(
                    controller: _startTimeController,  // add this line.
                    decoration: InputDecoration(
                      labelText: 'Start Time*',
                    ),
                    onTap: () async {
                      TimeOfDay time = TimeOfDay.now();
                      FocusScope.of(context).requestFocus(new FocusNode());

                      TimeOfDay? picked =
                      await showTimePicker(context: context, initialTime: time);
                      if (picked != null && picked != time) {
                        String lsHour = picked.hour.toString().padLeft(2, '0');
                        String lsMinute = picked.minute.toString().padLeft(2, '0');
                        _startTimeController.text = '$lsHour:$lsMinute';  // add this line.
                        setState(() {
                          time = picked;
                        });
                      } else {
                        String lsHour = TimeOfDay.now().hour.toString().padLeft(2, '0');
                        String lsMinute = TimeOfDay.now().minute.toString().padLeft(2, '0');
                        _startTimeController.text = '$lsHour:$lsMinute';  // add this line.
                        setState(() {
                          time = TimeOfDay.now();
                        });
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Cant be empty';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _endTimeController,  // add this line.
                    decoration: InputDecoration(
                      labelText: 'End Time*',
                    ),
                    onTap: () async {
                      TimeOfDay time = TimeOfDay.now();
                      FocusScope.of(context).requestFocus(new FocusNode());

                      TimeOfDay? picked =
                      await showTimePicker(context: context, initialTime: time);
                      if (picked != null && picked != time) {
                        String lsHour = picked.hour.toString().padLeft(2, '0');
                        String lsMinute = picked.minute.toString().padLeft(2, '0');
                        _endTimeController.text = '$lsHour:$lsMinute';  // add this line.
                        setState(() {
                          time = picked;
                        });
                      } else {
                        String lsHour = TimeOfDay.now().hour.toString().padLeft(2, '0');
                        String lsMinute = TimeOfDay.now().minute.toString().padLeft(2, '0');
                        _endTimeController.text = '$lsHour:$lsMinute';  // add this line.
                        setState(() {
                          time = TimeOfDay.now();
                        });
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Cant be empty';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField(
                    value: dropdownValue,
                    elevation: 16,
                    style: TextStyle(color: Colors.blue),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: <String>['General', 'Course', 'Appointment', 'Hobby']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(
                      labelText: "Description",
                    ),
                  ),

                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: _cancelForm,
              ),
              TextButton(
                child: const Text("Ok"),
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
        label: const Text("Add Activity"),
        icon: const Icon(Icons.add),
      ),
    );
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Map<DateTime, List<ScheduleActivity>>>('selectedActivities', selectedActivities));
  }
}
