import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatefulWidget {
  const TransactionList(
      {Key? key, required this.transactions, required this.deleteTx})
      : super(key: key);

  final List<Transaction> transactions;
  final Function deleteTx;

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
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
        : ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: widget.transactions.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                elevation: 5,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.lightBlue,
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: FittedBox(
                        child: Text(
                            '\$${widget.transactions[index].amount.toStringAsFixed(0)}',
                            style: Theme.of(context).textTheme.headline6),
                      ),
                    ),
                  ),
                  title: Text(widget.transactions[index].title,
                      style: Theme.of(context).textTheme.headline6),
                  subtitle: Text(
                      DateFormat.yMMMd()
                          .format(widget.transactions[index].date),
                      style: Theme.of(context).textTheme.bodyText2),
                  trailing: mediaQuery.size.width > 500
                      ? TextButton.icon(
                          onPressed: () =>
                              widget.deleteTx(widget.transactions[index].id),
                          icon: const Icon(
                            Icons.delete,
                            size: 35,
                          ),
                          label: const Text(
                            'Delete',
                          ),
                          style: TextButton.styleFrom(
                            primary: Colors.black,
                          ),
                        )
                      : IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.black,
                          ),
                          onPressed: () =>
                              widget.deleteTx(widget.transactions[index].id),
                        ),
                ),
              );

              // Card(
              //   child: Row(
              //     children: [
              //       Container(
              //         margin: const EdgeInsets.symmetric(
              //             horizontal: 20, vertical: 10),
              //         padding: const EdgeInsets.all(10),
              //         decoration: BoxDecoration(
              //           border: Border.all(
              //             color: Colors.purple,
              //             width: 2,
              //           ),
              //         ),
              //         child: Text(
              //           '\$${widget.transactions[index].amount.toStringAsFixed(2)}',
              //           style: const TextStyle(
              //             fontWeight: FontWeight.bold,
              //             fontSize: 20,
              //             color: Colors.purple,
              //           ),
              //         ),
              //       ),
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             widget.transactions[index].title,
              //             style: const TextStyle(
              //               fontWeight: FontWeight.bold,
              //               fontSize: 16,
              //             ),
              //           ),
              //           Text(
              //             // DateFormat('yyyy-MM-dd').format(trans.date),
              //             DateFormat.yMMMMd()
              //                 .format(widget.transactions[index].date),
              //             style: const TextStyle(color: Colors.grey),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // );
            },
          );
  }
}
