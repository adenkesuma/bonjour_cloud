import 'package:bonjour/Model/customer_model.dart';
import 'package:flutter/material.dart';

class CustomerSelectDialog extends StatefulWidget {
  final List<Customer> customerList;
  final Function(Customer) onCustomerSelected;

  CustomerSelectDialog({required this.customerList, required this.onCustomerSelected});

  @override
  _CustomerSelectDialogState createState() => _CustomerSelectDialogState();
}

class _CustomerSelectDialogState extends State<CustomerSelectDialog> {
  late List<Customer> filteredCustomerList;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredCustomerList = widget.customerList; // Initialize filtered list
    searchController.addListener(_filterCustomers);
  }

  // Filter customers based on search input
  void _filterCustomers() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredCustomerList = widget.customerList.where((customer) {
        return customer.kodeCustomer.toLowerCase().contains(query) ||
            customer.namaCustomer.toLowerCase().contains(query);
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
      title: Text('List Customer'),
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
                  hintText: 'Search customer...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // List of filtered customers
            Expanded(
              child: ListView.builder(
                itemCount: filteredCustomerList.length,
                itemBuilder: (context, index) {
                  return Card(  // Wrap each item with a Card widget
                    elevation: 3, // Add shadow to the card
                    margin: EdgeInsets.symmetric(vertical: 5), // Space between cards
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                    child: ListTile(
                      title: Text(filteredCustomerList[index].kodeCustomer),
                      subtitle: Text(filteredCustomerList[index].namaCustomer),
                      onTap: () {
                        widget.onCustomerSelected(filteredCustomerList[index]);
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
