import 'package:crux/backend/bloc/hangboard/form/hangboard_form_bloc.dart';
import 'package:crux/backend/bloc/hangboard/form/hangboard_form_event.dart';
import 'package:crux/backend/bloc/hangboard/form/hangboard_form_state.dart';
import 'package:crux/frontend/util_widget/unit_selector.dart';
import 'package:crux/model/finger_configuration.dart';
import 'package:crux/model/hold_enum.dart';
import 'package:crux/util/string_format_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HangboardFormScreen extends StatefulWidget {
  static const routeName = '/hangboardForm';

  final String workoutTitle;

//  final FirestoreHangboardWorkoutsRepository
//  firestoreHangboardWorkoutsRepository;

  HangboardFormScreen({/*this.firestoreHangboardWorkoutsRepository, */ this.workoutTitle});

  @override
  State createState() => new _HangboardFormScreenState();
}

class _HangboardFormScreenState extends State<HangboardFormScreen> {
  final GlobalKey<FormState> formKey = GlobalKey(debugLabel: 'HangboardFormScreen');

  final TextEditingController _depthController = TextEditingController();
  final TextEditingController _timeOnController = TextEditingController();
  final TextEditingController _timeOffController = TextEditingController();
  final TextEditingController _hangsPerSetController = TextEditingController();
  final TextEditingController _timeBetweenSetsController = TextEditingController();
  final TextEditingController _numberOfSetsController = TextEditingController();
  final TextEditingController _resistanceController = TextEditingController();

  int _numberOfHandsSelected;
  String _depthMeasurementSystem;
  String _resistanceMeasurementSystem;
  Hold _hold;
  FingerConfiguration _fingerConfiguration;

  HangboardFormBloc _hangboardFormBloc;

  @override
  void initState() {
    super.initState();
    _hangboardFormBloc = /* BlocProvider.of<HangboardFormBloc>(context);*/
        HangboardFormBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
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
        bloc: _hangboardFormBloc,
        listener: (BuildContext context, HangboardFormState hangboardFormState) {
          if (hangboardFormState.isSuccess) {
            exerciseSavedSnackbar(context);
            _hangboardFormBloc.add(ResetFlags());
//            BlocProvider.of<HangboardParentBloc>(context).add(HangboardParentUpdated());
          } else if (hangboardFormState.isDuplicate) {
            _exerciseExistsAlert(hangboardFormState);
            _hangboardFormBloc.add(ResetFlags());
          }
          if (hangboardFormState is InvalidSave) {
//            exerciseNotSavedSnackbar(context);
          }
        },
        child: BlocBuilder(
          bloc: _hangboardFormBloc,
          builder: (context, hangboardFormState) {
            return Builder(
              builder: (scaffoldContext) => Form(
                key: formKey,
                /*https://medium.com/saugo360/https-medium-com-saugo360-flutter-using-overlay-to-display-floating-widgets-2e6d0e8decb9
                TODO: See if I can get the keyboard to jump to the text form field in focus (nice to have)
                https://stackoverflow.com/questions/46841637/show-a-text-field-dialog-without-being-covered-by-keyboard/46849239#46849239
                TODO: ^ this was the original solution to the keyboard covering text fields, might want to refer to it in the future
                 */
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
                    _timeOnTile(hangboardFormState, scaffoldContext),
                    // hangProtocolTile(),
                    _hangsPerSetTile(hangboardFormState, scaffoldContext),
                    _timeBetweenSetsTile(hangboardFormState, scaffoldContext),
                    _numberOfSetsTile(hangboardFormState, scaffoldContext),
                    _resistanceTile(hangboardFormState, scaffoldContext),
                    _saveButton(hangboardFormState, scaffoldContext)
                  ].where(notNull).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Nice way to conditionally add widgets to a list that I found.
  /// Makes use of [where] and this function to make an [Iterable] which is then
  /// turned back into a list without the null entries.
  bool notNull(Object o) => o != null;

  Widget _handsRadioTile(HangboardFormState hangboardFormState, BuildContext scaffoldContext) {
    return new Card(
      child: ListTile(
        key: PageStorageKey('handsTile'),
        title: Row(
          children: <Widget>[
            Flexible(
              child: RadioListTile(
                title: Text('One hand'),
                value: 1,
                groupValue: hangboardFormState.hands,
                onChanged: (value) {
                  Scaffold.of(scaffoldContext).hideCurrentSnackBar();
                  _hangboardFormBloc.add(HandsChanged(value));
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
                  _hangboardFormBloc.add(HandsChanged(value));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _holdDropdownTile(HangboardFormState hangboardFormState, BuildContext scaffoldContext) {
    return new Card(
      child: new ListTile(
        leading: Icon(
          Icons.pan_tool,
        ),
        title: DropdownButtonHideUnderline(
          child: new DropdownButton<Hold>(
            elevation: 10,
            hint: Text(
              'Choose a hold',
            ),
            value: hangboardFormState.hold,
            onChanged: (value) {
              Scaffold.of(scaffoldContext).hideCurrentSnackBar();
              _hangboardFormBloc.add(HoldChanged(value));
            },
            items: Hold.values.map((Hold hold) {
              return new DropdownMenuItem<Hold>(
                child: new Text(
                  StringFormatUtil.formatHold(hold),
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
      return new Card(
        child: new ListTile(
          leading: Icon(
            //TODO: find better icons on fontAwesome?
            Icons.pan_tool,
          ),
          title: DropdownButtonHideUnderline(
            child: new DropdownButton<FingerConfiguration>(
              elevation: 10,
              hint: Text(
                'Choose a finger configuration',
              ),
              value: hangboardFormState.fingerConfiguration,
              onChanged: (value) {
                Scaffold.of(scaffoldContext).hideCurrentSnackBar();
                _hangboardFormBloc.add(FingerConfigurationChanged(value));
              },
              items: hangboardFormState.availableFingerConfigurations.map((fingerConfiguration) {
                return DropdownMenuItem(
                  child: new Text(
                    StringFormatUtil.formatFingerConfiguration(fingerConfiguration),
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
    return new Card(
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: new TextFormField(
            controller: _depthController,
            autovalidate: hangboardFormState.autoValidate,
            validator: (_) {
              return hangboardFormState.validDepth ? null : 'Invalid Depth';
            },
            onChanged: (value) {
              _hangboardFormBloc.add(DepthChanged(double.parse(value)));
            },
            decoration: InputDecoration(
              icon: Icon(Icons.keyboard_tab),
              labelText: 'Depth (${hangboardFormState.depthUnit})',
            ),
            keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
            onTap: () {
              Scaffold.of(scaffoldContext).hideCurrentSnackBar();
            },
          ),
        ),
      ),
    );
  }

  Widget _timeOnTile(HangboardFormState hangboardFormState, BuildContext scaffoldContext) {
    return Card(
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
                    return hangboardFormState.validTimeOn ? null : 'Invalid Time On';
                  },
                  onChanged: (value) {
                    _hangboardFormBloc.add(TimeOnChanged(int.tryParse(value)));
                  },
                  decoration: InputDecoration(
                    labelText: 'Time On (sec)',
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
                    return hangboardFormState.validTimeOff ? null : 'Invalid Time Off';
                  },
                  onChanged: (value) {
                    _hangboardFormBloc.add(TimeOffChanged(int.tryParse(value)));
                  },
                  decoration: InputDecoration(
                    labelText: 'Time Off (sec)',
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
//      child: new CheckboxListTile(
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
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: new TextFormField(
            controller: _hangsPerSetController,
            autovalidate: hangboardFormState.autoValidate,
            validator: (_) {
              return hangboardFormState.validHangsPerSet ? null : 'Invalid Hangs Per Set';
            },
            onChanged: (value) {
              _hangboardFormBloc.add(HangsPerSetChanged(int.tryParse(value)));
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

  Widget _timeBetweenSetsTile(HangboardFormState hangboardFormState, BuildContext scaffoldContext) {
    return Card(
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: new TextFormField(
            controller: _timeBetweenSetsController,
            autovalidate: hangboardFormState.autoValidate,
            validator: (_) {
              return hangboardFormState.validTimeBetweenSets ? null : 'Invalid Time Between Sets';
            },
            onChanged: (value) {
              _hangboardFormBloc.add(TimeBetweenSetsChanged(int.tryParse(value)));
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
      child: ListTile(
        key: PageStorageKey<String>('numberOfSetsTile'),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: new TextFormField(
            controller: _numberOfSetsController,
            autovalidate: hangboardFormState.autoValidate,
            validator: (_) {
              return hangboardFormState.validNumberOfSets ? null : 'Invalid Number of Sets';
            },
            onChanged: (value) {
              _hangboardFormBloc.add(NumberOfSetsChanged(int.tryParse(value)));
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
      child: ListTile(
        key: PageStorageKey<String>('resistanceTile'),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: new TextFormField(
            controller: _resistanceController,
            autovalidate: hangboardFormState.autoValidate,
            validator: (_) {
              return hangboardFormState.validResistance ? null : 'Invalid Resistance';
            },
            onChanged: (value) {
              _hangboardFormBloc.add(ResistanceChanged(double.tryParse(value)));
            },
            decoration: InputDecoration(
              icon: Icon(Icons.fitness_center),
              labelText: 'Resistance (${hangboardFormState.resistanceUnit})',
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

  Widget _saveButton(HangboardFormState hangboardFormState, BuildContext scaffoldContext) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        onPressed: () {
          _saveTileFields(scaffoldContext, hangboardFormState);
        },
        child: Text('Save Exercise'),
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
      _hangboardFormBloc.add(ValidSave(
        hangboardFormState.resistanceUnit,
        hangboardFormState.depthUnit,
        hangboardFormState.hands,
        hangboardFormState.hold,
        hangboardFormState.fingerConfiguration,
        _depthController.text,
        _timeOffController.text,
        _timeOnController.text,
        _timeBetweenSetsController.text,
        _hangsPerSetController.text,
        _numberOfSetsController.text,
        _resistanceController.text,
      ));
    } else {
      _hangboardFormBloc.add(InvalidSave());
    }
  }

  List<Widget> mapFingerConfigurations(Hold hold) {
    if (hold == Hold.POCKET) {
      return FingerConfiguration.values
          .sublist(0, 6)
          .map((FingerConfiguration fingerConfiguration) {
        return new DropdownMenuItem<FingerConfiguration>(
          child: new Text(
            StringFormatUtil.formatFingerConfiguration(fingerConfiguration),
          ),
          value: fingerConfiguration,
        );
      }).toList();
    } else if (hold == Hold.OPEN_HAND) {
      return FingerConfiguration.values.sublist(4).map((FingerConfiguration fingerConfiguration) {
        return new DropdownMenuItem<FingerConfiguration>(
          child: new Text(
            StringFormatUtil.formatFingerConfiguration(fingerConfiguration),
          ),
          value: fingerConfiguration,
        );
      }).toList();
    } else {
      return FingerConfiguration.values.map((FingerConfiguration fingerConfiguration) {
        return new DropdownMenuItem<FingerConfiguration>(
          child: new Text(
            StringFormatUtil.formatFingerConfiguration(fingerConfiguration),
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

//TODO: Figure out how to use date w/ firestore -- crashes app with this shit:
//todo: java.lang.IllegalArgumentException: Unsupported value: Timestamp(seconds=1549021849, nanoseconds=676000000)
/*data.putIfAbsent("created_date", () {
      return DateTime.now();
    });*/
}
