#!/bin/bash
echo
echo -e "${Blue}Listing all Tables: ${Defualt}"
echo
ls ./databases/$dbname/$filename
echo
echo -e "${Blue}Enter Table Name to Insert: ${Defualt}"
echo
read tablename 
if [ -f "./databases/$dbname/$tablename" ]; then
	    echo
		echo -e "${Green}${bold}Connected to $tablename Table${Defualt}";
		echo -e "${Blue}Table $tablename Schema: ${Defualt}"
        echo
        # Metadata
		awk -v var=$tablename 'BEGIN {FS=":"; print "\t\tTable Name: " var "\n"} {if(NR>1) printf     $1"<"$2">  \t\t"} END{printf "\n"}' "./databases/$dbname/.${tablename}.colmetadata"
		echo
		
	else 
	echo
	echo -e "${Red}${bold}Table is Not Exsits${Defualt}"	
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
        if [[ $i = $1 ]]; then
            checkPK=0
            break
        fi

        done
    return $checkPK 
}
        
while [ true ]; do
            echo
            echo -e "${Blue}Insert Primary key Value:${Defualt}"
            echo
            read primaryKeyValue
            #Checking if it contain colons
            if [ "$primaryKeyValue" = *:* ]; then
                echo -e "${Red}Primary key cannot contain: ${Defualt}"
                continue
            fi
            #Checking if it contain spaces
            if [[ $primaryKeyValue = *" "* ]];then
				echo
				echo -e "${Red}--> ERROR  Primary key value cannot Contain space.${Defualt}"
				echo
                continue		    
            fi

		    #Checking that  no special char in Database name 
		    if [[ $primaryKeyValue =~ ["!"?$%@"^"+="&""#"":""("")""'""}"";""{""<",.">""/"] ]];
		    	then
		    	echo
		    	echo "--> ERROR : primary key value cannot Start or Contain Special Char."
		    	echo
		    	continue
		    fi

		    #Checking For Empty String
		    if [ "$primaryKeyValue" = "" ];
		    	then
		    	echo 
		    	echo -e "${Red}--> ERROR: primary key value can not be Empty !${Defualt}"
		    	echo
                continue		
            fi
            #Checking Data type of the inserted 
		    if ! check_datatype "${coltype[0]}" "$primaryKeyValue" ; then
    
		    	echo
		    	echo -e "${Red}Primary key datatype value dose not match${Defualt}"
		    	echo
               continue
		    fi
          
            #Checking if the the primary key is uniqe
            if  checkPkeyUnique "$primaryKeyValue" ; then
                echo
                echo -e "${Red}Primary key value is not unique !${Defualt}"
               continue
            fi
break   
done    

record+=("$primaryKeyValue")

for ((i = 1; i < $colnum-1; i++ )); do

    while [ true ]; do
        echo
        echo -e "${Blue}Enter columns ${i} values: ${Defualt}"
        echo
        read values
        #Checking if it contain colons
        if [ "$values" = *:* ]; then
            echo -e "${Red}Column value cannot contain : ${Defualt}"
            continue
        fi
        #Checking For Empty String
        if [ "$values" = "" ]; then
            echo -e "${Red}Column value cannot be empty ! ${Defualt}"
            continue
        fi
        #Checking if it contain spaces
        if [ "$values" = *" "* ]; then
            echo -e "${Red}Column value cannot contain spaces ! ${Defualt}"
            continue
        fi
        #Checking  the primary key data type
        if ! check_datatype "${coltype[$i]}" "$values" ; then
	    	echo
	    	echo -e "${Red}Entered values and column datatype value dose not match ! ${Defualt}"
	    	echo
            continue	    
         fi
        break
    done
    record+=("$values")
done

for (( i = 0; i < $colnum-1; i++ )); do
    echo -n  "${record[$i]}:" >> "./databases/$dbname/$tablename"
done
echo "" >> "./databases/$dbname/$tablename"
echo
echo -e "${Green}${bold}Record has been added succesfully !${Defualt}"
echo
echo -e "${Blue}${bold}Table ${tablename} Data After insertion  ${Defualt}"
echo
# Metadata
awk -v var=$tablename 'BEGIN {FS=":"; print "\t\t\t\tTable Name: " var "\n"} {if(NR>1) printf     $1"<"$2">  \t\t"} END{printf "\n"}' "./databases/$dbname/.${tablename}.colmetadata"
# Data
awk 'BEGIN{FS=":";OFS="\t   \t\t";ORS="\n";}{  $1=$1; print substr($0, 1, length($0)-1) }' "./databases/$dbname/$tablename"
echo
sleep 1
echo -e "${Blue}Press any key to go back to the Table menu${Defualt}"
		echo
		read key
		case $key in
            *)   
				./submenu.sh
				;;
		esac

