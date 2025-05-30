import 'package:flutter/material.dart';

class PassportScreen extends StatelessWidget {
  const PassportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mocked progress and stamps
    final cafesVisited = 4;
    final goal = 10;

    return Scaffold(
      appBar: AppBar(title: const Text("Coffee Passport")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Visited $cafesVisited / $goal Cafés",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: cafesVisited / goal,
              backgroundColor: Colors.brown[100],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.builder(
                itemCount: goal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final isStamped = index < cafesVisited;
                  return Container(
                    decoration: BoxDecoration(
                      color: isStamped ? Colors.brown : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(
                        isStamped ? Icons.local_cafe : Icons.coffee_outlined,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
