# Instruction

## Prolog

### Installation

To run the pl file, you need to install [SICStus Prolog](https://sicstus.sics.se/download4.html)

### Use

The main predicate to solve the problem is solve(+InputBoard, -OutputBoard), the first parameter is the input matrix, and the second parameter is the output matrix solution.

### Test Instruction

Here are some test examples:
```
solve([[-1, -1, 2, -1], [-1, -1, -1, 6], [1, -1, -1, -1], [-1, 5, -1, -1]], Solution).
% Solution = [[-1,1,2,3],[0,3,-1,6],[1,-1,5,9],[2,5,8,-1]]

solve([[-1, -1, -1, 4, -1], [-1, -1, -1, -1, 5], [3, -1, -1, -1, -1], [-1, -1, 5, -1, -1], [-1, 7, -1, -1, -1]], Solution).
% Solution = [[2,-1,3,4,-1],[-1,3,4,-1,5],[3,5,-1,-1,7],[4,-1,5,6,-1],[-1,7,-1,8,9]]

solve([[-1, -1, -1, 3, -1], [-1, -1, 3, -1, -1], [2, -1, -1, -1, -1], [-1, -1, -1, -1, 9], [-1, 6, -1, -1, -1]], Solution).
% Solution = [[1, -1, -1, 3, 5], [-1, -1, 3, 5, 7], [2, 4, 6, -1, -1], [-1, 5, -1, 7, 9], [3, 6, 9, -1, -1]]
```

## CPLex

### Installation

To run the files OPL Model, you need to install [ILOG CPLEX Optimization Studio](https://www.ibm.com/products/ilog-cplex-optimization-studio)

### Use

The easy way to organize and run the program with different inputs is to create different ``run configurations`` each one with a different input.

### Test Instruction

We experiment run the code with different sizes of input and verify the result. After creating several ``run configurations`` just run it and you can see all the results of the decision variables.