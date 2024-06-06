import 'package:blocprojects/weather/models/weather.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_repository/weather_repository.dart'
    show WeatherRepository;

part 'weather_cubit.g.dart';
part 'weather_state.dart';

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
      } on Exception {
        emit(state.copyWith(weatherStatus: WeatherStatus.failure));
      }
    }
  }

  Future<void> refreshWeather() async {
    if (!state.weatherStatus.isSuccess) return;
    if (state.weather == Weather.empty) return;
    try {
      emit(state.copyWith(weatherStatus: WeatherStatus.loading));
      final weather = Weather.fromRepository(
          await weatherRepository.getWeather(state.weather!.location));
      final tempUnits = state.temperatureUnits;
      final double tempValue = tempUnits.isFahrenheit
          ? weather.temperature.value.toFahrenheit()
          : weather.temperature.value;

      emit(state.copyWith(
          weather: weather.copyWith(temperature: Temperature(value: tempValue)),
          temperatureUnits: tempUnits,
          weatherStatus: WeatherStatus.success));
    } on Exception {
      emit(state);
    }
  }

  void toggleUnits() {
    final TemperatureUnits unit = state.temperatureUnits.isCelsius
        ? TemperatureUnits.fahrenheit
        : TemperatureUnits.celsius;
    if (!state.weatherStatus.isSuccess) {
      emit(state.copyWith(temperatureUnits: unit));
    }
    final weather = state.weather;
    if (weather != Weather.empty) {
      final temperature = weather!.temperature;
      final convertedUnit = unit.isCelsius
          ? temperature.value.toCelsius()
          : temperature.value.toFahrenheit();
      emit(state.copyWith(
          temperatureUnits: unit,
          weather: weather.copyWith(
              temperature: Temperature(value: convertedUnit))));
    }
  }

  @override
  WeatherState fromJson(Map<String, dynamic> json) =>
      WeatherState.fromJson(json);

  @override
  Map<String, dynamic> toJson(WeatherState state) => state.toJson();
}

extension on double {
  double toFahrenheit() => (this * 9 / 5) + 32;
  double toCelsius() => (this - 32) * 5 / 9;
}
