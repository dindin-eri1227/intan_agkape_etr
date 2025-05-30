import 'package:flutter/material.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  final List<Map<String, dynamic>> reviews = const [
    {
      'user': 'Anna Cruz',
      'rating': 5,
      'comment': 'The ambiance was so cozy, and their cold brew was 🔥!',
      'photo': 'assets/images/review1.jpg',
    },
    {
      'user': 'Jay Dela Rosa',
      'rating': 4,
      'comment': 'Loved the latte art. Will definitely return!',
      'photo': 'assets/images/review2.jpg',
    },
    {
      'user': 'Mika R.',
      'rating': 3,
      'comment': 'Great food, a bit noisy for work though.',
      'photo': 'assets/images/review3.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Community Reviews")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    review['photo'],
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review['user'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: List.generate(
                          5,
                          (star) => Icon(
                            star < review['rating'] ? Icons.star : Icons.star_border,
                            size: 18,
                            color: Colors.orange[300],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(review['comment']),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/submit-review');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}