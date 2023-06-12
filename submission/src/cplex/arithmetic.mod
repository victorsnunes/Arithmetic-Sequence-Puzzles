/*********************************************
 * OPL 22.1.1.0 Model
 * Author: Valentina
 * Creation Date: 29/05/2023 at 19:15:05
 *********************************************/

 using CP;
 
 int n = ...; //Matrix nxn
 int InputBoard[1..n][1..n] = ...;
 
 
range Rows = 1..n;
range Cols = 1..n;

// Define the domain of numbers
range Numbers = 0..9;

dvar int OutputBoard[1..n][1..n] in -1..9;
// Define the model
dvar int N1_Rows[Rows] in Numbers;
dvar int N2_Rows[Rows] in Numbers;
dvar int N3_Rows[Rows] in Numbers;
dvar int N1_Cols[Cols] in Numbers;
dvar int N2_Cols[Cols] in Numbers;
dvar int N3_Cols[Cols] in Numbers;
dvar int N1Position_Rows[Rows] in Cols;
dvar int N2Position_Rows[Rows] in Cols;
dvar int N3Position_Rows[Rows] in Cols;
dvar int N1Position_Cols[Cols] in Rows;
dvar int N2Position_Cols[Cols] in Rows;
dvar int N3Position_Cols[Cols] in Rows;

/*
N1_Rows cada linha i tem um N1
N1Position_Rows na linha i tem um c que é a coluna que pertence
InputBoard[i][N1Position_Rows[i]] = N1
*/



subject to
 {
   forall (r in Rows, c in Cols){
     
     // findLineNumber(InputLine, N3, N3Position),
  	(InputBoard[r][c] != -1) => (N3_Rows[r]==InputBoard[r][c] && N3Position_Rows[r] == c) &&
  				(N3_Cols[c]==InputBoard[r][c] && N3Position_Cols[c] == r);
  	
  	/* element(N1Position, OutputLine, N1)
  	element(N2Position, OutputLine, N2)
  	element(N3Position, OutputLine, N3)*/
  	N1_Rows[r] == OutputBoard[r][N1Position_Rows[r]];
  	N2_Rows[r] == OutputBoard[r][N2Position_Rows[r]];
  	N3_Rows[r] == OutputBoard[r][N3Position_Rows[r]];
  	
  	N1_Cols[c] == OutputBoard[N1Position_Cols[c]][c];
  	N2_Cols[c] == OutputBoard[N2Position_Cols[c]][c];
  	N3_Cols[c] == OutputBoard[N3Position_Cols[c]][c];
  	
   } 
   
   /*all_distinct([N1, N2, N3])
   	all_distinct([N1Position, N2Position])*/
   forall(i in Rows){
     N1_Rows[i] != N2_Rows[i] && N2_Rows[i] != N3_Rows[i] && N1_Rows[i] != N3_Rows[i];
     N1_Cols[i] != N2_Cols[i] && N2_Cols[i] != N3_Cols[i] && N1_Cols[i] != N3_Cols[i];
     N1Position_Rows[i] != N2Position_Rows[i] && N2Position_Rows[i] != N3Position_Rows[i] && N1Position_Rows[i] != N3Position_Rows[i];
     N1Position_Cols[i] != N2Position_Cols[i] && N2Position_Cols[i] != N3Position_Cols[i] && N1Position_Cols[i] != N3Position_Cols[i];
   }
   
   //constrainNumbers(+[N1, N2, N3], +[N1Position, N2Position, N3Position])
   forall(j in Cols){
     // Rows
     (N1_Rows[j] < N2_Rows[j] && N2_Rows[j] < N3_Rows[j]) => N2_Rows[j]-N1_Rows[j]==N3_Rows[j]-N2_Rows[j] && 
     	N1Position_Rows[j] < N2Position_Rows[j] && N2Position_Rows[j] < N3Position_Rows[j];
     
     (N1_Rows[j] < N3_Rows[j] && N3_Rows[j] < N2_Rows[j]) => N3_Rows[j]-N1_Rows[j]==N2_Rows[j]-N3_Rows[j] && 
     	N1Position_Rows[j] < N3Position_Rows[j] && N3Position_Rows[j] < N2Position_Rows[j];
     	
     (N2_Rows[j] < N1_Rows[j] && N1_Rows[j] < N3_Rows[j]) => N1_Rows[j]-N2_Rows[j]==N3_Rows[j]-N1_Rows[j] && 
     	N2Position_Rows[j] < N1Position_Rows[j] && N1Position_Rows[j] < N3Position_Rows[j];
     	
     (N2_Rows[j] < N3_Rows[j] && N3_Rows[j] < N1_Rows[j]) => N3_Rows[j]-N2_Rows[j]==N1_Rows[j]-N3_Rows[j] && 
     	N2Position_Rows[j] < N3Position_Rows[j] && N3Position_Rows[j] < N1Position_Rows[j];
     	
     (N3_Rows[j] < N1_Rows[j] && N1_Rows[j] < N2_Rows[j]) => N1_Rows[j]-N3_Rows[j]==N2_Rows[j]-N1_Rows[j] && 
     	N3Position_Rows[j] < N1Position_Rows[j] && N1Position_Rows[j] < N2Position_Rows[j];
     	
     (N3_Rows[j] < N2_Rows[j] && N2_Rows[j] < N1_Rows[j]) => N2_Rows[j]-N3_Rows[j]==N1_Rows[j]-N2_Rows[j] && 
     	N3Position_Rows[j] < N2Position_Rows[j] && N2Position_Rows[j] < N1Position_Rows[j];
     	
     //Cols
     (N1_Cols[j] < N2_Cols[j] && N2_Cols[j] < N3_Cols[j]) => N2_Cols[j]-N1_Cols[j]==N3_Cols[j]-N2_Cols[j] && 
     	N1Position_Cols[j] < N2Position_Cols[j] && N2Position_Cols[j] < N3Position_Cols[j];
     
     (N1_Cols[j] < N3_Cols[j] && N3_Cols[j] < N2_Cols[j]) => N3_Cols[j]-N1_Cols[j]==N2_Cols[j]-N3_Cols[j] && 
     	N1Position_Cols[j] < N3Position_Cols[j] && N3Position_Cols[j] < N2Position_Cols[j];
     	
     (N2_Cols[j] < N1_Cols[j] && N1_Cols[j] < N3_Cols[j]) => N1_Cols[j]-N2_Cols[j]==N3_Cols[j]-N1_Cols[j] && 
     	N2Position_Cols[j] < N1Position_Cols[j] && N1Position_Cols[j] < N3Position_Cols[j];
     	
     (N2_Cols[j] < N3_Cols[j] && N3_Cols[j] < N1_Cols[j]) => N3_Cols[j]-N2_Cols[j]==N1_Cols[j]-N3_Cols[j] && 
     	N2Position_Cols[j] < N3Position_Cols[j] && N3Position_Cols[j] < N1Position_Cols[j];
     	
     (N3_Cols[j] < N1_Cols[j] && N1_Cols[j] < N2_Cols[j]) => N1_Cols[j]-N3_Cols[j]==N2_Cols[j]-N1_Cols[j] && 
     	N3Position_Cols[j] < N1Position_Cols[j] && N1Position_Cols[j] < N2Position_Cols[j];
     	
     (N3_Cols[j] < N2_Cols[j] && N2_Cols[j] < N1_Cols[j]) => N2_Cols[j]-N3_Cols[j]==N1_Cols[j]-N2_Cols[j] && 
     	N3Position_Cols[j] < N2Position_Cols[j] && N2Position_Cols[j] < N1Position_Cols[j];
   }
   
   //fillRest(-OutputLine, +[N1Pos, N2Pos, N3Pos], +Index)
   forall(r in Rows, c in Cols){
	
		(N1Position_Rows[r] == c) => OutputBoard[r][c] == N1_Rows[r];
		(N2Position_Rows[r] == c) => OutputBoard[r][c] == N2_Rows[r];
		(N3Position_Rows[r] == c) => OutputBoard[r][c] == N3_Rows[r];
		(N1Position_Rows[r] != c && N2Position_Rows[r] != c && N3Position_Rows[r] != c) => OutputBoard[r][c] == -1;
		
		(N1Position_Cols[c] == r) => OutputBoard[r][c] == N1_Cols[c];
		(N2Position_Cols[c] == r) => OutputBoard[r][c] == N2_Cols[c];
		(N3Position_Cols[c] == r) => OutputBoard[r][c] == N3_Cols[c];
		(N1Position_Cols[c] != r && N2Position_Cols[c] != r && N3Position_Cols[c] != r) => OutputBoard[r][c] == -1;
	
	}
	
 }
 
 execute{
   var f = cp.factory;
   var phase1 = f.searchPhase(OutputBoard,f.selectLargest(f.regretOnMin()),f.selectSmallest(f.valueImpact()));
   cp.setSearchPhases(phase1);
   cp.param.SearchType = "IterativeDiving";
}
 
