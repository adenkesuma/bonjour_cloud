import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:bonjour/Modul/User/create_user.dart';
import 'package:bonjour/Modul/User/edit_user.dart';
import 'package:bonjour/Provider/cloud_firebase.dart';
import 'package:bonjour/data.dart';
import 'package:bonjour/drawer.dart';
import 'package:bonjour/floatingactbutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserView extends StatefulWidget {
  const UserView({Key? key}) : super(key: key);

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final cloudFirebase = Provider.of<CloudFirebase>(context, listen: false);
    cloudFirebase.getUser();
  }

  void createUser() {
    Get.to(CreateUser());
  }

  @override
  Widget build(BuildContext context) {
    final cloudFirebase = Provider.of<CloudFirebase>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(AppLocalizations.of(context)!.user),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      drawer: MainDrawer(),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      cloudFirebase.filterUsers(value); // Filter users based on input
                    },
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                Expanded(
                  child: cloudFirebase.filteredUsers.isEmpty
                      ? Center(child: CircularProgressIndicator()) // Show loading indicator if no users
                      : ListView.builder(
                          itemCount: cloudFirebase.filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = cloudFirebase.filteredUsers[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(31, 172, 169, 169),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                title: Text(
                                  user.username!,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                ),
                                subtitle: Text(
                                  user.namaLengkap ?? "",
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                                trailing: SizedBox(
                                  width: 100,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: IconButton(
                                          onPressed: () {
                                            Get.to(EditUser(user: user));
                                          },
                                          icon: Icon(Icons.edit, color: Colors.blue),
                                        ),
                                      ),
                                      Expanded(
                                        child: IconButton(
                                          onPressed: () async {
                                            final status = await cloudFirebase.deleteUser(user.docId!);
                                            if (status) {
                                              ArtSweetAlert.show(
                                                context: context,
                                                artDialogArgs: ArtDialogArgs(
                                                  type: ArtSweetAlertType.success,
                                                  title: "Delete User Successful",
                                                  confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                                                ),
                                              );
                                            } else {
                                              ArtSweetAlert.show(
                                                context: context,
                                                artDialogArgs: ArtDialogArgs(
                                                  type: ArtSweetAlertType.warning,
                                                  title: "Delete User Failed",
                                                  confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                                                ),
                                              );
                                            }
                                          },
                                          icon: Icon(Icons.delete, color: Colors.red),
                                        ),
                                      ),
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
          if (cloudFirebase.processuser)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.4), // Dark background to indicate loading state
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActBtn(action: () => createUser(), icon: Icons.add), // Button to create a new user
    );
  }
}
