import 'dart:io';
import 'package:est/components/components.dart';
import 'package:est/controller/valuecontroller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ValueController valueController = Get.put(ValueController());
    valueController.widgetList = [];

    GlobalKey key = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: key,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(flex: 1, child: formField(valueController.controller)),
                Expanded(
                    flex: 2,
                    child: Obx(() => RangeSlider(
                          max: 999,
                          divisions: 20,
                          labels: RangeLabels(
                              valueController.values.value.start
                                  .ceil()
                                  .toString(),
                              valueController.values.value.end
                                  .ceil()
                                  .toString()),
                          values: valueController.values.value,
                          onChanged: (value) {
                            valueController.values.value = value;
                          },
                        ))),
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  child: Obx(() => DropdownButtonHideUnderline(
                        child: ButtonTheme(
                            focusColor: Colors.green.shade100,
                            minWidth: 40,
                            alignedDropdown: true,
                            child: DropdownButton(
                              onChanged: (value) {
                                valueController.semValue.value = value as int;
                              },
                              value: valueController.semValue.value,
                              borderRadius: BorderRadius.circular(5),
                              dropdownColor:
                                  const Color.fromARGB(255, 176, 227, 178),
                              items: valueController.sem.map((element) {
                                return DropdownMenuItem(
                                  value: element,
                                  child: Text("Sem $element"),
                                );
                              }).toList(),
                            )),
                      )),
                )),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    flex: 0,
                    child: TextButton(
                        style: TextButton.styleFrom(
                            minimumSize: const Size(140, 60),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: const BorderSide(
                                    width: 1, color: Colors.green))),
                        onPressed: () async {
                          valueController.endFlag.value = false;
                          if (valueController
                              .controller.value.text.isNotEmpty) {
                            valueController.flag.value = true;
                          }
                        },
                        child: const Text("Get")))
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => SizedBox(
                    height: MediaQuery.of(context).size.height / 1.71,
                    width: MediaQuery.of(context).size.width / 3.6,
                    child: valueController.flag.value
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: StreamBuilder<List<String?>>(
                              stream: valueController.getMarks(),
                              builder: (context, snapshot) {
                                if (snapshot.data != [] &&
                                    snapshot.data != null &&
                                    snapshot.data!.isNotEmpty &&
                                    snapshot.data!.length > 2) {
                                  sheet.insertRowIterables("sheet1",
                                      snapshot.data!, valueController.counts);
                                  valueController.widgetList.add(Card(
                                    margin: const EdgeInsets.all(8),
                                    shadowColor: Colors.green.shade300,
                                    elevation: 4,
                                    color: Colors.white,
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: SizedBox(
                                        height: 100,
                                        width: 420,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data![0]!,
                                                style: const TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                snapshot.data![1]!,
                                                style: TextStyle(
                                                    color:
                                                        Colors.green.shade300,
                                                    fontSize: 12),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  for (int k = 2;
                                                      k < snapshot.data!.length;
                                                      k++)
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              3),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        border: Border.all(
                                                            color: Colors.green,
                                                            width: 1.5),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          snapshot.data![k]! ==
                                                                  "Fail"
                                                              ? "F"
                                                              : snapshot
                                                                  .data![k]!,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: snapshot.data![
                                                                          k]! ==
                                                                      "Fail"
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .black),
                                                        ),
                                                      ),
                                                    )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ));
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const LinearProgressIndicator();
                                }
                                return SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  reverse: true,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: valueController.widgetList,
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Text(
                              "Please give prefix",
                              style: TextStyle(color: Colors.green.shade100),
                            ),
                          ),
                  ),
                ),
                Expanded(
                    flex: 4,
                    child: Center(
                      child: TextFormField(
                        readOnly: true,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        style: const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                        controller: valueController.pathcontroller.value,
                      ),
                    )),
                const Expanded(
                  flex: 3,
                  child: SizedBox(
                    width: 10,
                  ),
                ),
                Expanded(
                    child: TextButton(
                  style: TextButton.styleFrom(
                      minimumSize: const Size(140, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side:
                              const BorderSide(width: 1, color: Colors.green))),
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () {
                    if (valueController.pathcontroller.value.text.isNotEmpty) {
                      var fileBytes = sheet.save();
                      File(
                          "${valueController.pathcontroller.value.text}/${DateTime.now().toString().replaceAll(".", "").trim().replaceAll(":", "")}.xlsx")
                        ..createSync(recursive: true)
                        ..writeAsBytesSync(fileBytes!);
                    }
                  },
                )),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    flex: 1,
                    child: TextButton(
                        style: TextButton.styleFrom(
                            minimumSize: const Size(140, 60),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: const BorderSide(
                                    width: 1, color: Colors.green))),
                        onPressed: () async {
                          String? path =
                              await FilePicker.platform.getDirectoryPath();
                          if (path != null) {
                            valueController.pathcontroller.value.text = path;
                          }
                        },
                        child: const Text("Open")))
              ],
            )
          ],
        ),
      ),
    );
  }
}
