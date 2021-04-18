/// Manage the state of your widgets using imperative programming concepts.
library imperative_flutter;

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

/// Interface to display only in the necessary methods of [ImperativeProvider]
abstract class ImperativeProviderI {
  /// Updade state of ImperativeBuilder registred in [ImperativeProvider].
  ///
  /// The [id] must be registred in [ImperativeProvider] scope.
  void setState<T>(String id, T state);

  /// Get current state of ImperativeBuilder using [id].
  ///
  /// The [id] must be registred in [ImperativeProvider] scope.
  T getState<T>(String id);
}

/// [ImperativeProvider] is responsible for storing and handling the
/// references for [ImperativeBuilder], it can be global scope when
/// [MaterialApp] is his child or local scope when [Scaffold] is your child.
class ImperativeProvider extends InheritedWidget
    implements ImperativeProviderI {
  /// [child] is inside in scope of [ImperativeProvider]
  ImperativeProvider({Key key, @required Widget child})
      : super(key: key, child: child);

  /// Map to store state of [ImperativeBuilder]
  final Map<String, BehaviorSubject> _builders = {};

  /// Register a [ImperativeBuilder] with [id] in [_builders] of [ImperativeProvider]
  void _registerBuilder(String id, BehaviorSubject controller) {
    assert(!_builders.containsKey(id),
        'the id $id has already been registered by a ImperativeBuilder');
    _builders.addAll({id: controller});
  }

  /// Remove [ImperativeBuilder] with [id] of [_builders]
  void _unregisterBuilder(String id) {
    assert(!_builders.containsKey(id),
        'the id $id was not registered by any ImperativeBuilder');
    _builders.remove(id);
  }

  @override
  void setState<T>(String id, T state) {
    _getBuilderController(id).add(state);
  }

  @override
  T getState<T>(String id) {
    final value = _getBuilderController(id).value;
    assert(value is T,
        'type $T is divergent from the registered ImperativeBuilder<${value.runtimeType}> by id $id');
    return value;
  }

  /// Get state of ImperativeBuilder if [id] has registred in [_builders]
  BehaviorSubject _getBuilderController(String id) {
    assert(_builders.containsKey(id),
        'the id $id was not registered by any ImperativeBuilder');
    return _builders[id];
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  /// Get instace of [ImperativeProviderI] in scope of [context]
  static ImperativeProviderI of(BuildContext context) => context
      .getElementForInheritedWidgetOfExactType<ImperativeProvider>()
      .widget as ImperativeProviderI;

  /// Get instace of [ImperativeProvider] in scope of [context]
  static ImperativeProvider _of(BuildContext context) => context
      .getElementForInheritedWidgetOfExactType<ImperativeProvider>()
      .widget;
}

/// [ImperativeBuilder] is responsible for store the state of our widget and
/// reconstructing it when that state is changed, note that the id must be
/// unique for each [ImperativeProvider] Scope.
class ImperativeBuilder<T> extends StatefulWidget {
  final T initialData;
  final String id;
  final Widget Function(BuildContext context, AsyncSnapshot<T> snapshot)
      builder;

  ImperativeBuilder(
      {Key key, @required this.id, @required this.builder, this.initialData})
      : super(key: key);

  @override
  _ImperativeBuilderState<T> createState() => _ImperativeBuilderState<T>();
}

class _ImperativeBuilderState<T> extends State<ImperativeBuilder> {
  BehaviorSubject<T> _controller;

  @override
  void initState() {
    _controller =
        BehaviorSubject.seeded((widget as ImperativeBuilder<T>).initialData);
    super.initState();
  }

  /// Responsible to store dispose function
  void Function(String id) _disposeBuilder;

  @override
  Widget build(BuildContext context) {
    final provider = ImperativeProvider._of(context);

    provider._registerBuilder(widget.id, _controller);
    _disposeBuilder = provider._unregisterBuilder;

    return StreamBuilder<T>(
      stream: _controller.stream,
      builder: (widget as ImperativeBuilder<T>).builder,
    );
  }

  @override
  void dispose() {
    _controller.close();
    _disposeBuilder(widget.id);
    super.dispose();
  }
}
