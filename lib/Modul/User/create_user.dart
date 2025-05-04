import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:bonjour/Model/user_model.dart';
import 'package:bonjour/Provider/cloud_firebase.dart';
import 'package:bonjour/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({Key? key}) : super(key: key);

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  late TextEditingController _usernameController = TextEditingController();
  late TextEditingController _passwordController = TextEditingController();
  late TextEditingController _tierController = TextEditingController();
  late TextEditingController _namaLengkapController = TextEditingController();
  List modul = []; 
  List selectedModules = []; 

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: '');
    _passwordController = TextEditingController(text: '');
    _tierController = TextEditingController(text: '');
    _namaLengkapController = TextEditingController(text: '');
    fetchdata();
  }

  void fetchdata() async {
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
        title: const Text('Add User'),
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
              const SizedBox(height: 16),
              const Text('Select Modules:', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              modul.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
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
                      final status = await userCtrl.createUser(User(_usernameController.text, _passwordController.text, _tierController.text, _namaLengkapController.text, true, "", selectedModules));
                      if (status) {
                        ArtSweetAlert.show(
                          context: context,
                          artDialogArgs: ArtDialogArgs(
                            type: ArtSweetAlertType.success,
                            title: "Create User Successful",
                            confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                            onConfirm: () {
                              Get.back();
                              Get.back();
                            }
                          )
                        );
                      } else {
                        ArtSweetAlert.show(
                          context: context,
                          artDialogArgs: ArtDialogArgs(
                            type: ArtSweetAlertType.warning,
                            title: "Create User Failed",
                            confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                          )
                        );
                      }
                    },
                    icon: Icon(Icons.save, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white
                      ),
                      label: Text('Save'),
                  ),
                  SizedBox(width: 20,),
                  ElevatedButton.icon(
                    onPressed: () async {
                      Get.back();
                    }, 
                    icon: Icon(Icons.cancel, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white
                    ),
                    label: Text('Cancel'),
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
