import 'package:flutter/material.dart';
import 'package:smsbomber/widget/custom_textfield.dart';

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
                  prefixIcon: const Icon(Icons.phone_iphone),
                  suffixIcon: InkWell(
                    onTap: () {},
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
                  controller: _smsCountCtrl,
                  labelText: "Number of Messages",
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () {},
                    child: const Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20),
                      child: Text(
                        "Fire🔥",
                        style: TextStyle(fontSize: 20),
                      ),
                    ))
              ],
            ),
          ),
        ));
  }
}
