
class NullUtil {
  static bool notNull(Object o) => o != null;
}

class Nullable<T> {
  T _value;

  Nullable(this._value);

  T get value {
    return _value;
  }
}