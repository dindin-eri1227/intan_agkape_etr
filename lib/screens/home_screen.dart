import 'package:flutter/material.dart';
import 'map_screen.dart'; // Navigate to map
// Add other imports later (passport, events, etc.)

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intan Ag-Kape'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subtitle
            const Text(
              "Your Coffee Companion",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 24),

            // Feature Buttons
            _FeatureButton(
              label: "Find Cafés Near Me",
              icon: Icons.map,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MapScreen()),
                );
              },
            ),
            _FeatureButton(
              label: "My Coffee Passport",
              icon: Icons.local_activity,
              onTap: () {
                // TODO: Navigate to passport screen
              },
            ),
            _FeatureButton(
              label: "Events & Promos",
              icon: Icons.event,
              onTap: () {
                // TODO: Navigate to events screen
              },
            ),
            _FeatureButton(
              label: "Favorites",
              icon: Icons.favorite,
              onTap: () {
                // TODO: Navigate to favorites screen
              },
            ),

            const SizedBox(height: 32),

            // Featured Café
            const Text(
              "Featured Café",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _FeaturedCafeCard(),

            const SizedBox(height: 32),

            // Mood Brew
            const Text(
              "Mood Brew Playlist 🎧",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _MoodBrewCard(),
          ],
        ),
      ),
    );
  }
}

class _FeatureButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _FeatureButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.brown),
        title: Text(label),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class _FeaturedCafeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.asset(
              'assets/images/cafe_sample.jpg',
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Cafe Komunidad',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text('Try their award-winning cold brew!',
                      style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodBrewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.brown[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.music_note, color: Colors.brown),
        title: const Text('Chill Vibes for Rainy Days'),
        subtitle: const Text('Curated Spotify playlist'),
        onTap: () {
          // TODO: Launch Spotify/YouTube
        },
      ),
    );
  }
}
