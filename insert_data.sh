#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

      if [[ $OPPONENT != "opponent" ]]
        then
          
          TM2_NME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
            
            if [[ -z $TM2_NME ]]
              then
              
              INSERT_TM2_NME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
                
                if [[ $INSERT_TM2_NME == "INSERT 0 1" ]]
                  then
                    echo Inserted team $OPPONENT
                fi
            fi
      fi

      if [[ $WINNER != "winner" ]]
        then
          
          TM1_NME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")

            if [[ -z $TM1_NME ]]
              then
              
              INSERT_TM1_NME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
                
                if [[ $INSERT_TM1_NME == "INSERT 0 1" ]]
                  then
                    echo Inserted team $WINNER
                fi
            fi
      fi


    if [[ YEAR != "year" ]]
      then

        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

        INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")

          if [[ $INSERT_GAME == "INSERT 0 1" ]]
            then
              echo New game added: $YEAR, $ROUND, $WINNER_ID VS $OPPONENT_ID, score $WINNER_GOALS : $OPPONENT_GOALS
          fi
    fi
    
done
