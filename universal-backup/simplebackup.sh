#!/bin/bash
#
filename="bkp_wordpress2_"$(eval date +%Y%m%d)".tar.gz"
pathToBlog="/home/black/Downloads" # ex: /var/www/wordpress2/ 
pathToBKP="/tmp/bkp/" 
daystodelete="14" # how many days to keep logs :)

main()
{
	cd /tmp || exit #will exit if can't cd into /tmp
	
	tar -zcvf "$filename" "$pathToBlog"
	
	mv "$filename" "$pathToBKP"
	find $pathToBKP -type f -mtime +$daystodelete -exec rm -f{} \;
}
main
