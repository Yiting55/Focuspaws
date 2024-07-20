import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/dog_knowledge/companionshipinfo_page.dart';
import 'package:flutter_application_1/features/dog_knowledge/developmentinfo_page.dart';
import 'package:flutter_application_1/features/dog_knowledge/feedinfo_page.dart';
import 'package:flutter_application_1/features/dog_knowledge/fosterinfo_page.dart';
import 'package:flutter_application_1/features/dog_knowledge/sleepinfo_page.dart';


class DogKnowledgePage extends StatelessWidget {
  const DogKnowledgePage({super.key});

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
          title: const Text(
            'Knowledge about Dogs',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
              fontFamily: 'Open Sans'
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
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
          _knowledgeListItem(
            context,
            icon: Icons.fastfood,
            text: 'Feed',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FeedinfoPage()),
              );
            },
          ),
          _knowledgeListItem(
            context,
            icon: Icons.bed,
            text: 'Sleep',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SleepinfoPage()),
              );
            },
          ),
          _knowledgeListItem(
            context,
            icon: Icons.home,
            text: 'Foster',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FosterinfoPage()),
              );
            },
          ),
          _knowledgeListItem(
            context,
            icon: Icons.favorite,
            text: 'Companionship',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CompanionshipinfoPage()),
              );
            },
          ),
          _knowledgeListItem(
            context,
            icon: Icons.trending_up,
            text: 'Growth',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DevelopmentinfoPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _knowledgeListItem(BuildContext context, {required IconData icon, required String text, required VoidCallback onTap}) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(
          text,
          style: const TextStyle(
            fontSize: 18.0,
            fontFamily: 'Open Sans',
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
