import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import './theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add Timeclock',
      theme: myTheme,
      home: MyHomePage(title: 'Add Timeclock'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime startTime;
  final numHoursController = TextEditingController();
  String finalMessage = "";

  void initState() {
    numHoursController.addListener(() {
      final text = numHoursController.text;
    });
    super.initState();
  }

  void dispose() {
    numHoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Timeclock"),
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            DateTimeField(
                format: DateFormat("hh:mm a"),
                onShowPicker: (context, currentValue) async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  );
                  startTime = DateTimeField.convert(time);
                  return startTime;
                },
                decoration: InputDecoration(
                    labelText: "What time did you start?",
                    border: OutlineInputBorder())),
            TextFormField(
              decoration: InputDecoration(
                  labelText: "How long will you work?",
                  border: OutlineInputBorder()),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: numHoursController,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: FloatingActionButton(
                child: Icon(Icons.alarm),
                onPressed: () {
                  setState(() {
                    final clockOutTime = DateFormat("hh:mm a").format(
                        startTime.add(Duration(
                            minutes: (double.parse(numHoursController.text) * 60)
                                .toInt())));
                    finalMessage = "You can clock out at $clockOutTime";
                  });
                },
                backgroundColor: Theme.of(context).primaryColorDark,
                highlightElevation: 3.0,
              ),
            ),
            if (finalMessage.length > 0)
              Text(
                finalMessage,
                style: Theme.of(context).textTheme.subhead,
              ),
            if (numHoursController.text.length == 0 || startTime == null)
              Text("")
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        )));
  }
}
