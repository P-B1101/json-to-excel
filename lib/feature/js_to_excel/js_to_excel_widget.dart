import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:isolated_worker/js_isolated_worker.dart';
import 'package:rxdart/rxdart.dart';

import 'js_data_source.dart';
import 'json_to_excel_repository.dart';

class JsToExcelWidget extends StatefulWidget {
  const JsToExcelWidget({super.key});

  @override
  State<JsToExcelWidget> createState() => _JsToExcelWidgetState();
}

class _JsToExcelWidgetState extends State<JsToExcelWidget> {
  final JsonToExcelRepository _repository = JsonToExcelRepositoryImpl(
    dataSource: JSDataSourceImpl(
      worker: JsIsolatedWorker(),
      filePicker: FilePicker.platform,
    ),
  );

  final _streamController = BehaviorSubject<String>();
  StreamSubscription? _listener;
  String _logs = '';

  @override
  void dispose() {
    _streamController.close();
    _listener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            _buttonWidget,
            _logWidget,
          ],
        ),
      ),
    );
  }

  Widget get _buttonWidget => Builder(
        builder: (context) => Container(
          width: 200,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).primaryColor,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: _selectFile,
              child: const Center(
                child: Text(
                  'Select File',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ),
      );

  Widget get _logWidget => Builder(
        builder: (context) => StreamBuilder<String>(
          initialData: '',
          stream: _streamController,
          builder: (context, snapshot) {
            _logs = '$_logs${snapshot.data}\n';

            return SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Text(_logs),
              ),
            );
          },
        ),
      );

  void _selectFile() {
    _listener = _repository.startProccess().listen(_streamController.add);
  }
}
