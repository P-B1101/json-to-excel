import 'package:file_picker/file_picker.dart';
import 'package:isolated_worker/js_isolated_worker.dart';
import 'package:universal_html/html.dart';
import 'package:universal_html/js.dart' as js;

const List<String> _jsScripts = <String>['func.js'];
const String _jsCreateBlobFunc = 'createBlob';
const String _jsCreateExcelFunc = 'createExcel';
const String _jsDownloadBlobFunc = 'downloadBlob';

abstract class JSDataSource {
  Future<String?> createBlob(Blob source);

  Future<Blob?> createExcel(List<List<String>> data, String sheetName);

  Future<bool> downloadBlob({
    required String url,
    required String name,
  });

  Future<PlatformFile?> getJsonFile();
}

class JSDataSourceImpl implements JSDataSource {
  final JsIsolatedWorker worker;
  final FilePicker filePicker;
  bool _areScriptsImported = false;

  JSDataSourceImpl({
    required this.worker,
    required this.filePicker,
  });

  @override
  Future<String?> createBlob(Blob source) async {
    if (!_areScriptsImported) {
      await worker.importScripts(_jsScripts);
      _areScriptsImported = true;
    }
    return await worker.run(
      functionName: _jsCreateBlobFunc,
      arguments: source,
    );
  }

  @override
  Future<Blob?> createExcel(List<List<String>> data, String sheetName) async {
    if (!_areScriptsImported) {
      await worker.importScripts(_jsScripts);
      _areScriptsImported = true;
    }
    final result = await worker.run(
      functionName: _jsCreateExcelFunc,
      arguments: [data, sheetName],
    );
    return result;
  }

  @override
  Future<bool> downloadBlob({
    required String url,
    required String name,
  }) async {
    try {
      await js.context.callMethod(_jsDownloadBlobFunc, [url, name]);
      return true;
    } catch (error) {
      // ignore: avoid_print
      print(error);
      return false;
    }
  }

  @override
  Future<PlatformFile?> getJsonFile() async {
    final files = await filePicker.pickFiles(
      allowMultiple: false,
      allowedExtensions: ['json'],
      type: FileType.custom,
    );
    if (files == null || files.files.isEmpty) return null;
    if (files.files.first.extension != 'json') return null;
    return files.files.first;
  }
}
