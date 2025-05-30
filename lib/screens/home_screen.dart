import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'map_screen.dart';
import 'passport_screen.dart';
import 'events_screen.dart';
import 'favorites_screen.dart';
import 'reviews_screen.dart';
import '../models/mock_cafes.dart';
import '../models/mood_playlists.dart';
import '../services/weather_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String? _weather;
  bool _loadingWeather = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.12, end: 0.3).animate(_controller);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
      _fetchWeather();
    });
  }

  Future<void> _fetchWeather() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        await Geolocator.requestPermission();
      }
      final position = await Geolocator.getCurrentPosition();
      final condition = await WeatherService()
          .getWeatherCondition(position.latitude, position.longitude);
      setState(() {
        _weather = condition;
        _loadingWeather = false;
      });
    } catch (_) {
      setState(() {
        _weather = 'Unavailable';
        _loadingWeather = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showCafeDetails(Map<String, String> cafe) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cafe['name']!,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Image.asset(
              cafe['image']!,
              width: double.infinity,
              height: 160,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 12),
            Text(
              cafe['blurb']!,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.star, color: Colors.orange[300]),
                const SizedBox(width: 4),
                const Text('4.5 • 120 reviews')
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intan Ag-Kape'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const AuthScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Your Coffee Companion",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 12),
                if (!_loadingWeather && _weather != null)
                  Row(
                    children: [
                      const Icon(Icons.wb_sunny, color: Colors.amber),
                      const SizedBox(width: 8),
                      Text("Weather: $_weather")
                    ],
                  ),
                const SizedBox(height: 16),

                if (!_loadingWeather && _weather != null)
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: ListTile(
                      leading: const Icon(Icons.local_cafe, color: Colors.brown),
                      title: Text(
                        _weather == 'Rain' ? 'Try a Cozy Indoor Café!' :
                        _weather == 'Clear' ? 'Perfect Weather for an Outdoor Café!' :
                        'Find your comfort brew!'
                      ),
                      subtitle: const Text('Tap the map to explore recommendations.'),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => MapScreen(weather: _weather!)),
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 12),

                _FeatureButton(
                  label: "Find Cafés Near Me",
                  icon: Icons.map,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MapScreen(weather: _weather ?? 'Clear')),
                    );
                  },
                ),
                _FeatureButton(
                  label: "My Coffee Passport",
                  icon: Icons.local_activity,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PassportScreen()),
                    );
                  },
                ),
                _FeatureButton(
                  label: "Events & Promos",
                  icon: Icons.event,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EventsScreen()),
                    );
                  },
                ),
                _FeatureButton(
                  label: "Favorites",
                  icon: Icons.favorite,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                    );
                  },
                ),
                _FeatureButton(
                  label: "Community Reviews",
                  icon: Icons.people,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ReviewsScreen()),
                    );
                  },
                ),

                const SizedBox(height: 32),
                const Text(
                  "Mood Brew Playlist 🎧",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _MoodBrewCard(weather: _weather ?? 'Clear'),
                const SizedBox(height: 120),
              ],
            ),
          ),

          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return DraggableScrollableSheet(
                initialChildSize: _animation.value,
                minChildSize: 0.12,
                maxChildSize: 0.5,
                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, -2),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.brown[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text("Featured Cafés",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: featuredCafes.length,
                            itemBuilder: (context, index) {
                              final cafe = featuredCafes[index];
                              return ListTile(
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
                                subtitle: Text(cafe['blurb']!),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () => _showCafeDetails(cafe),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          )
        ],
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

class _MoodBrewCard extends StatelessWidget {
  final String weather;
  const _MoodBrewCard({required this.weather});

  Map<String, String> getCurrentMood() {
    final now = DateTime.now().hour;
    if (weather == 'Rain') {
      return {
        'label': 'Rainy Day Jazz ☔',
        'url': 'https://youtu.be/NJuSStkIZBg?si=fqHOfJi7rNZOIJgE'
      };
    }
    if (now >= 6 && now < 12) return moodPlaylists[0];
    if (now >= 12 && now < 17) return moodPlaylists[1];
    if (now >= 17 && now < 21) return moodPlaylists[2];
    return moodPlaylists[3];
  }

  void _launchPlaylist(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open playlist')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final playlist = getCurrentMood();
    return Card(
      color: Colors.brown[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.music_note, color: Colors.brown),
        title: Text(playlist['label']!),
        subtitle: const Text("Tap to listen on Spotify/YouTube"),
        onTap: () => _launchPlaylist(context, playlist['url']!),
      ),
    );
  }
}
