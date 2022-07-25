import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:butterfly_sdk_flutter_plugin/butterfly_sdk_flutter_plugin.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safe_button/pages/settings/settings_view.dart';
import 'package:safe_button/routes/routes.dart';
import 'package:safe_button/widget/lang_picker_widget.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({
    Key? key,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Align(
        alignment: Alignment.topRight,
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
              bottom: Radius.elliptical(
                  MediaQuery.of(context).size.width, 100.0)),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            child: Drawer(
                backgroundColor: const Color.fromRGBO(10, 124, 164, 1),
                key: _scaffoldKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                    children: <Widget>[
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(onPressed: (){Navigator.of(context).pop();}, icon: SvgPicture.asset(
                                "assets/images/go_back.svg",
                                width: 36,
                                height: 36,
                                fit: BoxFit.scaleDown))
                          ],
                        ),
                      ),
                      // const UserAccountsDrawerHeader(
                      //     accountName: Text('Test'), accountEmail: Text('Test@test.com'),
                      // ),
                      // LanguagePickerWidget(),
                      // IconButton(
                      //   icon: Icon(
                      //     Icons.settings,
                      //     color: Colors.white,
                      //   ),
                      //   onPressed: () {
                      //     _scaffoldKey.currentState?.openDrawer();
                      //   },
                      // ),
                      ListTile(
                          title: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                AppLocalizations.of(context)!.selectContacts,
                                style: const TextStyle(color: Colors.white),
                              )),
                          trailing: SvgPicture.asset(
                              "assets/images/add-contact.svg",
                              width: 36,
                              height: 36,
                              fit: BoxFit.scaleDown),
                          onTap: () {
                            Navigator.pushNamed(context, Routes.contacts);
                          }),
                      ListTile(
                          title: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                AppLocalizations.of(context)!.setupHelpMessage,
                                style: const TextStyle(color: Colors.white),
                              )),
                          trailing: SvgPicture.asset(
                              "assets/images/set-up-message.svg",
                              width: 36,
                              height: 36,
                              fit: BoxFit.scaleDown),
                          onTap: () {
                            Navigator.pushNamed(context, Routes.message);
                          }),
                      // ListTile(
                      //     title: Align(alignment: Alignment.centerRight,child: Text(AppLocalizations.of(context)!.setupLocation)),
                      //     trailing: const Icon(Icons.location_on_sharp),
                      //     onTap: () {
                      //       Navigator.pushNamed(context, routes.location);
                      //     }),
                      ListTile(
                          title: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              AppLocalizations.of(context)!.contactUs,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          trailing: SvgPicture.asset(
                              "assets/images/contact-us.svg",
                              width: 36,
                              height: 36,
                              fit: BoxFit.scaleDown),
                          onTap: () {
                            Navigator.pushNamed(context, Routes.contactUs);
                          }),
                      ListTile(
                        title: const Text('🦋'),
                        onTap: () {
                          ButterflySdk.overrideLanguage(supportedLanguage: 'he');
                          ButterflySdk.openReporter(
                              withKey: "b748171e-cba0-4d22-9655-1cdce835a24a");
                        },
                      )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
