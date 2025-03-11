import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusPage extends ConsumerWidget  {


  void _fetchAndPrintData(WidgetRef ref) async {
    String busRouteId = "100100118"; // 테스트할 버스 노선 ID
    List<Businfo> buses = await BusApiService(ref: ref).fetchBusLocation(busRouteId);

    for (var bus in buses) {
      print("🚌 버스 ID: ${bus.vehId}, 타입: ${bus.busType}");
      print("📍 GPS 위치: (${bus.gpsY}, ${bus.gpsX})");
      print("🚦 혼잡도: ${bus.congestion}, 노선 순서: ${bus.sectOrd}");
      print("--------------------------");
    }
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text("버스 정보 조회")),
      body: Center(
        child: ElevatedButton(
          onPressed:() => _fetchAndPrintData(ref), // 버튼 클릭 시 API 호출 및 print() 실행
          child: Text("버스 위치 정보 가져오기"),
        ),
      ),
    );
  }
}

class BusApiService {
  final WidgetRef ref;
  final Dio _dio = Dio();

  BusApiService({required this.ref});
  final String apiKey =
      "Hmyyh9ZiYNt4vOZZdasLtsfACBE+bL/+2PevBXn00OmYRdYQUZsHzJt+Lup4p4MK3m4HnRlV8Sy043CoDzm7Lg=="; // 여기에 실제 API 키를 입력하세요.

  Future<List<Businfo>> fetchBusLocation(String busRouteId) async {
    final String url =
        "http://ws.bus.go.kr/api/rest/buspos/getBusPosByRtid?serviceKey=$apiKey&busRouteId=$busRouteId&_type=json";

    try {
      Response response = await _dio.get(url);

      if (response.statusCode == 200) {


        final jsonData = response.data;

        List<Businfo> infoList = [];
        final foritems = jsonData['response']['msgBody']['itemList'];

        for(var i in foritems){
          Businfo businfo = Businfo(
            vehId: i['vehId'] ?? "N/A",
            busType: i['busType'] ?? "N/A",
            gpsX: double.tryParse(i['gpsX']?.toString() ?? "0.0") ?? 0.0,
            gpsY: double.tryParse(i['gpsY']?.toString() ?? "0.0") ?? 0.0,
            sectOrd: int.tryParse(i['sectOrd']?.toString() ?? "0") ?? 0, // sectOrd는 String -> int로 변환
            congestion: i['congestion'] ?? "정보 없음", // 혼잡도는 String

          );
          infoList.add(businfo);
        }
        print("🔹 API 응답 데이터:");
        print(response.data);
        ref.read(busInfolistProvider.notifier).state = infoList;
        return infoList;
      } else {
        print("❌ 오류 발생: ${response.statusCode}");
        return []; // 예외 발생 시 빈 리스트 반환
      }
    } catch (e) {
      print("❌ 예외 발생: $e");
      return []; // 예외 발생 시 빈 리스트 반환
    }
  }
}

final busInfolistProvider = StateProvider<List<Businfo>> ((ref)=> []);

class Businfo {
  final String vehId;
  final String busType;
  final double gpsX;
  final double gpsY;
  final int sectOrd;
  final String congestion;

  Businfo({
    required this.vehId,
    required this.busType,
    required this.gpsX,
    required this.gpsY,
    required this.sectOrd,
    required this.congestion,
  });
}
