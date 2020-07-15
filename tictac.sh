#!/bin/bash

echo -e "Welcome to Tic-Tac-Toe Game \n----------------------------- \nAs a Tic Tac Toe player lets challenge Computer"

ROW_SIZE=3
BOARD_SIZE=$((ROW_SIZE*ROW_SIZE))
Position=0
declare -A ticBoard

resetBoard() {
	for (( position=1; position<=$BOARD_SIZE; position++ ))
	do
		ticBoard[$position]=0
	done
}

tossFirstPlayer(){
	randomCheck=$((RANDOM%2))
	if [ $randomCheck -eq $user_symbol ]
	then
		firstPlayer=human
		echo "HUMAN has won the Toss"
	else
		firstPlayer=Computer
		echo "COMPUTER has won the Toss"
	fi

}

tossFirstPlayer
