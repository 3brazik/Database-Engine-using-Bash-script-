#!/bin/bash
clear
#colors
export Defualt='\033[0m'       # Text Reset
export Red='\033[0;31m'          # Red
export Green='\033[0;32m'        # Green
export Yellow='\033[0;33m'       # Yellow
export Blue='\033[0;34m'         # Blue


echo
echo
echo
echo -e "${Green}**************************************************************************************************************"
echo
echo -e "\t\t\t${Blue}    ------> Welcome To our DataBase Engine <------"
echo -e "\t\t\t${Blue} By { 2M -> Mohamed Magdy and Mohamed Abdel-Razik <- } ${Defualt}"
echo
echo -e "${Yellow}Please Select one of the following options :-${Defualt}"
echo
echo -e "\t\t1) Press 1 to ${Green}CREATE${Defualt} Database"
echo -e "\t\t2) Press 2 to ${Green}CONNECT${Defualt} Database"
echo -e "\t\t3) Press 3 to ${Green}LIST${Defualt} Database"
echo -e "\t\t4) Press 4 to ${Yellow}DROP${Defualt} Database"
echo -e "\t\t5) Press 5 to ${Red}EXIT${Defualt}"
echo
read option

	case $option in
	1)  ./createDB.sh 
		;; 
	2)  ./connectDB.sh
		;;
	3)  ./listDB.sh
		;;
	4)  ./dropDB.sh
		;;
	5) exit
		;;

	*) 
	   echo -e "${Red}Please Select Correctly from the options below: ${Defualt}"
		sleep 1.5
		./mainmenu.sh
		;;

esac



