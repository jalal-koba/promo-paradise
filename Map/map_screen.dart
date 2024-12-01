import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:promo/app/Institutions/models/institution.dart';
import 'package:promo/app/Map/Models/location.dart';

import 'package:promo/app/Map/cubit/map_cubit.dart';
import 'package:promo/app/Widget/app_loading.dart';
import 'package:promo/app/Widget/try_agin.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, this.institutions, this.location});
  static const String routeName = "/map-returant-category";
  final List<Institution>? institutions;
  final Location? location;
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          if (widget.institutions != null) {
             return MapCubit()
              ..showInstitutions(institutions: widget.institutions!);
          }
          return MapCubit()..goToLocation(location: widget.location!);
        },
        child: BlocConsumer<MapCubit, MapState>(
          listener: (context, state) {
           

             if (state is NoPermmitionsState) {
              Geolocator.requestPermission();
            }
            if (state is GoToLocationState) {
              GoRouter.of(context).push(
                "/institution-details-screen/${state.institionId}",
              );
            }
          },
          builder: (context, state) {
            final MapCubit mapCubit = MapCubit.get(context);
            if (state is MapLoadingState) {
              return const AppLoading();
            } else if (state is MapSuccessState || state is GoToLocationState) {
              return GoogleMap(
                  markers: mapCubit.marker,
                  initialCameraPosition: mapCubit.initialCameraPosition);
            }
            if (state is MapErrorState) {
              return TryAgain(onTap: () {
                if (widget.institutions != null) {
                  context
                      .read<MapCubit>()
                      .showInstitutions(institutions: widget.institutions!);
                } else {
                  context
                      .read<MapCubit>()
                      .goToLocation(location: widget.location!);
                }
              });
            }
            return const AppLoading();
          },
        ),
      ),
    );
  }
}
