import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:bonjour/Model/stock_model.dart';
import 'package:bonjour/Modul/Stock/create_stock_view.dart';
import 'package:bonjour/Modul/Stock/edit_stock_view.dart';
import 'package:bonjour/Modul/Stock/stock_controller.dart';
import 'package:bonjour/data.dart';
import 'package:bonjour/drawer.dart';
import 'package:bonjour/floatingactbutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class StockView extends StatefulWidget {
  const StockView({super.key});

  @override
  State<StockView> createState() => _StockViewState();
}
class _StockViewState extends State<StockView> {
  TextEditingController _search = TextEditingController();
  final Map<String, bool> isOpenMap = {}; // Map to track the toggle state of each stock

  @override
  void initState() {
    super.initState();
    final stockCtrl = Provider.of<StockController>(context, listen: false);
    stockCtrl.fetchData();
  }

  void createStock() {
    Get.to(CreateStockView());
  }

  @override
  Widget build(BuildContext context) {
    final stockCtrl = Provider.of<StockController>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(AppLocalizations.of(context)!.stock),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      drawer: MainDrawer(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: TextField(
                    controller: _search,
                    onChanged: (value) {
                      stockCtrl.filterStocks(value); // Filter based on the search input
                    },
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                Expanded(
                  child: stockCtrl.filteredStock.isEmpty
                      ? const Center(child: Text('Stock Tidak Ditemukan'))
                      : ListView.builder(
                          itemCount: stockCtrl.filteredStock.length,
                          itemBuilder: (context, index) {
                            final stock = stockCtrl.filteredStock[index];
                            final isOpen = isOpenMap[stock.docId] ?? false; // Retrieve the toggle state for this stock

                            return Container(
                              margin: EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(31, 172, 169, 169),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${stock.namaStock}',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '${stock.kodeStock}',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: const Color.fromARGB(255, 131, 131, 131)),
                                    ),
                                  ],
                                ),
                                leading: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: stock.img.isEmpty
                                        ? Image.network(
                                            linkImg + defaultStockImg,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            linkImg + stock.img,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                trailing: SizedBox(
                                  width: 30,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: IconButton(
                                          onPressed: () {
                                            Get.to(EditStockView(stock: stock));
                                          },
                                          icon: Icon(Icons.edit, color: Colors.blue),
                                        ),
                                      ),
                                      Expanded(
                                        child: IconButton(
                                          onPressed: () {
                                            stockCtrl.deleteStock(stockCtrl.filteredStock[index].docId!).then((value) => {
                                              value 
                                              ? ArtSweetAlert.show(
                                                  context: context,
                                                  artDialogArgs: ArtDialogArgs(
                                                    type: ArtSweetAlertType.success,
                                                    title: "Delete Stock Successful",
                                                    confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                                                  )
                                                )
                                              : ArtSweetAlert.show(
                                                  context: context,
                                                  artDialogArgs: ArtDialogArgs(
                                                    type: ArtSweetAlertType.warning,
                                                    title: "Delete Stock Failed",
                                                    confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                                                  )
                                                )
                                            },);
                                          },
                                          icon: Icon(Icons.delete, color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                subtitle: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isOpenMap[stock.docId!] = !(isOpenMap[stock.docId!] ?? false);
                                    });
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Stock ${stock.currentstock}',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.blue),
                                      ),
                                      if (isOpen && stock.currentstock!=0)
                                        ...stock.perloc!.entries.map((entry) {
                                          return Text(
                                            '${entry.key}: ${entry.value}', // Display location and its stock count
                                            style: TextStyle(fontSize: 14),
                                          );
                                        }).toList(),
                                      if (isOpen && stock.currentstock==0)
                                        Text('Stock Empty'),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          if (stockCtrl.processing)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.4), // Dark background
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActBtn(action: () => createStock(), icon: Icons.add),
    );
  }
}
