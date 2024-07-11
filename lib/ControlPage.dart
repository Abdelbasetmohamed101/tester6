import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

class ControlScreen extends StatefulWidget {
  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('System');
  String direction = 'center';
  bool powerState = false;

  void _updateDirection(double x, double y) {
    String newDirection = 'a'; //center the car stops

    if (y < -0.5 && x.abs() < 0.5) {
      newDirection = 'A'; //forward
    } else if (y > 0.5 && x.abs() < 0.5) {
      newDirection = 'B'; //backward
    } else if (x > 0.5 && y.abs() < 0.5) {
      newDirection = 'C'; //right
    } else if (x < -0.5 && y.abs() < 0.5) {
      newDirection = 'D'; //left
    } else if (x > 0.5 && y < -0.5) {
      newDirection = 'F'; //forward-right
    } else if (x < -0.5 && y < -0.5) {
      newDirection = 'E'; //forward-left
    } else if (x > 0.5 && y > 0.5) {
      newDirection = 'H'; //backard-right
    } else if (x < -0.5 && y > 0.5) {
      newDirection = 'G'; //backward-left
    }

    setState(() {
      direction = newDirection;
    });

    _database.update({'direction': newDirection});
  }

  void _togglePowerState() {
    setState(() {
      powerState = !powerState;
    });

    _database.update({'power_state': powerState});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Joystick(
            listener: (details) {
              _updateDirection(details.x, details.y);
            },
          ),
          const SizedBox(height: 100),
          ElevatedButton(
            onPressed: _togglePowerState,
            style: ElevatedButton.styleFrom(
              backgroundColor: powerState ? Colors.red : Colors.green,
            ),
            child: Text(powerState ? 'turn Power off' : 'turn Power on'),
          ),
        ],
      ),
    );
  }
}
