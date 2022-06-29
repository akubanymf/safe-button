import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:safe_button/pages/contact_us/contact_us.dart';
import 'package:safe_button/pages/contacts/contacts_view.dart';
import 'package:safe_button/pages/location/location_view.dart';
import 'package:safe_button/pages/message/message_view.dart';
import 'package:safe_button/pages/settings/home.dart';
import 'package:safe_button/provider/locale_provider.dart';
import 'package:safe_button/widget/lang_picker_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'l10n/l10n.dart';
import 'package:provider/provider.dart';

import 'pages/settings/settings_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => LocaleProvider(const Locale('he')),
        builder: (context, child) {
          final provider = Provider.of<LocaleProvider>(context);

          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
                scaffoldBackgroundColor: const Color.fromRGBO(42, 35, 60, 1)),
            home: HomePage(),
            locale: provider.locale,
            supportedLocales: L10n.all,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routes: {
              '/selectContacts': (context) => const ContactsView(),
              '/message': (context) => const MessageView(),
              '/locationSetup': (context) => const LocationView(),
              '/settings': (context) => const SettingsView(),
              '/contactUs': (context) => const ContactUsView(),
            },
          );
        },
      );
}

//TODO - remove this class
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel("com.example/SafeButtonChannel");
  static const methodChannel = MethodChannel("myChannel");
  TextEditingController? _controller;
  late String _name;
  late SharedPreferences _prefs;

  Future<void> getSharedPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.getString("phoneNumber") != null) {
      _name = _prefs.getString("phoneNumber")!;
      _controller =
          TextEditingController(text: _prefs.getString("phoneNumber"));
    } else {
      _controller = TextEditingController(text: "");
      _name = "";
    }

    setState(() {
      _controller = new TextEditingController(text: _name);
    });
  }

// set value
  @override
  void initState() {
    super.initState();
    getSharedPrefs();
    platform.setMethodCallHandler(nativeMethodCallHandler);
  }

  Future<dynamic> nativeMethodCallHandler(MethodCall methodCall) async {
    print('Native call!');
    switch (methodCall.method) {
      case "messageSent":
        return "This data from flutter.....";
        break;
      default:
        return "0509009714";
        break;
    }
  }

  Future<void> storeName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("phoneNumber", name);
  }

  Future<void> sendSms() async {
    try {
      await methodChannel.invokeMethod("sendSms");
    } on Exception catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        elevation: 0.0,
        backgroundColor: const Color.fromRGBO(42, 35, 60, 1),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
            },
          ),
        ],
      ),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: [
      //       ListTile(
      //         title: const Text('הגדרות')
      //       )
      //     ],
      //   ),
      // ),
      body: Container(
          padding: EdgeInsets.fromLTRB(20, 100, 20, 40),
          child: Column(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Image.asset('assets/images/app_logo.png')],
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(child: buildPhoneTextField()),
                ],
              ),
              SizedBox(height: 90),
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
            hintText: "SMS הכניסי מספר טלפון שיקבל",
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

class OpenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()..color = Color(0xffaa44aa);

    canvas.drawCircle(Offset(200, 200), 100, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
