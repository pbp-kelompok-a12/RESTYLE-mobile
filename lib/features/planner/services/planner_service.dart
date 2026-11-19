import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';

class PlannerService {
  PlannerService({ApiClient? apiClient}) : _api = apiClient ?? ApiClient();

  final ApiClient _api;

  String _url(String path, [Map<String, String>? query]) {
    final uri = Uri.parse('${ApiConstants.planner}$path');
    return query == null ? uri.toString() : uri.replace(queryParameters: query).toString();
  }

  Future<Map<String, dynamic>> getWeek(DateTime week) => _api.get(
        _url('week/', {'week': _date(week)}),
        authenticated: true,
      );

  Future<Map<String, dynamic>> getSettings() =>
      _api.get(_url('settings/'), authenticated: true);

  Future<Map<String, dynamic>> updateSettings({
    required List<int> laundryWeekdays,
    required int laundryTimeDays,
  }) =>
      _api.patch(
        _url('settings/'),
        authenticated: true,
        body: {
          'laundry_weekdays': laundryWeekdays,
          'laundry_time_days': laundryTimeDays,
        },
      );

  Future<Map<String, dynamic>> getOutfits(DateTime date, {String? weatherCategory}) {
    final query = <String, String>{'date': _date(date)};
    if (weatherCategory != null && weatherCategory.isNotEmpty) {
      query['weather_category'] = weatherCategory;
    }
    return _api.get(_url('outfits/', query), authenticated: true);
  }

  Future<Map<String, dynamic>> savePlan(DateTime date, int outfitId) =>
      _api.post(
        _url('plans/'),
        authenticated: true,
        body: {'date': _date(date), 'outfit_id': outfitId},
      );

  Future<Map<String, dynamic>> deletePlan(DateTime date) =>
      _api.delete(_url('plans/${_date(date)}/'), authenticated: true);

  Future<Map<String, dynamic>> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) =>
      _api.get(
        _url('weather/current/', {
          'latitude': '$latitude',
          'longitude': '$longitude',
        }),
        authenticated: true,
      );

  Future<Map<String, dynamic>> getForecast({
    required DateTime date,
    required double latitude,
    required double longitude,
  }) =>
      _api.get(
        _url('weather/forecast/', {
          'date': _date(date),
          'latitude': '$latitude',
          'longitude': '$longitude',
        }),
        authenticated: true,
      );

  Future<List<Map<String, dynamic>>> searchLocations(String name) async {
    final response = await _api.get(
      _url('locations/search/', {'name': name}),
      authenticated: true,
    );
    final locations = response['locations'];
    if (locations is! List) return const [];
    return locations
        .whereType<Map>()
        .map((location) => Map<String, dynamic>.from(location))
        .toList();
  }

  static String _date(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-'
      '${value.month.toString().padLeft(2, '0')}-'
      '${value.day.toString().padLeft(2, '0')}';
}
