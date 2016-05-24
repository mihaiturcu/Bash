#!/bin/bash
pathTodir="/var/log/somewhere"
daystodelete="60"
main()
{
	find $pathTodir -type f -mtime +$daystodelete -exec rm -f{} \;
	echo "simpledelete.sh ran on $(date)" >> /var/log/simpledete.log
}
main
