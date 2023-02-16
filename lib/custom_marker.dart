import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarker extends StatefulWidget {
  const CustomMarker({Key? key}) : super(key: key);

  @override
  State<CustomMarker> createState() => _CustomMarkerState();
}

class _CustomMarkerState extends State<CustomMarker> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGoohleplex = const CameraPosition(
    target: LatLng(24.625497133166697, 73.6796470992265),
    zoom: 13,
  );

  Uint8List? markerImage;

  List<String> images = [
    'assets/A icon.png',
    'assets/b icon.png',
    'assets/c icon.png',
    'assets/d icon.png'
  ];

  final List<Marker> _markers = <Marker>[
    const Marker(
      markerId: MarkerId('2'),
      position: LatLng(24.625575157594298, 73.6796363702457),
    ),
  ];

  final List<LatLng> _latlang = <LatLng>[
    LatLng(24.625575157594298, 73.6796363702457),
    LatLng(24.600188910677257, 73.66977141682747),
    LatLng(24.573587236397255, 73.69972228602646),
    LatLng(24.603188325445203, 73.6869579834902)
  ];



  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }


  loadData() async {
    for (int i = 0; i < images.length; i++) {
      final Uint8List markerIcon = await getBytesFromAssets(images[i], 100);
      _markers.add(
        Marker(
            markerId: MarkerId(i.toString()),
            position: _latlang[i],
            icon: BitmapDescriptor.fromBytes(markerIcon),
            infoWindow:
            InfoWindow(title: 'this is title marker:' + i.toString())),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _kGoohleplex,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          markers: Set<Marker>.of(_markers),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }
}
