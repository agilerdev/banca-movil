import 'package:flutter/material.dart';

double sp(BuildContext context) {
  double sp = ((MediaQuery.of(context).size.width / 3) / 100);
  return sp;
}
