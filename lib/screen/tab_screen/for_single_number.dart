// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  final TextEditingController _delayTimeCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FlutterContactPicker _contactPicker = FlutterContactPicker();
  final Telephony telephony = Telephony.instance;
  bool _isStopMessage = true;

  int _currentIndexNumber = 0;
  int _delayTime = 1;
  Contact? _contact;

  int _totalSent = 0;
  int _totalRecieved = 0;

  bool permissionsGranted = false;

  @override
  void initState() {
    _checkPermission();

    super.initState();
  }

  dynamic Function(SendStatus)? listener(SendStatus status) {
    if (status == SendStatus.SENT) {
      setState(() {
        _totalSent++;
      });
    } else if (status == SendStatus.DELIVERED) {
      setState(() {
        _totalRecieved++;
      });
    }
    Fluttertoast.showToast(
      msg: status == SendStatus.SENT
          ? "Sent"
          : status == SendStatus.DELIVERED
              ? "Delivered"
              : "Not Sent",
      textColor: status == SendStatus.SENT
          ? Colors.blue
          : status == SendStatus.DELIVERED
              ? Colors.green
              : Colors.red,
    );
  }

  // Increase Delay time
  _increaseDelayTime() {
    setState(() {
      _delayTime++;
    });
  }

  _decreaseDelayTime() {
    if (_delayTime != 1) {
      setState(() {
        _delayTime--;
      });
    }
    return Fluttertoast.showToast(
      msg: "Minimum 1 second required",
      textColor: Colors.red,
    );
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
    _phoneNumberCtrl.text = (_contact!.phoneNumbers!.first).replaceAll(
      RegExp(r"\s+"),
      "",
    );
    print(_contact!.phoneNumbers);
  }

  _sendSmS() async {
    setState(() {
      _isStopMessage = false;
    });
    for (var i = _currentIndexNumber; i < int.parse(_smsCountCtrl.text); i++) {
      if (_isStopMessage) {
        break;
      }
      await Future.delayed(Duration(seconds: _delayTime), () {
        telephony.sendSms(
          to: _phoneNumberCtrl.text,
          message: _smsCtrl.text,
          statusListener: listener,
        );
        print("Message number $i");
        _currentIndexNumber = i + 1;
      });
    }
    setState(() {
      _isStopMessage = true;
      _currentIndexNumber = 0;
    });
    _phoneNumberCtrl.clear();
    _smsCtrl.clear();
    _smsCountCtrl.clear();
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomTextField(
                    maxLines: 1,
                    enabled: _isStopMessage,
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
                    enabled: _isStopMessage,
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
                  const Text(
                    "Minimum Delay time per sms (in second)",
                    style: TextStyle(fontSize: 16),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            _decreaseDelayTime();
                          },
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text(
                          "$_delayTime",
                          style: const TextStyle(fontSize: 30),
                        ),
                        IconButton(
                          onPressed: () {
                            _increaseDelayTime();
                          },
                          icon: const Icon(Icons.add_circle_outline_outlined),
                        ),
                      ],
                    ),
                  ),

                  CustomTextField(
                    maxLines: 1,
                    enabled: _isStopMessage,
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
                            FocusManager.instance.primaryFocus?.unfocus();

                            _checkPermission().then((value) => _sendSmS());
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(left: 20.0, right: 20),
                          child: Text(
                            "Fire 🔥",
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
                            "End Fire ",
                            style: TextStyle(fontSize: 20),
                          ),
                        )),
                  ),
                  // const SizedBox(
                  //   height: 50,
                  // ),
                  // Text(
                  //   "Total SMS \n ${_smsCountCtrl.text}",
                  //   style: const TextStyle(
                  //     fontSize: 22,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(
                  //         "Total Send \n $_totalSent/${_smsCountCtrl.text}",
                  //         style: const TextStyle(
                  //           fontSize: 22,
                  //         ),
                  //         textAlign: TextAlign.center,
                  //       ),
                  //       Text(
                  //         "Total Delivered \n $_totalRecieved/$_totalSent",
                  //         style: const TextStyle(
                  //           fontSize: 22,
                  //         ),
                  //         textAlign: TextAlign.center,
                  //       ),
                  //     ],
                  //   ),
                  // ),
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
          ),
        ));
  }
}
