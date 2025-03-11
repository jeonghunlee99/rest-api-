// businfo_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'businfo_controller.dart';
import 'businfo_data.dart';

class BusInfoPage extends ConsumerStatefulWidget {
  @override
  _BusInfoPageState createState() => _BusInfoPageState();
}

class _BusInfoPageState extends ConsumerState<BusInfoPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBusInfo();
  }

  Future<void> fetchBusInfo() async {
    setState(() {
      _isLoading = true;
    });

    final busInfoController = BusInfoController();
    await busInfoController.fetchBusInfo(ref);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final busInfoList = ref.watch(busInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('버스 노선 정보'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : busInfoList.isEmpty
          ? Center(child: Text('버스 노선 정보가 없습니다.'))
          : ListView.builder(
        itemCount: busInfoList.length,
        itemBuilder: (context, index) {
          final bus = busInfoList[index];
          return ListTile(
            title: Text(bus.sttnnm ?? 'No Name'),
            subtitle: Text('버스 노선: ${bus.rteNo}'),
          );
        },
      ),
    );
  }
}
