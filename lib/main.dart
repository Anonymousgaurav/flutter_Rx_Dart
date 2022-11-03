import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends HookWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Caches the instance of a complex object.
// useMemoized will immediately call valueBuilder on first call and store its result. Later, when the HookWidget rebuilds,
// the call to useMemoized will return the previously created instance without calling valueBuilder.
    final subject = useMemoized(
      () => BehaviorSubject<String>(),
      [key],
    );

    /// Useful for side-effects and optionally canceling them.
    // useEffect is called synchronously on every build, unless keys is specified. In which case useEffect is called again only
    // if any value inside keys as changed.
    // It takes an effect callback and calls it synchronously. That effect may optionally return a function,
    // which will be called when the effect is called again or if the widget is disposed.
    // By default effect is called on every build call, unless keys is specified.

    /// The following example call useEffect to subscribes to a Stream and cancels the subscription when the widget is disposed.
    /// Also if the Stream changes, it will cancel the listening on the previous Stream and listen to the new one.
    useEffect(() => subject.close, [subject]);

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<String>(
          /// distinct Skips data events if they are equal to the previous data event.
             /// Transforms a [Stream] so that will only emit items from the source
             /// sequence whenever the time span defined by [duration] passes, without the
             /// source sequence emitting another item.

             /// This time span start after the last debounced event was emitted.
             ///
             /// debounceTime filters out items emitted by the source [Stream] that are
             /// rapidly followed by another emitted item.
          stream: subject.distinct().debounceTime(const Duration(seconds: 1)),
          initialData: 'Please start Typing......',
          builder: (context,snapshot){
            return Text(snapshot.requireData);

          },
        ),
      ),
      body: Padding(padding: EdgeInsets.all(8.0),child: TextField(
          onChanged: subject.sink.add
      ),)
    );
  }
}
