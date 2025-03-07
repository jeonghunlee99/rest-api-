import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AirQualityService {
  final Dio dio = Dio();
  final String apiKey =
      "Hmyyh9ZiYNt4vOZZdasLtsfACBE%2BbL%2F%2B2PevBXn00OmYRdYQUZsHzJt%2BLup4p4MK3m4HnRlV8Sy043CoDzm7Lg%3D%3D";
  final String baseUrl = "http://apis.data.go.kr/B552584/ArpltnInforInqireSvc/";

  Future<List<AirQualityItem>> fetchAirQuality() async {
    String url =
        "${baseUrl}getMsrstnAcctoRltmMesureDnsty?serviceKey=$apiKey&"
        "returnType=json&numOfRows=1&pageNo=1&stationName=종로구&dataTerm=DAILY&ver=1.3";

    Dio dio = Dio();

    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        final jsonData = response.data;
        List<AirQualityItem> airQualityList = [];
        final items = jsonData['response']['body']['items'];

        for (var i in items) {
          AirQualityItem airQuality = AirQualityItem(
            pm25Grade1h: i["pm25Grade1h"] ?? "0",
            pm10Value24: i["pm10Value24"] ?? "0",
            so2Value: i["so2Value"] ?? "0",
            pm10Grade1h: i["pm10Grade1h"] ?? "0",
            o3Grade: i["o3Grade"] ?? "0",
            pm10Value: i["pm10Value"] ?? "0",
            khaiGrade: i["khaiGrade"] ?? "0",
            pm25Value: i["pm25Value"] ?? "0",
            mangName: i["mangName"] ?? "0",
            no2Value: i["no2Value"] ?? "0",
            so2Grade: i["so2Grade"] ?? "0",
            khaiValue: i["khaiValue"] ?? "0",
            coValue: i["coValue"] ?? "0",
            no2Grade: i["no2Grade"] ?? "0",
            pm25Value24: i["pm25Value24"] ?? "0",
            pm25Grade: i["pm25Grade"] ?? "0",
            coGrade: i["coGrade"] ?? "0",
            dataTime: i["dataTime"] ?? "",
            pm10Grade: i["pm10Grade"] ?? "0",
            o3Value: i["o3Value"] ?? "0",
          );
          airQualityList.add(airQuality);
        }

        return airQualityList;
      } else {
        print("API 호출 실패: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("오류 발생: $e");
      return [];
    }
  }
}



final airQualityProvider = StateProvider<List<AirQualityItem>>((ref) => []);

class AirQualityItem {
  final String pm25Grade1h;
  final String pm10Value24;
  final String so2Value;
  final String pm10Grade1h;
  final String o3Grade;
  final String pm10Value;
  final String? pm25Flag;
  final String khaiGrade;
  final String pm25Value;
  final String? no2Flag;
  final String mangName;
  final String no2Value;
  final String so2Grade;
  final String? coFlag;
  final String khaiValue;
  final String coValue;
  final String? pm10Flag;
  final String no2Grade;
  final String pm25Value24;
  final String? o3Flag;
  final String pm25Grade;
  final String? so2Flag;
  final String coGrade;
  final String dataTime;
  final String pm10Grade;
  final String o3Value;

  AirQualityItem({
    required this.pm25Grade1h,
    required this.pm10Value24,
    required this.so2Value,
    required this.pm10Grade1h,
    required this.o3Grade,
    required this.pm10Value,
    this.pm25Flag,
    required this.khaiGrade,
    required this.pm25Value,
    this.no2Flag,
    required this.mangName,
    required this.no2Value,
    required this.so2Grade,
    this.coFlag,
    required this.khaiValue,
    required this.coValue,
    this.pm10Flag,
    required this.no2Grade,
    required this.pm25Value24,
    this.o3Flag,
    required this.pm25Grade,
    this.so2Flag,
    required this.coGrade,
    required this.dataTime,
    required this.pm10Grade,
    required this.o3Value,
  });
}
