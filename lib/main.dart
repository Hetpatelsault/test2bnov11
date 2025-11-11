import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(BankingApp());
}

class BankingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Banking App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  final String bankLogo = 'assets/bank_logo.png'; // Place a logo image in assets

  @override
  Widget build(BuildContext context) {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return Scaffold(
      appBar: AppBar(title: Text('Welcome')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(bankLogo, width: 150), // <- comma added here
            SizedBox(height: 20),
            Text(
              'Welcome to Your Bank!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Today is $today', style: TextStyle(fontSize: 16)), // Correct interpolation
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AccountListScreen()),
                );
              },
              child: Text('View Accounts'),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountListScreen extends StatelessWidget {
  final Map<String, dynamic> accountsJson = jsonDecode('''
  {
    "transactions": {
      "Chequing": [
        {"date": "2024-04-14", "description": "Utility Bill Payment", "amount": -120.00},
        {"date": "2024-04-16", "description": "ATM Withdrawal", "amount": -75.00},
        {"date": "2024-04-17", "description": "Deposit", "amount": 100.00},
        {"date": "2024-04-18", "description": "Withdrawal", "amount": -50.00}
      ],
      "Savings": [
        {"date": "2024-04-12", "description": "Withdrawal", "amount": -300.00},
        {"date": "2024-04-15", "description": "Interest", "amount": 10.00},
        {"date": "2024-04-16", "description": "Deposit", "amount": 200.00},
        {"date": "2024-04-18", "description": "Transfer to Chequing", "amount": -500.00}
      ]
    }
  }
  ''');

  @override
  Widget build(BuildContext context) {
    final accounts = accountsJson['transactions'].keys.toList();
    return Scaffold(
      appBar: AppBar(title: Text('Accounts')),
      body: ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          String account = accounts[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(account),
              trailing: ElevatedButton(
                child: Text('View Transactions'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TransactionScreen(
                        accountName: account,
                        transactions: accountsJson['transactions'][account],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class TransactionScreen extends StatelessWidget {
  final String accountName;
  final List<dynamic> transactions;

  TransactionScreen({required this.accountName, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$accountName Transactions')),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final tx = transactions[index];
          return ListTile(
            leading: Icon(
              tx['amount'] < 0 ? Icons.arrow_upward : Icons.arrow_downward,
              color: tx['amount'] < 0 ? Colors.red : Colors.green,
            ),
            title: Text(tx['description']),
            subtitle: Text(tx['date']),
            trailing: Text('\$' + tx['amount'].toStringAsFixed(2)),
          );
        },
      ),
    );
  }
}
