export 'home_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:safe_button/utils/app_colors.dart';
import 'package:safe_button/widget/app_drawer.dart';
import 'package:safe_button/widget/lang_picker_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:butterfly_sdk_flutter_plugin/butterfly_sdk_flutter_plugin.dart';
import 'package:safe_button/routes/routes.dart';
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _name;
  late SharedPreferences _prefs;
  static const methodChannel = MethodChannel("myChannel");
  TextEditingController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        elevation: 0.0,
        centerTitle: true,
        title: Row(
          children: [
            Expanded(child: Image.asset('assets/images/app_logo.png', fit: BoxFit.scaleDown, height: 60,)),
          ],
        ),
        backgroundColor: AppColors.appMainColor,
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Navigator.pushNamed(context, routes.settings),
          )
        ] ,
      ),
      // endDrawer: AppDrawer(),
      body: Container(
          padding: EdgeInsets.fromLTRB(20, 100, 20, 40),
          child: Column(
            children: [

              const SizedBox(height: 60),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: <Widget>[
              //     Container(child: buildPhoneTextField()),
              //   ],
              // ),
              //SizedBox(height: 90),
              GestureDetector(
                onTap: () {
                  sendSms();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                        child: Align(
                      child: SvgPicture.asset(
                        "assets/images/circle1.svg",
                        height: 297,
                        width: 297,
                        fit: BoxFit.scaleDown,
                      ),
                    )),
                    Positioned(
                        child: Align(
                      // alignment: Alignment.center,
                      child: SvgPicture.asset(
                        "assets/images/circle2.svg",
                        height: 270,
                        width: 270,
                        fit: BoxFit.scaleDown,
                      ),
                    )),
                    Positioned(
                        top: 35,
                        child: Align(
                          // alignment: Alignment.center,
                          child: Image.asset(
                            "assets/images/circle3.png",
                            width: 235,
                            height: 235,
                          ),
                        )),
                    Positioned(
                      child: Opacity(
                        opacity: 0.3,
                        child: SvgPicture.asset("assets/images/help_icon.svg"),
                      ),
                    ),
                  ],
                ),
              ),
              // Container(
              //   width: 400,
              //   height: 400,
              //   child: SvgPicture.asset("assets/images/circle1.svg"),
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     sendSms();
              //   },
              //   child: Text(
              //     "קראי לעזרה",
              //     style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
              //   ),
              //   style: ElevatedButton.styleFrom(
              //     shape: CircleBorder(),
              //     padding: EdgeInsets.all(80),
              //     primary: Color.fromRGBO(187, 134, 252, 1), // <-- Button color
              //     onPrimary:
              //         Color.fromRGBO(168, 129, 215, 1), // <-- Splash color
              //   ),
              // )
            ],
          )),
    );
  }

  Future<void> sendSms() async {
    try {
      await methodChannel.invokeMethod("sendSms");
    } on Exception catch (e) {}
  }

  Future<void> storeName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("phoneNumber", name);
  }

  Flexible buildPhoneTextField() {
    return Flexible(
      child: TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromRGBO(1, 160, 198, 1), width: 2)),
            hintText: AppLocalizations.of(context)!.phoneNumberTxt,
            border: const OutlineInputBorder(),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 2,
              minHeight: 2,
            ),
            suffixIcon: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 20,
                    child: SvgPicture.asset("assets/images/phone.svg"),
                  ),
                ),
                onTap: () {})),
        // decoration: const InputDecoration(
        //     contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        //     enabledBorder: OutlineInputBorder(
        //         borderSide:
        //             BorderSide(color: Color.fromRGBO(1, 160, 198, 1), width: 2)
        //     ),
        //     hintText: "הכניסי את מספר הטלפון שלך",
        //     border: OutlineInputBorder()
        //
        //
        // ),
        onChanged: (String str) {
          setState(() {
            _name = str;
            storeName(str);
          });
        },
        controller: _controller,
      ),
    );
  }
}
