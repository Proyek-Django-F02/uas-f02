import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({
    Key? key,
    this.restorationId,
    required this.select,
    required this.selectedDate,
  }) : super(key: key);

  final String? restorationId;
  final void Function(DateTime?) select;
  final RestorableDateTime selectedDate;
  @override
  State<DatePicker> createState() => _DatePickerState();
}

/// RestorationProperty objects can be used because of RestorationMixin.
class _DatePickerState extends State<DatePicker> with RestorationMixin {
  // In this example, the restoration ID for the mixin is passed in through
  // the [StatefulWidget]'s constructor.
  @override
  String? get restorationId => widget.restorationId;
  void Function(DateTime?) get select => widget.select;
  RestorableDateTime get _selectedDate => widget.selectedDate;

  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: select,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendar,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(1990),
          lastDate: DateTime(2022),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  Widget buildContent() => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Icon(Icons.calendar_today_outlined, size: 25),
          )
        ],
      );

  Widget buildBirthday() {
    return Row(
      children: [
        Text(
          "My Birthday",
          style: TextStyle(
              fontSize: 20, color: Colors.blue, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          ":  ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildBirthday(),
        ElevatedButton(
            onPressed: () {
              _restorableDatePickerRouteFuture.present();
            },
            child: buildContent())
      ],
    );
  }

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Center(
  //       child: OutlinedButton(
  //         onPressed: () {
  //           _restorableDatePickerRouteFuture.present();
  //         },
  //         child: const Text('Open Date Picker'),
  //       ),
  //     ),
  //   );
  // }

}
