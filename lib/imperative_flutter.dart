library imperative_flutter;

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

abstract class ImperativeProviderI {
  void setState<T>(String id, T state);
  T getState<T>(String id);
}

class ImperativeProvider extends InheritedWidget
    implements ImperativeProviderI {
  ImperativeProvider({Key key, @required Widget child})
      : super(key: key, child: child);

  final Map<String, BehaviorSubject> _builders = {};

  void _registerBuilder(String id, BehaviorSubject controller) {
    assert(!_builders.containsKey(id),
        'the id $id has already been registered by a ImperativeBuilder');
    _builders.addAll({id: controller});
  }

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

  BehaviorSubject _getBuilderController(String id) {
    assert(_builders.containsKey(id),
        'the id $id was not registered by any ImperativeBuilder');
    return _builders[id];
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  static ImperativeProviderI of(BuildContext context) => context
      .getElementForInheritedWidgetOfExactType<ImperativeProvider>()
      .widget as ImperativeProviderI;

  static ImperativeProvider _of(BuildContext context) => context
      .getElementForInheritedWidgetOfExactType<ImperativeProvider>()
      .widget;
}

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
