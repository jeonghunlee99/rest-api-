import 'package:flutter_riverpod/flutter_riverpod.dart';

final busInfoProvider = StateProvider<List<busInfo>>((ref) => []);


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
