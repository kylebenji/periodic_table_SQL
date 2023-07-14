#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  #check if input is number of string
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
    #if string, use symbol and name query
    ELEMENT_INFO=$($PSQL "SELECT * from elements inner join properties using(atomic_number) left join types using(type_id) where name='$1' or symbol='$1'")
  else
    #if number use atomic number query
    ELEMENT_INFO=$($PSQL "SELECT * from elements inner join properties using(atomic_number) left join types using(type_id) where atomic_number=$1")
  fi

  if [[ -z $ELEMENT_INFO ]]
  then
    echo "I could not find that element in the database."
  else
    #parse information
    echo "$ELEMENT_INFO" | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
    do 
      #format and output info
      echo "The element with atomic number $(echo $ATOMIC_NUMBER | sed 's/ |/"/') is $(echo $NAME | sed 's/ |/"/') ($(echo $SYMBOL | sed 's/ |/"/')). It's a $(echo $TYPE | sed 's/ |/"/'), with a mass of $(echo $ATOMIC_MASS | sed 's/ |/"/') amu. $(echo $NAME | sed 's/ |/"/') has a melting point of $(echo $MELTING_POINT | sed 's/ |/"/') celsius and a boiling point of $(echo $BOILING_POINT | sed 's/ |/"/') celsius."
    done
  fi
fi