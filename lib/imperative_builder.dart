part of 'imperative_flutter.dart';

/// [ImperativeBuilder] is responsible for store the state of our widget and
/// reconstructing it when that state is changed, note that the id must be
/// unique for each [ImperativeProvider] Scope.
class ImperativeBuilder<T> extends StatefulWidget {
  final T initial;
  final String id;
  final Widget Function(BuildContext context, T state) builder;

  ImperativeBuilder({
    Key? key,
    required this.id,
    required this.builder,
    required this.initial,
  }) : super(key: key);

  @override
  _ImperativeBuilderState<T> createState() => _ImperativeBuilderState<T>();
}

class _ImperativeBuilderState<T> extends State<ImperativeBuilder> {
  late final _widget = widget as ImperativeBuilder<T>;
  late final _handler = ImperativeStateHandler<T>(
    ImperativeState(id: _widget.id, value: _widget.initial),
  );
  late final provider = ImperativeProvider._of(context);

  @override
  void initState() {
    provider._registerStateHandler(_handler);
    _handler.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _widget.builder(context, _handler.state.value);
  }

  @override
  void dispose() {
    provider._unregisterStateHandler(_widget.id);
    super.dispose();
  }
}
