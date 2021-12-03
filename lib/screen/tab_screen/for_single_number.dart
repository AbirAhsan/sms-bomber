import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smsbomber/service/form_validation.dart';
import 'package:smsbomber/widget/custom_textfield.dart';
import 'package:telephony/telephony.dart';

class ForSingleNumber extends StatefulWidget {
  const ForSingleNumber({Key? key}) : super(key: key);

  @override
  State<ForSingleNumber> createState() => _ForSingleNumberState();
}

class _ForSingleNumberState extends State<ForSingleNumber> {
  final TextEditingController _phoneNumberCtrl = TextEditingController();
  final TextEditingController _smsCtrl = TextEditingController();
  final TextEditingController _smsCountCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FlutterContactPicker _contactPicker = FlutterContactPicker();
  final Telephony telephony = Telephony.instance;
  bool _isStopMessage = true;

  int _currentIndexNumber = 0;

  Contact? _contact;

  bool permissionsGranted = false;
  @override
  void initState() {
    _checkPermission();
    super.initState();
  }

  Future<void> _checkPermission() async {
    // final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
    // final isGpsOn = serviceStatus == ServiceStatus.enabled;
    // if (!isGpsOn) {
    //   print('Turn on location services before requesting permission.');
    //   return;
    // }

    final sStatus = await Permission.sms.request();
    final cStatus = await Permission.contacts.request();
    if (sStatus == PermissionStatus.granted &&
        cStatus == PermissionStatus.granted) {
      print('Permission granted');
    } else if (sStatus == PermissionStatus.denied ||
        cStatus == PermissionStatus.denied) {
      print(
          'Permission denied. Show a dialog and again ask for the permission');
      _checkPermission();
    } else if (sStatus == PermissionStatus.permanentlyDenied ||
        cStatus == PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
      await openAppSettings();
    }
  }

  _selectContact() async {
    _contact = await _contactPicker.selectContact();
    _phoneNumberCtrl.text = _contact!.phoneNumbers!.first;
    print(_contact!.phoneNumbers);
  }

  _sendSmS() async {
    setState(() {
      _isStopMessage = false;
    });
    for (var i = _currentIndexNumber; i < 100000; i++) {
      if (_isStopMessage) {
        break;
      }
      await Future.delayed(const Duration(seconds: 1), () {
        print("Hello Now it's count $i ");
        _currentIndexNumber = i + 1;
      });
    }
    setState(() {
      _isStopMessage = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Form(
          key: _formKey,
          child: SizedBox(
            child: Column(
              children: [
                CustomTextField(
                  maxLines: 1,
                  controller: _phoneNumberCtrl,
                  labelText: "Recipient Number",
                  keyboardType: TextInputType.phone,
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  // ],
                  validator: (value) {
                    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                    RegExp regExp = RegExp(patttern);
                    if (value!.isEmpty) {
                      return 'Please enter mobile number';
                    } else if (!regExp.hasMatch(value)) {
                      return 'Please enter valid mobile number';
                    }
                    return null;
                  },
                  prefixIcon: const Icon(Icons.phone_iphone),
                  suffixIcon: InkWell(
                    onTap: () {
                      _selectContact();
                    },
                    child: const Icon(
                      Icons.contact_page_outlined,
                      color: Colors.green,
                    ),
                  ),
                ),
                CustomTextField(
                  minLines: 4,
                  maxLines: null,
                  controller: _smsCtrl,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Type Your Message here';
                    } else if (value.length < 10) {
                      return "Message is too short";
                    }
                    return null;
                  },
                  labelText: "Your Message",
                  // prefixIcon: const Icon(Icons.phone_iphone),
                  // suffixIcon: InkWell(
                  //   onTap: () {},
                  //   child: const Icon(
                  //     Icons.contact_page_outlined,
                  //   ),
                  // ),
                ),
                CustomTextField(
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  controller: _smsCountCtrl,
                  labelText: "Number of Messages",
                  validator: (value) {
                    if (value == null) {
                      return null;
                    }
                    final n = num.tryParse(value);
                    if (n == null || n < 1) {
                      return '"$value" is not a valid number';
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Visibility(
                  visible: _isStopMessage,
                  child: ElevatedButton(
                      onPressed: () {
                        if (validateAndSave(_formKey)) {
                          print("object");
                          _checkPermission().then((value) => _sendSmS());
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20),
                        child: Text(
                          "Fire🔥",
                          style: TextStyle(fontSize: 20),
                        ),
                      )),
                ),
                Visibility(
                  visible: !_isStopMessage,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isStopMessage = true;
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20),
                        child: Text(
                          "Relax",
                          style: TextStyle(fontSize: 20),
                        ),
                      )),
                ),
                // Text('contact!.phoneNumber)
                // ListView.builder(
                //     itemCount: contacts.length,
                //     itemBuilder: (buildContext, index) {
                //       Contact contact = contacts[index];
                //       return Text(contact.phones!.first);
                //     })
              ],
            ),
          ),
        ));
  }
}
