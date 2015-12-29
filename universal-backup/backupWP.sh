#!/bin/bash
#
# Script requires values for pathToBlog and pathToBKP variables
logfile="/var/log/wpbackuplog.log"
filename="bkp_wordpress2_"$(eval date +%Y%m%d)".tar.gz"
pathToBlog="/home/black/Downloads" # ex: /var/www/wordpress2/ 
#pathToBKP="/tmp/bkp/" 
daystodelete="14" # how many days to keep logs :)
check_dir_writable()
{
	if [ -w "$1" ]
	then
		return 0
	else
		return 1
	fi
}
check_var_set()
{
	if [[ ! $\{$@\} ]]
	then
		echo "$1 variable not set"
		exit
	fi

}
satisfy_prereq()
{
	set -x
	check_var_set logfile
	check_var_set pathToBlog
	check_var_set pathToBKP
	echo "Starting prereq checks"
	if (check_dir_writable $logfile) && (check_dir_writable $pathToBKP)
	then
		echo "seems ok"
	else
		echo "failed prereq"
		exit
	fi
	set +x
}

main()
{
	
	cd /tmp || exit #will exit if can't cd into /tmp
	satisfy_prereq
# pana aci	
	if ([[ "$pathToBlog" ]] && [[ "$pathToBKP" ]]) #check if the variable is set to something
	then
		if [ -w $pathToBKP ]
		then
			echo "$pathToBKP writable"
		else
			echo "$pathToBKP not writable"
			exit
		fi

		if ([ ! -d "$pathToBKP" ])
		then
			mkdir -p $pathToBKP
			if [ $? -eq 0 ]
			then
				if check_dir_writable $logfile
				then
					echo "Logfile not writable, check $logfile"
					exit
				fi
				echo "Directory $pathToBKP was created">>$logfile
			else
				echo "Could not create $pathToBKP, you can't write there">>$logfile
				exit
			fi	
		else
			if [ ! -w "$pathToBKP" ]
			then
				echo "$pathToBKP directory is not writable by current user"
				exit
			fi
		fi
		
		
		echo "Started backup @ $(date)">>$logfile
		tar -zcvf "$filename" "$pathToBlog"
		
		if [ $? -eq 0 ]
		then
			echo "OK, backup finished @ $(date)">>$logfile
		else
			echo "FAIL, backup failed @ $(date)">>$logfile
			exit
		fi
		
		mv "$filename" "$pathToBKP"
		find $pathToBKP -type f -mtime +$daystodelete -exec rm -f{} \;
	else
		echo "Some variables are not set, check script"
	fi
}
main
