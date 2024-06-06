import 'package:blocprojects/weather/models/weather.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:weather_repository/weather_repository.dart' as weather_repo;


class ThemeCubit extends HydratedCubit<Color> {
  ThemeCubit() : super(defaultColor);
  static const defaultColor = Color(0xFF2196F3);

  void updateTheme(Weather? weather) {
    if (weather != null) emit(weather.toColor);
  }

  @override
  Color fromJson(Map<String, dynamic> json) {
    return Color(int.parse(json['color'] as String));
  }

  @override
  Map<String, dynamic> toJson(Color state) {
    return <String, String>{'color': '${state.value}'};
  }
}

extension on Weather {
  Color get toColor {
    switch (weatherCondition) {
      case weather_repo.WeatherCondition.clear:
        return Colors.yellow;
      case weather_repo.WeatherCondition.snowy:
        return Colors.lightBlueAccent;
      case weather_repo.WeatherCondition.cloudy:
        return Colors.blueGrey;
      case weather_repo.WeatherCondition.rainy:
        return Colors.indigoAccent;
      case weather_repo.WeatherCondition.unknown:
        return ThemeCubit.defaultColor;
    }
  }
}
