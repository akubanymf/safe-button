import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:butterfly_sdk_flutter_plugin/butterfly_sdk_flutter_plugin.dart';
import 'package:safe_button/pages/settings/settings_view.dart';
import 'package:safe_button/routes/routes.dart';
import 'package:safe_button/widget/lang_picker_widget.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({
    Key? key,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(50.0)),
      child: Container(
        height: 500,
        width: 500,
        child: Drawer(
            key: _scaffoldKey,
            child: ListView(
          children: <Widget>[
            const UserAccountsDrawerHeader(
                accountName: Text('Test'), accountEmail: Text('Test@test.com'),
            ),
            LanguagePickerWidget(),
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            ListTile(
                title: Text(AppLocalizations.of(context)!.selectContacts),
                leading: const Icon(Icons.account_circle),
                onTap: () {
                  Navigator.pushNamed(context, routes.contacts);
                }),
            ListTile(
                title: Text(AppLocalizations.of(context)!.setupHelpMessage),
                leading: const Icon(Icons.message_sharp),
                onTap: () {
                  Navigator.pushNamed(context, routes.message);
                }),
            ListTile(
                title: Text(AppLocalizations.of(context)!.setupLocation),
                leading: const Icon(Icons.location_on_sharp),
                onTap: () {
                  Navigator.pushNamed(context, routes.location);
                }),
            ListTile(
                title: Text(AppLocalizations.of(context)!.settings),
                leading: const Icon(Icons.settings_sharp),
                onTap: () {
                  Navigator.pushNamed(context, routes.settings);
                }),
            ListTile(
                title: Text(AppLocalizations.of(context)!.contactUs),
                leading: const Icon(Icons.mail_sharp),
                onTap: () {
                  Navigator.pushNamed(context, routes.contactUs);
                }),
            ListTile(
              title: const Text('🦋'),
              onTap: () {
                ButterflySdk.openReporter(
                    withKey: "b748171e-cba0-4d22-9655-1cdce835a24a");
              },
            )
          ],
        )),
      ),
    );
  }
}
