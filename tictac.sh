#!/bin/bash

echo -e "Welcome to Tic-Tac-Toe Game \n----------------------------- \nAs a Tic Tac Toe player lets challenge Computer"

ROW_SIZE=3
BOARD_SIZE=$((ROW_SIZE*ROW_SIZE))
Position=0
userSymbol="0"
compSymbol="0"
declare -A board

resetBoard() {
	for (( position=1; position<=$BOARD_SIZE; position++ ))
	do
		ticBoard[$position]=0
	done
}
randomGenerator() {
	randomCheck=$((RANDOM%2))
}

assignSymbol(){
	randomGenerator
	if [ "$randomCheck" == "$userSymbol" ]
	then
		userSymbol="X"
	else
		compSymbol="X"
	fi
	echo "Player Symbol is $userSymbol and Computer_Symbol is $compSymbol "

}


tossFirstPlayer(){
	randomGenerator
	if [ "$randomCheck" == "$userSymbol" ]
	then
		firstPlayer=human
		echo "HUMAN has won the Toss"
	else
		firstPlayer=Computer
		echo "COMPUTER has won the Toss"
	fi

}

displayBoard()
   {
      local count=0
      for (( count=1; count<=$BOARD_SIZE; count++ ))
      do
         if [[ "${board[$count]}" -eq "0" ]]
         then
            printf _"|"
         else
            printf ${board[$count]}" "
         fi
         if [ $(( $count % $ROW_SIZE )) -eq 0 ]
         then
               echo
         fi
      done
   }

playerInputChecker(){
	checker=false
	displayBoard
	assignSymbol
	echo "Choose a cell for your $userSymbol "
	read -p "Enter the choice in range 1 - $BOARD_SIZE : " inputPosition

	if [ $inputPosition -gt 0 -a $inputPosition -le $BOARD_SIZE ]
	then
		echo "Valid choice  $inputPosition in range"
	else
		echo "Invalid position out of range"
	fi

}
playerInputChecker
