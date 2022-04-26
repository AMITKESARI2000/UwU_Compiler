#! bin/bash
FILENAME="./examples/pgm4.uwu"
make preprocessor

read -p "Enter file: " FILENAME
./preprocessor $FILENAME
./parser ./output.uwupre
