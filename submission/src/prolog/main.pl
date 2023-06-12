
:- use_module(library(clpfd)).
:- use_module(library(lists)).

%solve(+InputBoard, -OutputBoard)
solve(InputBoard, OutputBoard) :- statistics(walltime, [Start,_]),
								  length(InputBoard, BoardSize), length(OutputBoard, BoardSize), 
								  length(PositionsHBoard, BoardSize), length(PositionsVBoard, BoardSize),
								  checkHorizontal(InputBoard, OutputBoard, PositionsHBoard), 
								  checkVertical(InputBoard, OutputBoard, PositionsVBoard),
								  append(PositionsHBoard, PlainPositionsHBoard),
								  append(PositionsVBoard, PlainPositionsVBoard),
								  append(PlainPositionsVBoard, PlainPositionsHBoard, Vars),
								  labeling([dom_w_deg, median], Vars),
								  statistics(walltime, [End,_]), Time is End - Start,
								  format('Time spent to find the answer: ~3d s~n', [Time]).


%checkHorizontal(+InputBoard, -OutputBoard)
checkHorizontal([],[],[]).
checkHorizontal([InputLine | InputRemainingLines], [OutputLine | OutputRemainingLines], 
				[PositionsLine | PositionsRemainingLine]) :- solveLine(InputLine, OutputLine, PositionsLine), 
															 checkHorizontal(InputRemainingLines, OutputRemainingLines, PositionsRemainingLine).

%solveLine(+InputLine, -OutputLine)
solveLine(InputLine, OutputLine, [N1, N1Position, N2, N2Position, N3, N3Position]) :- length(InputLine, LineSize), length(OutputLine, LineSize),
									findLineNumber(InputLine, N3, N3Position),
									element(N3Position, OutputLine, N3),
									domain(OutputLine, -1, 9),
									domain([N1, N2], 0, 9), all_distinct([N1, N2, N3]),
									domain([N1Position, N2Position], 1, LineSize), all_distinct([N1Position, N2Position, N3Position]),
									constrainNumbers([N1, N2, N3], [N1Position, N2Position, N3Position]),
									element(N1Position, OutputLine, N1), element(N2Position, OutputLine, N2),
									NumberOfEmptySquares is LineSize - 3,
									exactly(-1, OutputLine, NumberOfEmptySquares).


%findLineNumber(+InputLine, -N3, -N3Position)
findLineNumber(InputLine, N3, N3Position) :- element(N3Position, InputLine, N3), N3 #\= -1.


%constrainNumbers(+[N1, N2, N3], +[N1Position, N2Position, N3Position])
constrainNumbers([N1, N2, N3], [N1Position, N2Position, N3Position]) :- C in 1..4,
													(N3 #= N2 + C #/\ N2 #= N1 + C #/\ N1Position #< N2Position #/\ N2Position #< N3Position) +
													(N2 #= N3 + C #/\ N3 #= N1 + C #/\ N1Position #< N3Position #/\ N3Position #< N2Position) +
													(N3 #= N1 + C #/\ N1 #= N2 + C #/\ N2Position #< N1Position #/\ N1Position #< N3Position) + 
													(N1 #= N3 + C #/\ N3 #= N2 + C #/\ N2Position #< N3Position #/\ N3Position #< N1Position) +
													(N2 #= N1 + C #/\ N1 #= N3 + C #/\ N3Position #< N1Position #/\ N1Position #< N2Position) +
													(N1 #= N2 + C #/\ N2 #= N3 + C #/\ N3Position #< N2Position #/\ N2Position #< N1Position) #= 1.

checkVertical(InputBoard, OutputBoard, PositionsVBoard) :- transpose(InputBoard, InputBoardTransposed), transpose(OutputBoard, OutputBoardTransposed),
										  checkHorizontal(InputBoardTransposed, OutputBoardTransposed, PositionsVBoard).


exactly(_, [], 0).
exactly(X, [Y|L], N):- X #= Y #<=> B,
					   N #= M + B,
					   exactly(X, L, M).
					  

%solve([[-1, -1, 2, -1], [-1, -1, -1, 6], [1, -1, -1, -1], [-1, 5, -1, -1]], Solution).
% Solution = [[-1,1,2,3],[0,3,-1,6],[1,-1,5,9],[2,5,8,-1]]

%solve([[-1, -1, -1, 4, -1], [-1, -1, -1, -1, 5], [3, -1, -1, -1, -1], [-1, -1, 5, -1, -1], [-1, 7, -1, -1, -1]], Solution).
% Solution = [[2,-1,3,4,-1],[-1,3,4,-1,5],[3,5,-1,-1,7],[4,-1,5,6,-1],[-1,7,-1,8,9]]

%solve([[-1, -1, -1, 3, -1], [-1, -1, 3, -1, -1], [2, -1, -1, -1, -1], [-1, -1, -1, -1, 9], [-1, 6, -1, -1, -1]], Solution).
% Solution = [[1, -1, -1, 3, 5], [-1, -1, 3, 5, 7], [2, 4, 6, -1, -1], [-1, 5, -1, 7, 9], [3, 6, 9, -1, -1]]

%solve([[-1, 1, -1, -1, -1, -1], [-1, -1, -1, -1, -1, 5], [-1, -1, -1, -1, 6, -1], [-1, -1, -1, 5, -1, -1], [-1, -1, 3, -1, -1, -1], [6, -1, -1, -1, -1, -1]], Solution).
% Solution = [[0,1,-1,-1,-1,2],[-1,-1,1,-1,3,5],[-1,-1,2,4,6,-1],[3,4,-1,5,-1,-1],[-1,-1,3,6,9,-1],[6,7,-1,-1,-1, 8]]

%solve([[-1, -1, -1, 0, -1, -1, -1], [-1, 1, -1, -1, -1, -1, -1], [-1, -1, -1, -1, -1, 6, -1], [-1, -1, -1, -1, 8, -1, -1], [-1, -1, -1, -1, -1, -1, 7], [-1, -1, 6, -1, -1, -1, -1], [7, -1, -1, -1, -1, -1, -1]], Solution).
%solve([[-1, -1, -1, -1, -1, 5, -1], [-1, -1, -1, 0, -1, -1, -1], [-1, -1, -1, -1, -1, -1, 6], [-1, 4, -1, -1, -1, -1, -1], [-1, -1, 7, -1, -1, -1, -1], [5, -1, -1, -1, -1, -1, -1], [-1, -1, -1, -1, 6, -1, -1]], Solution).
%solve([[-1, -1, -1, -1, -1, 4, -1], [-1, -1, 3, -1, -1, -1, -1], [-1, -1, -1, 7, -1, -1, -1], [-1, -1, -1, -1, -1, -1, 7], [2, -1, -1, -1, -1, -1, -1], [-1, 5, -1, -1, -1, -1, -1], [-1, -1, -1, -1, 6, -1, -1]], Solution).
