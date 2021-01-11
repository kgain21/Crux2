import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:crux/frontend/screen/form/hangboard/bloc/hangboard_form_bloc.dart';
import 'package:crux/frontend/screen/form/hangboard/bloc/hangboard_form_event.dart';
import 'package:crux/frontend/screen/form/hangboard/bloc/hangboard_form_state.dart';
import 'package:crux/model/finger_configuration.dart';
import 'package:crux/model/hang_protocol.dart';
import 'package:crux/model/hold.dart';
import 'package:crux/model/unit.dart';
import 'package:crux/util/null_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  final TextEditingController _repDurationController = TextEditingController();
  final TextEditingController _restDurationController = TextEditingController();
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
  void dispose() {
    _depthController.dispose();
    _repDurationController.dispose();
    _restDurationController.dispose();
    _hangsPerSetController.dispose();
    _timeBetweenSetsController.dispose();
    _numberOfSetsController.dispose();
    _resistanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('hangboardFormScaffold'),
      appBar: AppBar(
        title: Text(
          'Create a new exercise',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            tooltip: 'Help',
            onPressed: () {},
          ),
        ],
      ),
      body: BlocProvider<HangboardFormBloc>(
        create: (_) => hangboardFormBloc,
        child: BlocListener<HangboardFormBloc, HangboardFormState>(
          listener: _listenForHangboardFormState,
          child: BlocBuilder<HangboardFormBloc, HangboardFormState>(
            cubit: hangboardFormBloc,
            builder: (context, state) {
              return Builder(
                builder: (scaffoldContext) => Form(
                  key: formKey,
                  child: ListView(
                    children: <Widget>[
                      _handsRadioTile(state, scaffoldContext),
                      _holdDropdownTile(state, scaffoldContext),
                      _fingerConfigurationDropdownTile(state, scaffoldContext),
                      _depthTile(state, scaffoldContext),
                      _hangProtocolDropdownTile(state, scaffoldContext),
                      _repDurationTile(state, scaffoldContext),
                      _restDurationTile(state, scaffoldContext),
                      _breakDurationTile(state, scaffoldContext),
                      _hangsPerSetTile(state, scaffoldContext),
                      _numberOfSetsTile(state, scaffoldContext),
                      _resistanceTile(state, scaffoldContext),
                      _saveButton(state, scaffoldContext)
                    ].where(NullUtil.notNull).toList(),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _listenForHangboardFormState(context, state) {
    if (state.isSuccess) {
      _exerciseSavedSnackbar(context);
      hangboardFormBloc.add(ResetFlags());
    } else if (state.isDuplicate) {
      _exerciseExistsAlert(state);
      hangboardFormBloc.add(ResetFlags());
    } else if (state.isFailure) {
      _exerciseSaveErrorSnackbar(context);
      hangboardFormBloc.add(ResetFlags());
    }
  }

  Widget _handsRadioTile(HangboardFormState hangboardFormState, BuildContext scaffoldContext) {
    return Card(
      key: Key('handsRadioTile'),
      child: ListTile(
        leading: Icon(
          FontAwesomeIcons.signLanguage,
        ),
        key: PageStorageKey('handsRadioTilePageStorage'),
        title: Row(
          children: <Widget>[
            Flexible(
              child: RadioListTile(
                title: Text(
                  'One hand',
                ),
                value: 1,
                groupValue: hangboardFormState.hands,
                onChanged: (value) {
                  ScaffoldMessenger.of(scaffoldContext).hideCurrentSnackBar();
                  hangboardFormBloc.add(HandsChanged(value));
                },
              ),
            ),
            Flexible(
              child: RadioListTile(
                title: Text(
                  'Two hands',
                ),
                value: 2,
                groupValue: hangboardFormState.hands,
                onChanged: (value) {
                  ScaffoldMessenger.of(scaffoldContext).hideCurrentSnackBar();
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
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
          child: DropdownButtonFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            value: hangboardFormState.hold,
            onChanged: (value) {
              ScaffoldMessenger.of(scaffoldContext).hideCurrentSnackBar();
              hangboardFormBloc.add(HoldChanged(value));
            },
            hint: Text(
              'Choose a hold',
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
            items: Hold.values.map((Hold hold) {
              return DropdownMenuItem<Hold>(
                child: Text(
                  hold.name,
                ),
                value: hold,
              );
            }).toList(),
            validator: (_) {
              return hangboardFormState.hold != null ? null : 'Please select a hold.';
            },
          ),
        ),
      ),
    );
  }

  Widget _fingerConfigurationDropdownTile(
      HangboardFormState hangboardFormState, BuildContext scaffoldContext) {
    if (!hangboardFormState.showFingerConfiguration) {
      return null;
    } else {
      return Card(
        key: Key('fingerConfigurationDropdownTile'),
        child: ListTile(
          leading: Icon(
            FontAwesomeIcons.solidHandPaper,
          ),
          title: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: DropdownButtonFormField(
              autovalidateMode: hangboardFormState.autoValidate
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              value: hangboardFormState.fingerConfiguration,
              onChanged: (value) {
                ScaffoldMessenger.of(scaffoldContext).hideCurrentSnackBar();
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
              hint: Text(
                'Choose a finger configuration',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              validator: (_) {
                return hangboardFormState.fingerConfiguration != null
                    ? null
                    : 'Please select a finger configuration.';
              },
            ),
          ),
        ),
      );
    }
  }

  Widget _depthTile(HangboardFormState hangboardFormState, BuildContext scaffoldContext) {
    if (hangboardFormState.depth == null) {
      _depthController.clear();
    }
    if (!hangboardFormState.showDepth) {
      return null;
    }
    return Card(
      key: Key('depthTile'),
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(FontAwesomeIcons.ruler),
          ],
        ),
        title: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
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
                Flexible(
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
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: TextFormField(
            controller: _depthController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (_) {
              return hangboardFormState.validDepth ? null : 'Invalid depth';
            },
            onChanged: (value) {
              hangboardFormBloc.add(DepthChanged(double.tryParse(value)));
            },
            decoration: InputDecoration(
              labelText: 'Depth (${hangboardFormState.depthUnit.abbreviation})',
            ),
            keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
            onTap: () {
              ScaffoldMessenger.of(scaffoldContext).hideCurrentSnackBar();
            },
          ),
        ),
      ),
    );
  }

  Widget _hangProtocolDropdownTile(
      HangboardFormState hangboardFormState, BuildContext scaffoldContext) {
    return Card(
      key: Key('hangProtocolDropdownTile'),
      child: ListTile(
        leading: Icon(
          FontAwesomeIcons.solidEdit,
        ),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
          child: DropdownButtonFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            hint: Text(
              'Choose hang protocol',
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
            value: hangboardFormState.hangProtocol,
            onChanged: (value) {
              ScaffoldMessenger.of(scaffoldContext).hideCurrentSnackBar();
              hangboardFormBloc.add(HangProtocolChanged(value));
            },
            items: HangProtocol.values.map((hangProtocol) {
              return DropdownMenuItem(
                child: Text(
                  hangProtocol.name,
                ),
                value: hangProtocol,
              );
            }).toList(),
            validator: (_) {
              return hangboardFormState.hangProtocol != null
                  ? null
                  : 'Please select a hang protocol.';
            },
          ),
        ),
      ),
    );
  }

  Widget _repDurationTile(HangboardFormState hangboardFormState, BuildContext scaffoldContext) {
    return Card(
      key: Key('repDurationTile'),
      child: ListTile(
        leading: Icon(FontAwesomeIcons.hourglassStart),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: TextFormField(
            controller: _repDurationController,
            autovalidateMode: hangboardFormState.autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            validator: (_) {
              return hangboardFormState.validRepDuration ? null : 'Invalid rep duration';
            },
            onChanged: (value) {
              hangboardFormBloc.add(RepDurationChanged(int.tryParse(value)));
            },
            decoration: InputDecoration(
              labelText: 'Rep duration (sec)',
            ),
            keyboardType: TextInputType.numberWithOptions(),
            onTap: () {
              ScaffoldMessenger.of(scaffoldContext).hideCurrentSnackBar();
            },
          ),
        ),
      ),
    );
  }

  Widget _restDurationTile(HangboardFormState hangboardFormState, BuildContext scaffoldContext) {
    return Card(
      key: Key('restDurationTile'),
      child: ListTile(
        leading: Icon(FontAwesomeIcons.hourglassEnd),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: hangboardFormState.showRestDuration
              ? TextFormField(
                  controller: _restDurationController,
                  autovalidateMode: hangboardFormState.autoValidate
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
                  validator: (_) {
                    return hangboardFormState.validRestDuration ? null : 'Invalid rest duration';
                  },
                  onChanged: (value) {
                    hangboardFormBloc.add(RestDurationChanged(int.tryParse(value)));
                  },
                  decoration: InputDecoration(
                    labelText: 'Rest duration (sec)',
                  ),
                  keyboardType: TextInputType.numberWithOptions(),
                  onTap: () {
                    ScaffoldMessenger.of(scaffoldContext).hideCurrentSnackBar();
                  },
                )
              : Row(
                  //todo: tie this to hang protocol? make toggle look more like resistance?
                  children: <Widget>[],
                ),
        ),
        trailing: Switch(
          value: hangboardFormState.showRestDuration,
          onChanged: (value) {
            hangboardFormBloc.add(ShowRestDurationChanged(value));
          },
        ),
      ),
    );
  }

  Widget _breakDurationTile(HangboardFormState hangboardFormState, BuildContext scaffoldContext) {
    return Card(
      key: Key('breakDurationTile'),
      child: ListTile(
        leading: Icon(FontAwesomeIcons.stopwatch),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: TextFormField(
            controller: _timeBetweenSetsController,
            autovalidateMode: hangboardFormState.autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            validator: (_) {
              return hangboardFormState.validBreakDuration ? null : 'Invalid time between sets';
            },
            onChanged: (value) {
              hangboardFormBloc.add(BreakDurationChanged(int.tryParse(value)));
            },
            decoration: InputDecoration(
              labelText: 'Time between sets (sec)',
            ),
            keyboardType: TextInputType.numberWithOptions(),
            onTap: () {
              ScaffoldMessenger.of(scaffoldContext).hideCurrentSnackBar();
            },
          ),
        ),
      ),
    );
  }

  Widget _hangsPerSetTile(HangboardFormState hangboardFormState, BuildContext scaffoldContext) {
    return Card(
      key: Key('hangsPerSetTile'),
      child: ListTile(
        leading: Icon(FontAwesomeIcons.ellipsisH),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: TextFormField(
            controller: _hangsPerSetController,
            autovalidateMode: hangboardFormState.autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            validator: (_) {
              return hangboardFormState.validHangsPerSet ? null : 'Invalid hangs per set';
            },
            onChanged: (value) {
              hangboardFormBloc.add(HangsPerSetChanged(int.tryParse(value)));
            },
            decoration: InputDecoration(
              labelText: 'Hangs per set',
            ),
            keyboardType: TextInputType.numberWithOptions(),
            onTap: () {
              ScaffoldMessenger.of(scaffoldContext).hideCurrentSnackBar();
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
        leading: Icon(FontAwesomeIcons.ellipsisV),
        key: PageStorageKey('numberOfSetsTilePageStorage'),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: TextFormField(
//todo: https://api.flutter.dev/flutter/material/TextFormField-class.html
            //todo: ^ has example of autovalidation/autofocus on next element when user hits enter
            controller: _numberOfSetsController,
            autovalidateMode: hangboardFormState.autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            validator: (_) {
              return hangboardFormState.validNumberOfSets ? null : 'Invalid Number of Sets';
            },
            onChanged: (value) {
              hangboardFormBloc.add(NumberOfSetsChanged(int.tryParse(value)));
            },
            decoration: InputDecoration(
              labelText: 'Number of sets',
            ),
            keyboardType: TextInputType.numberWithOptions(),
            onTap: () {
              ScaffoldMessenger.of(scaffoldContext).hideCurrentSnackBar();
            },
          ),
        ),
      ),
    );
  }

  Widget _resistanceTile(HangboardFormState hangboardFormState, BuildContext scaffoldContext) {
    return Card(
      key: Key('resistanceTile'),
      child: ExpansionTile(
        leading: Icon(
          FontAwesomeIcons.weightHanging,
          color: Colors.black38,
        ),
        onExpansionChanged: _resistanceTileVisibilityChanged,
        key: ValueKey(hangboardFormState.showResistance),
        initiallyExpanded: hangboardFormState.showResistance,
        trailing: Switch(
          value: hangboardFormState.showResistance,
          onChanged: _resistanceTileVisibilityChanged,
        ),
        title: Text(
          'Resistance',
          style: TextStyle(
            color: Colors.black54,
          ),
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
                autovalidateMode: hangboardFormState.autoValidate
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
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
                  ScaffoldMessenger.of(scaffoldContext).hideCurrentSnackBar();
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
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(
              maxHeight: 45.0,
              minWidth: 275.0,
            ),
            child: RaisedButton(
              elevation: 4.0,
              color: Theme.of(context).accentColor,
              key: Key('saveButton'),
              onPressed: () {
                _saveTileFields(scaffoldContext, hangboardFormState);
              },
              child: Text(
                'SAVE EXERCISE',
                style: Theme.of(context).textTheme.button,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        ],
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

  void _exerciseSavedSnackbar(BuildContext scaffoldContext) {
    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
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
                      'Exercise saved!',
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
                        onPressed: () {
                          ScaffoldMessenger.of(scaffoldContext).hideCurrentSnackBar();
                          Navigator.of(context).pop();
                        }),
                    FlatButton(
                      child: Row(
                        children: <Widget>[
                          Text('Continue editing'),
                        ],
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(scaffoldContext).hideCurrentSnackBar();
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
                        ScaffoldMessenger.of(scaffoldContext).hideCurrentSnackBar();
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

  void _exerciseSaveErrorSnackbar(BuildContext scaffoldContext) {
    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
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
                      'Exercise failed to save. Please try again.',
                      style: TextStyle(color: Theme.of(scaffoldContext).errorColor),
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
                        onPressed: () {
                          ScaffoldMessenger.of(scaffoldContext).hideCurrentSnackBar();
                          Navigator.of(context).pop();
                        }),
                    FlatButton(
                      child: Row(
                        children: <Widget>[
                          Text('Continue editing'),
                        ],
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(scaffoldContext).hideCurrentSnackBar();
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
                        ScaffoldMessenger.of(scaffoldContext).hideCurrentSnackBar();
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
