#!/bin/bash
echo -e "${Blue}Listing all Tables: ${Defualt}"
ls ./databases/$dbname/$filename
# ./DBMS/listTabel.sh
echo
echo -e "${Blue}Enter table name to insert: ${Defualt}"
read tablename 
if [ -f "./databases/$dbname/$tablename" ]; then
	    echo
		echo -e "${Green}Connected to $tablename table${Defualt}";
		echo -e "${Blue}Table $tablename Schema: ${Defualt}"
        echo
		cat ./databases/$dbname/.$tablename.colmetadata;
		echo
		
	else 
	echo
	echo -e "${Red}Table is not exsits${Defualt}"	
	echo
	./insertInTable.sh
fi

        colname=()
        coltype=()
        field1=($(cut -d: -f1 ./databases/$dbname/.$tablename.colmetadata))
        field2=($(cut -d: -f2 ./databases/$dbname/.$tablename.colmetadata))
        pkHead=${field2[0]}
        for i in "${field1[@]:1}";
        do 
            colname+=("$i")
        done

        for j in "${field2[@]:1}";
        do 
            coltype+=("$j")
        done

        colnum=$(wc -l "./databases/$dbname/.$tablename.colmetadata" | cut -f1 -d" ")
        
        #echo $pkHead
        #echo $field1
        #echo $field2
        #echo $colnum
        #echo $colname
        #echo $coltype

    function check_datatype {
	case "$1" in
		int )
			if [[ "$2" =~ ^[0-9]+$ ]]; then
				return 0
			else return 1
			fi
			;;
		str )
			if [[ "$2" =~ ^[A-Za-z" "]+$ ]]; then
				return 0
			else return 1
			fi
			;;
		* )
			return 1
			;;
	esac
}

function checkPkeyUnique {
    checkPK=1
    for i in $(cut -f1 -d: ./databases/$dbname/$tablename); do
        if [[ $i = $primaryKey ]]; then
            checkPK=0
        fi
        break
        done
    return $checkPK 
}
        
while [ true ]; do

            echo -e "${Blue}Insert primary key value: ${Defualt}"
            read primaryKeyValue
            #Checking if it contain colons
            if [ "$primaryKeyValue" = *:* ]; then
                echo -e "${Red}Primary key cannot contain: ${Defualt}"
                ./insertInTable.sh
            fi
            #Checking if it contain spaces
            if [[ $primaryKeyValue = *" "* ]];then
				echo
				echo -e "${Red}--> ERROR : Primary key value cannot Contain space.${Defualt}"
				echo
                ./insertInTable.sh
		    fi

		    #Checking that  no special char in Database name 
		    #if [[ $primaryKeyValue =~ ["!"?$%@"^"+="&""<".">""/"] ]];
		    #	then
		    #	echo
		    #	echo "--> ERROR : primary key value cannot Start or Contain Special Char."
		    #	echo
		    #	./insertInTable.sh
		    #fi

		    #Checking For Empty String
		    if [ "$primaryKeyValue" = "" ];
		    	then
		    	echo 
		    	echo -e "${Red}--> ERROR: primary key value can not be Empty !${Defualt}"
		    	echo
		    	./insertInTable.sh
		    fi
            #Checking Data type of the inserted 
		    if ! check_datatype "${coltype[0]}" "$primaryKeyValue" ; then
    
		    	echo
		    	echo -e "${Red}Primary key datatype value dose not match${Defualt}"
		    	echo
                ./insertInTable.sh
		    fi
            #Checking if the the primary key is uniqe
            if checkPkeyUnique "${colname[@]}" "$primaryKeyValue"; then
                echo
                echo -e "${Red}Primary key value is not unique !${Defualt}"
            fi
break   
done    

record+=("$primaryKeyValue")

for ((i = 1; i < $colnum-1; i++ )); do

    while [ true ]; do
        echo -e "${Blue}Enter enter columns${i} values: ${Defualt}"
        read values
        #Checking if it contain colons
        if [ "$values" = *:* ]; then
            echo -e "${Red}Column value cannot contain : ${Defualt}"
        fi
        #Checking For Empty String
        if [ "$values" = "" ]; then
            echo -e "${Red}Column value cannot be empty ! ${Defualt}"
        fi
        #Checking if it contain spaces
        if [ "$values" = *" "* ]; then
            echo -e "${Red}Column value cannot contain spaces ! ${Defualt}"
        fi
        #Checking  the primary key data type
        if ! check_datatype "${coltype[$i]}" "$values" ; then
	    	echo
	    	echo -e "${Red}Entered values and column datatype value dose not match ! ${Defualt}"
	    	echo
            ./insertInTable.sh
	    fi
        break
    done
    record+=("$values")
done

for (( i = 0; i < $colnum-1; i++ )); do
    echo -n  "${record[$i]}:" >> "./databases/$dbname/$tablename"
done
echo "" >> "./databases/$dbname/$tablename"
echo -e "${Green} Record has been added succesfully !${Defualt}"
echo
echo -e "${Blue} Table ${tablename} Data After insertion  ${Defualt}"
echo
# Metadata
awk -v var=$tablename 'BEGIN {FS=":"; print "\t\tTable Name: " var "\n"} {if(NR>1) printf      $1"<"$2">\t\t"} END{printf "\n"}' "./databases/$dbname/.${tablename}.colmetadata"
# Data
awk 'BEGIN{FS=":";OFS="\t\t\t";ORS="\n";}{  $1=$1; print substr($0, 1, length($0)-1) }' "./databases/$dbname/$tablename"
echo
sleep 2
./submenu.sh
