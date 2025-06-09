import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // Untuk koordinat LatLng
import 'package:geolocator/geolocator.dart'; // Untuk lokasi pengguna
import 'package:royal_clothes/db/database_helper.dart'; // Impor DBHelper

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final LatLng _destinationLatLng = LatLng(-6.175392, 106.827153);
  LatLng _currentLatLng = LatLng(0.0, 0.0);
  final List<Marker> _markers = [];
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getUserLocation(); // Meminta lokasi pengguna saat halaman dimuat
    _loadMarkers(); // Memuat marker yang disimpan dari database
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    setState(() {
      _currentLatLng = LatLng(position.latitude, position.longitude);
      _updateMarkers();
    });
  }

  void _updateMarkers() {
    _markers.clear();
    _markers.add(
      Marker(
        point: _currentLatLng,
        width: 40,
        height: 40,
        child: const Icon(Icons.location_on, color: Colors.blue, size: 40),
      ),
    );
    _markers.add(
      Marker(
        point: _destinationLatLng,
        width: 40,
        height: 40,
        child: const Icon(Icons.location_on, color: Colors.red, size: 40),
      ),
    );
  }

  void _handleLongPress(LatLng tappedPoint) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _controller = TextEditingController();

        return AlertDialog(
          title: const Text('Enter Location Name'),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Location Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (_controller.text.isNotEmpty) {
                  setState(() {
                    _markers.add(
                      Marker(
                        point: tappedPoint,
                        width: 40,
                        height: 60,
                        child: Column(
                          children: [
                            Icon(Icons.location_on, color: Colors.green, size: 40),
                            Text(
                              _controller.text,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );
                  });

                  // Simpan marker ke database
                  await DBHelper().saveMarker(
                      _controller.text, tappedPoint.latitude, tappedPoint.longitude);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Memuat marker dari database
  Future<void> _loadMarkers() async {
    List<Map<String, dynamic>> markersData = await DBHelper().getMarkers();
    setState(() {
      _markers.clear();
      for (var markerData in markersData) {
        _markers.add(
          Marker(
            point: LatLng(markerData['latitude'], markerData['longitude']),
            width: 40,
            height: 60,
            child: Column(
              children: [
                Icon(Icons.location_on, color: Colors.green, size: 40),
                Text(markerData['name'], style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps Navigation (flutter_map)'),
      ),
      body: _currentLatLng.latitude == 0.0 && _currentLatLng.longitude == 0.0
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentLatLng, // Titik tengah peta (lokasi pengguna)
                initialZoom: 15.0, // Zoom level awal
                onLongPress: (tapPosition, latLng) {
                  _handleLongPress(latLng); // Menangani long press langsung dengan LatLng
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const [],
                ),
                MarkerLayer(
                  markers: _markers, // Menampilkan marker di peta
                ),
              ],
            ),
    );
  }
}
