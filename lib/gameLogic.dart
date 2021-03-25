import 'package:flutter/material.dart';
import 'dart:math';

class MineSweeper extends ChangeNotifier{
	final _random = Random();
	
	int _cols = 3;
	int _rows = 3;

	int get cols => _cols;
	int get rows => _rows;
}