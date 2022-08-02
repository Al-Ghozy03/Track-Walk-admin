// ignore_for_file: prefer_const_constructors, unused_local_variable
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:track_walk_admin/colors.dart';
import 'package:track_walk_admin/screen/detail_tiket.dart';
import 'package:vibration/vibration.dart';

import '../service/api_service.dart';

class QR extends StatefulWidget {
  const QR({super.key});

  @override
  State<QR> createState() => _QRState();
}

class _QRState extends State<QR> {
  final qrkey = GlobalKey(debugLabel: "QR");
  Barcode? barcode;
  QRViewController? controller;
  String? hasil;
  late final Timer timer;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  void codeScan() {
    setState(() {
      if (barcode == null) {
        hasil = "Scan A Code";
      } else {
        hasil = barcode?.code;
      }
    });
  }

  @override
  void initState() {
    codeScan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = Get.height;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            buildQrView(context),
            Positioned(
              bottom: 90,
              child: buildResult(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                buildControlButtons(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildResult() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white24,
      ),
      child: Text(
        "$hasil",
        style: TextStyle(color: Colors.white),
        maxLines: 3,
      ),
    );
  }

  Widget buildControlButtons() {
    final height = Get.height;
    return Container(
      height: height / 12.5,
      // padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(8),
        color: blueTheme,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: FutureBuilder<bool?>(
              future: controller?.getFlashStatus(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return Icon(
                    snapshot.data! ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white,
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            onPressed: () async {
              await controller?.toggleFlash();
              setState(() {});
            },
          )
        ],
      ),
    );
  }

  Widget buildQrView(BuildContext context) => QRView(
        key: qrkey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: blueTheme,
          borderRadius: 11,
          borderWidth: 10,
          borderLength: 20,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
      );
  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((bar) {
      setState(() {
        this.barcode = bar;
        print(bar);
        Timer(Duration(milliseconds: 1), () {
          future(bar);
        });
      });
    });
  }

  void vibrate() async {
    if (await Vibration.hasVibrator()) {
      //check if device has vibration feature
      Vibration.vibrate(); //500 millisecond vibration
    }
  }

  void future(bar) {
    late Future ticket;
    ticket = ApiService().singleTicket(bar.code).then((value) {
      print(value);
      if (value["status"] != "error") {
        HapticFeedback.lightImpact();
        Get.to(
            DetailTiket(
              id: bar,
            ),
            transition: Transition.circularReveal);
      } else {
        vibrate();
        setState(() {
          hasil = "It's not a ticket";
          Timer(Duration(seconds: 5), () {
            hasil = "Scan A Code";
          });
        });
      }
    });
  }
}
