import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hudayi/services/map_service.dart';
import 'package:hudayi/ui/widgets/action_Bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> with AutomaticKeepAliveClientMixin<MapPage> {
  @override
  bool get wantKeepAlive => true;
  final Completer<GoogleMapController> _controller = Completer();
  final List<Marker> _markers = <Marker>[];
  BitmapDescriptor? allIcon;
  BitmapDescriptor? studentsIcon;
  BitmapDescriptor? studentsIconFemale;
  BitmapDescriptor? teachersIcon;
  BitmapDescriptor? branchesIcon;
  @override
  void initState() {
    () async {
      await FirebaseAnalytics.instance.logEvent(
        name: 'google_map_page',
        parameters: {
          'screen_name': "google_map_page",
          'screen_class': "profile",
        },
      );
      BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(1, 1)), 'assets/images/branchMarker.png').then((d) {
        branchesIcon = d;
      });
      BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(1, 1)), 'assets/images/maleMarker.png').then((d) {
        studentsIcon = d;
      });
      BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(1, 1)), 'assets/images/teacherMarker.png').then((d) {
        teachersIcon = d;
      });
      BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(22, 22)), 'assets/images/marker.png').then((d) {
        allIcon = d;
      });
      BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(22, 22)), 'assets/images/femaleMarker.png').then((d) {
        studentsIconFemale = d;
      });
      await [
        Permission.location,
      ].request();
    }();

    super.initState();
  }

  List items = ["الأساتذة", "الطلاب", "المراكز", "الكل"];
  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    double? x0 = 0;
    double x1 = 0;
    double y0 = 0;
    double y1 = 0;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0!, y0));
  }

  LatLng currentPosition = const LatLng(41.015137, 28.979530);
  moveCamera(LatLng target) {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: target,
      zoom: 8.0,
    )));
  }

  late GoogleMapController _mapController;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  ClipRRect(
                    child: GoogleMap(
                      mapType: MapType.normal,
                      zoomGesturesEnabled: true,
                      myLocationEnabled: true,
                      markers: Set<Marker>.of(_markers),
                      initialCameraPosition: CameraPosition(
                        target: currentPosition,
                        zoom: 8,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                        _mapController = controller;
                        setState(() {
                          Set<Marker>.of(_markers);
                        });
                      },
                    ),
                  ),
                  const Positioned(
                    child: ActionBar(
                      menuseItem: [],
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        for (var item in items)
                          Padding(
                            padding: const EdgeInsets.only(left: 0, right: 05, top: 5, bottom: 5),
                            child: GestureDetector(
                              child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  color: item == "المراكز"
                                      ? Theme.of(context).primaryColor
                                      : item == "الطلاب"
                                          ? const Color(0XFFE9C46A)
                                          : const Color(0XFFF4A261),
                                  borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(item,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  _markers.clear();
                                });

                                List categoriesItems = item == "المراكز"
                                    ? [
                                        {"description": "هذا الجامع جيد", "lat": 41.0191087, "lng": 28.9475298, "name": "جامع أبو علي", "gender": "m"}
                                      ]
                                    : item == "الطلاب"
                                        ? [
                                            {
                                              "name": "بيت وائل",
                                              "lat": 41.02079553502111,
                                              "lng": 28.94334738149157,
                                              "description": "بيت الوحش الحقيقي المفترس",
                                              "gender": "f"
                                            },
                                            {
                                              "name": "بيت عب اللطيف",
                                              "lat": 41.02436251647543,
                                              "lng": 28.952178249453965,
                                              "description": "بيت يحتوي على أعضاء بشريى",
                                              "gender": "f"
                                            }
                                          ]
                                        : item == "الأساتذة"
                                            ? [
                                                {
                                                  "description": "الأستاذ أبو علي",
                                                  "lat": 41.324234,
                                                  "lng": 28.23423424,
                                                  "name": "أستاذ جيد",
                                                  "gender": "m"
                                                }
                                              ]
                                            : [
                                                {
                                                  "name": "بيت وائل",
                                                  "lat": 41.02079553502111,
                                                  "lng": 28.94334738149157,
                                                  "description": "بيت الوحش الحقيقي المفترس",
                                                  "gender": "m",
                                                },
                                                {
                                                  "name": "بيت عب اللطيف",
                                                  "lat": 41.02436251647543,
                                                  "lng": 28.952178249453965,
                                                  "description": "بيت يحتوي على أعضاء بشريى",
                                                  "gender": "f",
                                                },
                                                {
                                                  "description": "الأستاذ أبو علي",
                                                  "lat": 41.324234,
                                                  "lng": 28.23423424,
                                                  "name": "أستاذ جيد",
                                                  "gender": "m",
                                                },
                                                {
                                                  "description": "هذا الجامع جيد",
                                                  "lat": 41.0191087,
                                                  "lng": 28.9475298,
                                                  "name": "جامع أبو علي",
                                                  "gender": "m",
                                                }
                                              ];
                                moveCamera(LatLng(categoriesItems[0]["lat"], categoriesItems[0]["lng"]));
                                for (var element in categoriesItems) {
                                  _markers.add(Marker(
                                      markerId: MarkerId('${element['lat']}_${element['lng']}'),
                                      icon: item == "المراكز"
                                          ? branchesIcon!
                                          : item == "الطلاب"
                                              ? studentsIcon!
                                              : item == "الأساتذة"
                                                  ? teachersIcon!
                                                  : allIcon!,
                                      position: LatLng(double.parse(element['lat'].toString()), double.parse(element['lng'].toString())),
                                      infoWindow: InfoWindow(
                                          title: element['name'],
                                          snippet: element['description'],
                                          onTap: () {
                                            MapsLauncher.launchCoordinates(element['lat'], element['lng'], element['name']);
                                          })));
                                }
                                setState(() {
                                  Set<Marker>.of(_markers);
                                });
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
