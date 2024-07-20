import 'package:flutter/material.dart';

class CompanionshipinfoPage extends StatelessWidget {
  const CompanionshipinfoPage({super.key});

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
          title: const Text(
            'Companionship',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
              fontFamily: 'Open Sans',
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        body: _page(),
      ),
    );
  }

  Widget _page() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: const [
          Text(
            'Key Aspects of Companionship a Dog Needs',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            'Dogs thrive on companionship and social interaction. Here are some tips:',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Open Sans',
            ),
          ),
          
          SizedBox(height: 10.0),
          Text(
            '1. Regular Interaction and Attention.',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            '• Quality Time: Spend time with your dog daily through activities like playing, walking, or simply sitting together.',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Open Sans',
            ),
          ),

          SizedBox(height: 10.0),
          Text(
            '2. Affection and Love.',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            '• Physical Affection: Petting, cuddling, and gentle grooming help reinforce the bond between you and your dog.',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Open Sans',
            ),
          ),

          SizedBox(height: 10.0),
          Text(
            '3. Socialization.',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            '• Exposure to New Experiences: Introduce your dog to various environments, people, and other animals to build their confidence and social skills.\n'
            '• Playdates: Arrange for your dog to meet and play with other dogs to fulfill their need for social interaction and play.',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Open Sans',
            ),
          ),
        ],
      ),
    );
  }
}
