import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/transaction_list.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();

  //chi cho phep xoay ngang
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.landscapeLeft,
  //   DeviceOrientation.landscapeRight,
  // ]);

//chi cho  phep xoay doc man hinh
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.amber,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber)
            .copyWith(secondary: Colors.lightBlueAccent),
        fontFamily: 'Quicksand',
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  bool _showChart = false;

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  void _addNewTransactions({
    required String title,
    required double amount,
    required DateTime date,
  }) {
    Transaction trans = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: date,
    );
    setState(() {
      _userTransactions.add(trans);
    });
  }

  void _startAddNewTransactions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(
              addTx: _addNewTransactions,
            ),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTransaction(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Platform.isIOS
          ? CupertinoAlertDialog(
              title: const Text('Alert'),
              content: const Text('Proceed with destructive action?'),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                    child: const Text('Yes'),
                    isDestructiveAction: true,
                    onPressed: () {
                      setState(
                        () {
                          _userTransactions.removeWhere((tx) {
                            return tx.id == id;
                          });
                        },
                      );
                    }),
              ],
            )
          : AlertDialog(
              title: const Text('Delete !'),
              content: const Text('Do you want to delete this transaction?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Cancel');
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'OK');
                    setState(() {
                      _userTransactions.removeWhere((tx) {
                        return tx.id == id;
                      });
                    });
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
    );

    // setState(() {
    //   _userTransactions.removeWhere((tx) {
    //     return tx.id == id;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isShowLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
      actions: [
        IconButton(
          onPressed: () => _startAddNewTransactions(context),
          icon: const Icon(Icons.add),
        ),
        IconButton(
          icon: const Icon(Icons.change_history),
          onPressed: () {},
        )
      ],
      centerTitle: true,
      title: const Text(
        "Expensis",
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
    );
    final appBarCupertino = CupertinoNavigationBar(
      middle: const Text('Pesional Expensis'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _startAddNewTransactions(context),
            child: const Icon(CupertinoIcons.add),
          ),
        ],
      ),
    );
    final txListWidgets = SizedBox(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(
          transactions: _userTransactions, deleteTx: _deleteTransaction),
    );

    final pageBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (isShowLandscape)
            ..._buildLandscapeContent(
              context,
              mediaQuery,
              appBar,
              txListWidgets,
            ),
          if (!isShowLandscape)
            ..._buildPortraintContent(
              mediaQuery,
              appBar,
              txListWidgets,
            ),
        ],
      ),
    ));

    return SafeArea(
      child: Platform.isIOS
          ? CupertinoPageScaffold(
              child: pageBody,
              navigationBar: appBarCupertino,
            )
          : Scaffold(
              appBar: appBar,
              body: pageBody,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: FloatingActionButton(
                onPressed: () => _startAddNewTransactions(context),
                child: const Icon(Icons.add),
              ),
            ),
    );
  }

  List<Widget> _buildPortraintContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget txListWidgets,
  ) {
    return [
      SizedBox(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(
          recentTransactions: _recentTransactions,
        ),
      ),
      txListWidgets
    ];
  }

  List<Widget> _buildLandscapeContent(
    BuildContext context,
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget txListWidgets,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Show Chart', style: Theme.of(context).textTheme.headline6),
          Switch.adaptive(
              value: _showChart,
              onChanged: (value) {
                setState(() {
                  _showChart = value;
                });
              }),
        ],
      ),
      _showChart
          ? SizedBox(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(
                recentTransactions: _recentTransactions,
              ),
            )
          : txListWidgets
    ];
  }
}
