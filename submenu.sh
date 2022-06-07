#!/bin/bash
echo
echo -e "${Green}**************************************************************************************************************"
echo
echo -e "${Yellow}Please Select one of the following options :-${Defualt}"
echo
echo -e "\t\t1) Press 1 to ${Blue}CREATE${Defualt} Table"
echo -e "\t\t2) Press 2 to ${Blue}LIST${Defualt} Table"
echo -e "\t\t3) Press 3 to ${Blue}DROP${Defualt} Table"
echo -e "\t\t4) Press 4 to ${Blue}SELECT${Defualt} from Table"
echo -e "\t\t5) Press 5 to ${Blue}DELETE${Defualt} from Table"
echo -e "\t\t6) Press 6 to ${Blue}UPDATE${Defualt} Table"
echo -e "\t\t7) Press 7 to ${Blue}INTSERT${Defualt} into Table"
echo -e "\t\t8) Press 8 to ${Red}Return${Defualt} back to the ${Red}Main Menu${Defualt}"

read option

case $option in
	1)  ./createTable.sh
		;;
	2)  ./listTable.sh
		;;
	3)  ./dropTable.sh
		;;
	4)  ./SelectWhere.sh
		;;
	5)  ./deleteRecord.sh
		;;
	6)  ./updateTable.sh
		;;
	7) ./insertInTable.sh
		;;
	8) ./mainmenu.sh	
		;;
	*) echo -e "${Red}Please select correctly from the options below: ${Defualt}"
		./submenu.sh
		;;
esac

