import 'package:flutter/material.dart';

class SleepinfoPage extends StatelessWidget {
  const SleepinfoPage({super.key});

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
            'Sleep',
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
            'How Much Rest does a Dog Need?',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            'To ensure your dog gets the rest they need for overall health and well-being, here are some tips:',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 10.0),

          Text(
            '1. Ensure your dog gets enough sleep.',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            '• Sleep Duration: Dogs typically need 12-14 hours of sleep per day. Puppies and senior dogs may need even more.',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Open Sans',
            ),
          ),

          SizedBox(height: 10.0),
          Text(
            '2. Provide a comfortable sleeping environment.',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 10.0),
          
          SizedBox(height: 10.0),
          Text(
            '3. Establish a consistent sleep routine.',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            "• Regular Schedule: Keep a consistent bedtime routine to help your dog know when it's time to sleep.\n"
            '• Calm Environment: Reduce noise and activity levels in the house during sleep times.',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Open Sans',
            ),
          ),

          SizedBox(height: 10.0),
          Text(
            '4. Provide adequate exercise.',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            "• Daily Activity: Regular exercise helps ensure your dog is tired at bedtime and can sleep more soundly.\n"
            '• Mental Stimulation: Engage your dog in activities that challenge their mind, such as puzzle toys or training sessions, to promote better sleep.',
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
