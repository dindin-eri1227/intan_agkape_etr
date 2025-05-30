import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  final String weather;
  const MapScreen({super.key, required this.weather});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  LatLng? _userLocation;

  final Map<String, bool> _filters = {
    'Wi-Fi': false,
    'Pet-Friendly': false,
    'Outdoor': false,
    'Indoor': false,
  };

  final List<Map<String, dynamic>> _cafes = [
    {
      'name': 'Brew & Chill',
      'position': LatLng(14.5995, 120.9842),
      'features': ['Wi-Fi', 'Outdoor'],
    },
    {
      'name': 'Cafe Komunidad',
      'position': LatLng(14.6010, 120.9830),
      'features': ['Pet-Friendly', 'Wi-Fi', 'Indoor'],
    },
    {
      'name': 'Morning Roast',
      'position': LatLng(14.6025, 120.9865),
      'features': ['Outdoor'],
    },
  ];

  List<Map<String, dynamic>> get _filteredCafes {
    final activeFilters =
        _filters.entries.where((e) => e.value).map((e) => e.key).toList();

    // Inject weather suggestion logic
    if (widget.weather == 'Rain') activeFilters.add('Indoor');
    if (widget.weather == 'Clear') activeFilters.add('Outdoor');

    if (activeFilters.isEmpty) return _cafes;

    return _cafes
        .where((cafe) =>
            activeFilters.every((filter) => cafe['features'].contains(filter)))
        .toList();
  }

  Set<Marker> get _markers {
    return _filteredCafes
        .map((cafe) => Marker(
              markerId: MarkerId(cafe['name']),
              position: cafe['position'],
              infoWindow: InfoWindow(title: cafe['name']),
            ))
        .toSet();
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
    });
  }

  Future<bool> _handleLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        return false;
      }
    }
    return true;
  }

  void _recenterMap() {
    if (_userLocation != null && mapController != null) {
      mapController!.animateCamera(CameraUpdate.newLatLng(_userLocation!));
    }
  }

  void _toggleFilter(String key) {
    setState(() {
      _filters[key] = !_filters[key]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coffee Map"),
        centerTitle: true,
      ),
      body: _userLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: (controller) => mapController = controller,
                  initialCameraPosition: CameraPosition(
                    target: _userLocation!,
                    zoom: 14,
                  ),
                  myLocationEnabled: true,
                  markers: _markers,
                ),

                // Filter Chips
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Wrap(
                    spacing: 8,
                    children: _filters.entries.map((entry) {
                      return FilterChip(
                        label: Text(entry.key),
                        selected: entry.value,
                        onSelected: (_) => _toggleFilter(entry.key),
                      );
                    }).toList(),
                  ),
                ),

                // Recenter Button
                Positioned(
                  bottom: 140,
                  right: 16,
                  child: FloatingActionButton(
                    backgroundColor: Colors.brown,
                    onPressed: _recenterMap,
                    child: const Icon(Icons.my_location),
                  ),
                ),

                // Café Cards
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 120,
                    color: Colors.white.withOpacity(0.95),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filteredCafes.length,
                      itemBuilder: (context, index) {
                        final cafe = _filteredCafes[index];
                        return Container(
                          width: 220,
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.brown[50],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(cafe['name'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Text("Features: ${cafe['features'].join(', ')}",
                                  style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
