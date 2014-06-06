#!/usr/bin/ksh
#First P780 LPAR
./create_FIX1P.sh
./create_FIX2B.sh
./create_TEMP.sh
./create_TS1.sh
./create_NIM.sh
./create_MDS1.sh
./create_LOG1.sh
./create_DAR1.sh
./create_DAP1.sh
#Second P780 LPAR
: << COMMIT
./create_FIX1B.sh
./create_FIX2P.sh
./create_TS2.sh
./create_WK.sh
./create_MDS2.sh
./create_LOG2.sh
./create_DAR2.sh
./create_DAP2.sh
COMMIT
#VIOS
./create_vios1.sh
./create_vios2.sh
