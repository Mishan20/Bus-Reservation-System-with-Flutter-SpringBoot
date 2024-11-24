// ignore_for_file: use_build_context_synchronously

import 'package:bus_reservation/datasource/temp_db.dart';
import 'package:bus_reservation/models/but_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_data_provider.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';

class AddRoutePage extends StatefulWidget {
  final BusRoute? route; // Optional route for editing

  const AddRoutePage({Key? key, this.route}) : super(key: key);

  @override
  State<AddRoutePage> createState() => _AddRoutePageState();
}

class _AddRoutePageState extends State<AddRoutePage> {
  final _formKey = GlobalKey<FormState>();
  String? from, to;
  final distanceController = TextEditingController();
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    // Check if we're editing an existing route
    if (widget.route != null) {
      isEditMode = true;
      from = widget.route!.cityFrom;
      to = widget.route!.cityTo;
      distanceController.text = widget.route!.distanceInKm.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          isEditMode ? 'Edit Route' : 'Add Route',
          style: const TextStyle(
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
                horizontal: 20, vertical: 10), // Improved padding
            shrinkWrap: true,
            children: [
              _buildSectionTitle('Route Information'),
              const SizedBox(height: 10),
              _buildCityDropdown(
                hint: 'From',
                value: from,
                onChanged: (value) {
                  setState(() {
                    from = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              _buildCityDropdown(
                hint: 'To',
                value: to,
                onChanged: (value) {
                  setState(() {
                    to = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              _buildDistanceField(),
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

  // Helper method to build city dropdowns
  Widget _buildCityDropdown({
    required String hint,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      onChanged: onChanged,
      isExpanded: true,
      value: value,
      hint: Text(hint),
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(),
      ),
      items: cities
          .map((city) => DropdownMenuItem<String>(
                value: city,
                child: Text(city),
              ))
          .toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a $hint city';
        }
        return null;
      },
    );
  }

  // Helper method to build the distance input field
  Widget _buildDistanceField() {
    return TextFormField(
      controller: distanceController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: 'Distance in Kilometer',
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.social_distance_outlined),
        border: OutlineInputBorder(),
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
        width: 150,
        child: ElevatedButton(
          onPressed: saveRoute,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: Text(isEditMode ? 'SAVE CHANGES' : 'ADD ROUTE'),
        ),
      ),
    );
  }

  void saveRoute() {
    if (_formKey.currentState!.validate()) {
      final route = BusRoute(
        routeId:
            isEditMode ? widget.route!.routeId : TempDB.tableRoute.length + 1,
        routeName: '$from-$to',
        cityFrom: from!,
        cityTo: to!,
        distanceInKm: double.parse(distanceController.text),
      );

      final provider = Provider.of<AppDataProvider>(context, listen: false);

      if (isEditMode) {
        provider
            .updateRoute(route) // Update the route if in edit mode
            .then((response) {
          if (response.responseStatus == ResponseStatus.UPDATED) {
            showMsg(context, 'Route updated successfully!');
            Navigator.pop(context);
          }
        });
      } else {
        provider
            .addRoute(route) // Add a new route if not in edit mode
            .then((response) {
          if (response.responseStatus == ResponseStatus.SAVED) {
            showMsg(context, response.message);
            resetFields();
          }
        });
      }
    }
  }

  void resetFields() {
    from = null;
    to = null;
    distanceController.clear();
  }

  @override
  void dispose() {
    distanceController.dispose();
    super.dispose();
  }
}
