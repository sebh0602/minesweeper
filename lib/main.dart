import 'package:flutter/material.dart';
import 'package:minesweeper/gameLogic.dart';
import 'package:minesweeper/menus.dart';
import 'package:provider/provider.dart';

void main() {
	runApp(MyApp());
}

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return ChangeNotifierProvider(
			create: (context) => MineSweeper(),
			child:MaterialApp(
				title: 'minesweeper',
				theme: ThemeData(
					colorScheme: ColorScheme.dark(
						primary:Colors.blueGrey[400],
						primaryVariant: Colors.blueGrey[700],
						
						secondary: Colors.blue[50],
						onSecondary: Colors.black,
						secondaryVariant: Colors.blue[700],
					),
					accentColor: Colors.blue[300]
				),
				home: Scaffold(
					floatingActionButton: FAB(),
					//floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
					body:Center(
						child:LayoutBuilder(
							builder:(context,constraints){
								return InteractiveViewer(
									constrained: false,
									boundaryMargin: EdgeInsets.all(150),
									minScale: 0.1,
									maxScale: 2,
									clipBehavior: Clip.none,
									transformationController: TransformationController(),
									child:Consumer<MineSweeper>(
										builder: (context, mineSweeper, child){
											var viewportSize = Size(
												constraints.maxWidth,
												constraints.maxHeight
											);
											var boxSize = 50.0;
											var boxMargin = 5.0;
											var boundaryMargin = 20*2;
											var borderRadius = 5.0;
											var gridWidth = mineSweeper.cols*(boxSize + 2*boxMargin);
											var gridHeight = mineSweeper.rows*(boxSize + 2*boxMargin);
											num containerWidth;
											if (gridWidth > viewportSize.width){
												containerWidth = gridWidth + boundaryMargin;
											} else{
												if (viewportSize.width - gridWidth < boundaryMargin){
													containerWidth = viewportSize.width + boundaryMargin - (viewportSize.width - gridWidth);
												} else{
													containerWidth = viewportSize.width;
												}
											}
											num containerHeight;
											if (gridHeight > viewportSize.height){
												containerHeight = gridHeight + boundaryMargin;
											} else{
												if (viewportSize.height - gridHeight < boundaryMargin){
													containerHeight = viewportSize.height + boundaryMargin - (viewportSize.height - gridHeight);
												} else{
													containerHeight = viewportSize.height;
												}
											}

											Widget fieldChild(int x, int y){
												/*if (mineSweeper.getField(x,y)['bomb']){ //TEMP: remove later
													return Icon(Icons.dangerous);
												}*/

												var playing = mineSweeper.gameMode == 'playing' || mineSweeper.gameMode == 'init';
												var covered = mineSweeper.getField(x,y)['covered'];
												var flagged = mineSweeper.getField(x,y)['flagged'];
												var bomb = mineSweeper.getField(x,y)['bomb'];
												var bombsNearby = mineSweeper.getBombCount(x,y) != 0;

												if (covered){
													if (flagged){
														return Icon(Icons.flag);
													} else {
														if (playing){
															return null;
														} else{
															if (bomb){
																return Icon(Icons.coronavirus);
															} else{
																return null;
															}
														}
													}
												} else{
													if (bomb){
														return Icon(Icons.coronavirus);
													} else{
														if (bombsNearby){
															return Text('${mineSweeper.getBombCount(x, y)}',
																style:TextStyle(color:Theme.of(context).colorScheme.onSecondary),
															);
														} else{
															return null;
														}
													}
												}
											}

											Color fieldColor(int x, int y){
												var playing = mineSweeper.gameMode == 'playing' || mineSweeper.gameMode == 'init';
												var covered = mineSweeper.getField(x,y)['covered'];
												var bomb = mineSweeper.getField(x,y)['bomb'];
												var colorScheme = Theme.of(context).colorScheme;

												if (playing){
													if (covered){
														return colorScheme.secondaryVariant;
													} else{
														return colorScheme.secondary;
													}
												} else{
													if (covered){
														if (bomb){
															return colorScheme.primaryVariant;
														} else{
															return colorScheme.secondaryVariant;
														}
													} else{
														if (bomb){
															return colorScheme.primary;
														} else{
															return colorScheme.secondary;
														}
													}
												}
											}

											return Container(
												width:containerWidth,
												height:containerHeight,
												child:Center(
													
													child:Row(
														mainAxisAlignment: MainAxisAlignment.center,
														crossAxisAlignment: CrossAxisAlignment.center,
														mainAxisSize: MainAxisSize.min,
														
														children: <Widget>[for (int x = 0; x < mineSweeper.cols; x++) Column(
															mainAxisAlignment: MainAxisAlignment.center,
															crossAxisAlignment: CrossAxisAlignment.center,
															mainAxisSize: MainAxisSize.min,
															
															children: <Widget>[for (int y = 0; y < mineSweeper.rows; y++) Container(
																margin: EdgeInsets.all(boxMargin),
																
																child:Ink(
																	decoration: BoxDecoration(
																		borderRadius: BorderRadius.circular(borderRadius),
																		color:fieldColor(x, y)
																	),
																	width: boxSize,
																	height: boxSize,
																	
																	child: InkWell(
																		onDoubleTap: (){
																			mineSweeper.unCover(x, y, context);
																		},
																		onLongPress: (){
																			mineSweeper.toggleFlag(x, y);
																		},
																		borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
																		child:Center(
																			child:fieldChild(x, y)
																		),
																	)
																)
															)],
														)],
													)
												)
											);
										},
									)
								);
							}
						)
					)
				),
			)
		);
	}
}


