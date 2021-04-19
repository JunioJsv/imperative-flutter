# Imperative Flutter

Manage the state of your widgets using imperative programming concepts.

## Setup
Intall imperative_flutter package in pubspec.yaml
```yaml
dependencies:
  imperative_flutter: ^0.0.2
```
Then it's just import in your code
```dart
import 'package:imperative_flutter/imperative_flutter.dart';
```
## Usage
**ImperativeProvider** is responsible for storing and handling the references for **ImperativeBuilder**, it can be _global scope_ when **MaterialApp** is his child or _local scope_ when **Scaffold** is your child.
```dart

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ImperativeProvider(
      child: MaterialApp(
        title: 'Imperative Flutter Demo',
        home: MyHomePage(),
      ),
    );
  }
}
```

**ImperativeBuilder** is responsible for store the state of our widget and reconstructing it when that state is changed, note that the id must be unique for each ImperativeProvider Scope.
```dart
// Inside StatelessWidget

ImperativeBuilder<int>(
    id: 'count',
    initialData: 0,
    /* the builder method will be called every time the state changes,
    updating only the widget within the scope */
    builder: (context, snapshot) {
        return Container(
            height: 48,
            width: 48,
            color: Colors.pink,
            child: Center(
                child: Text(
                    '${snapshot.data}',
                    style: TextStyle(color: Colors.white),
                  ),
            ),
        );
    },
),

// ...

class Whatever extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get instance of ImperativeProvider
    final imperative = ImperativeProvider.of(context);

    return ElevatedButton.icon(
            onPressed: () {
                // Get current state of ImperativeBuilder where id equal 'count'
                final value = imperative.getState<int>('count');
                // Set state of ImperativeBuilder where id equal 'count' and rebuild
                imperative.setState('count', value + 1);
            },
            icon: Icon(Icons.add),
            label: Text('plus'),
    ),
  }
```
