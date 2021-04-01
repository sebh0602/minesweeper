import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vibration/vibration.dart';
import 'package:minesweeper/menus.dart';

class MineSweeper extends ChangeNotifier{
	final _random = Random();
	
	int _cols = 9;
	int _rows = 20;
	double _explosiveChance = 0.2;
	int _bombCount = 0;
	int _flagCount = 0;

	int get cols => _cols;
	int get rows => _rows;
	int get bombCount => _bombCount;
	int get flagCount => _flagCount;
	String get gameMode => _gameMode;

	List<List<Map<String,bool>>> _board;
	var _boardPopulated = false;
	var _gameMode = 'init'; //playing, won, lost

	void startGame(){
		_gameMode = 'init';

		_createBoard();
		notifyListeners();
	}

	void _createBoard(){
		_bombCount = 0;
		_flagCount = 0;
		_board = [for (var x = 0; x < _cols; x++) 
			[for (var y = 0; y < _rows; y++) 
				Map<String,bool>()
			]
		];

		for (var x = 0; x < _cols; x++){
			for (var y = 0; y < _rows; y++){
				_board[x][y]['covered'] = true;
				_board[x][y]['flagged'] = false;
				bool bomb = _random.nextDouble() < _explosiveChance;
				_board[x][y]['bomb'] = bomb;
				if (bomb) _bombCount++;
			}
		}

		_boardPopulated = true;
	}

	void _boardExistsCheck([int x = -1, int y = -1]){
		if (!_boardPopulated) _createBoard();
		
		if (x != -1){
			while (getBombCount(x, y) != 0 || _board[x][y]['bomb']){
				_createBoard();
			}
		}
	}

	bool _checkWin(){
		for (var x = 0; x < _cols; x++){
			for (var y = 0; y < _rows; y++){
				if (!_board[x][y]['bomb'] && _board[x][y]['covered']){
					return false;
				}
			}
		}
		return true;
	}

	void _quietlyUnCover(x,y){
		if (_board[x][y]['covered'] && !_board[x][y]['flagged']){
			_board[x][y]['covered'] = false;
			if (getBombCount(x, y) == 0 && !_board[x][y]['bomb']){
				var coords = [
					[x-1,y-1],
					[x,y-1],
					[x+1,y-1],
					[x-1,y],
					[x+1,y],
					[x-1,y+1],
					[x,y+1],
					[x+1,y+1],
				];
				for (var pair in coords){
					if (0 <= pair[0] && pair[0] < _cols){
						if (0 <= pair[1] && pair[1] < _rows){
							_quietlyUnCover(pair[0], pair[1]);
						}
					}
				}	
			}
		}
	}

	void unCover(int x,int y, BuildContext context){
		if (_gameMode == 'init'){
			_boardExistsCheck(x,y);
			_gameMode = 'playing';
		} else{
			_boardExistsCheck();
		}

		if (_board[x][y]['flagged']){
			return null;
		}

		_quietlyUnCover(x, y); //to prevent mass notification of listeners

		if (_board[x][y]['bomb']){
			_gameMode = 'lost';
			showDialog(
				context: context, 
				builder: (context){
					return LostDialog(this);
				}
			);
		} else if (_checkWin()){
			_gameMode = 'won';
			showDialog(
				context: context, 
				builder: (context){
					return WonDialog(this);
				}
			);
		}

		notifyListeners();
	}

	Map<String,bool> getField(int x, int y){
		_boardExistsCheck();
		return _board[x][y];
	}

	void toggleFlag(int x, int y){
		if (_board[x][y]['covered']){
			_board[x][y]['flagged'] = !_board[x][y]['flagged'];

			if (_board[x][y]['flagged']) _flagCount++;
			else _flagCount--;

			notifyListeners();
			Vibration.vibrate(duration: 50);
		}
	}

	int getBombCount(int x, int y){
		_boardExistsCheck();
		var bombCount = 0;
		var coords = [
			[x-1,y-1],
			[x,y-1],
			[x+1,y-1],
			[x-1,y],
			[x+1,y],
			[x-1,y+1],
			[x,y+1],
			[x+1,y+1],
		];
		for (var pair in coords){
			if (0 <= pair[0] && pair[0] < _cols){
				if (0 <= pair[1] && pair[1] < _rows){
					if (_board[pair[0]][pair[1]]['bomb']){
						bombCount += 1;
					}
				}
			}
		}
		return bombCount;
	}
}