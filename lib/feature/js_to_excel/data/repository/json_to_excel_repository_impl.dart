import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../domain/repository/json_to_excel_repository.dart';
import '../data_source/js_data_source.dart';

@LazySingleton(as: JsonToExcelRepository)
class JsonToExcelRepositoryImpl implements JsonToExcelRepository {
  final JSDataSource dataSource;
  const JsonToExcelRepositoryImpl({
    required this.dataSource,
  });

  @override
  Stream<String> startJsonToExcelProccess() async* {
    const delay = Duration(milliseconds: 1000);
    try {
      yield 'start proccess...';
      final file = await dataSource.getJsonFile();
      final bytes = file?.bytes;
      if (file == null || bytes == null) {
        yield 'process canceled.';
        return;
      }
      final name = file.name.substring(0, file.name.lastIndexOf('.'));
      yield 'file selected. converting content to json string...';
      final jsonData = utf8.decode(bytes);
      await Future.delayed(delay);
      yield 'content converted to string. convert it to map...';
      Map<String, dynamic> map = json.decode(jsonData);
      await Future.delayed(delay);
      yield 'string content converted to map. convert it to list of list...';
      List<List<String>> items = [];
      final temp = map.entries.toList();
      for (int i = 0; i < temp.length; i++) {
        items.add([temp[i].key, temp[i].value.toString()]);
      }
      await Future.delayed(delay);
      yield 'final list is ready. convert it to excel...';
      final result = await dataSource.createExcel(items, name);
      await Future.delayed(delay);
      if (result == null) {
        yield 'failed to create excel!';
        return;
      }
      yield 'excel is ready. create url from blob...';
      final url = await dataSource.createBlob(result);
      await Future.delayed(delay);
      if (url == null) {
        yield 'failed to create url from blob!';
        return;
      }
      yield 'blob url is ready. request for download...';
      final isDownloaded = await dataSource.downloadBlob(
        url: url,
        name: '$name-json-to-excel.xlsx',
      );
      await Future.delayed(delay);
      if (isDownloaded) {
        yield 'excel file downloaded request sent. proccess finished successfully';
        return;
      }
      yield 'fail to download excel file!';
    } catch (error) {
      await Future.delayed(delay);
      yield 'process failed with error $error';
    }
  }

  @override
  Stream<String> startExcelToJsonProccess() async* {
    const delay = Duration(milliseconds: 1000);
    try {
      yield 'start proccess...';
      final file = await dataSource.getExcelFile();
      final bytes = file?.bytes;
      if (file == null || bytes == null) {
        yield 'process canceled.';
        return;
      }
      final name = file.name.substring(0, file.name.lastIndexOf('.'));
      yield 'file selected. converting content to list of json...';
      final jsonData = await dataSource.parseExcel(bytes);
      yield 'list is ${jsonData.toString()}';
      // final jsonData = utf8.decode(bytes);
      // await Future.delayed(delay);
      // yield 'content converted to string. convert it to map...';
      // Map<String, dynamic> map = json.decode(jsonData);
      // await Future.delayed(delay);
      // yield 'string content converted to map. convert it to list of list...';
      // List<List<String>> items = [];
      // final temp = map.entries.toList();
      // for (int i = 0; i < temp.length; i++) {
      //   items.add([temp[i].key, temp[i].value.toString()]);
      // }
      // await Future.delayed(delay);
      // yield 'final list is ready. convert it to excel...';
      // final result = await dataSource.createExcel(items, name);
      // await Future.delayed(delay);
      // if (result == null) {
      //   yield 'failed to create excel!';
      //   return;
      // }
      // yield 'excel is ready. create url from blob...';
      // final url = await dataSource.createBlob(result);
      // await Future.delayed(delay);
      // if (url == null) {
      //   yield 'failed to create url from blob!';
      //   return;
      // }
      // yield 'blob url is ready. request for download...';
      // final isDownloaded = await dataSource.downloadBlob(
      //   url: url,
      //   name: '$name-json-to-excel.xlsx',
      // );
      // await Future.delayed(delay);
      // if (isDownloaded) {
      //   yield 'excel file downloaded request sent. proccess finished successfully';
      //   return;
      // }
      // yield 'fail to download excel file!';
    } catch (error) {
      await Future.delayed(delay);
      yield 'process failed with error $error';
    }
  }
}
