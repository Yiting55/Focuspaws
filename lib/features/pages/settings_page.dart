// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_types_as_parameter_names, non_constant_identifier_names, unused_import

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/features/dog_knowledge/dogknowledge_page.dart';
import 'package:flutter_application_1/features/user_auth/changepassword_page.dart';
import 'package:flutter_application_1/features/user_auth/signinorregister_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 252, 192, 40),
            Color.fromARGB(255, 255, 179, 57),
            Color.fromARGB(255, 251, 161, 44),
            Color.fromARGB(255, 254, 155, 25),
          ],
          stops: [0.1, 0.3, 0.7, 0.9],
        )),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            'Settings',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
              fontFamily: 'Open Sans'
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: _page(context),
      ),
    );
  }

  Widget _page(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          _settingsListItem(
            context,
            icon: Icons.lock,
            text: 'Change Password',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordPage()),
              );
            },
          ),
          
          _settingsListItem(
            context,
            icon: Icons.pets,
            text: 'Knowledge about Dogs',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DogKnowledgePage()),
              );
            },
          ),
          _settingsListItem(
            context,
            icon: Icons.logout,
            text: 'Logout',
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              // Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SigninOrRegisterPage()));
            },
          ),
        ],
      ),
    );
  }

  Widget _settingsListItem(BuildContext context, {required IconData icon, required String text, required VoidCallback onTap}) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Open Sans'
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
