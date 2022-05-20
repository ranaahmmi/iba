import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_flutter_web/google_maps_flutter_web.dart' as webGM;

class MapPicker extends StatefulWidget {
  final double zoom;
  final double lat;
  final double lng;

  const MapPicker(
      {Key? key, this.zoom = 14.4746, required this.lat, required this.lng})
      : super(key: key);

  @override
  State<MapPicker> createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? latlong;
  @override
  void initState() {
    latlong = LatLng(widget.lat, widget.lng);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            var maxWidth = constraints.biggest.width;
            var maxHeight = constraints.biggest.height;

            return Stack(
              children: <Widget>[
                SizedBox(
                  height: maxHeight,
                  width: maxWidth,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: latlong!,
                      zoom: widget.zoom,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    onCameraMove: (CameraPosition newPosition) {
                      // print(newPosition.target.toJson());
                      latlong = newPosition.target;
                    },
                    mapType: MapType.normal,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: false,
                    zoomGesturesEnabled: true,
                    padding: const EdgeInsets.all(0),
                    buildingsEnabled: true,
                    cameraTargetBounds: CameraTargetBounds.unbounded,
                    compassEnabled: true,
                    indoorViewEnabled: false,
                    mapToolbarEnabled: true,
                    minMaxZoomPreference: MinMaxZoomPreference.unbounded,
                    rotateGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    tiltGesturesEnabled: true,
                    trafficEnabled: false,
                  ),
                ),
                Positioned(
                  bottom: maxHeight / 2,
                  right: (maxWidth - 30) / 2,
                  child: const Icon(
                    Icons.person_pin_circle,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 30,
                  child: Container(
                    color: Colors.white,
                    child: IconButton(
                      onPressed: () async {
                        var position = await _determinePosition();
                        final GoogleMapController controller =
                            await _controller.future;
                        controller.animateCamera(CameraUpdate.newCameraPosition(
                            CameraPosition(
                                target: LatLng(
                                    position.latitude, position.longitude),
                                zoom: widget.zoom)));
                      },
                      icon: const Icon(Icons.my_location),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
