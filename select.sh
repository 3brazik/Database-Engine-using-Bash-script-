#!/bin/bash
clear
echo
echo -e "\t\t\t\t\t${Blue}***********************************************************************"
echo -e "\t\t\t\t\t${Blue}***                                                                 ***"
echo -e "\t\t\t\t\t${Blue}***        ${Green}${bold}------> Welcome To Select From Table Menu <------${Defualt}        ${Blue}***"
echo -e "\t\t\t\t\t${Blue}***                                                                 ***"
echo -e "\t\t\t\t\t${Blue}***                     ${Green}${bold}Connected to $dbname Database${Defualt}                    ${Blue}***"
echo -e "\t\t\t\t\t${Blue}***                                                                 ***"
echo -e "\t\t\t\t\t${Blue}***********************************************************************"
echo
echo -e "${Yellow}Please Select one of the following options :-${Defualt}"
echo
echo -e "\t\t1) Press 1 to ${Blue}${bold}SELECT RECORD BY PRIMARY KEY${Defualt}${normal} From Table"
echo -e "\t\t2) Press 2 to ${Blue}${bold}SELECT RECORD BY Colnum Value${Defualt}${norrmal} From Table"
echo -e "\t\t3) Press 3 to ${Red}${bold}Return Back To Tables Menu${Defualt}"


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