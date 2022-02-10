import 'package:flutter/material.dart';

import '../widgets/transaction_item.dart';
import '../models/transaction.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({
    Key? key,
    required this.transactions,
    required this.deleteTx,
  }) : super(key: key);

  final List<Transaction> transactions;
  final Function deleteTx;

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  @override
  Widget build(BuildContext context) {
    return widget.transactions.isEmpty
        ? LayoutBuilder(builder: (context, contraints) {
            return Column(
              children: [
                Text(
                  'No Transaction added yet',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: contraints.maxHeight * 0.6,
                  child: Image.asset('assets/images/waiting.png'),
                ),
              ],
            );
          })
        : ListView(
            children: widget.transactions
                .map(
                  (tx) => TransactionItem(
                    key: ValueKey(tx.id),
                    transaction: tx,
                    deleteTx: widget.deleteTx,
                  ),
                )
                .toList(),
          );

    // ListView.builder(
    //     physics: const BouncingScrollPhysics(),
    //     itemCount: widget.transactions.length,
    //     itemBuilder: (context, index) {
    //       return TransactionItem(
    //         key: ValueKey(widget.transactions[index].id),
    //         deleteTx: widget.deleteTx,
    //         transaction: widget.transactions[index],
    //       );
    //     },
    //   );
  }
}
