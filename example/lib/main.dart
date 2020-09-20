import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter App',
      home: MyHomePage(title: 'Counter App Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool hasLongPressedText = false;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        key: const Key('drawer'),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: const Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              // Provide a Key to this specific Text Widget. This allows us
              // to identify this specific Widget from inside our test suite and
              // read the text.
              key: const Key('counter'),
              style: Theme.of(context).textTheme.headline4,
            ),
            FlatButton(
              key: Key('openPage2'),
              child: Text('Open page 2'),
              onLongPress: () {
                Future.delayed(
                    Duration(seconds: 12),
                    () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PageTwo()),
                        ));
              },
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PageTwo()),
                );
              },
            ),
            GestureDetector(
              onLongPress: () {
                setState(() {
                  hasLongPressedText = true;
                });
              },
              child: Container(
                color:
                    hasLongPressedText ? Colors.blueGrey : Colors.transparent,
                child: Text(
                  hasLongPressedText
                      ? 'Text has been long pressed!'
                      : 'Text that has not been long pressed',
                  key: const Key('longPressText'),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Provide a Key to this the button. This allows us to find this
        // specific button and tap it inside the test suite.
        key: const Key('increment'),
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('pageTwo'),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Page 2'),
      ),
      body: SafeArea(
        child: Center(
          child: Text('Contents of page 2'),
        ),
      ),
    );
  }
}
