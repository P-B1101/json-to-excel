import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../injectable_container.dart';
import '../../domain/use_case/start_excel_to_json_process.dart';
import '../../domain/use_case/start_json_to_excel_process.dart';

class JsToExcelPage extends StatefulWidget {
  const JsToExcelPage({super.key});

  @override
  State<JsToExcelPage> createState() => _JsToExcelPageState();
}

class _JsToExcelPageState extends State<JsToExcelPage> {
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
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _jsonToExcelButtonWidget,
                  _excelToJsonButtonWidget,
                ],
              ),
              const SizedBox(height: 16),
              _logWidget,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _jsonToExcelButtonWidget => Builder(
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
              onTap: _selectJsonFile,
              child: const Center(
                child: Text(
                  'Select Json File',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ),
      );

  Widget get _excelToJsonButtonWidget => Builder(
        builder: (context) => Container(
          width: 200,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: _selectExcelFile,
              child: const Center(
                child: Text(
                  'Select XLSX File',
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
            _logs = '$_logs\n${snapshot.data}';
            return SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                  alignment: AlignmentDirectional.topStart,
                  child: Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Text(_logs),
                  ),
                ),
              ),
            );
          },
        ),
      );

  void _selectJsonFile() {
    _logs = '';
    _listener =
        getIt<StartJsonToExcelProcess>()().listen(_streamController.add);
  }

  void _selectExcelFile() {
    _logs = '';
    _listener =
        getIt<StartExcelToJsonProcess>()().listen(_streamController.add);
  }
}
