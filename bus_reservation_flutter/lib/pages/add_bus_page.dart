// ignore_for_file: use_build_context_synchronously

import 'package:bus_reservation/customwidgets/login_alert_dialog.dart';
import 'package:bus_reservation/providers/app_data_provider.dart';
import 'package:bus_reservation/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/bus_model.dart';
import '../utils/constants.dart';

class AddBusPage extends StatefulWidget {
  const AddBusPage({super.key});

  @override
  State<AddBusPage> createState() => _AddBusPageState();
}

class _AddBusPageState extends State<AddBusPage> {
  final _formKey = GlobalKey<FormState>();
  String? busType;
  final seatController = TextEditingController();
  final nameController = TextEditingController();
  final numberController = TextEditingController(); // New controller for price

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Add Bus',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 10), // Adjusted padding
            shrinkWrap: true,
            children: [
              _buildSectionTitle('Bus Information'),
              const SizedBox(height: 10),
              _buildBusTypeDropdown(),
              const SizedBox(height: 10),
              _buildTextField(
                controller: nameController,
                hintText: 'Bus Name',
                icon: Icons.directions_bus,
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: numberController,
                hintText: 'Bus Number',
                icon: Icons.confirmation_number,
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: seatController,
                hintText: 'Total Seats',
                icon: Icons.event_seat,
                inputType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Sales Information'),
          
              const SizedBox(height: 20),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build section titles
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blueAccent,
      ),
    );
  }

  // Helper method to build dropdown for Bus Type
  Widget _buildBusTypeDropdown() {
    return DropdownButtonFormField<String>(
      onChanged: (value) {
        setState(() {
          busType = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a Bus Type';
        }
        return null;
      },
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: 'Select Bus Type',
        border: OutlineInputBorder(),
      ),
      isExpanded: true,
      value: busType,
      hint: const Text('Select Bus Type'),
      items: busTypes
          .map((e) => DropdownMenuItem<String>(
                value: e,
                child: Text(e),
              ))
          .toList(),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return emptyFieldErrMessage;
        }
        return null;
      },
    );
  }

  // Helper method to build the submit button
  Widget _buildSubmitButton() {
    return Center(
      child: SizedBox(
        width: 200,
        child: ElevatedButton(
          onPressed: addBus,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text(
            'ADD BUS',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  

  void addBus() {
    if (_formKey.currentState!.validate()) {
      final bus = Bus(
        busName: nameController.text,
        busNumber: numberController.text,
        busType: busType!,
        totalSeat: int.parse(seatController.text),
      );
      Provider.of<AppDataProvider>(context, listen: false)
          .addBus(bus)
          .then((response) {
        if (response.responseStatus == ResponseStatus.SAVED) {
          showMsg(context, response.message);
          resetFields();
        } else if (response.responseStatus == ResponseStatus.EXPIRED ||
            response.responseStatus == ResponseStatus.UNAUTHORIZED) {
          showLoginAlertDialog(
            context: context,
            message: response.message,
            callback: () {
              Navigator.pushNamed(context, routeNameLoginPage);
            },
          );
        }
      });
    }
  }

  void resetFields() {
    numberController.clear();
    seatController.clear();
    nameController.clear(); // Clear the new price field
  }

  @override
  void dispose() {
    seatController.dispose();
    nameController.dispose();
    numberController.dispose(); // Dispose the new controller
    super.dispose();
  }
}
