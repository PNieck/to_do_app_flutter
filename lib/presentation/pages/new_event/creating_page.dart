import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_flutter/Helpers/date_time.dart';
import 'package:to_do_app_flutter/logic/cubit/events/single_event_cubit.dart';

import '../../../data/models/calendar_event.dart';
import '../../../data/models/event_category.dart';
import '../../../logic/cubit/categories/categories_cubit.dart';
import '../../elements/app_text_form_field.dart';
import '../../elements/category_choose_menu.dart';

class CreatingEventPage extends StatefulWidget {
  const CreatingEventPage({super.key});

  @override
  State<CreatingEventPage> createState() => _CreatingEventPageState();
}

class _CreatingEventPageState extends State<CreatingEventPage> {
  final _formKey = GlobalKey<FormState>();
  static const double iconsSize = 28;

  final GlobalKey<FormFieldState<String>> _eventNameKey = GlobalKey();
  final GlobalKey<FormFieldState<DateTime>> _startDateTimeKey = GlobalKey();
  final GlobalKey<FormFieldState<DateTime>> _endDateTimeKey = GlobalKey();
  final GlobalKey<FormFieldState<EventCategory?>> _eventCategoryKey =
      GlobalKey();
  final GlobalKey<FormFieldState<String>> _descriptionKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    const divider = Divider(
      height: 1.0,
      color: Colors.white,
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.event, size: iconsSize),
                title: AppTextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Event name cannot be empty';
                    }
                    return null;
                  },
                  key: _eventNameKey,
                  labelText: "Event name",
                ),
              ),
              divider,
              ListTile(
                leading: const Icon(
                  Icons.schedule,
                  size: iconsSize,
                ),
                title: setTimeText("Start time"),
                subtitle: FormField<DateTime>(
                  key: _startDateTimeKey,
                  initialValue: DateTime.now(),
                  builder: (field) => ElevatedButton(
                    onPressed: () async {
                      DateTime? newDateTime = await pickDateTime();
                      if (newDateTime == null) {
                        return;
                      }
                      field.didChange(newDateTime);
                    },
                    child: Text(field.value!.formatDateAndTime()),
                  ),
                ),
              ),
              divider,
              ListTile(
                leading: const Icon(
                  Icons.schedule,
                  size: iconsSize,
                ),
                title: setTimeText("End time"),
                subtitle: FormField<DateTime>(
                  key: _endDateTimeKey,
                  validator: (value) {
                    if (_startDateTimeKey.currentState == null ||
                        _startDateTimeKey.currentState?.value == null ||
                        value == null) {
                      return null;
                    }

                    if (value
                        .isBefore(_startDateTimeKey.currentState!.value!)) {
                      return "End Time cannot be before start value";
                    }

                    return null;
                  },
                  autovalidateMode: AutovalidateMode.always,
                  initialValue: DateTime.now().add(const Duration(hours: 1)),
                  builder: (field) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            DateTime? newDateTime = await pickDateTime();
                            if (newDateTime == null) {
                              return;
                            }

                            field.didChange(newDateTime);
                          },
                          child: Text(field.value!.formatDateAndTime()),
                        ),
                        if (field.hasError)
                          Text(
                            field.errorText ?? '',
                            style: const TextStyle(color: Colors.red),
                          ),
                      ]),
                ),
              ),
              divider,
              ListTile(
                leading: const Icon(
                  Icons.category,
                  size: iconsSize,
                ),
                title: const Text("Category"),
                subtitle: FormField<EventCategory?>(
                  key: _eventCategoryKey,
                  initialValue: null,
                  builder: (field) => ElevatedButton(
                    onPressed: () async {
                      EventCategory? newCategory = await showCategoryPopUp();
                      field.didChange(newCategory);
                    },
                    child: Text(
                        field.value == null ? "Default" : field.value!.name),
                  ),
                ),
              ),
              ListTile(
                  leading: const Icon(
                    Icons.description,
                    size: iconsSize,
                  ),
                  title: const Text("Description"),
                  subtitle: AppTextFormField(
                    key: _descriptionKey,
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                  )),
              const Divider(
                height: 1,
              ),
              Container(
                margin:
                    const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Duration duration = _endDateTimeKey.currentState!.value!
                          .difference(_startDateTimeKey.currentState!.value!);
                      CalendarEvent newEvent = CalendarEvent(
                        name: _eventNameKey.currentState!.value,
                        startDateTime: _startDateTimeKey.currentState!.value,
                        duration: duration,
                        category: _eventCategoryKey.currentState!.value,
                        description: _descriptionKey.currentState!.value,
                      );

                      context.read<SingleEventCubit>().createEvent(newEvent);
                    }
                  },
                  child: const Text("Add new event"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  showCategoryPopUp() => showDialog<EventCategory?>(
        context: context,
        builder: (newContext) => BlocProvider.value(
          value: context.read<CategoriesCubit>(),
          child: const CategoryChooseMenu(),
        ),
      );

  RichText setTimeText(String text) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
        children: <TextSpan>[
          TextSpan(text: text),
          const TextSpan(
              text: "  (HH:MM DD-MM-YYYY)",
              style: TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 136, 136, 136),
              )),
        ],
      ),
    );
  }

  Future<DateTime?> pickDateTime() async {
    DateTime? date;
    TimeOfDay? time;

    date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));

    if (date == null) {
      return null;
    }

    time = await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (time == null) {
      return null;
    }

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}
