import 'package:bonjour/Model/stock_model.dart';
import 'package:flutter/material.dart';

class StockSelectDialog extends StatefulWidget {
  final List<Stock> stockList;
  final Function(Stock) onStockSelected;

  StockSelectDialog({required this.stockList, required this.onStockSelected});

  @override
  _StockSelectDialogState createState() => _StockSelectDialogState();
}

class _StockSelectDialogState extends State<StockSelectDialog> {
  late List<Stock> filteredstockList;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredstockList = widget.stockList; // Initialize filtered list
    searchController.addListener(_filterStocks);
  }

  void _filterStocks() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredstockList = widget.stockList.where((stock) {
        return stock.kodeStock.toLowerCase().contains(query) ||
            stock.namaStock.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('List Stock'),
      // Add actions to the dialog with a back button
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white
          ),
          child: Text('Back'),
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog
          },
        ),
      ],
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,  // Prevent overflow
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  hintText: 'Search Stock...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredstockList.length,
                itemBuilder: (context, index) {
                  return Card(  // Wrap each item with a Card widget
                    elevation: 3, // Add shadow to the card
                    margin: EdgeInsets.symmetric(vertical: 5), // Space between cards
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                    child: ListTile(
                      title: Text(filteredstockList[index].kodeStock),
                      subtitle: Text(filteredstockList[index].namaStock),
                      onTap: () {
                        widget.onStockSelected(filteredstockList[index]);
                        Navigator.of(context).pop();  // Close dialog after selection
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
