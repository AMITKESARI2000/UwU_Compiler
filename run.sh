#! bin/bash
FILENAME="./examples/pgm2.uwu"
make preprocessor
read -p "Enter file: " FILENAME
./preprocessor $FILENAME
./parser ./output.uwupre
python3 ./ir_to-mips.py