import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

enum WeatherCondition {
  clear,
  rainy,
  cloudy,
  snowy,
  unknown,
}

@JsonSerializable()
class WeatherModel extends Equatable {
  final WeatherCondition condition;
  final String location;
  final double temperature;

  const WeatherModel(
      {required this.condition,
      required this.location,
      required this.temperature});
  @override
  List<Object?> get props => [condition, location, temperature];
  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherModelToJson(this);
}
