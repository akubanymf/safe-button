import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:safe_button/Model/custom_contact.dart';
import 'package:safe_button/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactsView extends StatefulWidget {
  static const String routeName = '/selectContacts';

  const ContactsView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  List<CustomContact>? contacts;
  static SharedPreferences? _pref;

  @override
  void initState() {
    super.initState();
    _populateContacts();
    //Future<PhoneContact> contact = _getPhoneContact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(10, 124, 164, 1),
        leading: GestureDetector(
          onTap: () {
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
          'הוסיפי אנשי קשר להודעת סמס',
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
      body: Center(
        child: Scrollbar(
          trackVisibility: true,
          child: Container(
            color: AppColors.appMainColor,
            child: Column(
              children: [
                _createContacts(),
                const SizedBox(height: 60),
                contacts != null && (contacts?.length ?? 0) < 5
                    ? (IconButton(
                        onPressed: () {
                          _getPhoneContact();
                        },
                        icon: SvgPicture.asset(
                          "assets/images/plus_sign.svg",
                          fit: BoxFit.scaleDown,
                        ),
                      ))
                    : (const SizedBox.shrink()),
                const SizedBox(height: 60),
                const Text(
                  'ניתן להוסיף עד 5 אנשי קשר',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<PhoneContact> _getPhoneContact() async {
    FullContact fullContact = await FlutterContactPicker.pickFullContact();
    String? fullName;
    if (fullContact.name!.lastName != null) {
      fullName =
          fullContact.name!.firstName! + ' ' + fullContact.name!.lastName!;
    } else {
      fullName = fullContact.name!.firstName!;
    }
    PhoneNumber phoneNumber = fullContact.phones.first;
    PhoneContact contact = PhoneContact(fullName, phoneNumber);
    Uint8List photo;
    if (fullContact.photo == null) {
      photo = Uint8List(0);
    } else {
      photo = fullContact.photo!.bytes;
    }
    await _insertContactToSharedPref(contact, photo);
    return contact;
  }

  void _populateContacts() async {
    _pref ??= await SharedPreferences.getInstance();
    final String? contactsString = _pref!.getString('selected_contacts');
    if (contactsString != null) {
      setState(() {
        contacts = CustomContact.decode(contactsString);
      });
    }
  }

  void _editContact(int index) {}
  Future<void> _deleteContact(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? contactsString = prefs.getString('selected_contacts');
    List<CustomContact> contacts = CustomContact.decode(contactsString!);
    contacts.removeAt(index);
    await prefs.setString('selected_contacts', CustomContact.encode(contacts));
    setState(() {
      this.contacts = contacts;
    });
  }

  Future<void> _insertContactToSharedPref(
      PhoneContact contact, Uint8List byteImage) async {
    String byteImageString = String.fromCharCodes(byteImage);
    CustomContact customContact = CustomContact(
        contact.phoneNumber?.number, contact.fullName, byteImageString);
    final String? contactsString = _pref!.getString('selected_contacts');
    if (contactsString == null) {
      _pref!.setString(
          'selected_contacts', CustomContact.encode([customContact]));
      setState(() {
        contacts = [customContact];
      });
    } else {
      List<CustomContact> contacts = CustomContact.decode(contactsString);
      contacts.add(customContact);
      await _pref!
          .setString('selected_contacts', CustomContact.encode(contacts));
      setState(() {
        this.contacts = contacts;
      });
    }
  }

  _createContacts() {
    if (contacts == null || contacts!.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: contacts!.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      "assets/images/remove.svg",
                      height: 270,
                      width: 270,
                      fit: BoxFit.scaleDown,
                    ),
                    onPressed: () {
                      _deleteContact(index);
                    },
                  ),
                  Flexible(
                      fit: FlexFit.tight,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          contacts?[index].name! ?? '',
                          style: const TextStyle(color: Colors.white),
                        ),
                      )),
                  IconButton(
                    icon: _createImage(contacts?[index].byteImage),
                    onPressed: () {},
                  ),
                ],
              ),
            );
          });
    }
  }

  _createImage(String? byteImage) {
    return byteImage == null || byteImage.isEmpty
        ? SvgPicture.asset(
            "assets/images/contact_person.svg",
            height: 270,
            width: 270,
            fit: BoxFit.scaleDown,
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.memory(Uint8List.fromList(byteImage.codeUnits)),
          );
  }
}
