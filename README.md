########################################################################################
# COMP122 - Assembly Language Projects
# Description: A collection of various Assembly Language programs that I wrote during the Fall 2018 semester for my Assembly Language class.
# Written by Dustin Redmon
########################################################################################

## List of Projects:
- ARMsimExample.s : Copy/Paste and get Example 11.1 from the University of Victoria's ARMSim documentation working in ARMSim.
- integers.s      : 1. Opens a file named "input.txt".
                    2. Repeatedly reads integers from that file and prints the integer to STDOUT.
                    3. Closes the input file when the integers have been exhausted.
                    4. Prints the count of how many integers were read.
                    5. prints out the sum of all the integers
- sort.s          : Write an assembly program that sorts positive integers. The source file is to be named sort.s The input file is to be named input.txt and will consist of non-negative integers, one integer per line. The output is the same set of integers printed to STDOUT, one per line, but sorted in ascending order.
- sudoguSolver.s  : Solve Sudoku using well defined functions:
                    - boolean solve(int puzzle[9][9]);
                    - int findFirstEmpty(int puzzle[9][9]);
                    - boolean unhappyBoard(int puzzle[9][9]);
                    - boolean unhappyRow(int puzzle[9][9], int row);
                    - boolean unhappyCol(int puzzle[9][9], int col);
                    - boolean unhappyBox(int puzzle[9][9], int row, int col);
                    - The board will come from an input file named "input.txt" and will have the following format: 70400639000070150000009002700261005340020700861003940093006000006308000048900206
           
