import 'package:flutter/material.dart';
import 'package:get/get.dart';

TextFormField formField(Rx<TextEditingController> controller) {
  return TextFormField(
    controller: controller.value,
    textCapitalization: TextCapitalization.characters,
    style: const TextStyle(color: Colors.green),
    decoration: const InputDecoration(
      border: OutlineInputBorder(),
      hintText: "Enter prefix",
    ),
  );
}
