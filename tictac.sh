#!/bin/bash

echo -e "Welcome to Tic-Tac-Toe Game \n----------------------------- \nAs a Tic Tac Toe player lets challenge Computer"

ROW_SIZE=3
BOARD_SIZE=$(($ROW_SIZE*$ROW_SIZE))
userSymbol="O"
compSymbol="O"
quit=false
validator=false
visited=false
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
	if [ "$visited" == "false" ]
	then

        	if [ $1 -gt 0  -a $1 -le $BOARD_SIZE ]
        	then
               	validator=true
        	fi
        	if [ "$validator" == "true" -a "${board[$1]}" == "0" ]
        	then
               		board[$1]=$2
			visited=true
        	else
                	validator=false
        	fi
	fi

}

computerPlays(){
      	if [ "$visited" == "false" ]
	then

		while [ "$validator" == "false" ]
        	do
                	number=$((RANDOM%9+1))
                	validPositionChecker $number $compSymbol
        	done
        	validator=false
	fi
}

userPlays(){

        while [ "$validator" == "false" ]
        do
                read -p "Please enter the number between 1-9 where insert your $userSymbol in board " input
                validPositionChecker $input $userSymbol
		if [ "$validator" == "false" ]
                then
                        echo "Input not accepted please try again"
                fi
        done
        validator=false

}

send_var(){
	echo $1
	winnerDisplay $1
}

diagonalEndingTopLeft(){
		if [ "$visited" == "false" ]
		then
			cell=0
			count=0
			increase_by=$((ROW_SIZE+1))
        		for (( position=1; position <= $BOARD_SIZE; position+=$((ROW_SIZE+1)) ))
        		do
                		if [ ${board[$position]} == $1 ]
                		then
                        		((count++))
                		elif [ "$cell" == "0" -a "${board[$position]}" == "0" ]
				then
					cell=$position
				fi
        		done
        		if [ $count -eq $ROW_SIZE ]
        		then
                	winnerDisplay $1
                	quit=true
        		elif [ $count -ne $(($ROW_SIZE-1)) ]
			then
			cell=0
			fi
		fi

}

diagonalEndingTopRight(){
	if [ "$visited" == "false" ]
	then

        	count=0
		cell=0
        	for (( position=$ROW_SIZE; position <= $((BOARD_SIZE+1-ROW_SIZE)); position+=$((ROW_SIZE-1)) )) do
                	if [ ${board[$position]} == $1 ]
                	then
                        	((count++))
                	elif [ "$cell" == "0" -a "${board[$position]}" == 0 ]
			then
				cell=$position
			fi

        	done
        	if [ $count == $ROW_SIZE ]
        	then
                winnerDisplay $1
                quit=true
   		elif [ $count -ne $(($ROW_SIZE-1)) ]
		then
		cell=0
		fi
	fi
}

rowChecker(){
	if [ "$visited" == "false" ]
	then

        	count=0
        	position=0
        	for (( row=0;row<$ROW_SIZE;row++ ))
		do
                	count=0
			cell=0
           		for (( col=1; col<=$ROW_SIZE; col++ ))
			do
               			position=$(($ROW_SIZE*row+col ))
               			if [ ${board[$position]} == $1 ]
               			then
                    			(( count++ ))
                		elif [ "$cell" == "0" -a "${board[$position]}" == 0 ]
                  		then
                     			cell=$position
                  		fi

              		done
              		if [ $count -eq $ROW_SIZE ]
              		then
                        	winnerDisplay $1
                        	quit=true
			break
			elif [ $count -ne $(($ROW_SIZE-1)) ]
			then
				cell=0
			else
			break

                	fi
        	done
        fi
}


rowWin(){
	count=0
        position=0
        for (( row=0; row<$ROW_SIZE; row++ )) do
                count=0
                for (( col=1; col<=$ROW_SIZE; col++ )) do
                        position=$(( ROW_SIZE*row+col ))
                        if [ ${board[$position]} == $1 ]
                        then
                                (( count++ ))
                        fi
                done
                if [ $count -eq $ROW_SIZE ]
                then
                        winnerDisplay $1
                        quit=true
                        break
                fi
        done
}



columnChecker(){
	if [ "$visited" == "false" ]
	then
       	count=0
        position=0
        	for (( col=1;col<=$ROW_SIZE;col++ )) do
                	count=0
                	for (( row=0; row<=$ROW_SIZE; row++ )) do
                        	position=$(($ROW_SIZE*row+col ))
                        	if [ "${board[$position]}" == "$1" ]
                        	then
                                	(( count++ ))
				elif [ "$cell" == "0" -a "${board[$position]}" == 0 ]
                  		then
                     			cell=$position
                  		fi

              		done
                	if [ $count -eq $ROW_SIZE ]
                	then
``                        	winnerDisplay $1
                        	quit=true
			break
               		elif [ $count -ne $(($ROW_SIZE-1)) ]
               		then
                  		cell=0
               		else
                  	break

                	fi
        	done
        fi

}

columnWin(){
        if [ "$visited" == "false" ]
        then
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
                                quit=true
                                break
                        fi
                done
        fi
}




checkMoveToWin(){
	diagonalEndingTopLeft $compSymbol
	validPositionChecker $cell $compSymbol
	diagonalEndingTopRight $compSymbol
	validPositionChecker $cell $compSymbol
	rowChecker $compSymbol
	validPositionChecker $cell $compSymbol
	columnChecker $compSymbol
	validPositionChecker $cell $compSymbol

}

blockPlayer(){
 	rowChecker $userSymbol
        validPositionChecker $cell $compSymbol
        columnChecker $userSymbol
        validPositionChecker $cell $compSymbol
        diagonalEndingTopRight $userSymbol
        validPositionChecker $cell $compSymbol
        diagonalEndingTopLeft $userSymbol
        validPositionChecker $cell $compSymbol

}

check_If_Can_Win(){
        rowChecker $compSymbol
        validPositionChecker $cell $compSymbol
        columnChecker $compSymbol
        validPositionChecker $cell $compSymbol
        diagonalEndingTopRight $compSymbol
        validPositionChecker $cell $compSymbol
        diagonalEndingTopLeft $compSymbol
        validPositionChecker $cell $compSymbol
}


function corners(){
        if [ $visited == "false" ]
        then
                local key=1
                validPositionChecker 1 $compSymbol

                position=$((ROW_SIZE*0+ROW_SIZE))
                validPositionChecker $key $compSymbol

                position=$(( ROW_SIZE*$((ROW_SIZE-1)) + 1))
                validPositionChecker $key $compSymbol

                position=$(( ROW_SIZE*$((ROW_SIZE-1)) + ROW_SIZE))
                validPositionChecker $key $compSymbol
        fi

}


checkForComp(){
	check_If_Can_Win
        block
        corners
        computerPlay


	}


winnerCheck(){
        diagonalEndingTopLeft $1
        diagonalEndingTopRight $1
	rowWin $1
        columnWin $1
}

winnerDisplay(){
        if [ $1 == $userSymbol ]
        then
                echo You won
        else
                echo Computer won
        fi
}
ticTacToeApplication(){
	resetBoard
        assignSymbol
        toss
        while [ $quit == false ]
        do
                validator=false
		visited=false
                displayBoard
                userPlays
		validator=false
		visited=false
                winnerCheck $userSymbol
		computerPlays
                visited=false
		winnerCheck $compSymbol
        done
        displayBoard
}

ticTacToeApplication
