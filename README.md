# Imperative Flutter

Manage the state of your widgets using imperative programming concepts.

## Setup
Install imperative_flutter package in pubspec.yaml
```yaml
dependencies:
  imperative_flutter: ^1.0.0
```
Then it's just import in your code
```dart
import 'package:imperative_flutter/imperative_flutter.dart';
```
## Usage
**ImperativeProvider** is responsible for storing state and handling the references for **ImperativeBuilder**, it can be _global scope_ when **MaterialApp** is his child or _local scope_ when **Scaffold** is your child.
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

**ImperativeBuilder** is responsible for reconstructing it when that state is changed, note that the id must be unique for each ImperativeProvider Scope.
```dart
// Inside StatelessWidget

ImperativeBuilder<int>(
    id: 'count',
    initialData: 0,
    /* the builder method will be called every time the state changes,
    updating only the widget within the scope */
    builder: (context, state) {
        return Container(
            height: 48,
            width: 48,
            color: Colors.pink,
            child: Center(
                child: Text(
                    '$state',
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
    final provider = ImperativeProvider.of(context);

    return ElevatedButton.icon(
            onPressed: () {
                // Set state of ImperativeBuilder where id equal 'count' and rebuild
                provider.updateState<int>('count', (current) => current + 1);
            },
            icon: Icon(Icons.add),
            label: Text('plus'),
    ),
  }
```
