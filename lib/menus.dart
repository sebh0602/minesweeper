import 'package:flutter/material.dart';
import 'package:minesweeper/gameLogic.dart';

class LostDialog extends StatelessWidget{
	final MineSweeper mineSweeper;
	LostDialog(this.mineSweeper);

	@override
	Widget build(BuildContext context){
		return AlertDialog(
			title: Text('You lost!'),
			content:Icon(
				Icons.sentiment_very_dissatisfied,
				size: 50,
			),
			actions: [
				TextButton(
					child: Text('RETRY',
						style:TextStyle(color:Theme.of(context).colorScheme.secondary)
					),
					onPressed: (){
						mineSweeper.startGame();
						Navigator.of(context, rootNavigator: true).pop();
					}
				),
				TextButton(
					child: Text('OK',
						style:TextStyle(color:Theme.of(context).colorScheme.secondary)
					),
					onPressed: (){
						Navigator.of(context, rootNavigator: true).pop();
						//TODO: DISPLAY SOME SORT OF FLOATING RESTART BUTTON
					},
				)
			],
		);
	}
}

class WonDialog extends StatelessWidget{
	final MineSweeper mineSweeper;
	WonDialog(this.mineSweeper);

	@override
	Widget build(BuildContext context){
		return AlertDialog(
			title: Text('You won!'),
			content:Icon(
				Icons.sentiment_very_satisfied,
				size: 50,
			),
			actions: [
				TextButton(
					child: Text('RESTART',
						style:TextStyle(color:Theme.of(context).colorScheme.secondary)
					),
					onPressed: (){
						mineSweeper.startGame();
						Navigator.of(context, rootNavigator: true).pop();
					}
				),
				TextButton(
					child: Text('OK',
						style:TextStyle(color:Theme.of(context).colorScheme.secondary)
					),
					onPressed: (){
						Navigator.of(context, rootNavigator: true).pop();
						//TODO: DISPLAY SOME SORT OF FLOATING RESTART BUTTON
					},
				)
			],
		);
	}
}