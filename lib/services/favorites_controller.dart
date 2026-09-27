import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesController extends ChangeNotifier {
  FavoritesController(this._preferences)
      : _favoriteIds =
            _preferences.getStringList(_storageKey)?.toSet() ?? <String>{};

  static const _storageKey = 'cookmate-favorites';
  final SharedPreferences _preferences;
  Set<String> _favoriteIds;

  bool contains(String id) => _favoriteIds.contains(id);

  int get count => _favoriteIds.length;

  void toggle(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds = {..._favoriteIds}..remove(id);
    } else {
      _favoriteIds = {..._favoriteIds, id};
    }
    _preferences.setStringList(_storageKey, _favoriteIds.toList());
    notifyListeners();
  }
}