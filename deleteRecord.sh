#!/bin/bash
echo -e "${Blue}Listing all Tables: ${Defualt}"
ls ./databases/$dbname/$filename
echo
echo -e "${Blue}Enter table name to Select From : ${Defualt}"
read tablename 

if [ -f "./databases/$dbname/$tablename" ]; then
	    echo
		echo -e "${Green}-----> Connected to $tablename table .....${Defualt}";
		echo
		echo -e "${Bule}Table $tablename Schema: ${Defualt}"
		echo
		cat ./databases/$dbname/.$tablename.colmetadata;
        echo
        echo -e "${Blue}Table $tablename Data${Defualt}"
        cat ./databases/$dbname/$tablename ;
		echo
    else 
	echo
	echo -e "${Red}----> ERROR Table is not exsits${Defualt}"	
	echo
	./deleteRecord.sh
fi

function delete_record {
	foundflagg=1
	
	for field in $(cut -f1 -d: "./databases/$dbname/$tablename"); do

		if [[ $field = "$1" ]]; then
			foundflagg=0
			sed -i '/^'"$1"':.*$/d' "./databases/$dbname/$tablename"
			break
		fi
	done
	return $foundflagg
}

while [ true ]; do
	echo -e "${Blue}Please enter primary key: ${Defualt}"
	read PKey
	if delete_record "$PKey" ; then
		echo -e "${Green}Record Deleted${Defualt}"
		echo
		echo -e "${Blue}Table records after deletion:${Defualt}"
		cat ./databases/$dbname/$tablename ;
		echo
		echo
		./mainmenu.sh
	fi
	
	
done




