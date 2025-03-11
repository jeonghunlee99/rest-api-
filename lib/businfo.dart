import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class BusInfoPage extends ConsumerStatefulWidget  {
  @override
  _BusInfoPageState createState() => _BusInfoPageState();
}

class _BusInfoPageState extends  ConsumerState<BusInfoPage> {
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchBusInfo();
  }

  Future<List<busInfo>> fetchBusInfo() async {
    try {
      // API 호출 URL
      final String url = 'http://apis.data.go.kr/1613000/BusRoutespecificStopInformation/getBusRoutespecificStopInformation';


      // 인증키 (Encoding된 인증키)
      final String serviceKey =
          'Hmyyh9ZiYNt4vOZZdasLtsfACBE+bL/+2PevBXn00OmYRdYQUZsHzJt+Lup4p4MK3m4HnRlV8Sy043CoDzm7Lg==';

      // 요청 파라미터 설정
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

      // API 호출
      final response = await _dio.get(url, queryParameters: queryParameters);

      // 응답 데이터 출력 (JSON)
      if (response.statusCode == 200) {
        print('Response Data: ${response.data}');
        final jsonData =response.data;

        print('jsonData: ${jsonData}');


        List<busInfo> infoList = [];
        final item = jsonData['Response']['body']['items']['item'];

        print('Item: $item');

        for (var i in item){

          print('Bus Info Item: $i'); // 각 항목 확인

          busInfo businfo = busInfo(
            sttnseq: i['sttn_seq'], // sttn_seq
            sttnid: i['sttn_id'], // sttn_id
            ctpvnm: i['ctpv_nm'], // ctpv_nm
            sttnnm: i['sttn_nm'], // sttn_nm
            rteNo: i['rte_no'], // rte_no
            emdnm: i['emd_nm'], // emd_nm
            sggnm: i['sgg_nm'], // sgg_nm
            emdcd: i['emd_cd'],
            sggcd: i['sgg_cd'],
            oprymd: i['opr_ymd'],
            rtenm: i['rte_nm'], // rte_nm
          );

          print(' 여기입니다 BusInfo: ${businfo.sttnseq}, ${businfo.sttnnm}, ${businfo.sttnid}, ${businfo.ctpvnm}, ${businfo.rteNo}, ${businfo.rtenm}');
          infoList.add(businfo);

        }
        ref.read(busInfoProvider.notifier).state = infoList;
        return infoList;
      } else {
        print('Error: ${response.statusCode}');
        return[];
      }
    } catch (e) {
      print('Error occurred: $e');
      return[];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('버스 노선 정보'),
      ),
      body: Center(
        child: Text('버스 노선 정보를 받아옵니다.'),
      ),
    );
  }
}

final busInfoProvider = StateProvider<List<busInfo>> ((ref)=> [] );

class busInfo {
  final int? sttnseq;
  final String? sttnid;
  final String? ctpvnm;
  final String? sttnnm;
  final String? rteNo;
  final String? emdnm;
  final String? sggnm;
  final String? emdcd;
  final String? sggcd;
  final String? oprymd;
  final String? rtenm;

  busInfo({
    required this.sttnseq,
    required this.sttnid,
    required this.ctpvnm,
    required this.sttnnm,
    required this.rteNo,
    required this.emdnm,
    required this.sggnm,
    required this.emdcd,
    required this.sggcd,
    required this.oprymd,
    required this.rtenm,
  });
}
