import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

@JsonSerializable()
class Weather {
  const Weather({required this.temperature, required this.weatherCode});
  final double temperature;
  @JsonKey(name: 'weathercode')
  final double weatherCode;
  Map<String, dynamic> toJson() => _$WeatherToJson(this);
  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
}
