import 'package:path_provider/path_provider.dart';

import '../../../../objectbox.g.dart';

class BaseBox {
  /// override this to change Box name
  final String boxName;
  BaseBox({required this.boxName});

  Store? _store;

  Future<Store> get lazyStore async {
    if (_store != null) return _store!;

    // if _store is null we instantiate it
    final dir = await getApplicationDocumentsDirectory();
    _store = Store(
      getObjectBoxModel(),
      directory: "${dir.path}/$boxName",
    );

    return _store!;
  }
}
