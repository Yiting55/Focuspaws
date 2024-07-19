// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/localization.dart';

class ChangeLanguagePage extends StatefulWidget {
  final Function(Locale) setLocale;
  const ChangeLanguagePage({super.key, required this.setLocale});

  @override
  State<ChangeLanguagePage> createState() => _ChangeLanguagePageState();
}

class _ChangeLanguagePageState extends State<ChangeLanguagePage> {
  // A list of supported languages
  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'zh', 'name': 'Chinese'}
  ];
  String? selectedLanguageCode;

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
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.translate('title'),
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
              fontFamily: 'Open Sans'
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: _page(),
      ),
    );
  }

  Widget _page() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: languages.length,
              itemBuilder: (context, index) {
                var language = languages[index];
                return RadioListTile<String>(
                  title: Text(AppLocalizations.of(context)!.translate(language['name']!)),
                    value: language['code'] as String,
                    groupValue: selectedLanguageCode,
                  onChanged: (String? value) {
                    setState(() {
                      selectedLanguageCode = value;
                    });
                  },
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.grey,
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: selectedLanguageCode == null
                ? null
                : () {
                    // Save the selected language and apply changes
                    widget.setLocale(Locale(selectedLanguageCode!));
                      Navigator.pop(context);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: Text(AppLocalizations.of(context)!.translate('apply')),
          ),
        ],
      ),
    );
  }
}
