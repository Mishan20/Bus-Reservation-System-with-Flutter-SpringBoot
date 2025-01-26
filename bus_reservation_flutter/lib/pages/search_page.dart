import 'package:bus_reservation/drawers/main_drawer.dart';
import 'package:bus_reservation/providers/app_data_provider.dart';
import 'package:bus_reservation/utils/constants.dart';
import 'package:bus_reservation/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? fromCity, toCity;
  DateTime? departureDate;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text(
          "Search for Buses",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                _buildDropdownField(
                  label: "From",
                  value: fromCity,
                  onChanged: (value) {
                    setState(() {
                      fromCity = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildDropdownField(
                  label: "To",
                  value: toCity,
                  onChanged: (value) {
                    setState(() {
                      toCity = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildDatePicker(),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _search,
                  child: const Text("Search"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return emptyFieldErrMessage;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      ),
      isExpanded: true,
      items: cities
          .map((city) => DropdownMenuItem<String>(
                value: city,
                child: Text(
                  city,
                  style: const TextStyle(fontSize: 16, color: Colors.teal),
                ),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDatePicker() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.teal),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            departureDate == null
                ? "Select Departure Date"
                : getFormattedDate(departureDate!, format: 'EEE MMM dd, yyyy'),
            style: const TextStyle(fontSize: 16, color: Colors.teal),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.teal),
            onPressed: _selectDate,
          ),
        ],
      ),
    );
  }

  void _selectDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    ).then((value) {
      if (value != null) {
        setState(() {
          departureDate = value;
        });
      }
    });
  }

  void _search() {
    if (departureDate == null) {
      showMsg(context, emptyDateErrMessage);
    }
    if (_formKey.currentState!.validate()) {
      Provider.of<AppDataProvider>(context, listen: false)
          .getRouteByCityFromAndCityTo(fromCity!, toCity!)
          .then((value) {
        if (value == null) {
          showMsg(context, "Route not found");
        } else {
          Navigator.pushNamed(context, routeNameSearchResultPage,
              arguments: [value, getFormattedDate(departureDate!)]);
        }
      });
    }
    return;
  }
}
