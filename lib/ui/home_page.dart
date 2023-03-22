import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/services/local_notification_service.dart';
import 'package:to_do_app/services/theme_services.dart';
import 'package:to_do_app/ui/theme.dart';
import 'package:to_do_app/ui/widgets/my_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectDate = DateTime.now();
  late NotifHelper notifHelper;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting();
    notifHelper = NotifHelper();
    notifHelper.initializeNotification();
    print(GetStorage().read("isDarkMode"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(left: 16, top: 20),
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: DateTime.now(),
        width: 60,
        height: 100,
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        locale: "uz_UZ",
        dateTextStyle: GoogleFonts.lato(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        dayTextStyle: GoogleFonts.lato(
            fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey),
        monthTextStyle: GoogleFonts.lato(
            fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
        onDateChange: (date) {
          setState(() {
            _selectDate = date;
          });
        },
      ),
    );
  }

  _addTaskBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd("uz_UZ").format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                "Bugun",
                style: headingStyle,
              )
            ],
          ),
          MyButton(label: "+ Vazifa", onTap: () => null)
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
          onTap: () {
            ThemeServices().switchTheme();
            notifHelper.displayNotification(
                title: "Mavzuni o'zgartirish",
                body: !Get.isDarkMode
                    ? "Qorong'u rejimga o'zgartirildi"
                    : "Kunduzgi rejimga o'zgartirildi");
            notifHelper.scheduledNotification();
          },
          child: Icon(
            Get.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
            color: Get.isDarkMode ? Colors.white : Colors.black,
            size: 20,
          )),
      actions: [
        Image(
            width: 30,
            height: 30,
            color: Get.isDarkMode ? Colors.white : Colors.black,
            image: const AssetImage("assets/icons/user.png")),
        const SizedBox(
          width: 20,
        )
      ],
    );
  }
}
