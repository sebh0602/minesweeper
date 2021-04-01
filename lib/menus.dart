import 'package:flutter/material.dart';
import 'package:minesweeper/gameLogic.dart';
import 'package:provider/provider.dart';

class FAB extends StatelessWidget{
	@override
	Widget build(BuildContext context){
		var mineSweeper = Provider.of<MineSweeper>(context, listen:false);

		return FloatingActionButton(
			child: Icon(Icons.more_vert,color: Colors.white,),
			backgroundColor: Theme.of(context).colorScheme.primaryVariant,
			onPressed: (){
				showMenu(
					context: context, 
					position: RelativeRect.fromLTRB(99999, 99999, 0, 0), 
					items: <PopupMenuEntry<dynamic>>[
						PopupMenuItem(
							child:ListTile(
								leading: Icon(Icons.info_outline),
								onTap: (){},
								title:RichText(
									text:TextSpan(
										style: TextStyle(
											fontSize: 20
										),
										children:[
											TextSpan(text:'${mineSweeper.bombCount} '),
											WidgetSpan(
												child: Icon(Icons.coronavirus)
											),
											TextSpan(text: '  -  ${mineSweeper.flagCount} '),
											WidgetSpan(
												child: Icon(Icons.flag)
											),
										]
									)
								),
							)
						),
						PopupMenuDivider(),
						PopupMenuItem(
							child:ListTile(
								leading: Icon(Icons.settings),
								title:Text('Settings'),
								onTap: (){
									showDialog(
										context: context, 
										builder: (context){
											return WonDialog(mineSweeper);
										}
									);
									print('wut');
									print(Theme.of(context).colorScheme);
									Navigator.of(context, rootNavigator: true).pop();
								},
							)
						),
						PopupMenuItem(
							child:ListTile(
								leading: Icon(Icons.settings_backup_restore),
								title:Text('Reset'),
								onTap: (){
									mineSweeper.startGame();
									Navigator.of(context, rootNavigator: true).pop();
								},
							)
						),
					]
				);
			},
		);
	}
}

class CustomDialog extends StatefulWidget{
	@override
	_CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog>{
	@override
	Widget build(BuildContext context){
		return AlertDialog(
			title:Text('Settings'),
			content: Column(
				children:[Text('hi'),]
			),
			actions: [
				TextButton(
					onPressed: (){},
					child: Text('CANCEL')
				),
				TextButton(
					onPressed: (){},
					child: Text('OK')
				)
			],
		);
	}
}

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
					},
				)
			],
		);
	}
}