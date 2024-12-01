import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:promo/app/Map/Models/location.dart';
import 'package:promo/app/Map/cubit/map_cubit.dart';
import 'package:promo/app/Widget/app_loading.dart';
import 'package:promo/app/Widget/try_agin.dart';
import 'package:sizer/sizer.dart';

class HomeMapScreen extends StatefulWidget {
  const HomeMapScreen({super.key, required this.institutionsLocations});
  final List<Location> institutionsLocations;

  @override
  State<HomeMapScreen> createState() => _HomeMapScreenState();
}

class _HomeMapScreenState extends State<HomeMapScreen> {
  final MapCubit mapCubit = MapCubit();
  @override
  void initState() {
    mapCubit.getNearbyInstitutions();
    super.initState();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        body: BlocProvider(
          create: (context) => mapCubit,
          child: SafeArea(
            bottom: false,
            child: BlocConsumer<MapCubit, MapState>(listener: (context, state) {
              if (state is MapErrorState) {
                if (state.type == "no-permmitions") {}
              }

              if (state is NoPermmitionsState) {
                Geolocator.requestPermission();
              }
              if (state is GoToLocationState) {
                GoRouter.of(context).push(
                  "/institution-details-screen/${state.institionId}",
                );
              }
            }, builder: (context, state) {
              final MapCubit mapCubit = MapCubit.get(context);

              if (state is MapLoadingState) {
                return const AppLoading();
              }

              if (state is MapErrorState) {
                return TryAgain(onTap: () {
                  mapCubit.getNearbyInstitutions();
                });
              }
              if (state is MapSuccessState || state is GoToLocationState) {
                return Stack(children: [
                  SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: GoogleMap(
                      padding:
                          EdgeInsets.symmetric(vertical: 10.h, horizontal: 6.w),
                      mapType: MapType.normal,
                      markers: mapCubit.marker,
                      initialCameraPosition: mapCubit.initialCameraPosition,
                    ),
                  ),
                ]);
              }

              return const AppLoading();
            }),
          ),
        ));
  }

  // Function to display the dialog to enable location services
}
