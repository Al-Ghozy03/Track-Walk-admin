// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_unnecessary_containers, non_constant_identifier_names, unused_local_variable, curly_braces_in_flow_control_structures, must_be_immutable, deprecated_member_use, avoid_print, unnecessary_new, unrelated_type_equality_checks

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:track_walk_admin/colors.dart';
import 'package:track_walk_admin/screen/qr_scanner.dart';
import '../service/api_service.dart';
import '../widget/custom_shimmer.dart';

class Ticket extends StatefulWidget {
  String id;
  String img;
  Ticket({super.key, required this.id, required this.img});

  @override
  State<Ticket> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  int activeIndexFilter = 0;
  int activeIndexSort = 0;
  late Future ticket;
  String keyword = "";
  final arguments = Get.arguments;
  List data = [];
  String formattedDate = "";

  void dialogDetails() {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(MediaQuery.of(context).size.width / 20),
              topRight:
                  Radius.circular(MediaQuery.of(context).size.width / 20))),
      context: context,
      builder: (context) {
        final width = MediaQuery.of(context).size.width;
        final height = MediaQuery.of(context).size.height;
        List data = [1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3];
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(width / 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Details",
                  style:
                      TextStyle(fontSize: width / 15, fontFamily: "popinsemi"),
                ),
                SizedBox(height: width / 40),
                Text(arguments[0]),
                SizedBox(height: width / 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Location",
                      style: TextStyle(color: grayText),
                    ),
                    SizedBox(width: width / 15),
                    Flexible(
                        child: Text(
                            "Pertamina Mandalika, Internation Street Circuit")),
                  ],
                ),
                SizedBox(height: width / 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Time Zone",
                      style: TextStyle(color: grayText),
                    ),
                    SizedBox(width: width / 25),
                    Flexible(child: Text("Asia/Singapore")),
                  ],
                ),
                SizedBox(height: width / 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Slots",
                      style: TextStyle(color: grayText),
                    ),
                    SizedBox(width: width / 7),
                    Flexible(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Session 1 06.30 - 09.00 WITA",
                          style: TextStyle(fontFamily: "popinsemi"),
                        ),
                        Column(
                          children: data
                              .map((e) => Row(
                                    children: [
                                      Text(
                                        "July 04, 2022",
                                        style: TextStyle(color: grayText),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: width / 40),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width / 50,
                                            vertical: width / 100),
                                        decoration: BoxDecoration(
                                            color: blueTheme,
                                            borderRadius:
                                                BorderRadius.circular(width)),
                                        child: Text(
                                          "10/10",
                                          style: TextStyle(
                                              fontSize: width / 50,
                                              color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ))
                              .toList(),
                        )
                      ],
                    )),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void modalFilter() {
    showModalBottomSheet(
      backgroundColor: bgDark,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(MediaQuery.of(context).size.width / 20),
        topRight: Radius.circular(MediaQuery.of(context).size.width / 20),
      )),
      clipBehavior: Clip.antiAlias,
      context: context,
      builder: (context) {
        final width = MediaQuery.of(context).size.width;
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(width / 15),
            child: StatefulBuilder(
              builder: (context, StateSetter stateSetter) {
                List filter = [
                  "All Tickets",
                  "One-day Tickets",
                  "Bookable Tickets"
                ];
                List sort = [
                  "Ticket Name : A-Z",
                  "Ticket Name : Z-A",
                ];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Filter",
                        style: TextStyle(
                            fontSize: width / 15, fontFamily: "popinsemi")),
                    SizedBox(height: width / 20),
                    Wrap(
                      children: filter
                          .asMap()
                          .entries
                          .map((data) => Container(
                              margin: EdgeInsets.only(right: width / 40),
                              child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor:
                                          activeIndexFilter == data.key
                                              ? blueThemeOpacity
                                              : null,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color:
                                                  activeIndexFilter == data.key
                                                      ? blueTheme
                                                      : grayText),
                                          borderRadius:
                                              BorderRadius.circular(width))),
                                  onPressed: () {
                                    stateSetter(() {
                                      activeIndexFilter = data.key;
                                    });
                                    setState(() {
                                      
                                    });
                                  },
                                  child: Text(
                                    data.value,
                                    style: TextStyle(
                                        color: activeIndexFilter == data.key
                                            ? blueTheme
                                            : grayText,
                                        fontSize: width / 25,
                                        fontFamily:
                                            activeIndexFilter == data.key
                                                ? "popinsemi"
                                                : "popin"),
                                  ))))
                          .toList(),
                    ),
                    SizedBox(height: width / 20),
                    Text("Sort",
                        style: TextStyle(
                            fontSize: width / 15, fontFamily: "popinsemi")),
                    SizedBox(height: width / 20),
                    Wrap(
                      children: sort
                          .asMap()
                          .entries
                          .map((data) => Container(
                              margin: EdgeInsets.only(right: width / 40),
                              child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor:
                                          activeIndexSort == data.key
                                              ? blueThemeOpacity
                                              : null,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: activeIndexSort == data.key
                                                  ? blueTheme
                                                  : grayText),
                                          borderRadius:
                                              BorderRadius.circular(width))),
                                  onPressed: () {
                                    stateSetter(() {
                                      activeIndexSort = data.key;
                                    });
                                  },
                                  child: Text(
                                    data.value,
                                    style: TextStyle(
                                        color: activeIndexSort == data.key
                                            ? blueTheme
                                            : grayText,
                                        fontSize: width / 25,
                                        fontFamily: activeIndexSort == data.key
                                            ? "popinsemi"
                                            : "popin"),
                                  ))))
                          .toList(),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    ticket = ApiService().ticket(widget.id);
    ticket.then((value) {
      setState(() {
        data = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var filter = data.where((element) {
      DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(
          int.parse(element["WooCommerceEventsBookingDateTimestamp"]) * 1000);
      return DateFormat.yMEd().format(timestamp) ==
              DateFormat.yMEd().format(arguments[1]) &&
          element["WooCommerceEventsAttendeeName"]
              .toLowerCase()
              .toString()
              .contains(keyword.toLowerCase());
    }).toList();
    final width = Get.width;
    final height = Get.height;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(width / 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(GetPlatform.isIOS
                          ? Icons.arrow_back_ios_rounded
                          : Iconsax.arrow_left)),
                  SizedBox(height: width / 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: width / 4,
                        height: width / 4,
                        decoration: BoxDecoration(
                          color: grayText,
                          borderRadius: BorderRadius.circular(width / 30),
                          image: DecorationImage(
                            image: NetworkImage(widget.img),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width / 20,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              arguments[0],
                              style: TextStyle(
                                  fontSize: width / 18,
                                  fontFamily: "popinsemi"),
                            ),
                            Text(
                              arguments[1] == "02 Jan 2022"
                                  ? "02 Jan 2022"
                                  : "${DateFormat.d().format(arguments[1])} ${DateFormat.MMMM().format(arguments[1])} ${DateFormat.y().format(arguments[1])}",
                              style: TextStyle(
                                  fontSize: width / 27, color: grayText),
                            ),
                            InkWell(
                              onTap: () {
                                dialogDetails();
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "Expand Details",
                                    style: TextStyle(fontSize: width / 27),
                                  ),
                                  Icon(Iconsax.arrow_down_1, size: width / 22)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: width / 20),
                  _searchBar(width, height),
                  SizedBox(height: width / 15),
                  FutureBuilder(
                    future: ticket,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState != ConnectionState.done)
                        return _loadingState(width, height);
                      if (snapshot.hasError)
                        return Column(
                          children: [
                            LottieBuilder.asset(
                                "assets/json/94992-error-404.json"),
                            Text(
                              "Ooops, something went wrong",
                              style: TextStyle(
                                  fontFamily: "popinsemi",
                                  fontSize: width / 17),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Please check your internet connection",
                              style: TextStyle(color: grayText),
                            )
                          ],
                        );
                      if (snapshot.hasData) {
                        return _listBuilder(width, height, filter);
                      } else {
                        return Text("kosong");
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
      bottomNavigationBar: Container(
        height: height / 12.5,
        width: width,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: blueTheme,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0))),
            onPressed: () {
              Get.to(QR(),
                  transition: Transition.circularReveal, arguments: arguments);
            },
            child: Icon(Icons.qr_code_scanner, size: width / 10)),
      ),
    );
  }

  Widget _loadingState(width, height) {
    return Container(
      height: height * 0.75,
      child: ListView.separated(
          itemBuilder: (_, i) {
            return Row(
              children: [
                CustomShimmer(
                    width: width / 6, height: width / 6, radius: width / 30),
                SizedBox(width: width / 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomShimmer(
                        height: width / 30, width: width * 0.65, radius: width),
                    SizedBox(height: width / 55),
                    CustomShimmer(
                        height: width / 30, width: width * 0.45, radius: width),
                  ],
                )
              ],
            );
          },
          separatorBuilder: (_, i) =>
              SizedBox(height: width / 15, child: Divider(thickness: 0.8)),
          itemCount: 10),
    );
  }

  Widget _listBuilder(height, width, List data) {
    return (data.isNotEmpty)
        ? Container(
            height: height * 1.19,
            child: ListView.separated(
              itemBuilder: (_, i) {
                return _listTickets(width, i, data[i]);
              },
              separatorBuilder: (context, index) =>
                  SizedBox(height: width / 15, child: Divider(thickness: 0.8)),
              itemCount: data.length,
            ),
          )
        : (data.isNotEmpty)
            ? Container(
                height: height * 1.19,
                child: ListView.separated(
                  itemBuilder: (_, i) => _listTickets(width, i, data[i]),
                  separatorBuilder: (context, index) => SizedBox(
                      height: width / 15, child: Divider(thickness: 0.8)),
                  itemCount: data.length,
                ),
              )
            : Column(
                children: [
                  LottieBuilder.asset("assets/json/67375-no-data.json"),
                  Container(
                    width: width / 3,
                    child: AutoSizeText(
                      "Ooops, No Ticket In This Date",
                      style: TextStyle(fontFamily: "popinsemi"),
                      presetFontSizes: [20, 15],
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
  }

  Widget _listTickets(width, int i, tickets) {
    return InkWell(
      onTap: () {},
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: width / 20,
                    color: (tickets["WooCommerceEventsStatus"] != "Checked In")
                        ? Colors.grey
                        : Colors.green,
                  ),
                  SizedBox(width: width / 30),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          (tickets["customerFirstName"] == "")
                              ? tickets["WooCommerceEventsTicketID"]
                              : tickets["customerFirstName"],
                          style: TextStyle(fontFamily: "popinsemi"),
                          presetFontSizes: [width / 45, 14, 12],
                        ),
                        AutoSizeText(
                          presetFontSizes: [width / 55, 12, 10],
                          (tickets["WooCommerceEventsStatus"] != "Checked In")
                              ? "Status : Check-out"
                              : "Status : Check-in",
                          style: TextStyle(color: grayText),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Iconsax.arrow_right_3, size: width / 40, color: grayText)
          ],
        ),
      ),
    );
  }

  Widget _searchBar(width, height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: width * 0.75,
          child: TextField(
            onChanged: (value) {
              setState(() {
                keyword = value;
              });
            },
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                prefixIcon: Icon(Iconsax.search_normal_1, color: grayText),
                hintText: "Search",
                filled: storage.read("isDark"),
                fillColor: inputDark,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width / 40),
                    borderSide: storage.read("isDark")
                        ? BorderSide.none
                        : BorderSide(color: grayText)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width / 40),
                    borderSide: storage.read("isDark")
                        ? BorderSide.none
                        : BorderSide(color: grayText))),
          ),
        ),
        InkWell(
          onTap: () {
            modalFilter();
          },
          child: Container(
            padding: EdgeInsets.all(width / 35),
            decoration: BoxDecoration(
                color: blueTheme,
                borderRadius: BorderRadius.circular(width / 40)),
            child: Icon(Iconsax.setting_4, color: Colors.white),
          ),
        )
      ],
    );
  }
}
