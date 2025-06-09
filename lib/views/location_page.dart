import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // Untuk koordinat LatLng
import 'package:geolocator/geolocator.dart'; // Untuk lokasi pengguna

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  // Titik lokasi tujuan (contoh: Monas, Jakarta)
  final LatLng _destinationLatLng = LatLng(-6.175392, 106.827153);

  // Koordinat lokasi pengguna
  LatLng _currentLatLng = LatLng(0.0, 0.0);

  // Menyimpan marker
  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _getUserLocation(); // Meminta lokasi pengguna saat halaman dimuat
  }

  // Mendapatkan lokasi pengguna
  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Cek apakah layanan lokasi aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Jika tidak aktif, tampilkan pesan atau minta pengguna mengaktifkan
      return;
    }

    // Cek izin lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Jika izin tetap ditolak, keluar dari fungsi
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Jika izin ditolak permanen, keluar dari fungsi
      return;
    }

    // Ambil posisi saat ini
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
    setState(() {
      _currentLatLng = LatLng(position.latitude, position.longitude);
      _updateMarkers(); // Menambahkan marker untuk pengguna dan tujuan
    });
  }

  // Menambahkan marker pada peta
  void _updateMarkers() {
    _markers.clear();
    _markers.add(
      Marker(
        point: _currentLatLng,
        width: 40,
        height: 40,
        child: const Icon(
          Icons.location_on,
          color: Colors.blue,
          size: 40,
        ),
      ),
    );
    _markers.add(
      Marker(
        point: _destinationLatLng,
        width: 40,
        height: 40,
        child: const Icon(
          Icons.location_on,
          color: Colors.red,
          size: 40,
        ),
      ),
    );
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
              mapController: MapController(),
              options: MapOptions(
                initialCenter: _currentLatLng, // Titik tengah peta (lokasi pengguna)
                initialZoom: 15.0, // Zoom level awal
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: _markers, // Menampilkan marker di peta
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Navigate to Destination',
        onPressed: _navigateToDestination,
        child: const Icon(Icons.directions),
      ),
    );
  }

  // Fungsi untuk menavigasi ke titik lokasi tujuan
  void _navigateToDestination() {
    setState(() {
      // Pindahkan peta ke lokasi tujuan (monas di Jakarta)
      _currentLatLng = _destinationLatLng;
      _updateMarkers(); // Update marker setelah navigasi
    });
  }
}
