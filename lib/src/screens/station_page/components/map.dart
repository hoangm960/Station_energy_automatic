import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';
import 'package:ocean_station_auto/src/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ocean_station_auto/src/models/station.dart';

class StationMap extends StatefulWidget {
  final int index;
  final Station station;
  const StationMap({Key? key, required this.index, required this.station})
      : super(key: key);

  @override
  State<StationMap> createState() => _StationMapState();
}

class _StationMapState extends State<StationMap> {
  late LatLng _currentLocation;
  late MapController controller;

  @override
  void initState() {
    super.initState();
    _currentLocation =
        LatLng(widget.station.location.x, widget.station.location.y);
    controller = MapController(
      location: _currentLocation,
    );
  }

  void _gotoDefault() {
    controller.center =
        LatLng(widget.station.location.x, widget.station.location.y);
    setState(() {});
  }

  void _onDoubleTap() {
    controller.zoom += 0.5;
    setState(() {});
  }

  Offset? _dragStart;
  double _scaleStart = 1.0;
  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      controller.zoom += 0.01;
      setState(() {});
    } else if (scaleDiff < 0) {
      controller.zoom -= 0.01;
      setState(() {});
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart!;
      _dragStart = now;
      controller.drag(diff.dx, diff.dy);
      setState(() {});
    }
  }

  Widget _buildMarkerWidget(Offset pos, Color color) {
    return Positioned(
      left: pos.dx - 16,
      top: pos.dy - 16,
      width: 24,
      height: 24,
      child: Icon(Icons.location_on, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.zoom = 8;
    return Container(
        margin: const EdgeInsets.all(18.0),
        height: getScreenSize(context).height - 18.0 * 2 - 100,
        color: Colors.black45,
        child: MapLayoutBuilder(
            controller: controller,
            builder: (context, transformer) {
              final homeLocation =
                  transformer.fromLatLngToXYCoords(_currentLocation);
              final homeMarkerWidget =
                  _buildMarkerWidget(homeLocation, Colors.red);
              return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onDoubleTap: _onDoubleTap,
                  onScaleStart: _onScaleStart,
                  onScaleUpdate: _onScaleUpdate,
                  onLongPress: _gotoDefault,
                  child: Listener(
                    behavior: HitTestBehavior.opaque,
                    onPointerSignal: (event) {
                      if (event is PointerScrollEvent) {
                        final delta = event.scrollDelta * 5;

                        controller.zoom -= delta.dy / 1000.0;
                        setState(() {});
                      }
                    },
                    child: Stack(
                      children: [
                        Map(
                          controller: controller,
                          builder: (context, x, y, z) {
                            final url =
                                'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';

                            return CachedNetworkImage(
                              imageUrl: url,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                        homeMarkerWidget,
                      ],
                    ),
                  ));
            }));
  }
}
