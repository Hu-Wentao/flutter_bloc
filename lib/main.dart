import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Streams Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<IncrementBloc>(
        /// 这里使用一个 Provider
        bloc: IncrementBloc(),
        child: CounterPage(),
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final IncrementBloc bloc = BlocProvider.of<IncrementBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text('使用Stream的计数器')),
      body: Center(
        child: StreamBuilder<int>(
            // StreamBuilder控件中没有任何处理业务逻辑的代码
            stream: bloc.outCounter,
            initialData: 0,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return Text('You hit me: ${snapshot.data} times');
            }),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          bloc.incrementCounter.add(null);
        },
      ),
    );
  }
}

/// BLoC 核心
class IncrementBloc implements BlocBase {
  int _counter;

  /// 处理counter的stream
  StreamController<int> _counterController = StreamController<int>();
  // 供内部调用, 输入以 in 开头
  StreamSink<int> get _inAdd => _counterController.sink; // sink,向Stream输入
  // 供外部调用, 输出以 out 开头
  Stream<int> get outCounter => _counterController.stream;// stream, 输出控制?

  // 处理业务逻辑的stream, 即处理用户点击等事件
  StreamController _actionController = StreamController();
  // 暴露给外部, 提供处理方法, 计数器增加
  StreamSink get incrementCounter => _actionController.sink;

  // 构造器
  IncrementBloc() {
    _counter = 0;
    _actionController.stream.listen(_handleLogic);
  }

  // 释放资源
  void dispose() {
    _actionController.close();
    _counterController.close();
  }

  // 监听到事件后调用的处理逻辑
  void _handleLogic(data) {
    _counter = _counter + 1;
    _inAdd.add(_counter);
  }

}

///#######################################################################
// 所有 BLoCs 的通用接口
abstract class BlocBase {
  void dispose();
}

// 通用的 BLoC provider, 它是一个StatefulWidget, 尽量不要使用 InheritedWidget
class BlocProvider<T extends BlocBase> extends StatefulWidget {
  BlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);

  final T bloc;
  final Widget child;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context) {
    final type = _typeOf<BlocProvider<T>>();
    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T> extends State<BlocProvider<BlocBase>> {
  @override
  void dispose() {
    super.dispose();
    widget.bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
