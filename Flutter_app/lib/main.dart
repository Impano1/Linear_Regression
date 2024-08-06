import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPA Predictor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _studyHoursController = TextEditingController();
  final TextEditingController _otherVariable1Controller = TextEditingController();
  final TextEditingController _otherVariable2Controller = TextEditingController();
  String? _prediction;

  Future<void> _predictGPA() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/predict'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'study_hours': double.parse(_studyHoursController.text),
        'other_variable1': double.parse(_otherVariable1Controller.text),
        'other_variable2': double.parse(_otherVariable2Controller.text),
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _prediction = jsonDecode(response.body)['predicted_gpa'].toString();
      });
    } else {
      setState(() {
        _prediction = "Error: Unable to predict GPA";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GPA Predictor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _studyHoursController,
                decoration: InputDecoration(labelText: 'Study Hours'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter study hours';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _otherVariable1Controller,
                decoration: InputDecoration(labelText: 'Other Variable 1'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter other variable 1';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _otherVariable2Controller,
                decoration: InputDecoration(labelText: 'Other Variable 2'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter other variable 2';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _predictGPA();
                  }
                },
                child: Text('Predict'),
              ),
              SizedBox(height: 20),
              if (_prediction != null)
                Text(
                  'Predicted GPA: $_prediction',
                  style: TextStyle(fontSize: 20),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
