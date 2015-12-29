#!/bin/bash
#
# Script requires values for pathToBlog and pathToBKP variables
logfile="/var/log/wpbackuplog.log"
filename="bkp_wordpress2_"$(eval date +%Y%m%d)".tar.gz"
pathToBlog="/home/black/Downloads" # ex: /var/www/wordpress2/ 
pathToBKP="/tmp/bkp/" 
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
	for var in "$@"
	do
		if [ -z ${!var} ]
		then
			echo "$var variable not set -- @$(date)" | tee -a $logfile
			exit
		fi
	done

}
satisfy_prereq()
{
	check_var_set logfile pathToBlog pathToBKP daystodelete
	if !(check_dir_writable $logfile) && !(check_dir_writable $pathToBKP)
	then
		echo "Backup dir/logfile not writable"
		exit
	fi
}
main()
{
	cd /tmp || exit #will exit if can't cd into /tmp
	satisfy_prereq
	
	echo "Started backup @ $(date)" | tee -a $logfile
	tar -zcvf "$filename" "$pathToBlog"
	
	if [ $? -eq 0 ]
	then
		echo "OK, backup finished @ $(date)" | tee -a $logfile
	else
		echo "FAIL, backup failed @ $(date)" | tee -a $logfile
		exit
	fi
		
	mv "$filename" "$pathToBKP"
	find $pathToBKP -type f -mtime +$daystodelete -exec rm -f{} \;
}
main
