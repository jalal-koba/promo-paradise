import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location_package;
import 'package:promo/Apis/network.dart';
import 'package:promo/Apis/urls.dart';
import 'package:promo/app/Institutions/models/institution.dart';
import 'package:promo/app/Institutions/models/section_details_response.dart';
import 'package:promo/app/Map/Models/location.dart';
import 'package:promo/constant/app_assets.dart';
part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapInitialState());
  static MapCubit get(context) => BlocProvider.of(context);

  Completer<GoogleMapController> controller = Completer();

  static Location? myLocation;
  static location_package.Location location = location_package.Location();

  static late location_package.PermissionStatus _permissionGranted;
  static late location_package.LocationData _locationData;

  static onLocationChange() async {
    addCoustomIcon();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == location_package.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != location_package.PermissionStatus.granted) {
        myLocation = null;
        return;
      }
    }
    _locationData = await location.getLocation();
    myLocation = Location(
        lat: "${_locationData.latitude!}", long: "${_locationData.longitude!}");

    location.onLocationChanged
        .listen((location_package.LocationData currentLocation) {
      myLocation = Location(
          lat: "${currentLocation.latitude!}",
          long: "${currentLocation.longitude!}");
    });
  }

  late double lat;
  late double long;
  static late BitmapDescriptor imageMarker;
  Set<Marker> marker = {};

  late CameraPosition initialCameraPosition;

  static void addCoustomIcon() {
    BitmapDescriptor.asset(const ImageConfiguration(), AppAssets.marker).then(
      (icon) {
        imageMarker = icon;
      },
    );
  }

  void addMarkers({
    required List<Institution> institutions,
  }) {
    for (Institution institution in institutions) {
      marker.add(
        Marker(
            markerId: MarkerId("${DateTime.now().millisecondsSinceEpoch}"),
            infoWindow: InfoWindow(
              title: institution.name,
              onTap: () {
                emit(GoToLocationState(institionId: institution.id));
              },
            ),
            draggable: true,
            flat: true,
            position: LatLng(
              double.parse(institution.latitude),
              double.parse(institution.longitude),
            ),
            icon: imageMarker),
      );
    }
  }

  Future<void> showInstitutions(
      {required List<Institution> institutions}) async {
    if (myLocation != null) {
      addMarkers(institutions: institutions);

      emit(MapSuccessState());
    }
  }

  Future goToLocation({required Location location}) async {
    emit(MapLoadingState());
    initialCameraPosition = CameraPosition(
      zoom: 12,
      target: LatLng(
        double.parse(location.lat),
        double.parse(location.long),
      ),
    );

    marker.add(Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        markerId: MarkerId("${DateTime.now().millisecondsSinceEpoch}"),
        position: LatLng(
          double.parse(location.lat),
          double.parse(location.long),
        )));

    emit(MapSuccessState());
  }

  late List<Institution> institutions;

  Future<void> getNearbyInstitutions() async {
    SectionDetailsResponse sectionDetailsResponse;

    double lat;
    double lng;
    try {
      if (myLocation == null) {
        await onLocationChange();
        myLocation = myLocation;
      } else {
        myLocation = myLocation;
      }

      if (myLocation != null) {
        lat = double.parse(myLocation!.lat);
        lng = double.parse(myLocation!.long);
        marker.add(
          Marker(
            infoWindow: const InfoWindow(title: "My location"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
            markerId: const MarkerId("my-location"),
            position: LatLng(lat, lng),
          ),
        );
      } else {
        //  if the user dont give permission for his location the initial posstion in capital of canda
        lat = 45.424721;
        lng = -75.695000;
      }
      initialCameraPosition = CameraPosition(target: LatLng(lat, lng), zoom: 4.5);

      Response response = await Network.getData(
          url: Urls.getNearbyInstitutions(
              lat: lat.toString(), lng: lng.toString()));
      sectionDetailsResponse = SectionDetailsResponse.fromJson(response.data);

      institutions = sectionDetailsResponse.data;

      addMarkers(
        institutions: institutions,
      );

      emit(MapSuccessState());
    } on DioException {
      emit(MapErrorState(type: "type"));
    }
  }
}
