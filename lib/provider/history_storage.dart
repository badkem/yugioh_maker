
part of 'provider.dart';

class HistoryStorage {
  Future<List<String>> getListHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var list = prefs.getStringList('history');
      return list!;
    } catch (e) {
      return [];
    }
  }

  Future saveHistory(History history) async {
    var list = await getListHistory();
    list.add(jsonDecode(jsonEncode(history)));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('history', list);
  }

  Future updateHistory(List<String> items) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('history', items);
  }
}