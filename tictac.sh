#/bin/bash
echo -e "Welcome to Tic-Tac-Toe Game \n----------------------------- \nAs a Tic Tac Toe player lets challenge Computer"

ROW_SIZE=3
BOARD_SIZE=$(($ROW_SIZE*$ROW_SIZE))
userSymbol="O"
compSymbol="O"
quit=false
validator=false
position=0
count=0

declare -A board
resetBoard(){
	position=0
        for (( position=1; position<=$BOARD_SIZE ; position++ )) 
	do
        	board[$position]=0
        done
}

displayBoard(){
        count=0
        for (( count=1; count<=$BOARD_SIZE ; count++ ))
	do
		if [ "${board[$count]}" == "0" ]
              	then
                	printf  _" "
                else
                     	printf ${board[$count]}" "
                fi
                if [ $(( $count % $ROW_SIZE )) -eq 0 ]
                then
                     echo
                fi
        done
}

assignSymbol(){
        randomVariable=$((RANDOM%2))
        if [ $randomVariable -eq 0 ]
        then
                userSymbol="X"
        else
                compSymbol="X"
        fi
        echo "Your sign is "$userSymbol" and computer sign is "$compSymbol
}

toss(){
        randomVariable=$((RANDOM%2))
        if [ $randomVariable -eq 0 ]
        then
                echo User turn first
                firstPlay=user
        else
                echo Computer turn first
                firstPlay=computer
        fi
}

validPositionChecker(){
        if [ $1 -gt 0  -a $1 -le $BOARD_SIZE ]
        then
                validator=true
        fi
        if [ "$validator" == "true" -a "${board[$1]}" == "0" ]
        then
                board[$1]=$2
        else
                validator=false
        fi

}

computerPlays(){
        while [ "$validator" == "false" ]
        do
                number=$((RANDOM%9+1))
                validPositionChecker $number $compSymbol
        done
        validator=false
}

userPlays(){
        while [ "$validator" == "false" ]
        do
                read -p "Please enter the number between 1-9 where insert your $userSymbol in board " input;
                validPositionChecker $input $userSymbol
                if [ "$validator" == "false" ]
                then
                        echo Input not accepted please try again
                fi
        done
        validator=false
}

diagonalEndingTopLeft(){
        count=0
        increase_by=$((ROW_SIZE+1))
        for (( position=1; position <= $BOARD_SIZE; position+=$((ROW_SIZE+1)) ))
        do
                if [ ${board[$position]} == $1 ]
                then
                        ((count++))
                fi
        done
        if [ $count -eq $ROW_SIZE ]
        then
                winnerDisplay $1
                quit=true
        fi
}

diagonalEndingTopRight(){
        count=0
        for (( position=$ROW_SIZE; position <= $((BOARD_SIZE+1-ROW_SIZE)); position+=$((ROW_SIZE-1)) )) do
                if [ ${board[$position]} == $1 ]
                then
                        ((count++))
                fi
        done
        if [ $count == $ROW_SIZE ]
        then
                winnerDisplay $1
                quit=true
        fi
}

rowChecker(){
        count=0
        position=0
        for (( row=0;row<$ROW_SIZE;row++ )) do
                count=0
                for (( col=1; col<=$ROW_SIZE; col++ )) do
                        position=$(($ROW_SIZE*row+col ))
                        if [ ${board[$position]} == $1 ]
                        then
                                (( count++ ))
                        fi
                done
                if [ $count -eq $ROW_SIZE ]
                then
                        winnerDisplay $1
                        break
                fi
        done
        if [ $count -eq $ROW_SIZE ]
        then
                quit=true
        fi
}

columnChecker(){
       count=0
       position=0
       for (( col=1;col<=$ROW_SIZE;col++ )) do
               count=0
               for (( row=0; row<=$ROW_SIZE; row++ )) do
                        position=$(($ROW_SIZE*row+col ))
                        if [ "${board[$position]}" == "$1" ]
                        then
                                (( count++ ))
                        fi
                done
                if [ $count -eq $ROW_SIZE ]
                then
                        winnerDisplay $1
                        break

                fi
        done
        if [ $count -eq $ROW_SIZE ]
        then
                quit=true
        fi
}

winnerCheck(){
        diagonalEndingTopLeft $1
        diagonalEndingTopRight $1
        rowChecker $1
        columnChecker $1
}

winnerDisplay(){
        if [ $1 == $userSymbol ]
        then
                echo "User Wins the game"
        else
                echo "Computer wins the game"
        fi
}


ticTacToeApplication(){
        resetBoard
        assignSymbol
        toss
        while [ $quit == false ]
        do
                validator=false
                displayBoard
                userPlays $firstPlay
                validator=false
                winnerCheck $userSymbol
                computerPlays $firstPlay
                winnerCheck $compSymbol
        done
        displayBoard
}

ticTacToeApplication
