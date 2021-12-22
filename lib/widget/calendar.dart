import 'package:flutter/foundation.dart';
import '../temp_schedule_event.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  String dropdownValue = 'General';

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (selectedEvents[selectedDay] != null) {
        selectedEvents[selectedDay]!.add(
          Event(title: _titleController.text, desc: _descController.text, type: dropdownValue),
        );
      } else {
        selectedEvents[selectedDay] = [
          Event(title: _titleController.text, desc: _descController.text, type: dropdownValue)
        ];
      }
    }
    _formKey.currentState!.save();
    _formKey.currentState!.reset();
    dropdownValue = 'General';
    Navigator.pop(context);
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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

            eventLoader: _getEventsfromDay,

            //To style the Calendar
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                // color: AppTheme.colors.customBlue,
                shape : BoxShape.circle,
              ),
              // selectedTextStyle: TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                // color: AppTheme.colors.customPink,
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
                // color: AppTheme.colors.customBlue,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),

          // Show Activities
          Expanded(
              child:
              ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  ..._getEventsfromDay(selectedDay).map((Event event) => Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('19:00 - 20:00'),
                                Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Text(event.type),
                          ],
                        ),
                        const SizedBox(height: 5),

                        if (event.desc != '')
                          const Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
                        if (event.desc != '')
                          Text(event.desc),
                      ],
                    ),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    // decoration: BoxDecoration(
                    //     border: Border.all(color: AppTheme.colors.customYellow)
                    // ),
                  )
                  ),
                ],
              )
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
                          labelText: "Activity Title *"
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please type the activity's title";
                        }
                        return null;
                      }
                  ),
                  DropdownButtonFormField(
                    value: dropdownValue,
                    elevation: 16,
                    // style: TextStyle(color: AppTheme.colors.customBlue),
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
                onPressed: () => Navigator.pop(context),
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
    properties.add(DiagnosticsProperty<Map<DateTime, List<Event>>>('selectedEvents', selectedEvents));
  }
}