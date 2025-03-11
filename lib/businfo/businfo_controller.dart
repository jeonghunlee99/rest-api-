// businfo_controller.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'businfo_data.dart';

class BusInfoController {
  final Dio _dio = Dio();


  Future<List<busInfo>> fetchBusInfo(WidgetRef   ref) async {
    try {

      final String url = 'http://apis.data.go.kr/1613000/BusRoutespecificStopInformation/getBusRoutespecificStopInformation';


      final String serviceKey = 'Hmyyh9ZiYNt4vOZZdasLtsfACBE+bL/+2PevBXn00OmYRdYQUZsHzJt+Lup4p4MK3m4HnRlV8Sy043CoDzm7Lg==';


      final queryParameters = {
        'serviceKey': serviceKey,
        'pageNo': '1',
        'numOfRows': '10',
        'opr_ymd': '20240501',
        'rte_id': '00000001',
        'ctpv_cd': '29',
        'sgg_cd': '29140',
        'dataType': 'JSON',
      };


      final response = await _dio.get(url, queryParameters: queryParameters);


      if (response.statusCode == 200) {
        final jsonData = response.data;
        List<busInfo> infoList = [];
        final item = jsonData['Response']['body']['items']['item'];

        for (var i in item) {
          busInfo businfo = busInfo(
            sttnseq: i['sttn_seq'],
            sttnid: i['sttn_id'],
            ctpvnm: i['ctpv_nm'],
            sttnnm: i['sttn_nm'],
            rteNo: i['rte_no'],
            emdnm: i['emd_nm'],
            sggnm: i['sgg_nm'],
            emdcd: i['emd_cd'],
            sggcd: i['sgg_cd'],
            oprymd: i['opr_ymd'],
            rtenm: i['rte_nm'],
          );
          infoList.add(businfo);
        }
        ref.read(busInfoProvider.notifier).state = infoList;
        return infoList;
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error occurred: $e');
      return [];
    }
  }
}
