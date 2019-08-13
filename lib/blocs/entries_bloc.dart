import 'package:informe_pastran_app/models/entry_model.dart';
import 'package:informe_pastran_app/services/api_service.dart';

import 'package:rxdart/rxdart.dart';

class EntriesBloc {

  final apiService = ApiService();

  EntriesBloc();

  BehaviorSubject<List<Entry>> _entriesController = BehaviorSubject();
  Stream<List<Entry>> get entries => _entriesController.stream;

  BehaviorSubject<bool> _loading = BehaviorSubject.seeded(false);
  Stream<bool> get loading => _loading.stream;

  void getEntries() async {
    _loading.sink.add(true);
    List<Entry> entries = await apiService.getEntries();
    _entriesController.sink.add(entries);
    _loading.sink.add(false);
  }

  void dispose() {
    _entriesController.close();
    _loading.close();
  }
}