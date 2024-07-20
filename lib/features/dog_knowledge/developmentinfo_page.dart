import 'package:flutter/material.dart';

class DevelopmentinfoPage extends StatelessWidget {
  const DevelopmentinfoPage({super.key});

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
            'Growth',
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
            "What You should Know about a Dog's Growth?",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            "Understanding your dog's growth stages is crucial for ensuring a healthy and happy life. Here are some tips:",
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Open Sans',
            ),
          ),
          
          SizedBox(height: 10.0),
          Text(
            '1. Puppyhood (0-6 months).',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            '• Rapid Growth: Puppies experience significant growth and development during this period, including muscle and bone growth.\n'
            '• Nutrition: High-quality puppy food rich in protein and essential nutrients is crucial for proper development.\n'
            '• Socialization: Expose puppies to different people, animals, and environments to build social skills and confidence.\n'
            '• Training: Start basic training and housebreaking early to establish good behavior and routines.',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Open Sans',
            ),
          ),

          SizedBox(height: 10.0),
          Text(
            '2. Adolescence (6-18 months).',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            '• Continued Growth: Adolescents still grow rapidly, though the pace slows down compared to early puppyhood.\n'
            '• Behavior Changes: Expect behavioral changes and testing of boundaries. Consistent training and reinforcement are key.\n'
            '• Exercise Needs: Increase physical and mental exercise to manage high energy levels and prevent destructive behavior.\n'
            '• Sexual Maturity: Dogs reach sexual maturity during this period. Consider spaying or neutering based on veterinary advice.',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Open Sans',
            ),
          ),

          SizedBox(height: 10.0),
          Text(
            '3. Adulthood (1-7 years).',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            '• Physical Maturity: Most dogs reach their full adult size by the end of this period, though some large breeds may continue growing until two years old.\n'
            '• Stable Routine: Maintain a consistent routine for feeding, exercise, and training to ensure a balanced and well-adjusted adult dog.\n'
            '• Health Maintenance: Regular veterinary check-ups, a balanced diet, and appropriate exercise are essential for maintaining health.\n'
            '• Mental Stimulation: Continue providing mental challenges and new experiences to keep the dog engaged and happy.',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Open Sans',
            ),
          ),

          SizedBox(height: 10.0),
          Text(
            '4. Senior Years (7+ years).',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            '• Slowing Down: Older dogs may slow down and become less active. Adjust exercise routines to match their energy levels.\n'
            '• Dietary Changes: Senior dogs may require special diets to manage weight and support aging joints and organs.\n'
            '• Health Monitoring: Increase the frequency of veterinary visits to monitor and manage age-related health issues.\n'
            '• Comfort: Provide a comfortable living environment with easy access to favorite resting spots and less strenuous activities.',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Open Sans',
            ),
          ),

          SizedBox(height: 10.0),
          Text(
            '5. Factors Affecting Growth and Development.',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            '• Breed: Different breeds have varying growth rates and developmental milestones. Large breeds tend to mature slower than small breeds.\n'
            "• Nutrition: Proper nutrition is vital at every stage. Ensure the diet is balanced and appropriate for the dog's life stage.\n"
            '• Health: Regular veterinary care, vaccinations, and parasite control are crucial for healthy development.\n'
            '• Environment: A stimulating environment with social interaction, training, and exercise promotes healthy mental and physical development.',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Open Sans',
            ),
          ),
          
          SizedBox(height: 10.0),
          Text(
            '6. Milestones to Monitor.',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            '• Teething: Puppies start teething around 3-4 months and finish by 6-7 months.\n'
            "• Growth Spurts: Expect rapid growth spurts in the first 6 months, followed by gradual growth.\n"
            '• Behavioral Changes: Noticeable changes in behavior and temperament can occur during adolescence.\n'
            '• Senior Signs: Watch for signs of aging such as decreased activity, weight changes, and joint stiffness.',
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
