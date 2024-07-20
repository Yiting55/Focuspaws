import 'package:flutter/material.dart';

class FosterinfoPage extends StatelessWidget {
  const FosterinfoPage({super.key});

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
            'Foster',
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
            'How to Correctly Foster a Dog?',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            'To ensure that your dog receives proper care and attention, and make the transition as smooth as possible for both you and your pet, here are some tips:',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 10.0),
          
          Text(
            '1. Contact the pet house or organization.',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            "• Find a Reputable Facility: Research and choose a reputable pet house, kennel, or organization that provides temporary care for dogs.",
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Open Sans',
            ),
          ),

          SizedBox(height: 10.0),
          Text(
            "2. Provide the dog's information.",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            "• Medical Records: Supply up-to-date medical records, including vaccination history and any ongoing treatments or medications.\n"
            "• Behavioral Information: Share details about the dog's temperament, habits, likes, dislikes, and any special needs or concerns.",
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Open Sans',
            ),
          ),

          SizedBox(height: 10.0),
          Text(
            "3. Prepare the dog for the transition.",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            "• Comfort Items: Send the dog with familiar items such as their bed, toys, and a blanket to help ease the transition.\n"
            "• Feeding Instructions: Provide detailed feeding instructions, including the type of food, portion sizes, and feeding schedule.",
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Open Sans',
            ),
          ),

          SizedBox(height: 10.0),
          Text(
            "4. Visit the facility beforehand.",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            "• Tour the Facility: Visit the pet house or organization to ensure it meets your standards for cleanliness, safety, and overall care.\n"
            "• Meet the Caregivers: Introduce yourself and your dog to the staff who will be caring for them, and discuss any specific instructions or concerns.",
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Open Sans',
            ),
          ),

          SizedBox(height: 10.0),
          Text(
            "5. Ensure proper documentation.",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            "• Agreement: Fill out any necessary paperwork, including a temporary care agreement, to outline the terms and conditions of the dog's stay.\n"
            "• Emergency Contact: Provide emergency contact information and authorize someone to make decisions on your behalf if needed.",
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Open Sans',
            ),
          ),

          SizedBox(height: 10.0),
          Text(
            "6. Plan for regular updates.",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            "• Communication: Arrange for regular updates on your dog's well-being, including photos, videos, or reports on their adjustment and activities.",
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Open Sans',
            ),
          ),

          SizedBox(height: 10.0),
          Text(
            "7. Prepare for the dog's return.",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
        ],
      ),
    );
  }
}
