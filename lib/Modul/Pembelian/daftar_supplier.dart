import 'package:bonjour/Model/supplier_model.dart';
import 'package:flutter/material.dart';

class SupplierSelectDialog extends StatefulWidget {
  final List<Supplier> supplierList;
  final Function(Supplier) onSupplierSelected;

  SupplierSelectDialog({required this.supplierList, required this.onSupplierSelected});

  @override
  _SupplierSelectDialogState createState() => _SupplierSelectDialogState();
}

class _SupplierSelectDialogState extends State<SupplierSelectDialog> {
  late List<Supplier> filteredsupplierList;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredsupplierList = widget.supplierList; // Initialize filtered list
    searchController.addListener(_filterSuppliers);
  }

  // Filter customers based on search input
  void _filterSuppliers() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredsupplierList = widget.supplierList.where((supplier) {
        return supplier.kodeSupplier.toLowerCase().contains(query) ||
            supplier.namaSupplier.toLowerCase().contains(query);
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
      title: Text('List Supplier'),
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
                  hintText: 'Search supplier...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // List of filtered customers
            Expanded(
              child: ListView.builder(
                itemCount: filteredsupplierList.length,
                itemBuilder: (context, index) {
                  return Card(  // Wrap each item with a Card widget
                    elevation: 3, // Add shadow to the card
                    margin: EdgeInsets.symmetric(vertical: 5), // Space between cards
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                    child: ListTile(
                      title: Text(filteredsupplierList[index].kodeSupplier),
                      subtitle: Text(filteredsupplierList[index].namaSupplier),
                      onTap: () {
                        widget.onSupplierSelected(filteredsupplierList[index]);
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
