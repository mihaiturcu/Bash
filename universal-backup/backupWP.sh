#!/bin/bash
#
# Script requires values for pathToBlog and pathToBKP variables

logfile="/var/log/wpbackuplog.log"
filename="bkp_wordpress2_"$(eval date +%Y%m%d)".tar.gz"
pathToBlog="/home/black/Downloads" # ex: /var/www/wordpress2/ 
pathToBKP="/tmp/bkp/" 
daystodelete="14" # how many days to keep logs :)
main()
{
	
	cd /tmp || exit #will exit if can't cd into /tmp
	if [[ "$pathToBlog" ]] && [[ "$pathToBKP" ]] #check if the variable is set to something
	then
		
		if [ ! -d "$pathToBKP" || ! -w "$logfile" ]
		then
			mkdir -p $pathToBKP
			if [ $? -eq 0 ]
			then
				echo "Directory $pathToBKP was created">>$logfile
			else
				echo "Could not create $pathToBKP, you can't write there">>$logfile
				exit
			fi	
		fi
		
		echo "Started backup @ $(date)">>$logfile
		tar -zcvf $filename $pathToBlog
		
		if [ $? -eq 0 ]
		then
			echo "OK, backup finished @ $(date)">>$logfile
		else
			echo "FAIL, backup failed @ $(date)">>$logfile
		fi
		
		mv $filename $pathToBKP
		find $pathToBKP -type f -mtime +$daystodelete -exec rm -f{} \;
	else
		echo "Required variables not set or you do not have permissions for writing in $logfile"
	fi
}
main
