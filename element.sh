#!/bin/bash


PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # Cek apakah input adalah angka atau string
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    CONDITION="atomic_number = $1"
  else
    CONDITION="symbol = '$1' OR name = '$1'"
  fi

  # Ambil data
  DATA=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE $CONDITION")

  if [[ -z $DATA ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$DATA" | while IFS="|" read ATOMIC_ID NAME SYMBOL TYPE MASS MELTING BOILING
    do
      echo "The element with atomic number $ATOMIC_ID is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
fi

