#!/bin/bash

clear

echo
echo
echo -e "\t\t\t\t\t${Blue}***********************************************************************"
echo -e "\t\t\t\t\t${Blue}***                                                                 ***"
echo -e "\t\t\t\t\t${Blue}***             ${Green}${bold}------> Welcome To Tables Menu <------${Defualt}              ${Blue}***"
echo -e "\t\t\t\t\t${Blue}***                                                                 ***"
echo -e "\t\t\t\t\t${Blue}***                     ${Green}${bold}Connected to $dbname Database${Defualt}                   ${Blue}***"
echo -e "\t\t\t\t\t${Blue}***                                                                 ***"
echo -e "\t\t\t\t\t${Blue}***********************************************************************"
echo
echo
echo

echo -e "${Yellow}Please Select one of the following options :-${Defualt}"
echo

echo -e "\t\t1) Press 1 to ${Blue}${bold}CREATE${Defualt} Table"
echo -e "\t\t2) Press 2 to ${Blue}${bold}LIST${Defualt} Table"
echo -e "\t\t3) Press 3 to ${Blue}${bold}DROP${Defualt} Table"
echo -e "\t\t4) Press 4 to ${Blue}${bold}SELECT${Defualt} from Table"
echo -e "\t\t5) Press 5 to ${Blue}${bold}DELETE${Defualt} from Table"
echo -e "\t\t6) Press 6 to ${Blue}${bold}UPDATE${Defualt} Table"
echo -e "\t\t7) Press 7 to ${Blue}${bold}INTSERT${Defualt} into Table"
echo -e "\t\t8) Press 8 to ${Red}${bold}Return${Defualt} back to the ${Red}${bold}Main Menu${Defualt}"

read option

case $option in
	1)  ./createTable.sh
		;;
	2)  ./listTable.sh
		;;
	3)  ./dropTable.sh
		;;
	4)  ./select.sh
		;;
	5)  ./deleteRecord.sh
		;;
	6)  ./updateTable.sh
		;;
	7) ./insertInTable.sh
		;;
	8) ./mainmenu.sh	
		;;
	*)	echo
		echo -e "${Red}Please select correctly from the options below: ${Defualt}"
		sleep 1.5
		./submenu.sh
		;;
esac

