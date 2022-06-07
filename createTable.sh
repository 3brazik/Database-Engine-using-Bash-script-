#!/bin/bash
echo
echo -e "${Blue}Please enter table name:${Defualt}"
read tablename
while [[ true ]];do
		#----> checking if contain spaces 
		if [[ $tablename = *" "* ]];
			then
			echo
			echo -e "${Red}--> ERROR : Table Name cannot Contain Space.${Defualt}"
			echo
			./createTable.sh
		fi
		
		#Checking that no special char in Database name 
    	allchar=${tablename}
		if [[ $allchar =~ ["!"?$%@"^"+="&""#"":""("")""'""}"";""{""<",.">""/"] ]];
			then
			echo
			echo -e "${Red}--> ERROR : Table Name cannot Start or Contain Special Char.${Defualt}"
			echo
			./createTable.sh
		fi

		#Checking the first char is not a Number
		firstC=${tablename:0:1}
		if [[ $firstC =~ [0-9] ]]; then
			echo 
        	echo -e "${Red}--> ERROR: Table name cannot start with number.${Defualt}" 
			echo
			./createTable.sh
		 	echo
		fi

		#Checking For Empty String
		if [ "$tablename" = "" ];
			then
			echo 
			echo -e "${Red}--> ERROR: Table name can not be Empty !${Defualt}"
			echo
			./createTable.sh
		fi

		if [ -f "./databases/$dbname/$tablename" ]; then
			echo
			echo -e "${Red}--> Table is already exsit${Defualt}" 
			echo
			./createTable.sh	
			echo
		fi
	break;
done



#validate and entering colnum num <<<<
while [[ true ]]; do 
	echo
	echo -e "${Green}Connected to table: $tablename ${Defualt}"
	echo	
    echo -e "${Blue}Please enter colnums number: ${Defualt}"
    read colnum
		
    #cannot be special char 
    if [[ $colnum =~ ["!"?$%@"^"+="&""#"":""("")""'""}"";""{""<",.">""/"] ]];then
		echo
		echo -e "${Red}--> ERROR : Colnum name cannot Start or Contain Special Char.${Defualt}"
		echo   
		./createTable.sh    
	fi
    #can not enter spaces
    if [[ $colnum =~ *" "* ]] ;then 
        echo 
        echo -e "${Red}colnum number cannot contain spaces${Defualt}"
        echo
		./createTable.sh  
    fi
    #can not be empty
    if [[ "$colnum" = "" ]] ; then 
        echo 
        echo -e"${Red}Colnum number cannot contain spaces${Defualt}"
        echo
		./createTable.sh         
 	fi
    #cannot be char
    if [[ $colnum =~ [A-Za-z] ]];then
        echo 
        echo -e "${Red}please enter number letters not allowed${Defualt}"
        ./createTable.sh  
    fi
	#cannot be zero 
    if  [[ $colnum == 0 ]];then 
	    echo
	    echo -e "${Red}Colnum can not be zero !!${Defualt}"
	    echo
        ./createTable.sh  
    fi
	break;        
done

#array for colnum names 
col_name=()
#array for colnum datatype
col_datatypes=()
#fun to check for repeted primary key name
function repeated_name {
	arr=$2
	foundflag=1
	for col in "${arr[@]}"; do
		if [[ "$col" == "$1" ]]; then
			foundflag=0
		fi
	done
	return $foundflag
}
#Checking primary key 
while [[ true ]]; 
	do
		echo
		echo -e "${Blue}Enter primary key name:${Defualt}"
		read pkey
		#----> checking if contain spaces 
		if [[ $pkey = *" "* ]];
			then
				echo
				echo -e "${Red}--> ERROR: Primary key name cannot Contain space .${Defualt}"
				echo
				./createTable.sh
		fi

		#Checking that  no special char in primarykey name 
		if [[ $pkey =~ ["!"?$%@"^"+="&""#"":""("")""'""}"";""{""<",.">""/"] ]];
			then
			echo
			echo -e "${Red}--> ERROR : Pimary key Name cannot Start or Contain Special Char.${Defualt}"
			echo
			./createTable.sh
		fi

		#Checking For Empty String
		if [ "$pkey" = "" ];
			then
			echo 
			echo -e "${Red}--> ERROR: primary key Name can Not be Empty !${Defualt}"
			echo
			./createTable.sh
		fi
		#check if primary key name is exsist or not
		if repeated_name $pkey $col_name ; then
			echo
			echo -e "${Red}----> ERROR Primarykey name cannot be Repeted ${Defualt}"
			echo
		fi
	break;	
done 
	
#fill the array
col_name+=("$pkey")
echo
echo -e "${Yellow}Please Select The Primary Key datatype of the following:  ${Defualt}"
echo -e "${Yellow}\t\t-Please Enter str For String: ${Defualt}"
echo -e "${Yellow}\t\t-Please Enter int For Integer: ${Defualt}"
read pkey_datatype
#Checking the Primary key Datatype
while [[ true ]]; do
	case $pkey_datatype in
		str )
			break;;
		int )
			break;;
		* )
			echo
			echo -e "${Red}--> ERORR Please Enter A Valid Datatype !!${Defualt}"
			echo
			./createTable.sh
	esac
break;	
done

col_datatypes+=("$pkey_datatype")

#filling the table meta data
for (( i =1; i<$colnum; i++ ));
do 	
		while [[ true ]];
			do
			echo 
			echo -e "${Blue}Enter colnum ${i} name : ${Defualt}"
			echo 
			read name
				#- checking if contain spaces 
				if [[ $name = *" "* ]];then
						echo
						echo -e "${Red}--> ERROR : primary key name cannot Contain space.${Defualt}"
						echo
						./createTable.sh
					fi
				#Checking that no special char in Database name 
				if [[ $name =~ ["!"?$%@"^"+="&""#"":""("")""'""}"";""{""<",.">""/"] ]];then
						echo
						echo -e "${Red}--> ERROR : pimary key name cannot Start or Contain Special Char.${Defualt}"
						echo
						./createTable.sh
				fi
				#Checking the first char is not a Number
				firstC=${name:0:1}
				if [[ $firstC =~ [0-9] ]]; then
					echo 
        			echo -e "${Red}--> ERROR: primary key name cannot start with number.${Defualt}" 
					echo
					./createTable.sh
		 			echo
				fi

				#Checking For Empty String
				if [ "$name" = "" ];then
						echo 
						echo -e "${Red}--> ERROR: primary key name can not be Empty !${Defualt}"
						echo
						./createTable.sh
				fi
				function repeated {
					foundflag=1
					for col in "${col_name[@]}"; do
						if [[ "$col" == "$name" ]]; then
								foundflag=0
						fi
					done
					return $foundflag
				}
				#Check if the name of the colnums is repeted 
				if  repeated $name $col_name ; then
					echo
					echo  -e "${Red}---> ERROR Repeated column name! ${Defualt}"
					./createTable.sh
				fi
		
		break;	
		done
		#adding named to the array 
     col_name+=("$name")
	 echo
     echo -e "${Yellow}Please Select  colnm ${i} datatype of the following: ${Defualt}"
	 echo -e "${Yellow}\t\tPlease Enter str For String: ${Defualt}"
	 echo -e "${Yellow}\t\tPlease Enter int For Integer:${Defualt}"
	 read name_datatype
		#Checking data type of each array
		while [[ true ]]; do
			case $name_datatype in
				str )
						break;;
				int )
						break;;

				* )
					echo -e "${Red}Please Enter A Valid Datatype :${Defualt}"
					 	if ! read name_datatype; then
							return
						fi;;		
			esac
		done
	col_datatypes+=("$name_datatype")
done

#metadata of the table
touch ./databases/$dbname/$tablename
echo "pk:${col_name[0]}" > ./databases/$dbname/$tablename.colmetadata

for (( i =0; i < $colnum; i++ ));
do 
 	echo "${col_name[$i]}:${col_datatypes[$i]}" >> ./databases/$dbname/$tablename.colmetadata
done
mv ./databases/$dbname/$tablename.colmetadata ./databases/$dbname/.$tablename.colmetadata

echo
echo -e "${Green}Table $tablename created Successfully${Defualt}"
echo
sleep 1 
./submenu.sh
