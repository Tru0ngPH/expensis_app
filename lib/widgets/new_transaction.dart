import '../widgets/adaptive_flat_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  const NewTransaction({Key? key, required this.addTx}) : super(key: key);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleInputController = TextEditingController();

  final _amountInputController = TextEditingController();

  DateTime? _selectDate;

  void _submitData() {
    if (_amountInputController.text.isEmpty ||
        _titleInputController.text.isEmpty ||
        double.parse(_amountInputController.text) <= 0 ||
        _selectDate == null) {
      return;
    }
    final enterTitle = _titleInputController.text;
    final enterAmount = double.parse(_amountInputController.text);

    widget.addTx(
      title: enterTitle,
      amount: enterAmount,
      date: _selectDate,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: mediaQuery.viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                // onChanged: (value) {
                //   titleInput = value;
                // },
                controller: _titleInputController,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
                // onChanged: (value) {
                //   amountInput = value;
                // },
                controller: _amountInputController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectDate == null
                            ? 'No date chosen!'
                            : DateFormat.yMd().format(_selectDate as DateTime),
                      ),
                    ),
                    AdaptiveFlatButton(
                        text: 'Chose date', handle: _presentDatePicker)
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor),
                child: const Text(
                  "Add transaction",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => _submitData(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
