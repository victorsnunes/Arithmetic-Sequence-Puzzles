
:- use_module(library(clpfd)).
:- use_module(library(lists)).



%solve([[-1, -1, -1, 0, -1, -1, -1], [-1, 1, -1, -1, -1, -1, -1], [-1, -1, -1, -1, -1, 6, -1], [-1, -1, -1, -1, 8, -1, -1], [-1, -1, -1, -1, -1, -1, 7], [-1, -1, 6, -1, -1, -1, -1], [7, -1, -1, -1, -1, -1, -1]], Solution).
%normal - X

%min - V
%max - V
%ff - V
%anti_first_fail - V
%occurrence - 
%ffc - V
%max_regret - Muito tempo
%impact - X
%dom_w_deg - V

%com min
%step - more than 370s
%enum - more than 370s
%bisect - more than 370s
%median - more than 370s
%middle - more than 370s

%com max
%step - more than 370s
%enum - more than 370s
%bisect - more than 370s
%median - more than 370s
%middle - more than 370s

%anti_first_fail 
%step - more than 370s
%enum - more than 370s
%bisect - more than 370s
%median - more than 370s
%middle - more than 370s

%occurrence
%step - 63,135s
%enum - 2,2238s
%bisect - more than 370s
%median - 
%middle - 

%com ff
%step - 294,055s
%enum - 292,435s
%bisect - 311,006s
%median - 206,980s
%middle - 204,424s

%com ffc
%step - 5,658s
%enum - 5,597s
%bisect - 5,636s
%median - 12,031s
%middle - 12,116s

%com dom_w_deg
%step - 227,353s
%enum - 289,519s
%bisect - 135.608s
%median - 228,374s
%middle - 105,235s

%solve(+InputBoard, -OutputBoard)
solve(InputBoard, OutputBoard, Order, Selection) :- statistics(walltime, [Start,_]),
								  length(InputBoard, BoardSize), length(OutputBoard, BoardSize), 
								  length(PositionsHBoard, BoardSize), length(PositionsVBoard, BoardSize),
								  checkHorizontal(InputBoard, OutputBoard, PositionsHBoard), 
								  checkVertical(InputBoard, OutputBoard, PositionsVBoard),
								  append(PositionsHBoard, PlainPositionsHBoard),
								  append(PositionsVBoard, PlainPositionsVBoard),
								  append(PlainPositionsVBoard, PlainPositionsHBoard, Vars),
								  labeling([Order, Selection, time_out(350000, _)], Vars),
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
% normal - 0,014s

%min - 0,066s
%max - 2,001s
%ff - 0,012s
%anti_first_fail - 5,536s
%occurrence - 0,015s
%ffc - 0,014s
%max_regret - 0,005s

%solve([[-1, -1, -1, 4, -1], [-1, -1, -1, -1, 5], [3, -1, -1, -1, -1], [-1, -1, 5, -1, -1], [-1, 7, -1, -1, -1]], Solution).
% Solution = [[2,-1,3,4,-1],[-1,3,4,-1,5],[3,5,-1,-1,7],[4,-1,5,6,-1],[-1,7,-1,8,9]]
% normal - 1,310s

%min - 63,881s
%max - < 5 minutos
%ff - 0,020s
%anti_first_fail - muito alto
%occurrence - 0,003s
%ffc - 0,012s
%max_regret - 2,284s
%impact - 9,522s
%dom_w_deg - 0,052s

%solve([[-1, -1, -1, 3, -1], [-1, -1, 3, -1, -1], [2, -1, -1, -1, -1], [-1, -1, -1, -1, 9], [-1, 6, -1, -1, -1]], Solution).
% Solution = [[1, -1, -1, 3, 5], [-1, -1, 3, 5, 7], [2, 4, 6, -1, -1], [-1, 5, -1, 7, 9], [3, 6, 9, -1, -1]]
% normal - 2,285s

%solve([[-1, 1, -1, -1, -1, -1], [-1, -1, -1, -1, -1, 5], [-1, -1, -1, -1, 6, -1], [-1, -1, -1, 5, -1, -1], [-1, -1, 3, -1, -1, -1], [6, -1, -1, -1, -1, -1]], Solution).
% Solution = [[0,1,-1,-1,-1,2],[-1,-1,1,-1,3,5],[-1,-1,2,4,6,-1],[3,4,-1,5,-1,-1],[-1,-1,3,6,9,-1],[6,7,-1,-1,-1, 8]]
% normal - 48,957s

%min - X
%max - X
%ff - 1,208s
%anti_first_fail - X
%occurrence - 23,983s
%ffc - 0,579s
%max_regret - 0,799s
%impact - X
%dom_w_deg - 0,182s

%com ffc
%enum - 0,568s
%bisect - 0,578s
%median - 0,134s
%middle - 0,267s

%com dom_w_deg
%step - 0,182s
%enum - 0,552s
%bisect - 0,164s
%median - 0,644s
%middle - 5,308s









%solve([[-1, -1, -1, 0, -1, -1, -1], [-1, 1, -1, -1, -1, -1, -1], [-1, -1, -1, -1, -1, 6, -1], [-1, -1, -1, -1, 8, -1, -1], [-1, -1, -1, -1, -1, -1, 7], [-1, -1, 6, -1, -1, -1, -1], [7, -1, -1, -1, -1, -1, -1]], Solution).
%normal - X

%min - X
%max - X
%ff - 294,055s
%anti_first_fail - X
%occurrence - 
%ffc - 5,658s
%max_regret - Muito tempo
%impact - X
%dom_w_deg - mt tempo

%com ffc
%enum - 5,597s
%bisect - 5,636s
%median - 12,031s
%middle - 12,116s

%com dom_w_deg
%enum - 
%bisect - 
%median - 
%middle - 228,374s











%solve([[-1, -1, -1, -1, -1, 5, -1], [-1, -1, -1, 0, -1, -1, -1], [-1, -1, -1, -1, -1, -1, 6], [-1, 4, -1, -1, -1, -1, -1], [-1, -1, 7, -1, -1, -1, -1], [5, -1, -1, -1, -1, -1, -1], [-1, -1, -1, -1, 6, -1, -1]], Solution).
%normal - X

%min - X
%max - X
%ff - 23,837s
%anti_first_fail - X
%occurrence - 
%ffc - 20,104s
%max_regret - X
%impact - X
%dom_w_deg - 19,011s

%com ffc
%step - 20,104s
%enum - 19,784s
%bisect - 20,096s
%median - 89,664s
%middle - 58,175s

%com dom_w_deg
%step - 19,011s
%enum - 42,620s
%bisect - 17,115s
%median - 15,452s
%middle - 98,907s


%solve([[-1, -1, -1, -1, -1, 4, -1], [-1, -1, 3, -1, -1, -1, -1], [-1, -1, -1, 7, -1, -1, -1], [-1, -1, -1, -1, -1, -1, 7], [2, -1, -1, -1, -1, -1, -1], [-1, 5, -1, -1, -1, -1, -1], [-1, -1, -1, -1, 6, -1, -1]], Solution).

%dom_w_deg median - 0,054s
