part of 'imperative_flutter.dart';

/// Interface to display only in the necessary methods of [ImperativeProvider]
abstract class ImperativeProviderContract {
  /// Update state of ImperativeBuilder registered in [ImperativeProvider].
  ///
  /// The [id] must be registered in [ImperativeProvider] scope.
  void setState<T>(String id, T state);

  void updateState<T>(String id, T Function(T current) builder);

  /// Get current state of ImperativeBuilder using [id].
  ///
  /// The [id] must be registered in [ImperativeProvider] scope.
  T getState<T>(String id);

  void listenerState<T>(String id, void onChange(T current));
}
