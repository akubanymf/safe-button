import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageView extends StatefulWidget {
  static const String routeName = '/message';

  const MessageView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  bool locationToggle =  true;
  static SharedPreferences? _pref;

  @override
  void initState() {
    super.initState();
    _populateMessage();
    _setLocationButton();
  }
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(10, 124, 164, 1),
        leading: GestureDetector(
          onTap: () async {
            await _saveMessageAndLocationSettings();
            Navigator.of(context).pop();
          },
          child: const Align(
            alignment: Alignment
                .center, // Align however you like (i.e .centerRight, centerLeft)
            child: Text(
              "שמירה",
              style: TextStyle(color: Color.fromRGBO(5, 215, 239, 1)),
            ),
          ),
        ),
        title: const Text(
          'ערכי הודעת סמס',
          style: TextStyle(fontSize: 13),
        ),
        centerTitle: true,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: SvgPicture.asset(
                  "assets/images/go_back.svg",
                  fit: BoxFit.scaleDown,
                ),
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 50.0),
              child: TextField(
                controller: _controller,
                textAlign: TextAlign.right,
                minLines: 6,
                maxLines: 6,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    // suffixIcon: IconButton(
                    //     onPressed: _controller.clear,
                    //   icon: const Icon(Icons.message),
                    // ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "הקלידי הודעה כאן",
                    fillColor: Colors.white),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Flexible(
                      fit: FlexFit.loose,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'שליחת מיקום',
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: locationToggle
                    ? SvgPicture.asset(
                      "assets/images/send-location.svg",
                      fit: BoxFit.fitHeight,
                    ) : const Icon(Icons.location_on),
                    onPressed: () {
                      setState(() {
                        locationToggle = !locationToggle;
                      });
                    },
                  ),
                ],
              ),
            ),
            const Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "ההודעה תישמר עד לעריכת הודעה חדשה",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }




  Future<void> _populateMessage() async {
    _pref ??= await SharedPreferences.getInstance();
    final String? message = _pref!.getString('selected_message');
    if (message != null) {
      _controller.text = message;
    }
  }

  Future<void> _setLocationButton() async {
    _pref ??= await SharedPreferences.getInstance();
    final String? location = _pref!.getString('use_location');
    if (location != null) {
      setState(() {
        locationToggle = location == 'true' ? true : false;
      });
    }
  }

  _saveMessageAndLocationSettings() async {
    _pref ??= await SharedPreferences.getInstance();
    await _pref!.setString('selected_message', _controller.text);
    await _pref!.setString('use_location', locationToggle.toString());
  }
}
