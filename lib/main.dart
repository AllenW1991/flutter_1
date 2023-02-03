import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/chart.dart';
import 'package:flutter_complete_guide/widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';

void main() => {
      // WidgetsFlutterBinding.ensureInitialized(),
      // SystemChrome.setPreferredOrientations(
      //   [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
      // ),
      runApp(MyApp())
    };

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: ThemeData(
        fontFamily: 'OpenSans',
        errorColor: Colors.amber[900],
        textTheme: ThemeData.light().textTheme.copyWith(
              titleMedium: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
              fontFamily: 'FiraCode',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(secondary: Colors.red),
      ),
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  @override
  State<_MyHomePage> createState() => __MyHomePageState();
}

class __MyHomePageState extends State<_MyHomePage> {
  final List<Transaction> _userTransaction = [
    Transaction(
      id: 't1',
      title: 'T-Shirt',
      amount: 10.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Pants',
      amount: 25.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't3',
      title: 'Glasses',
      amount: 8.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't4',
      title: 'Glasses',
      amount: 8.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't5',
      title: 'Glasses',
      amount: 8.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't6',
      title: 'Glasses',
      amount: 8.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't7',
      title: 'Glasses',
      amount: 8.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't8',
      title: 'Glasses',
      amount: 8.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't9',
      title: 'Glasses',
      amount: 8.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't10',
      title: 'Glasses',
      amount: 8.99,
      date: DateTime.now(),
    ),
  ];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransaction.where((transaction) {
      return transaction.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
        title: txTitle,
        amount: txAmount,
        date: chosenDate,
        id: '${DateTime.now()}');

    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere(
        (transaction) => transaction.id == id,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = 2 < 3
        ? CupertinoNavigationBar(
            middle: Text('Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () => _startAddNewTransaction(context),
                  child: Icon(CupertinoIcons.add),
                ),
              ],
            ),
          )
        : AppBar(
            title: Text(
              '<==Expenses==>',
            ),

            // IconButton(
            //   onPressed: () => _startAddNewTransaction(context),
            //   icon: Icon(
            //     Icons.add,
            //   ),
            // ),
          );

    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransaction, _deleteTransaction),
    );

    final appBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Show Chart'),
                  Switch.adaptive(
                    value: _showChart,
                    onChanged: (value) {
                      setState(
                        () {
                          _showChart = value;
                        },
                      );
                    },
                  ),
                ],
              ),
            if (!isLandscape)
              Container(
                height: (mediaQuery.size.height - appBar.preferredSize.height) *
                    0.2,
                child: Chart(_recentTransactions),
              ),
            if (!isLandscape) txListWidget,
            if (isLandscape)
              _showChart
                  ? Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7,
                      child:
                          TransactionList(_userTransaction, _deleteTransaction),
                    )
                  : txListWidget
          ],
        ),
      ),
    );
    return 2 < 3
        ? CupertinoPageScaffold(
            child: appBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: appBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(context),
            ),
          );
  }
}
