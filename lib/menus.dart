import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
									Navigator.of(context, rootNavigator: true).pop();
									showDialog(
										context: context,
										builder: (context){
											return CustomDialog();
										}
									);									
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
		var mineSweeper = Provider.of<MineSweeper>(context, listen:false);

		var wController = TextEditingController();
		wController.text = mineSweeper.cols.toString();

		var hController = TextEditingController();
		hController.text = mineSweeper.rows.toString();

		var pController = TextEditingController();
		pController.text = mineSweeper.explosiveChance.toString();

		void okHandler(){
			int w;
			try{
				w = int.parse(wController.text);
			}on FormatException{
				w = mineSweeper.defaultSize;
			}
			
			if (w > 100) w = 100;
			else if (w < 4) w = 4;
			mineSweeper.cols = w;

			int h;
			try{
				h = int.parse(hController.text);
			}on FormatException{
				h = mineSweeper.defaultSize;
			}
			if (h > 100) h = 100;
			else if (h < 4) h = 4;
			mineSweeper.rows = h;

			double p;
			try{
				p = double.parse(pController.text);
			}on FormatException{
				p = mineSweeper.defaultChance;
			}
			if (p > 0.5) p = 0.5;
			mineSweeper.explosiveChance = p;
		}

		return AlertDialog(
			title:Text('Settings'),
			content: Column(
				mainAxisSize: MainAxisSize.min,
				children:[
					TextField(
						decoration: InputDecoration(
							labelText: 'Width',
							hintText: mineSweeper.defaultSize.toString(),
						),
						keyboardType: TextInputType.number,
						inputFormatters: [FilteringTextInputFormatter.digitsOnly],
						controller: wController,
					),
					TextField(
						decoration: InputDecoration(
							labelText: 'Height',
							hintText: mineSweeper.defaultSize.toString(),
						),
						keyboardType: TextInputType.number,
						inputFormatters: [FilteringTextInputFormatter.digitsOnly],
						controller: hController,
					),
					TextField(
						decoration: InputDecoration(
							labelText: 'Bomb Probability',
							hintText: mineSweeper.defaultChance.toString(),
						),
						keyboardType: TextInputType.numberWithOptions(decimal:true),
						inputFormatters: [
							FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
						],
						controller: pController,
					),
				]
			),
			actions: [
				TextButton(
					onPressed: (){
						Navigator.of(context, rootNavigator: true).pop();
					},
					child: Text('CANCEL',
						style:TextStyle(color:Theme.of(context).colorScheme.secondary)
					)
				),
				TextButton(
					onPressed: (){
						okHandler();
						Navigator.of(context, rootNavigator: true).pop();
					},
					child: Text('OK',
						style:TextStyle(color:Theme.of(context).colorScheme.secondary)
					)
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