import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:crux/frontend/screen/form/hangboard/bloc/hangboard_form_bloc.dart';
import 'package:crux/frontend/screen/form/hangboard/bloc/hangboard_form_event.dart';
import 'package:crux/frontend/screen/form/hangboard/bloc/hangboard_form_state.dart';
import 'package:crux/frontend/util_widget/unit_selector.dart';
import 'package:crux/model/finger_configuration.dart';
import 'package:crux/model/hold_enum.dart';
import 'package:crux/model/unit.dart';
import 'package:crux/util/null_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HangboardFormScreenArguments {
  final CruxUser cruxUser;
  final CruxWorkout cruxWorkout;

  HangboardFormScreenArguments({
    @required this.cruxUser,
    @required this.cruxWorkout,
  });
}

class HangboardFormScreen extends StatefulWidget {
  static const routeName = '/hangboardForm';

  final HangboardFormBloc hangboardFormBloc;
  final CruxWorkout cruxWorkout;
  final CruxUser cruxUser;

  HangboardFormScreen({
    @required this.hangboardFormBloc,
    @required this.cruxWorkout,
    @required this.cruxUser,
  });

  @override
  State createState() => _HangboardFormScreenState(hangboardFormBloc);
}

class _HangboardFormScreenState extends State<HangboardFormScreen> {
  final HangboardFormBloc hangboardFormBloc;
  final GlobalKey<FormState> formKey = GlobalKey(debugLabel: 'hangboardForm');

  final TextEditingController _depthController = TextEditingController();
  final TextEditingController _timeOnController = TextEditingController();
  final TextEditingController _timeOffController = TextEditingController();
  final TextEditingController _hangsPerSetController = TextEditingController();
  final TextEditingController _timeBetweenSetsController = TextEditingController();
  final TextEditingController _numberOfSetsController = TextEditingController();
  final TextEditingController _resistanceController = TextEditingController();

  _HangboardFormScreenState(this.hangboardFormBloc);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('hangboardFormScaffold'),
      appBar: AppBar(
        title: Text('Create a new exercise'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            tooltip: 'Help',
            onPressed: () {},
          ),
        ],
      ),
      body: BlocListener(
        bloc: hangboardFormBloc,
        listener: (BuildContext context, HangboardFormState hangboardFormState) {
          if (hangboardFormState.isSuccess) {
            exerciseSavedSnackbar(context);
            hangboardFormBloc.add(ResetFlags());
          } else if (hangboardFormState.isDuplicate) {
            _exerciseExistsAlert(hangboardFormState);
            hangboardFormBloc.add(ResetFlags());
          }
        },
        child: BlocBuilder(
          bloc: hangboardFormBloc,
          builder: (context, hangboardFormState) {
            return Builder(
              builder: (scaffoldContext) => Form(
                key: formKey,
                child: ListView(
                  children: <Widget>[
                    UnitSelector(
                      depthMeasurementSystem: 'mm',
                      resistanceMeasurementSystem: 'kg',
                    ),
                    _handsRadioTile(hangboardFormState, scaffoldContext),
                    _holdDropdownTile(hangboardFormState, scaffoldContext),
                    _fingerConfigurationDropdownTile(hangboardFormState, scaffoldContext),
                    _depthTile(hangboardFormState, scaffoldContext),
                    _durationTile(hangboardFormState, scaffoldContext),
                    // hangProtocolTile(),
                    _hangsPerSetTile(hangboardFormState, scaffoldContext),
                    _breakDurationTile(hangboardFormState, scaffoldContext),
                    _numberOfSetsTile(hangboardFormState, scaffoldContext),
                    _resistanceTile(hangboardFormState, scaffoldContext),
                    _saveButton(hangboardFormState, scaffoldContext)
                  ].where(NullUtil.notNull).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _handsRadioTile(HangboardFormState hangboardFormState, BuildContext scaffoldContext) {
    return Card(
      key: Key('handsRadioTile'),
      child: ListTile(
        key: PageStorageKey('handsRadioTilePageStorage'),
        title: Row(
          children: <Widget>[
            Flexible(
              child: RadioListTile(
                title: Text('One hand'),
                value: 1,
                groupValue: hangboardFormState.hands,
                onChanged: (value) {
                  Scaffold.of(scaffoldContext).hideCurrentSnackBar();
                  hangboardFormBloc.add(HandsChanged(value));
                },
              ),
            ),
            Flexible(
              child: RadioListTile(
                title: Text('Two hands'),
                value: 2,
                groupValue: hangboardFormState.hands,
                onChanged: (value) {
                  Scaffold.of(scaffoldContext).hideCurrentSnackBar();
                  hangboardFormBloc.add(HandsChanged(value));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _holdDropdownTile(HangboardFormState hangboardFormState, BuildContext scaffoldContext) {
    return Card(
      key: Key('holdDropdownTile'),
      child: ListTile(
        leading: Icon(
          FontAwesomeIcons.solidHandRock,
        ),
        title: DropdownButtonHideUnderline(
          child: DropdownButton<Hold>(
            elevation: 10,
            hint: Text(
              'Choose a hold',
            ),
            value: hangboardFormState.hold,
            onChanged: (value) {
              Scaffold.of(scaffoldContext).hideCurrentSnackBar();
              hangboardFormBloc.add(HoldChanged(value));
            },
            items: Hold.values.map((Hold hold) {
              return DropdownMenuItem<Hold>(
                child: Text(
                  hold.name,
                ),
                value: hold,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _fingerConfigurationDropdownTile(
      HangboardFormState hangboardFormState, BuildContext scaffoldContext) {
    if (hangboardFormState.showFingerConfiguration) {
      return Card(
        key: Key('fingerConfigurationDropdownTile'),
        child: ListTile(
          leading: Icon(
            FontAwesomeIcons.solidHandPaper,
          ),
          title: DropdownButtonHideUnderline(
            child: DropdownButton<FingerConfiguration>(
              elevation: 10,
              hint: Text(
                'Choose a finger configuration',
              ),
              value: hangboardFormState.fingerConfiguration,
              onChanged: (value) {
                Scaffold.of(scaffoldContext).hideCurrentSnackBar();
                hangboardFormBloc.add(FingerConfigurationChanged(value));
              },
              items: hangboardFormState.availableFingerConfigurations.map((fingerConfiguration) {
                return DropdownMenuItem(
                  child: Text(
                    fingerConfiguration.name,
                  ),
                  value: fingerConfiguration,
                );
              }).toList(),
            ),
          ),
        ),
      );
    } else {
      return null;
    }
  }

  Widget _depthTile(HangboardFormState hangboardFormState, BuildContext scaffoldContext) {
    if (!hangboardFormState.showDepth) {
      return null;
    }
    return Card(
      key: Key('depthTile'),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: RadioListTile(
                      title: Text(
                        '${DepthUnit.MILLIMETERS.name} (${DepthUnit.MILLIMETERS.abbreviation})',
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      groupValue: hangboardFormState.depthUnit,
                      value: DepthUnit.MILLIMETERS,
                      onChanged: (value) {
                        hangboardFormBloc.add(DepthUnitChanged(value));
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      title: Text(
                        '${DepthUnit.INCHES.name} (${DepthUnit.INCHES.abbreviation})',
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      groupValue: hangboardFormState.depthUnit,
                      value: DepthUnit.INCHES,
                      onChanged: (value) {
                        hangboardFormBloc.add(DepthUnitChanged(value));
                      },
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _depthController,
                autovalidate: hangboardFormState.autoValidate,
                validator: (_) {
                  return hangboardFormState.validDepth ? null : 'Invalid Depth';
                },
                onChanged: (value) {
                  hangboardFormBloc.add(DepthChanged(double.parse(value)));
                },
                decoration: InputDecoration(
                  icon: Icon(FontAwesomeIcons.rulerHorizontal),
                  labelText: 'Depth (${hangboardFormState.depthUnit.abbreviation})',
                ),
                keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                onTap: () {
                  Scaffold.of(scaffoldContext).hideCurrentSnackBar();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _durationTile(HangboardFormState hangboardFormState, BuildContext scaffoldContext) {
    return Card(
      key: Key('durationTile'),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 4.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 0.0, right: 8.0, bottom: 8.0),
                child: TextFormField(
                  controller: _timeOnController,
                  autovalidate: hangboardFormState.autoValidate,
                  validator: (_) {
                    return hangboardFormState.validRepDuration ? null : 'Invalid Rep Duration';
                  },
                  onChanged: (value) {
                    hangboardFormBloc.add(RepDurationChanged(int.tryParse(value)));
                  },
                  decoration: InputDecoration(
                    labelText: 'Rep Duration (sec)',
                  ),
                  keyboardType: TextInputType.numberWithOptions(),
                  onTap: () {
                    Scaffold.of(scaffoldContext).hideCurrentSnackBar();
                  },
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 0.0, right: 8.0, bottom: 8.0),
                child: TextFormField(
                  controller: _timeOffController,
                  autovalidate: hangboardFormState.autoValidate,
                  validator: (_) {
                    return hangboardFormState.validRestDuration ? null : 'Invalid Rest Duration';
                  },
                  onChanged: (value) {
                    hangboardFormBloc.add(RestDurationChanged(int.tryParse(value)));
                  },
                  decoration: InputDecoration(
                    labelText: 'Rest Duration (sec)',
                  ),
                  keyboardType: TextInputType.numberWithOptions(),
                  onTap: () {
                    Scaffold.of(scaffoldContext).hideCurrentSnackBar();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//  Widget hangProtocolTile(HangboardFormState hangboardFormState) {
//    return Card(
//      child:  CheckboxListTile(
//        key: PageStorageKey('hangProtocolTile'),
//        value: _hangProtocolSelected,
//        onChanged: (value) {
//          setState(() {
//            _hangProtocolSelected = value;
//          });
//        },
//        title: Text('Include Hang Protocol?'),
//      ),
//    );
//  }

  Widget _hangsPerSetTile(HangboardFormState hangboardFormState, BuildContext scaffoldContext) {
    return Card(
      key: Key('hangsPerSetTile'),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: TextFormField(
            controller: _hangsPerSetController,
            autovalidate: hangboardFormState.autoValidate,
            validator: (_) {
              return hangboardFormState.validHangsPerSet ? null : 'Invalid Hangs Per Set';
            },
            onChanged: (value) {
              hangboardFormBloc.add(HangsPerSetChanged(int.tryParse(value)));
            },
            decoration: InputDecoration(
              labelText: 'Hangs per set',
              icon: Icon(Icons.format_list_bulleted),
            ),
            keyboardType: TextInputType.numberWithOptions(),
            onTap: () {
              Scaffold.of(scaffoldContext).hideCurrentSnackBar();
            },
          ),
        ),
      ),
    );
  }

  Widget _breakDurationTile(HangboardFormState hangboardFormState, BuildContext scaffoldContext) {
    return Card(
      key: Key('breakDurationTile'),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: TextFormField(
            controller: _timeBetweenSetsController,
            autovalidate: hangboardFormState.autoValidate,
            validator: (_) {
              return hangboardFormState.validTimeBetweenSets ? null : 'Invalid Time Between Sets';
            },
            onChanged: (value) {
              hangboardFormBloc.add(BreakDurationChanged(int.tryParse(value)));
            },
            decoration: InputDecoration(
              icon: Icon(Icons.watch_later),
              labelText: 'Time between sets (sec)',
            ),
            keyboardType: TextInputType.numberWithOptions(),
            onTap: () {
              Scaffold.of(scaffoldContext).hideCurrentSnackBar();
            },
          ),
        ),
      ),
    );
  }

  Widget _numberOfSetsTile(HangboardFormState hangboardFormState, BuildContext scaffoldContext) {
    return Card(
      key: Key('numberOfSetsTile'),
      child: ListTile(
        key: PageStorageKey('numberOfSetsTilePageStorage'),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: TextFormField(
//todo: https://api.flutter.dev/flutter/material/TextFormField-class.html
            //todo: ^ has example of autovalidation/autofocus on next element when user hits enter
            controller: _numberOfSetsController,
            autovalidate: hangboardFormState.autoValidate,
            validator: (_) {
              return hangboardFormState.validNumberOfSets ? null : 'Invalid Number of Sets';
            },
            onChanged: (value) {
              hangboardFormBloc.add(NumberOfSetsChanged(int.tryParse(value)));
            },
            decoration: InputDecoration(
              labelText: 'Number of sets',
              icon: Icon(Icons.format_list_bulleted),
            ),
            keyboardType: TextInputType.numberWithOptions(),
            onTap: () {
              Scaffold.of(scaffoldContext).hideCurrentSnackBar();
            },
          ),
        ),
      ),
    );
  }

  Widget _resistanceTile(HangboardFormState hangboardFormState, BuildContext scaffoldContext) {
    return Card(
      child: ExpansionTile(
        onExpansionChanged: _resistanceTileVisibilityChanged,
        key: ValueKey(hangboardFormState.showResistance),
        initiallyExpanded: hangboardFormState.showResistance,
        trailing: Switch(
          value: hangboardFormState.showResistance,
          onChanged: _resistanceTileVisibilityChanged,
        ),
        title: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
              child: Icon(
                FontAwesomeIcons.weightHanging,
                color: Theme.of(scaffoldContext).iconTheme.color,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
              child: Text('Resistance'),
            )
          ],
        ),
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: RadioListTile(
                  title: Text(
                    '${ResistanceUnit.KILOGRAMS.name} (${ResistanceUnit.KILOGRAMS.abbreviation})',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  groupValue: hangboardFormState.resistanceUnit,
                  value: ResistanceUnit.KILOGRAMS,
                  onChanged: (value) {
                    hangboardFormBloc.add(ResistanceUnitChanged(value));
                  },
                ),
              ),
              Expanded(
                child: RadioListTile(
                  title: Text(
                    '${ResistanceUnit.POUNDS.name} (${ResistanceUnit.POUNDS.abbreviation})',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  groupValue: hangboardFormState.resistanceUnit,
                  value: ResistanceUnit.POUNDS,
                  onChanged: (value) {
                    hangboardFormBloc.add(ResistanceUnitChanged(value));
                  },
                ),
              ),
            ],
          ),
          ListTile(
            key: PageStorageKey<String>('resistanceTilePageStorage'),
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
              child: TextFormField(
                controller: _resistanceController,
                autovalidate: hangboardFormState.autoValidate,
                validator: (_) {
                  return hangboardFormState.validResistance ? null : 'Invalid Resistance';
                },
                onChanged: (value) {
                  hangboardFormBloc.add(ResistanceChanged(double.tryParse(value)));
                },
                decoration: InputDecoration(
                  labelText: 'Resistance (${hangboardFormState.resistanceUnit.abbreviation})',
                ),
                keyboardType: TextInputType.numberWithOptions(),
                onTap: () {
                  Scaffold.of(scaffoldContext).hideCurrentSnackBar();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _resistanceTileVisibilityChanged(value) {
    _resistanceController.clear();
    hangboardFormBloc.add(ShowResistanceChanged(value));
  }

  Widget _saveButton(HangboardFormState hangboardFormState, BuildContext scaffoldContext) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      //todo: make this narrower
      child: RaisedButton(
        key: Key('saveButton'),
        onPressed: () {
          _saveTileFields(scaffoldContext, hangboardFormState);
        },
        child: Text('SAVE EXERCISE'),
      ),
    );
  }

  /// Saving the form exercises the front end validations on each field. These
  /// validations are done against the form fields and will provide UI messages
  /// describing invalid fields.
  ///
  /// If validation passes, the state is sent to the BLoC to be saved to the DB.
  void _saveTileFields(BuildContext scaffoldContext, HangboardFormState hangboardFormState) {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      hangboardFormBloc.add(ValidSave(cruxUser: widget.cruxUser, cruxWorkout: widget.cruxWorkout));
    } else {
      hangboardFormBloc.add(InvalidSave());
    }
  }

  List<Widget> mapFingerConfigurations(Hold hold) {
    if (hold == Hold.POCKET) {
      return FingerConfiguration.values
          .sublist(0, 6)
          .map((FingerConfiguration fingerConfiguration) {
        return DropdownMenuItem<FingerConfiguration>(
          child: Text(
            fingerConfiguration.name,
          ),
          value: fingerConfiguration,
        );
      }).toList();
    } else if (hold == Hold.OPEN_HAND) {
      return FingerConfiguration.values.sublist(4).map((FingerConfiguration fingerConfiguration) {
        return DropdownMenuItem<FingerConfiguration>(
          child: Text(
            fingerConfiguration.name,
          ),
          value: fingerConfiguration,
        );
      }).toList();
    } else {
      return FingerConfiguration.values.map((FingerConfiguration fingerConfiguration) {
        return DropdownMenuItem<FingerConfiguration>(
          child: Text(
            fingerConfiguration.name,
          ),
          value: fingerConfiguration,
        );
      }).toList();
    }
  }

  Future<void> _exerciseExistsAlert(HangboardFormState hangboardFormState) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exercise already exists'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                    children: [
                      TextSpan(text: 'You already have an exercise created for '),
                      TextSpan(
                        text: '${hangboardFormState.exerciseTitle}.\n\n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: 'Would you like to replace it with this one?'),
                    ],
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              children: <Widget>[
                FlatButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black54),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Replace'),
                  onPressed: () {
//                    exerciseRef.setData(data);
//                    exerciseSavedSnackbar(scaffoldContext);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void exerciseSavedSnackbar(BuildContext scaffoldContext) {
    Scaffold.of(scaffoldContext).showSnackBar(
      SnackBar(
        duration: Duration(days: 1),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Exercise Saved!',
                      style: TextStyle(color: Theme.of(scaffoldContext).accentColor),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FlatButton(
                      child: Row(
                        children: <Widget>[
                          Text('Back'),
                        ],
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    FlatButton(
                      child: Row(
                        children: <Widget>[
                          Text('Continue Editing'),
                        ],
                      ),
                      onPressed: () {
                        Scaffold.of(scaffoldContext).hideCurrentSnackBar();
                      },
                    ),
                    FlatButton(
                      child: Row(
                        children: <Widget>[
                          Text('Reset'),
                        ],
                      ),
                      onPressed: () {
                        formKey.currentState.reset();
                        clearFields();
                        Scaffold.of(scaffoldContext).hideCurrentSnackBar();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void clearFields() {
    //todo: add this for resetting form
//    _exerciseFormBloc.add(HangboardFormCleared());
  }
}
