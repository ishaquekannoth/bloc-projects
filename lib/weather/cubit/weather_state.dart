part of 'weather_cubit.dart';

enum WeatherStatus { initial, loading, success, failure }

extension WeatherStatusX on WeatherStatus {
  bool get isInitial => this == WeatherStatus.initial;
  bool get isLoading => this == WeatherStatus.loading;
  bool get isSuccess => this == WeatherStatus.success;
  bool get isFailure => this == WeatherStatus.failure;
}

class WeatherState extends Equatable {
  WeatherState(
      {this.weatherStatus = WeatherStatus.initial,
      Weather? weather,
      this.temperatureUnits = TemperatureUnits.celsius})
      : weather = weather ?? Weather.empty;

  final WeatherStatus weatherStatus;
  final Weather? weather;
  final TemperatureUnits temperatureUnits;

  @override
  List<Object?> get props => [weatherStatus, weather, temperatureUnits];

  WeatherState copyWith({
    WeatherStatus? weatherStatus,
    Weather? weather,
    TemperatureUnits? temperatureUnits,
  }) {
    return WeatherState(
      weatherStatus: weatherStatus ?? this.weatherStatus,
      weather: weather ?? this.weather,
      temperatureUnits: temperatureUnits ?? this.temperatureUnits,
    );
  }
}
