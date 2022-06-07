#!/bin/bash
echo -e "${Blue}Listing all Tables: ${Defualt}"
ls ./databases/$dbname/$filename
echo
echo -e "${Blue}Enter Table Name to Select From: ${Defualt}"
read tablename 

if [ -f "./databases/$dbname/$tablename" ]; then
	    echo
		echo -e "${Green}-----> Connected to $tablename table .....${Defualt}";
		echo
		echo -e "${Blue}Table $tablename Schema: ${Defualt}"
		cat ./databases/$dbname/.$tablename.colmetadata;
        echo
        echo -e "${Blue}Table $tablename Data: ${Defualt}"
        cat ./databases/$dbname/$tablename ;
		echo
	else 
	echo
	echo -e "${Red}Table is not exsits${Defualt}"	
	echo
	./selectTable.sh
fi

function get_record {
	Rec_Check=1
	lineNumber=1
	for field in $(cut -f1 -d: "./databases/$dbname/$tablename"); do

		if [[ $field = "$primaryKey" ]]; then
			Rec_Check=0
			rec=($(cut -d: -f1- "./databases/$dbname/$tablename"))
			let indx=$lineNumber-1
			old_record="${rec[$indx]}"
			break
		fi
		let lineNumber=$lineNumber+1
	done
	return $Rec_Check
}

while [[ true ]]; do
	echo -e "${Blue}Enter Primary key of the Table to Select record: ${Defualt}"
	read primaryKey
	
		if ! get_record $primaryKey ; then
		echo 
		echo -e "${Red}Record Not Found!${Defualt}"
		continue
		fi
break 
done
#array of records
record=($old_record) 

#length of the array
length="${#record[@]}"


echo 
echo -e "${Green}Here Is The Record Found.${Defualt}"
awk -v var=$tablename 'BEGIN {FS=":"; print "\t\t\tTable Name: " var "\n"} {if(NR>1) printf " "$1"<"$2">\t\t"} END{printf "\n"}' "./databases/$dbname/.${tablename}.colmetadata"
awk -v var=$lineNumber 'BEGIN{FS=":";OFS="    \t\t\t";ORS="\n";}{  if(NR==var){ $1=$1; print " "substr($0, 1, length($0)-2)}}' "./databases/$dbname/$tablename"
./mainmenu.sh