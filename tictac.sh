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

computerPlay(){
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
		read -p "Please enter the number between 1-9 where insert your $userSymbol in board " input;
		validPositionChecker $input $userSymbol
		if [ "$validator" == "false" ]
		then
			echo "Invalid User Input"
		fi
	done

}

send_var(){
	echo $1
	winnerDisplay $1
}

winnerDisplay(){
	if [ $1 == $userSymbol ]
	then
		echo "You won"
	else
		echo "Computer won"
	fi
}

diagonalEndingTopLeft(){
	if [ "$visited" == "false" ]
        then

		local count=0
		local increase_by=$((ROW_SIZE+1))
		position=0
		for (( position=1; position <= $BOARD_SIZE; position+=$((ROW_SIZE+1))  )) 
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
				cell=0
	        local count=0
	        position=0
		for (( position=$ROW_SIZE; position <= $((BOARD_SIZE-ROW_SIZE+1)); position+=$((ROW_SIZE-1)) )) 
			do
	                if [ ${board[$position]} == $1 ]
	                then
	                	(( count++ ))
			elif [ "$cell" == "0" -a "${board[$position]}" == "0" ]
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
		local count=0
	        position=0
	        for (( row=0;row<$ROW_SIZE;row++ )) do
	                count=0
	                cell=0
	                for (( col=1; col<=$ROW_SIZE; col++ )) do
	                        position=$((ROW_SIZE*row+col ))
	                        if [ ${board[$position]} == $1 ]
	                        then
	                                (( count++ ))
	                        elif [ "$cell" == "0" -a "${board[$position]}" == "0" ]
	                        then
        		                cell=$position
        	                fi
        	        done
        	        if [ $count -ne $(( ROW_SIZE-1 )) ]
        	        then
        	                cell=0
			else
				break
	                fi
	        done
	fi
}


rowWin(){
	local count=0
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
		local count=0
		position=0
		for (( col=1;col<=$ROW_SIZE;col++ )) do
		        count=0
		        cell=0
		        for (( row=0; row<=$ROW_SIZE; row++ )) do
		                position=$((ROW_SIZE*row+col ))
		                if [ "${board[$position]}" == "$1" ]
				then
		                        (( count++ ))
		                elif [ "$cell" == "0" -a "${board[$position]}" == "0" ]
				then
					cell=$position
		                fi
		        done
		        if [ $count -ne $(( ROW_SIZE-1 )) ]
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
		local count=0
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

block(){

	rowChecker $userSymbol
	validPositionChecker $cell $compSymbol
	columnChecker $userSymbol
	validPositionChecker $cell $compSymbol
	diagonalEndingTopRight $userSymbol
	validPositionChecker $cell $compSymbol
	diagonalEndingTopLeft $userSymbol
	validPositionChecker $cell $compSymbol

}

corners(){
	if [ $visited == "false" ]
	then
		local position=1
		validPositionChecker 1 $compSymbol
		position=$((ROW_SIZE*0+ROW_SIZE))
		validPositionChecker $position $compSymbol
		position=$(( ROW_SIZE*$((ROW_SIZE-1)) + 1))

		validPositionChecker $position $compSymbol
		position=$(( ROW_SIZE*$((ROW_SIZE-1)) + ROW_SIZE))
		validPositionChecker $position $compSymbol
	fi
}

winnerChecker(){
	rowChecker $compSymbol
	validPositionChecker $cell $compSymbol
	columnChecker $compSymbol
	validPositionChecker $cell $compSymbol
	diagonalEndingTopRight $compSymbol
	validPositionChecker $cell $compSymbol
	diagonalEndingTopLeft $compSymbol
	validPositionChecker $cell $compSymbol
}

centre(){
	if [ "$visited" == "false" ]
	then
		mid=$((ROW_SIZE/2))
		position=$(( $(( ROW_SIZE*mid)) + $((ROW_SIZE-mid)) ))
		validPositionChecker $position $compSymbol
	fi
}


checkWin(){
	diagonalEndingTopRight $1
	diagonalEndingTopLeft $1
	rowWin $1
	columnWin $1
}


sides(){
   	if [ $visited == "false" ]
   	then
   		for (( side=1; side<=$ROW_SIZE; side++ ))
   		do
      			position=side
      			validPositionChecker $position $compSymbol
   		done

  		for (( side=1; side<=$BOARD_SIZE; side+=$ROW_SIZE ))
   		do
      			position=side
      			validPositionChecker $position $compSymbol
   		done

   		for (( side=$((BOARD_SIZE-ROW_SIZE+1)); side<=$BOARD_SIZE; side++ ))
   		do
      			position=side
      			validPositionChecker $position $compSymbol
   		done
   		for (( side=$ROW_SIZE; side<=$BOARD_SIZE; side++ ))
   		do
      			position=side
      			validPositionChecker $position $compSymbol
   		done
   		fi
}


plays(){
	winnerChecker
	block
	corners
	centre
	sides
	computerPlay

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
                checkWin $userSymbol
		plays
                visited=false
		checkWin $compSymbol
        done
        displayBoard
}

ticTacToeApplication
