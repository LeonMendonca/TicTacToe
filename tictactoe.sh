#!/bin/bash
declare -A Marray

#Initialize the Grid
Initialize() {
 for ((i=0 ; i<3 ; i++)); do
   for ((j=0 ; j<3 ; j++)); do
     Marray[$i,$j]=" "
   done
 done
}

HLines() {
 for x in {1..15}; do
  echo -n "-"
 done
 echo
}

printBoard() {
  for ((i=0 ; i<3 ; i++)); do
    for ((j=0 ; j<3 ; j++)); do
      echo -n "| ${Marray[$i,$j]} |"
    done
    echo
    #avoided printing extra Hlines below
    if [[ $i -ne 2 ]]; then
      HLines
    fi
  done
  echo
}

PrintTitle() {
  declare -A Egarray
  Egarrayvalue=0
  echo "  TIC TAC TOE"
  echo
  for((i=0 ; i<3 ; i++)); do
    for((j=0 ; j<3 ; j++)); do
      Egarrayvalue=$(($Egarrayvalue+1))
      echo -n "| ${Egarray[$i,$j]}$Egarrayvalue |"
    done
    echo
    if [[ $i -ne 2 ]]; then
      HLines
    fi
  done
  echo
  echo "EACH NUMBER IS THE POSITIONING TO INPUT TO THE GRID"
  echo
}

#Begins here
Start() {
  Initialize
  currPlayer="X"
}

Start

#input from user
TakeInput() {
 printBoard ${Marray[@]}
 echo -n "enter number:"; read input
 case $input in
  1)
    row=0 col=0
  ;;
  2)
    row=0 col=1
  ;;
  3)
    row=0 col=2
  ;;
  4)
    row=1 col=0
  ;;
  5)
    row=1 col=1
  ;;
  6)
    row=1 col=2
  ;;
  7)
    row=2 col=0
  ;;
  8)
    row=2 col=1
  ;;
  9)
    row=2 col=2
  ;;
  *)
    echo
  ;;
 esac
}

#Winner
Winner() {
  countDiagonal=0
  for ((i=0 ; i<3 ; i++)); do
    countRowWinner=0
    countColWinner=0
    for ((j=0 ; j<3 ; j++)); do
      #row check
      if [ "${Marray[$i,$j]}" == $currPlayer ]; then
         countRowWinner=$(($countRowWinner+1))
      fi

      #col check
      if [ "${Marray[$j,$i]}" == $currPlayer ]; then
         countColWinner=$(($countColWinner+1))
      fi
    done
    #any row match
    if [[ $countRowWinner -eq 3 ]]; then
      break
    #any col match
    elif [[ $countColWinner -eq 3 ]]; then
      break
    fi

    #diagonal check
    if [[ "${Marray[$i,$i]}" == $currPlayer  || "${Marray[$i,$((2-$i))]}" == $currPlayer ]]; then
       countDiagonal=$(($countDiagonal+1))
    fi

  done
}

#Tie
Tie() {
  count=0
  for ((i=0 ; i<3 ; i++)); do
    for ((j=0 ; j<3 ; j++)); do
      if [ "${Marray[$i,$j]}" != " " ]; then
         count=$(($count+1))
      fi
    done
  done
}


#Main program loop
while :
do
   PrintTitle

   echo -e "\n   $currPlayer's turn\n"
   TakeInput

   #clears the terminal for less clutter
   echo "$(clear)"

   #Check if the selected row col is not empty
   if [ "${Marray[$row,$col]}" != " " ]; then
     echo -e "INVALID MOVE!\n"
     continue
   fi

   Marray[$row,$col]=$currPlayer

   #row, col and diagonal with same values return 3
   Winner
   if [[ $countRowWinner -eq 3 ]]; then
      printBoard ${Marray[@]}
      echo "$currPlayer WON BY ROW"
      break
   elif [[ $countColWinner -eq 3 ]]; then
     printBoard ${Marray[@]}
     echo "$currPlayer WON BY COLUMN"
     break
   elif [[ $countDiagonal -eq 3  ]]; then
     printBoard ${Marray[@]}
     echo "$currPlayer WON BY DIAGONAL"
     break
   fi

   #Checks if all 9 cells are full
   Tie
   if [[ $count -eq 9 ]]; then
     printBoard ${Marray[@]}
     echo "TIE!"
     break
   fi

   #Switch b/w X and O
   if [[ "$currPlayer" == "X" ]]; then
      currPlayer="O"
   else
      currPlayer="X"
   fi
done
