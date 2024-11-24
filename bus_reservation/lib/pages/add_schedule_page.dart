import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../datasource/temp_db.dart';
import '../models/bus_model.dart';
import '../models/bus_schedule.dart';
import '../models/but_route.dart';
import '../providers/app_data_provider.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';

class AddSchedulePage extends StatefulWidget {
  const AddSchedulePage({Key? key}) : super(key: key);

  @override
  State<AddSchedulePage> createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  final _formKey = GlobalKey<FormState>();
  String? busType;
  BusRoute? busRoute;
  Bus? bus;
  TimeOfDay? timeOfDay;
  final priceController = TextEditingController();
  final discountController = TextEditingController();
  final feeController = TextEditingController();

  @override
  void didChangeDependencies() {
    _getData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Schedule',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            children: [
              _buildDropdownFields(),
              const SizedBox(height: 15),
              _buildTextFormField(
                controller: priceController,
                hintText: 'Ticket Price',
                icon: Icons.price_change,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              _buildTextFormField(
                controller: discountController,
                hintText: 'Discount (%)',
                icon: Icons.discount,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              _buildTextFormField(
                controller: feeController,
                hintText: 'Processing Fee',
                icon: Icons.monetization_on_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              _buildTimePicker(),
              const SizedBox(height: 30),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownFields() {
    return Column(
      children: [
        Consumer<AppDataProvider>(
          builder: (context, provider, child) => Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: DropdownButtonFormField<Bus>(
                onChanged: (value) {
                  setState(() {
                    bus = value;
                  });
                },
                isExpanded: true,
                value: bus,
                decoration: const InputDecoration(
                  labelText: 'Select Bus',
                  border: InputBorder.none,
                ),
                items: provider.busList
                    .map(
                      (e) => DropdownMenuItem<Bus>(
                        value: e,
                        child: Text('${e.busName} - ${e.busType}'),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Consumer<AppDataProvider>(
          builder: (context, provider, child) => Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: DropdownButtonFormField<BusRoute>(
                onChanged: (value) {
                  setState(() {
                    busRoute = value;
                  });
                },
                isExpanded: true,
                value: busRoute,
                decoration: const InputDecoration(
                  labelText: 'Select Route',
                  border: InputBorder.none,
                ),
                items: provider.routeList
                    .map(
                      (e) => DropdownMenuItem<BusRoute>(
                        value: e,
                        child: Text(e.routeName),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: hintText,
            prefixIcon: Icon(icon),
            border: InputBorder.none,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return emptyFieldErrMessage;
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Colors.teal,
          ),
          onPressed: _selectTime,
          child: const Text('Select Departure Time'),
        ),
        const SizedBox(width: 10),
        Text(
          timeOfDay == null ? 'No time chosen' : getFormattedTime(timeOfDay!),
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: addSchedule,
        child: const Text(
          'ADD Schedule',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void addSchedule() {
    if (timeOfDay == null) {
      showMsg(context, 'Please select a departure date');
      return;
    }
    if (_formKey.currentState!.validate()) {
      final schedule = BusSchedule(
        scheduleId: TempDB.tableSchedule.length + 1,
        bus: bus!,
        busRoute: busRoute!,
        departureTime: getFormattedTime(timeOfDay!),
        ticketPrice: int.parse(priceController.text),
        discount: int.parse(discountController.text),
        processingFee: int.parse(feeController.text),
      );
      Provider.of<AppDataProvider>(context, listen: false)
          .addSchedule(schedule)
          .then((response) {
        if (response.responseStatus == ResponseStatus.SAVED) {
          showMsg(context, response.message);
          resetFields();
        }
      });
    }
  }

  void _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (time != null) {
      setState(() {
        timeOfDay = time;
      });
    }
  }

  void resetFields() {
    priceController.clear();
    discountController.clear();
    feeController.clear();
    setState(() {
      bus = null;
      busRoute = null;
      timeOfDay = null;
    });
  }

  void _getData() {
    Provider.of<AppDataProvider>(context, listen: false).getAllBus();
    Provider.of<AppDataProvider>(context, listen: false).getAllBusRoutes();
  }
}
