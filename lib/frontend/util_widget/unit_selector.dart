import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Select between English and Metric units for depth and weight with radio buttons.
/// This may need to be a more central user config - for now it is just used
/// on the [hangboard] workout creator screen.
class UnitSelector extends StatelessWidget with ChangeNotifier {
  final String depthMeasurementSystem;
  final String resistanceMeasurementSystem;

  UnitSelector({Key key, this.depthMeasurementSystem, this.resistanceMeasurementSystem});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          new ExpansionTile(
            key: PageStorageKey('unitSelector'),
            initiallyExpanded: true,
            title: new Text('Select your units'),
            children: <Widget>[
              unitRow(),
            ],
          ),
        ],
      ),
    );
  }

  Widget unitRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          fit: FlexFit.loose,
          child: Column(
            children: <Widget>[
              new Text(
                'Depth',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              new RadioListTile(
                title: Text(
                  'Millimeters (mm)',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                groupValue: depthMeasurementSystem,
                value: 'mm',
                onChanged: (value) {
                  notifyListeners();
                },
              ),
              new RadioListTile(
                title: Text(
                  'Inches (in)',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                groupValue: depthMeasurementSystem,
                value: 'in',
                onChanged: (value) {
                  notifyListeners();
                },
              ),
            ],
          ),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Column(
            children: <Widget>[
              new Text(
                'Resistance',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              new RadioListTile(
                title: Text(
                  'Kilograms (kg)',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                groupValue: resistanceMeasurementSystem,
                value: 'kg',
                onChanged: (value) {
                  notifyListeners();
                },
              ),
              new RadioListTile(
                title: Text(
                  'Pounds (lb)',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                groupValue: resistanceMeasurementSystem,
                value: 'lb',
                onChanged: (value) {
                  notifyListeners();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
