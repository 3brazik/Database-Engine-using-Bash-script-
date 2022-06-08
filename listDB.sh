#!/bin/bash
echo
echo -e "${Blue}Listing all databases: ${Defualt}"
echo
ls  ./databases
echo
echo -e "${Blue}Press any key to go back to the main menu:${Defualt}"
echo
read key

	case $key in
	
	*)   
		./mainmenu.sh
		;;

esac
