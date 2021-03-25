import 'package:flutter/material.dart';
import 'package:minesweeper/gameLogic.dart';
import 'package:provider/provider.dart';

void main() {
	runApp(MyApp());
}

class MyApp extends StatelessWidget {
	// This widget is the root of your application.
	@override
	Widget build(BuildContext context) {
		return ChangeNotifierProvider(
			create: (context) => MineSweeper(),
			child:MaterialApp(
				title: 'Flutter Demo',
				theme: ThemeData(
					primarySwatch: Colors.indigo,
					brightness: Brightness.dark
				),
				home: Scaffold(
					body:Center(
						child:LayoutBuilder(
							builder:(context,constraints){
								return InteractiveViewer(
									constrained: false,
									//boundaryMargin: EdgeInsets.all(150),
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
																decoration: BoxDecoration(
																	borderRadius: BorderRadius.circular(5),
																	color:Colors.blue,
																),
																width: boxSize,
																height: boxSize,
																margin: EdgeInsets.all(boxMargin),
																child: Center(
																	child:Text('$x, $y')
																),
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
