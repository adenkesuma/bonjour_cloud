import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:bonjour/Model/user_model.dart';
import 'package:bonjour/Provider/cloud_firebase.dart';
import 'package:bonjour/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class EditUser extends StatefulWidget {
  final User user;
  const EditUser({Key? key, required this.user}) : super(key: key);

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _tierController;
  late TextEditingController _namaLengkapController;
  List modul = [];
  List selectedModules = [];

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _passwordController = TextEditingController(text: widget.user.pass);
    _tierController = TextEditingController(text: widget.user.tier);
    _namaLengkapController = TextEditingController(text: widget.user.namaLengkap);
    selectedModules = List.from(widget.user.module ?? []);
    print(widget.user.toJson());
    fetchModules();
  }

  void fetchModules() async {
    List modules = await CloudFirebase().getModule();
    setState(() {
      modul = modules;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _tierController.dispose();
    _namaLengkapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userCtrl = Provider.of<CloudFirebase>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _tierController,
                decoration: const InputDecoration(
                  labelText: 'Tier',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _namaLengkapController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Select Modules:', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              modul.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: modul.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text(modul[index]),
                        value: selectedModules.contains(modul[index]),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedModules.add(modul[index]);
                            } else {
                              selectedModules.remove(modul[index]);
                            }
                          });
                        },
                      );
                    },
                  ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      User updatedUser = User(
                        _usernameController.text,
                        _passwordController.text,
                        _tierController.text,
                        _namaLengkapController.text,
                        true,
                        widget.user.docId,
                        selectedModules,
                      );

                      final status = await userCtrl.editUser(updatedUser);
                      if (status) {
                        ArtSweetAlert.show(
                          context: context,
                          artDialogArgs: ArtDialogArgs(
                            type: ArtSweetAlertType.success,
                            title: "Edit User Successful",
                            confirmButtonColor: const Color.fromARGB(255, 3, 192, 0),
                            onConfirm: () {
                              Get.back(); 
                              Get.back(); 
                            },
                          ),
                        );
                      } else {
                        ArtSweetAlert.show(
                          context: context,
                          artDialogArgs: ArtDialogArgs(
                            type: ArtSweetAlertType.warning,
                            title: "Edit User Failed",
                            confirmButtonColor: const Color.fromARGB(255, 3, 192, 0),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.save),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    label: const Text('Save'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.cancel),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    label: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
