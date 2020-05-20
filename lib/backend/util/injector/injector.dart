import 'package:crux/backend/util/injector/type_factory.dart';

import 'injector_exception.dart';

typedef ObjectFactoryFn<T> = T Function(Injector injector);
typedef ObjectFactoryWithParamsFn<T> = T Function(
  Injector injector,
  Map<String, dynamic> additionalParameters,
);

class Injector {
  static final injector = Injector._internal();

  /// Map of factories by each type of object registered
  final _factories = <String, TypeFactory<Object>>{};

  Injector._internal();

  String _makeKey<T>(T type, [String key]) => '${type.toString()}::${key ?? 'default'}';

  /// Make a key from the object type
  void map<T>(ObjectFactoryFn<T> factoryFn, {bool isSingleton = false, String key}) {
    final objectKey = _makeKey(T, key);
    if (_factories.containsKey(objectKey)) {
      throw InjectorException("Mapping already exists for type '$objectKey'");
    }
    _factories[objectKey] =
        TypeFactory<T>((injector, params) => factoryFn(injector), isSingleton);
  }

  void mapWithParams<T>(ObjectFactoryWithParamsFn<T> factoryFn, {String key}) {
    final objectKey = _makeKey(T, key);
    if (_factories.containsKey(objectKey)) {
      throw InjectorException('Mapping already exists for type "$objectKey"');
    }
    _factories[objectKey] = TypeFactory<T>(factoryFn, false);
  }

  T get<T>({String key, Map<String, dynamic> additionalParameters}) {
    final objectKey = _makeKey(T, key);
    final objectFactory = _factories[objectKey];
    if(objectFactory == null) {
      throw InjectorException("Cannot find object factory for '$objectKey");
    }
    return objectFactory.get(this, additionalParameters);
  }

  void dispose() {
    _factories.clear();
  }
}
