import 'package:flutter/material.dart';

class FeedinfoPage extends StatelessWidget {
  const FeedinfoPage({super.key});

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
            'Feed',
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
            'How to Feed a Dog?',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            'Feeding your dog the right way is crucial for its health. Here are some tips:',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 10.0),
         
          Text(
            '1. Provide a balanced diet with appropriate nutrients.',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            '• Protein: Essential for growth, maintenance, and energy. Common sources include meat, fish, eggs, and some plant-based ingredients.\n'
            '• Fats: Provide energy, support cell function, and help absorb vitamins. Sources include fish oil, chicken fat, and flaxseed.\n'
            '• Carbohydrates: Supply energy and aid in gastrointestinal health. Found in grains, vegetables, and fruits.\n'
            '• Vitamins and Minerals: Crucial for metabolic functions, bone health, and overall well-being. Include vitamin A, D, E, K, B-complex vitamins, calcium, phosphorus, and more.',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Open Sans',
            ),
          ),
          
          SizedBox(height: 10.0),
          Text(
            '2. Avoid feeding your dog human food.',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            '• Many human foods can be toxic to dogs, such as chocolate, grapes, onions, and certain nuts.\n'
            '• Stick to dog-specific foods and treats designed to meet their nutritional needs.',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Open Sans',
            ),
          ),

          SizedBox(height: 10.0),
          Text(
            '3. Ensure fresh water is always available.',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),

          SizedBox(height: 10.0),
          Text(
            '4. Feed your dog at regular intervals.',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            "• Portion Control: Follow guidelines based on the dog's weight, age, and activity level. Overfeeding can lead to obesity.\n"
            '• Feeding Schedule: Typically, adult dogs are fed twice a day, while puppies may need 3-4 meals a day.',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Open Sans',
            ),
          ),

          SizedBox(height: 10.0),
          Text(
            '5. Consult with a vet for specific dietary needs.',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            "• Regular Check-Ups: Ensure that your dog's nutritional needs are being met and adjust the diet as necessary.",
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
