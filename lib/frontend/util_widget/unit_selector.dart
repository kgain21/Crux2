import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      key: Key('unitSelector'),
      child: Column(
        children: <Widget>[

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(FontAwesomeIcons.rulerHorizontal,),
                  Text(
                    'Depth',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              RadioListTile(
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
              RadioListTile(
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

      ],
    );
  }
}
