import 'package:flutter/widgets.dart';

class ImperativeStateHandler<T> extends ChangeNotifier {
  ImperativeState<T> _state;

  ImperativeStateHandler(this._state);

  ImperativeState<T> get state => _state;

  void setState(T value) {
    ImperativeState<T> _new = _state.copyWith(state: value);
    if (_new != _state) {
      _state = _new;
      notifyListeners();
    }
  }
}

class ImperativeState<T> extends ChangeNotifier {
  final String id;
  final T value;

  ImperativeState({required this.id, required this.value});

  ImperativeState<T> copyWith({String? id, T? state}) {
    return ImperativeState(
      id: id ?? this.id,
      value: state ?? this.value,
    );
  }
}
