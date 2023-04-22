
:- use_module(library(clpfd)).
:- use_module(library(lists)).

%solve(+InputBoard, -OutputBoard)
solve(InputBoard, OutputBoard) :- length(InputBoard, BoardSize), length(OutputBoard, BoardSize),
								  checkHorizontal(InputBoard, OutputBoard), 
								  checkVertical(InputBoard, OutputBoard),
								  append(OutputBoard, PlainOutputBoard), labeling([], PlainOutputBoard).


%checkHorizontal(+InputBoard, -OutputBoard)
checkHorizontal([],[]).
checkHorizontal([InputLine | InputRemainingLines], [OutputLine | OutputRemainingLines]) :- solveLine(InputLine, OutputLine), 
																						   checkHorizontal(InputRemainingLines, OutputRemainingLines).

%solveLine(+InputLine, -OutputLine)
solveLine(InputLine, OutputLine) :- length(InputLine, LineSize), length(OutputLine, LineSize),
									NumberOfEmptySquares is LineSize - 3,
									findLineNumber(InputLine, N3, N3Position),
									element(N3Position, OutputLine, N3),
									domain([N1, N2], 0, 9), all_distinct([N1, N2, N3]),
									domain([N1Position, N2Position], 1, LineSize), all_distinct([N1Position, N2Position]),
									constrainNumbers([N1, N2, N3], [N1Position, N2Position, N3Position]),
									element(N1Position, OutputLine, N1), element(N2Position, OutputLine, N2),
									fillRest(OutputLine, [N1Position, N2Position, N3Position], LineSize).

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


%fillRest(-OutputLine, +[N1Pos, N2Pos, N3Pos], +Index)
fillRest(_, _, 0).
fillRest(OutputLine, [N1Pos, N2Pos, N3Pos], Index) :- (N1Pos #= Index), NewIndex is Index - 1,  fillRest(OutputLine, [N1Pos, N2Pos, N3Pos], NewIndex).
fillRest(OutputLine, [N1Pos, N2Pos, N3Pos], Index) :- (N2Pos #= Index), NewIndex is Index - 1,  fillRest(OutputLine, [N1Pos, N2Pos, N3Pos], NewIndex).
fillRest(OutputLine, [N1Pos, N2Pos, N3Pos], Index) :- (N3Pos #= Index), NewIndex is Index - 1,  fillRest(OutputLine, [N1Pos, N2Pos, N3Pos], NewIndex).
fillRest(OutputLine, [N1Pos, N2Pos, N3Pos], Index) :- element(Index, OutputLine, -1), NewIndex is Index - 1,  fillRest(OutputLine, [N1Pos, N2Pos, N3Pos], NewIndex).





checkVertical(InputBoard, OutputBoard) :- transpose(InputBoard, InputBoardTransposed), transpose(OutputBoard, OutputBoardTransposed), 
										  checkHorizontal(InputBoardTransposed, OutputBoardTransposed).


%solve([[-1, -1, 2, -1], [-1, -1, -1, 6], [1, -1, -1, -1], [-1, 5, -1, -1]], Solution).
%solve([[-1, -1, -1, 4, -1], [-1, -1, -1, -1, 5], [3, -1, -1, -1, -1], [-1, -1, 5, -1, -1], [-1, 7, -1, -1, -1]], Solution).