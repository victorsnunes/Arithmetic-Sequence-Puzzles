
:- use_module(library(clpfd)).
:- use_module(library(lists)).


%solve(+InputBoard, -OutputBoard)
solve(InputBoard, OutputBoard) :- statistics(walltime, [Start,_]),
								  length(InputBoard, BoardSize), length(OutputBoard, BoardSize), constrainOutputBoard(OutputBoard, BoardSize),
								  length(N1_Rows, BoardSize), length(N2_Rows, BoardSize), length(N3_Rows, BoardSize),
								  domain(N1_Rows, 0, 9), domain(N2_Rows, 0, 9), domain(N3_Rows, 0, 9),
								  length(N1_Cols, BoardSize), length(N2_Cols, BoardSize), length(N3_Cols, BoardSize),
								  domain(N1_Cols, 0, 9), domain(N2_Cols, 0, 9), domain(N3_Cols, 0, 9),
								  length(N1Position_Rows, BoardSize), length(N2Position_Rows, BoardSize), length(N3Position_Rows, BoardSize),
								  domain(N1Position_Rows, 0, BoardSize), domain(N2Position_Rows, 0, BoardSize), domain(N3Position_Rows, 0, BoardSize),
								  length(N1Position_Cols, BoardSize), length(N2Position_Cols, BoardSize), length(N3Position_Cols, BoardSize),
								  domain(N1Position_Cols, 0, BoardSize), domain(N2Position_Cols, 0, BoardSize), domain(N3Position_Cols, 0, BoardSize),
								  initialConstraints(InputBoard, OutputBoard, N1_Rows, N2_Rows, N3_Rows,
																			  N1_Cols, N2_Cols, N3_Cols,
																			  N1Position_Rows, N2Position_Rows, N3Position_Rows,
																			  N1Position_Cols, N2Position_Cols, N3Position_Cols, 1),
								  constrainNumbers(N1_Rows, N2_Rows, N3_Rows, N1_Cols, N2_Cols, N3_Cols,
													  N1Position_Rows, N2Position_Rows, N3Position_Rows, 
													  N1Position_Cols, N2Position_Cols, N3Position_Cols),
								  fillRest(OutputBoard, N1_Rows, N2_Rows, N3_Rows,
														N1_Cols, N2_Cols, N3_Cols,
														N1Position_Rows, N2Position_Rows, N3Position_Rows,
														N1Position_Cols, N2Position_Cols, N3Position_Cols, 1),
								  append(N1_Rows, N2_Rows, Vars1), append(Vars1, N3_Rows, Vars2),
								  append(Vars2, N1_Cols, Vars3), append(Vars3, N2_Cols, Vars4), append(Vars4, N3_Cols, Vars5),
								  append(Vars5, N1Position_Rows, Vars6), append(Vars6, N2Position_Rows, Vars7), append(Vars7, N3Position_Rows, Vars8),
								  append(Vars8, N1Position_Cols, Vars9), append(Vars9, N2Position_Cols, Vars10), append(Vars10, N3Position_Cols, Vars),
								  labeling([], Vars),
								  statistics(walltime, [End,_]), Time is End - Start,
								  format('Time spent to find the answer: ~3d s~n', [Time]).


constrainOutputBoard([], _).
constrainOutputBoard([LineOutputBoard | RestOutputBoard], BoardSize) :- length(LineOutputBoard, BoardSize), domain(LineOutputBoard, -1, 9), constrainOutputBoard(RestOutputBoard, BoardSize).

constrainRowColPositions(OutputBoard, N1_Row, N2_Row, N3_Row, N1_Col, N2_Col, N3_Col, N1Position_Row, N2Position_Row, N3Position_Row, N1Position_Col, N2Position_Col, N3Position_Col, RowIndex, ColumnIndex) :-
								length(OutputBoard, Size), append(OutputBoard, PlainOutputBoard), 
								Index1 #= N1Position_Row + Size * (RowIndex - 1), element(Index1, PlainOutputBoard, N1_Row),
								Index2 #= N2Position_Row + Size * (RowIndex - 1), element(Index2, PlainOutputBoard, N2_Row), 
								Index3 #= N3Position_Row + Size * (RowIndex - 1), element(Index3, PlainOutputBoard, N3_Row),
								Index4 #= ColumnIndex + Size * (N1Position_Col - 1), element(Index4, PlainOutputBoard, N1_Col),
								Index5 #= ColumnIndex + Size * (N2Position_Col - 1), element(Index5, PlainOutputBoard, N2_Col),
								Index6 #= ColumnIndex + Size * (N3Position_Col - 1), element(Index6, PlainOutputBoard, N3_Col).
								

contrainRow([], _, _, _, _, [], [], [], _, _, _, [], [], [], _, _).

contrainRow([-1 | RemainingInputBoardRowElements], OutputBoard, N1_Row, N2_Row, N3_Row, 
									[N1_Col | RemainingN1_Cols], [N2_Col | RemainingN2_Cols], [N3_Col | RemainingN3_Cols],
									N1Position_Row, N2Position_Row, N3Position_Row,
									[N1Position_Col | RemainingN1Position_Cols], [N2Position_Col | RemainingN2Position_Cols], [N3Position_Col | RemainingN3Position_Cols], RowIndex, ColumnIndex) :- constrainRowColPositions(OutputBoard, N1_Row, N2_Row, N3_Row, N1_Col, N2_Col, N3_Col, N1Position_Row, N2Position_Row, N3Position_Row, N1Position_Col, N2Position_Col, N3Position_Col, RowIndex, ColumnIndex), NewColumnIndex is ColumnIndex + 1, contrainRow(RemainingInputBoardRowElements, OutputBoard, N1_Row, N2_Row, N3_Row, 
																																																																																																																		RemainingN1_Cols, RemainingN2_Cols, RemainingN3_Cols,
																																																																																																																		N1Position_Row, N2Position_Row, N3Position_Row,
																																																																																																																		RemainingN1Position_Cols, RemainingN2Position_Cols, RemainingN3Position_Cols, RowIndex, NewColumnIndex).

contrainRow([InputBoardRowElement | RemainingInputBoardRowElements], OutputBoard, N1_Row, N2_Row, N3_Row, 
									[N1_Col | RemainingN1_Cols], [N2_Col | RemainingN2_Cols], [N3_Col | RemainingN3_Cols],
									N1Position_Row, N2Position_Row, N3Position_Row,
									[N1Position_Col | RemainingN1Position_Cols], [N2Position_Col | RemainingN2Position_Cols], [N3Position_Col | RemainingN3Position_Cols], RowIndex, ColumnIndex) :- N3_Row = InputBoardRowElement, N3Position_Row = ColumnIndex, N3_Col = InputBoardRowElement, N3Position_Col = RowIndex, constrainRowColPositions(OutputBoard, N1_Row, N2_Row, N3_Row, N1_Col, N2_Col, N3_Col, N1Position_Row, N2Position_Row, N3Position_Row, N1Position_Col, N2Position_Col, N3Position_Col, RowIndex, ColumnIndex), NewColumnIndex is ColumnIndex + 1, contrainRow(RemainingInputBoardRowElements, OutputBoard, N1_Row, N2_Row, N3_Row, 
																																																																																																																																															RemainingN1_Cols, RemainingN2_Cols, RemainingN3_Cols,
																																																																																																																																															N1Position_Row, N2Position_Row, N3Position_Row,
																																																																																																																																															RemainingN1Position_Cols, RemainingN2Position_Cols, RemainingN3Position_Cols, RowIndex, NewColumnIndex).


initialConstraints([], _, _, _, _, _, _, _, _, _, _, _, _, _, _).
initialConstraints([RowInputBoard | RemainingRowsInputBoard], OutputBoard, [N1_Row | RemainingN1_Rows], [N2_Row | RemainingN2_Rows], [N3_Row | RemainingN3_Rows], 
									N1_Cols, N2_Cols, N3_Cols,
									[N1Position_Row | RemainingN1Position_Rows], [N2Position_Row | RemainingN2Position_Rows], [N3Position_Row | RemainingN3Position_Rows],
									N1Position_Cols, N2Position_Cols, N3Position_Cols, RowIndex) :- contrainRow(RowInputBoard,OutputBoard, N1_Row, N2_Row, N3_Row, 
																																		   N1_Cols, N2_Cols, N3_Cols,
																																		   N1Position_Row, N2Position_Row, N3Position_Row,
																																		   N1Position_Cols, N2Position_Cols, N3Position_Cols, RowIndex, 1), NewRowIndex is RowIndex + 1, initialConstraints(RemainingRowsInputBoard, OutputBoard, RemainingN1_Rows, RemainingN2_Rows, RemainingN3_Rows, 
																																																																								 N1_Cols, N2_Cols, N3_Cols,
																																																																								 RemainingN1Position_Rows, RemainingN2Position_Rows, RemainingN3Position_Rows,
																																																																								 N1Position_Cols, N2Position_Cols, N3Position_Cols, NewRowIndex).
																																																																																											

constrainNumbers([], [], [], [], [], [], [], [], [], [], [], []).
constrainNumbers([N1_Row | RemainingN1_Rows], [N2_Row | RemainingN2_Rows], [N3_Row | RemainingN3_Rows], 
					[N1_Col | RemainingN1_Cols], [N2_Col | RemainingN2_Cols], [N3_Col | RemainingN3_Cols],
					[N1Position_Row | RemainingN1Position_Rows], [N2Position_Row | RemainingN2Position_Rows], [N3Position_Row | RemainingN3Position_Rows], 
					[N1Position_Col | RemainingN1Position_Cols], [N2Position_Col | RemainingN2Position_Cols], [N3Position_Col | RemainingN3Position_Cols]) :- 
										all_distinct([N1_Row, N2_Row, N3_Row]), all_distinct([N1_Col, N2_Col, N3_Col]),
										all_distinct([N1Position_Row, N2Position_Row, N3Position_Row]), all_distinct([N1Position_Col, N2Position_Col, N3Position_Col]),
										constrainNumbersOrder(N1_Row, N2_Row, N3_Row, N1_Col, N2_Col, N3_Col, N1Position_Row, N2Position_Row, N3Position_Row, N1Position_Col, N2Position_Col, N3Position_Col),
										constrainNumbers(RemainingN1_Rows, RemainingN2_Rows, RemainingN3_Rows, RemainingN1_Cols, RemainingN2_Cols, RemainingN3_Cols,
															RemainingN1Position_Rows, RemainingN2Position_Rows, RemainingN3Position_Rows,
															RemainingN1Position_Cols, RemainingN2Position_Cols, RemainingN3Position_Cols).


constrainNumbersOrder(N1_Row, N2_Row, N3_Row, N1_Col, N2_Col, N3_Col, 
					  N1Position_Row, N2Position_Row, N3Position_Row, 
					  N1Position_Col, N2Position_Col, N3Position_Col) :- 
							(N1_Row #< N2_Row #/\ N2_Row #< N3_Row) #=> (N2_Row - N1_Row #= N3_Row - N2_Row #/\ N1Position_Row #< N2Position_Row #/\ N2Position_Row #< N3Position_Row),
							(N1_Row #< N3_Row #/\ N3_Row #< N2_Row) #=> (N3_Row - N1_Row #= N2_Row - N3_Row #/\ N1Position_Row #< N3Position_Row #/\ N3Position_Row #< N2Position_Row),
							(N2_Row #< N1_Row #/\ N1_Row #< N3_Row) #=> (N1_Row - N2_Row #= N3_Row - N1_Row #/\ N2Position_Row #< N1Position_Row #/\ N1Position_Row #< N3Position_Row),
							(N2_Row #< N3_Row #/\ N3_Row #< N1_Row) #=> (N3_Row - N2_Row #= N1_Row - N3_Row #/\ N2Position_Row #< N3Position_Row #/\ N3Position_Row #< N1Position_Row),
							(N3_Row #< N1_Row #/\ N1_Row #< N2_Row) #=> (N1_Row - N3_Row #= N2_Row - N1_Row #/\ N3Position_Row #< N1Position_Row #/\ N1Position_Row #< N2Position_Row),
							(N3_Row #< N2_Row #/\ N2_Row #< N1_Row) #=> (N2_Row - N3_Row #= N1_Row - N2_Row #/\ N3Position_Row #< N2Position_Row #/\ N2Position_Row #< N1Position_Row),
							(N1_Col #< N2_Col #/\ N2_Col #< N3_Col) #=> (N2_Col - N1_Col #= N3_Col - N2_Col #/\ N1Position_Col #< N2Position_Col #/\ N2Position_Col #< N3Position_Col),
							(N1_Col #< N3_Col #/\ N3_Col #< N2_Col) #=> (N3_Col - N1_Col #= N2_Col - N3_Col #/\ N1Position_Col #< N3Position_Col #/\ N3Position_Col #< N2Position_Col),
							(N2_Col #< N1_Col #/\ N1_Col #< N3_Col) #=> (N1_Col - N2_Col #= N3_Col - N1_Col #/\ N2Position_Col #< N1Position_Col #/\ N1Position_Col #< N3Position_Col),
							(N2_Col #< N3_Col #/\ N3_Col #< N1_Col) #=> (N3_Col - N2_Col #= N1_Col - N3_Col #/\ N2Position_Col #< N3Position_Col #/\ N3Position_Col #< N1Position_Col),
							(N3_Col #< N1_Col #/\ N1_Col #< N2_Col) #=> (N1_Col - N3_Col #= N2_Col - N1_Col #/\ N3Position_Col #< N1Position_Col #/\ N1Position_Col #< N2Position_Col),
							(N3_Col #< N2_Col #/\ N2_Col #< N1_Col) #=> (N2_Col - N3_Col #= N1_Col - N2_Col #/\ N3Position_Col #< N2Position_Col #/\ N2Position_Col #< N1Position_Col).
	

fillRestInsideLine([], _, _, _, [], [], [], _, _, _, [], [], [], _, _).
fillRestInsideLine([ElementOutputBoard | RestLineOutputBoard], N1_Row, N2_Row, N3_Row,
					  [N1_Col | RemainingN1_Cols], [N2_Col | RemainingN2_Cols], [N3_Col | RemainingN3_Cols],
					  N1Position_Row, N2Position_Row, N3Position_Row,
					  [N1Position_Col | RemainingN1Position_Cols], [N2Position_Col | RemainingN2Position_Cols], [N3Position_Col | RemainingN3Position_Cols], RowIndex, ColumnIndex) :-
									(N1Position_Row #= ColumnIndex) #=> (ElementOutputBoard #= N1_Row),
									(N2Position_Row #= ColumnIndex) #=> (ElementOutputBoard #= N2_Row),
									(N3Position_Row #= ColumnIndex) #=> (ElementOutputBoard #= N3_Row),
									(N1Position_Row #\= ColumnIndex #/\ N2Position_Row #\= ColumnIndex #/\ N3Position_Row #\= ColumnIndex) #=> ElementOutputBoard #= -1,
									(N1Position_Col #= RowIndex) #=> (ElementOutputBoard #= N1_Col),
									(N2Position_Col #= RowIndex) #=> (ElementOutputBoard #= N2_Col),
									(N3Position_Col #= RowIndex) #=> (ElementOutputBoard #= N3_Col),
									(N1Position_Col #\= RowIndex #/\ N2Position_Col #\= RowIndex #/\ N3Position_Col #\= RowIndex) #=> ElementOutputBoard #= -1,
									NewColumnIndex is ColumnIndex + 1,
									fillRestInsideLine(RestLineOutputBoard, N1_Row, N2_Row, N3_Row,
										  RemainingN1_Cols, RemainingN2_Cols, RemainingN3_Cols,
										  N1Position_Row, N2Position_Row, N3Position_Row,
										  RemainingN1Position_Cols, RemainingN2Position_Cols, RemainingN3Position_Cols, RowIndex, NewColumnIndex).


fillRest([], [], [], [], _, _, _, [], [], [], _, _, _, _).
fillRest([LineOutputBoard | RestOutputBoard], [N1_Row | RemainingN1_Rows], [N2_Row | RemainingN2_Rows], [N3_Row | RemainingN3_Rows],
				N1_Cols, N2_Cols, N3_Cols,
				[N1Position_Row | RemainingN1Position_Rows], [N2Position_Row | RemainingN2Position_Rows], [N3Position_Row | RemainingN3Position_Rows],
				N1Position_Cols, N2Position_Cols, N3Position_Cols, RowIndex) :- 
								fillRestInsideLine(LineOutputBoard, N1_Row, N2_Row, N3_Row, N1_Cols, N2_Cols, N3_Cols, 
																	N1Position_Row, N2Position_Row, N3Position_Row,
																	N1Position_Cols, N2Position_Cols, N3Position_Cols,
																	RowIndex, 1),
								NewRowIndex is RowIndex + 1,
								fillRest(RestOutputBoard, RemainingN1_Rows, RemainingN2_Rows, RemainingN3_Rows,
										N1_Cols, N2_Cols, N3_Cols,
										RemainingN1Position_Rows, RemainingN2Position_Rows, RemainingN3Position_Rows,
										N1Position_Cols, N2Position_Cols, N3Position_Cols, NewRowIndex).
								
										

%solve([[-1, -1, 2, -1], [-1, -1, -1, 6], [1, -1, -1, -1], [-1, 5, -1, -1]], Solution).
% Solution = [[-1,1,2,3],[0,3,-1,6],[1,-1,5,9],[2,5,8,-1]]
% 1- 0,090s
% 2- 0,023s
% new- 3.344s
% WRONGSolution = [[-1,0,2,1],[0,-1,3,6],[1,2,-1,3],[2,5,0,-1]]
% WRONGSolution2 = [[-1,0,2,4],[0,-1,3,6],[1,2,-1,3],[2,5,8,-1]]


%solve([[-1, -1, -1, 4, -1], [-1, -1, -1, -1, 5], [3, -1, -1, -1, -1], [-1, -1, 5, -1, -1], [-1, 7, -1, -1, -1]], Solution).
% 1- 58,888s
% 2- 2,581s
% 3- 1,356s
% Solution = [[2,-1,3,4,-1],[-1,3,4,-1,5],[3,5,-1,-1,7],[4,-1,5,6,-1],[-1,7,-1,8,9]]
% WRONGSolution = [[-1,-1,0,4,1],[-1,-1,1,0,5],[3,0,-1,-1,4],[0,3,5,-1,-1],[4,7,-1,5,-1]]

%solve([[-1, 1, -1, -1, -1, -1], [-1, -1, -1, -1, -1, 5], [-1, -1, -1, -1, 6, -1], [-1, -1, -1, 5, -1, -1], [-1, -1, 3, -1, -1, -1], [6, -1, -1, -1, -1, -1]], Solution).
% Solution = [[0,1,-1,-1,-1,2],[-1,-1,1,-1,3,5],[-1,-1,2,4,6,-1],[3,4,-1,5,-1,-1],[-1,-1,3,6,9,-1],[6,7,-1,-1,-1, 8]]  %86,967s
% 2- 86,967s
% 3- 49,422s


%solve([[-1, -1, -1, 0, -1, -1, -1], [-1, 1, -1, -1, -1, -1, -1], [-1, -1, -1, -1, -1, 6, -1], [-1, -1, -1, -1, 8, -1, -1], [-1, -1, -1, -1, -1, -1, 7], [-1, -1, 6, -1, -1, -1, -1], [7, -1, -1, -1, -1, -1, -1]], Solution).