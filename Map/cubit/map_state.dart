part of 'map_cubit.dart';

abstract class MapState {}

class MapInitialState extends MapState {}

class MapLoadingState extends MapState {}

class MapSuccessState extends MapState {}

class MapErrorState extends MapState {
  final String type;
  MapErrorState({
    required this.type,
  });
}

class NoPermmitionsState extends MapState {}

class GoToLocationState extends MapState {
  final int institionId;

  GoToLocationState({required this.institionId});
}
