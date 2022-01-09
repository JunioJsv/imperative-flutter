part of 'imperative_flutter.dart';

/// [ImperativeProvider] is responsible for storing and handling the
/// references for [ImperativeBuilder], it can be global scope when
/// [MaterialApp] is his child or local scope when [Scaffold] is your child.
class ImperativeProvider extends InheritedWidget
    implements ImperativeProviderContract {
  /// [child] is inside in scope of [ImperativeProvider]
  ImperativeProvider({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  /// Map to store state of [ImperativeBuilder]
  final Map<String, ImperativeStateHandler> _states = {};

  /// Register a [ImperativeStateHandler] with [id] in [_states] of [ImperativeProvider]
  void _registerStateHandler(ImperativeStateHandler handler) {
    if (_states.containsKey(handler.state.id))
      throw ArgumentError.value(handler, 'Already been registered',
          'the id ${handler.state.id} has already been registered by a ImperativeBuilder');
    _states[handler.state.id] = handler;
  }

  /// Remove [ImperativeStateHandler] with [id] of [_states]
  void _unregisterStateHandler(String id) {
    if (!_states.containsKey(id))
      throw ArgumentError.value(id, 'Not registered',
          'the id $id was not registered by any ImperativeBuilder');
    _states.remove(id);
  }

  @override
  void setState<T>(String id, T value) {
    final _handler = _getStateHandler<T>(id);
    _handler.setState(value);
  }

  @override
  void updateState<T>(String id, T Function(T current) builder) {
    final _handler = _getStateHandler<T>(id);
    final _new = builder(_handler.state.value);
    _handler.setState(_new);
  }

  @override
  T getState<T>(String id) {
    final state = _getStateHandler<T>(id).state.value;

    return state;
  }

  @override
  void listenerState<T>(String id, void Function(T current) onChange) {
    final _handler = _getStateHandler<T>(id);

    _handler.addListener(() {
      onChange(_handler.state.value);
    });
  }

  /// Get state of ImperativeBuilder if [id] has registered in [_states]
  ImperativeStateHandler<T> _getStateHandler<T>(String id) {
    if (!_states.containsKey(id))
      throw ArgumentError.value(id, 'Not registered',
          'the id $id was not registered by any ImperativeBuilder');
    return _states[id]! as ImperativeStateHandler<T>;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  /// Get instance of [ImperativeProviderContract] in scope of [context]
  static ImperativeProviderContract of(BuildContext context) => context
      .getElementForInheritedWidgetOfExactType<ImperativeProvider>()!
      .widget as ImperativeProviderContract;

  /// Get instance of [ImperativeProvider] in scope of [context]
  static ImperativeProvider _of(BuildContext context) => context
      .getElementForInheritedWidgetOfExactType<ImperativeProvider>()!
      .widget as ImperativeProvider;
}
