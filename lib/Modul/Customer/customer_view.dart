import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:bonjour/Modul/Customer/create_customer_view.dart';
import 'package:bonjour/Modul/Customer/customer_controller.dart';
import 'package:bonjour/Modul/Customer/edit_customer_view.dart';
import 'package:bonjour/data.dart';
import 'package:bonjour/drawer.dart';
import 'package:bonjour/floatingactbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomerView extends StatefulWidget {
  const CustomerView({super.key});

  @override
  State<CustomerView> createState() => _CustomerViewState();
}

class _CustomerViewState extends State<CustomerView> {
  TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    final customerCtrl = Provider.of<CustomerController>(context, listen: false);
    customerCtrl.fetchData();
  }

  void CreateCustomer () {
    Get.to(CreateCustomerView());
  }

  @override
  Widget build(BuildContext context) {
    final customerCtrl = Provider.of<CustomerController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(AppLocalizations.of(context)!.customer),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      drawer: MainDrawer(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: TextField(
                controller: _search,
                onChanged: (value) {
                  customerCtrl.filterCustomer(value);
                },
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: customerCtrl.filteredCustomer.isEmpty 
              ? const Center(child: Text('Customer Tidak Ditemukan')) 
              : ListView.builder(
                itemCount: customerCtrl.filteredCustomer.length,
                itemBuilder: (context, index) {
                  final customer = customerCtrl.filteredCustomer[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(31, 172, 169, 169),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: ListTile(
                      title: Text('${customerCtrl.filteredCustomer[index].kodeCustomer}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            Expanded(
                              child: IconButton(
                                onPressed: () {
                                  Get.to(EditCustomerView(customer: customer));
                                }, 
                                icon: Icon(Icons.edit, color: Colors.blue,)
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                onPressed: () {
                                  customerCtrl.deleteCustomer(customerCtrl.filteredCustomer[index].docId!).then((value) => {
                                    value 
                                    ? ArtSweetAlert.show(
                                        context: context,
                                        artDialogArgs: ArtDialogArgs(
                                          type: ArtSweetAlertType.success,
                                          title: "Delete Customer Successful",
                                          confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                                        )
                                      )
                                    : ArtSweetAlert.show(
                                        context: context,
                                        artDialogArgs: ArtDialogArgs(
                                          type: ArtSweetAlertType.warning,
                                          title: "Delete Customer Failed",
                                          confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                                        )
                                      )
                                  },);
                                }, 
                                icon: Icon(Icons.delete, color: Colors.red,)
                              ),
                            ),
                          ],
                        ),
                      ), 
                      subtitle: Text(
                        '${customerCtrl.filteredCustomer[index].namaCustomer}',
                        style: TextStyle(
                          fontSize: 12, 
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActBtn(action: () => CreateCustomer(), icon: Icons.add,),
    );
  }
}