import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safe_button/pages/contacts/contacts_view.dart';
import 'package:safe_button/routes/routes.dart';
import 'package:butterfly_sdk_flutter_plugin/butterfly_sdk_flutter_plugin.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart' as ul;

class SettingsView extends StatelessWidget {
  static const String routeName = '/settings';

  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(10, 124, 164, 1),
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
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Align(
          alignment: Alignment.topRight,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(
                bottom: Radius.elliptical(
                    MediaQuery.of(context).size.width, 180.0)),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              child: Drawer(
                  backgroundColor: const Color.fromRGBO(10, 124, 164, 1),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView(
                      children: <Widget>[
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
                              // Navigator.of(context).pop();
                              // Navigator.pushNamed(context, routes.contacts);
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          const ContactsView(),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                              );
                            }),
                        ListTile(
                            title: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .setupHelpMessage,
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
                        SettingsListTile(image: "assets/images/contact-us.svg"),
                        ListTile(
                          title: const Align(
                              alignment: Alignment.centerRight,
                              child: Text('🦋')),
                          onTap: () {
                            ButterflySdk.overrideLanguage(
                                supportedLanguage: 'he');
                            ButterflySdk.openReporter(
                                withKey:
                                    "b748171e-cba0-4d22-9655-1cdce835a24a");
                          },
                        )
                      ],
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _launchUrl() async {
  final Uri _url = Uri.parse('safebuttonio@gmail.com');
  const String subject = "צור קשר";
  const String body = "שלום רב,";
  Uri mail = Uri.parse("mailto:$_url?subject=$subject&body=${Uri.encodeFull(body)}");
  // ul.WebViewConfiguration webViewConfiguration = ul.WebViewConfiguration(enableJavaScript: true);
  // await ul.launchUrl(mail, webViewConfiguration: webViewConfiguration);
  if (await ul.canLaunchUrl(mail)) {
    await ul.launchUrl(mail);
  } else {
    throw Exception("Unable to open the email");
  }
}

class SettingsListTile extends StatefulWidget {
  String image;


   SettingsListTile({Key? key,
    required this.image,
  }) : super(key: key);

  @override
  State<SettingsListTile> createState() => _SettingsListTileState();
}

class _SettingsListTileState extends State<SettingsListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            AppLocalizations.of(context)!.contactUs,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        trailing: SvgPicture.asset(
            widget.image,
            width: 36,
            height: 36,
            fit: BoxFit.scaleDown),
        onTap: _launchUrl);
  }
}
