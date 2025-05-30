import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  final List<Map<String, String>> favorites = const [
    {
      'name': 'Cafe Laya',
      'image': 'assets/images/cafe_laya.jpg',
      'notes': 'Love the iced mocha and chill ambiance.',
    },
    {
      'name': 'The Coffee Library',
      'image': 'assets/images/cafe_library.jpg',
      'notes': 'Perfect for reading with fresh pastries.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Favorites")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final cafe = favorites[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  cafe['image']!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(cafe['name']!),
              subtitle: Text(cafe['notes']!),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Optional: go to full profile page
              },
            ),
          );
        },
      ),
    );
  }
}
