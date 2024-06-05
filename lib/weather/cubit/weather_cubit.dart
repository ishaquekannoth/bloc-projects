import 'package:blocprojects/weather/models/weather.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_repository/weather_repository.dart';

part 'weather_state.dart';

@JsonSerializable()
class WeatherCubit extends HydratedCubit<WeatherState> {
  final WeatherRepository weatherRepository;
  WeatherCubit(this.weatherRepository) : super(WeatherState());

  Future<void> fetchWeather({String? city}) async {
    if (city == null || city.isEmpty) {
      return;
    } else {
      try {
        emit(state.copyWith(weatherStatus: WeatherStatus.loading));
        final weather =
            Weather.fromRepository(await weatherRepository.getWeather(city));
        final tempUnits = state.temperatureUnits;
        final double tempValue = tempUnits.isFahrenheit
            ? weather.temperature.value.toFahrenheit()
            : weather.temperature.value;

        emit(state.copyWith(
            weather:
                weather.copyWith(temperature: Temperature(value: tempValue)),
            temperatureUnits: tempUnits,
            weatherStatus: WeatherStatus.success));
      } on Exception{
        emit(state.copyWith(weatherStatus: WeatherStatus.failure));
      }
    }
  }

  @override
  WeatherState? fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic>? toJson(WeatherState state) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}

extension on double {
  double toFahrenheit() => (this * 9 / 5) + 32;
  double toCelsius() => (this - 32) * 5 / 9;
}
