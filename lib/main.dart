import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  double _numberForm;
  final List<String> _measures = [
    'meters',
    'kilometers',
    'grams',
    'kilograms',
    'feet',
    'miles',
    'pounds (lbs)',
    'ounces',
  ];
  String _startMeasure;
  String _convertedMeasure;
  final Map<String, int> _measuresMap = {
    'meters': 0,
    'kilometers': 1,
    'grams': 2,
    'kilograms': 3,
    'feet': 4,
    'miles': 5,
    'pounds (lbs)': 6,
    'ounces': 7,
  };
  final dynamic _formulas = {
    '0': [1, 0.001, 0, 0, 3.28084, 0.000621371, 0, 0],
    '1': [1000, 1, 0, 0, 3280.84, 0.621371, 0, 0],
    '2': [0, 0, 1, 0.0001, 0, 0, 0.00220462, 0.035274],
    '3': [0, 0, 1000, 1, 0, 0, 2.20462, 35.274],
    '4': [0.3048, 0.0003048, 0, 0, 1, 0.000189394, 0, 0],
    '5': [1609.34, 1.60934, 0, 0, 5280, 1, 0, 0],
    '6': [0, 0, 453.592, 0.453592, 0, 0, 1, 16],
    '7': [0, 0, 28.3495, 0.0283495, 3.28084, 0, 0.0625, 1],
  };

  String _resultMessage;

  final TextStyle _inputStyle = TextStyle(
    fontSize: 20,
    color: Colors.blue[900],
  );

  final TextStyle _labelStyle = TextStyle(
    fontSize: 24,
    color: Colors.grey[700],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Measures Converter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Measures Converter'),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Spacer(),
              Text(
                'Value',
                style: _labelStyle,
              ),
              Spacer(),
              TextField(
                  style: _inputStyle,
                  // InputDecoration allows us to specify the border, labels, icons, and styles of a text field
                  decoration: InputDecoration(
                    hintText: "Please insert the measure to be converted",
                  ),
                  onChanged: (text) {
                    var rv = double.tryParse(text);
                    if (rv != null) {
                      setState(() {
                        _numberForm = rv;
                      });
                    }
                  }),
              Spacer(),
              Text(
                'Form',
                style: _labelStyle,
              ),
              Spacer(),
              DropdownButton(
                isExpanded: true,
                items: _measures.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: _inputStyle,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _startMeasure = value;
                  });
                },
                value: _startMeasure,
              ),
              Spacer(),
              Text(
                'To',
                style: _labelStyle,
              ),
              Spacer(),
              DropdownButton(
                isExpanded: true,
                style: _inputStyle,
                items: _measures.map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(
                      value,
                      style: _inputStyle,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _convertedMeasure = value;
                  });
                },
                value: _convertedMeasure,
              ),
              Spacer(
                flex: 2,
              ),
              RaisedButton(
                child: Text(
                  'Convert',
                  style: _inputStyle,
                ),
                onPressed: () {
                  if (_startMeasure.isEmpty ||
                      _convertedMeasure.isEmpty ||
                      _numberForm == 0) {
                    return;
                  }
                  convert(_numberForm, _startMeasure, _convertedMeasure);
                },
              ),
              Spacer(
                flex: 2,
              ),
              Text(
                (_resultMessage == null) ? '' : _resultMessage,
                style: _labelStyle,
              ),
              Spacer(
                flex: 8,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _numberForm = 0;
    super.initState();
  }

  void convert(double value, String from, String to) {
    int nFrom = _measuresMap[from];
    int nTo = _measuresMap[to];
    var multiplier = _formulas[nFrom.toString()][nTo];
    var result = value * multiplier;

    _resultMessage = (result == 0)
        ? 'This conversion cannot be performed'
        : '${_numberForm.toString()} $_startMeasure are ${result.toString()} $_convertedMeasure';

    setState(() {
      _resultMessage = _resultMessage;
    });
  }
}
