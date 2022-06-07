#!/bin/bash
clear
echo
echo -e "${Green}**************************************************************************************************************"
echo
echo -e "${Yellow}Please Select one of the following options :-${Defualt}"
echo
echo -e "\t\t1) Press 1 to ${Blue}SELECT BY PRIMARY KEY${Defualt} Table"
echo -e "\t\t2) Press 2 to ${Blue}SELECT BY Colnum Value${Defualt} Table"
echo -e "\t\t3) Press 3 to ${Red}Return${Defualt} back to the ${Red}Table Menu${Defualt}"


read option

case $option in
	1)  ./selectTable.sh
		;;
	2)  ./SelectWhere.sh
		;;
	3)  ./submenu.sh
		;;

	*) echo -e "${Red}Please select correctly from the options below: ${Defualt}"
		./submenu.sh
		;;
esac