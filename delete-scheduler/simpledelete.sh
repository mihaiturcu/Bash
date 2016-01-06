#!/bin/bash
pathTodir="/var/log/somewhere"
daystodelete="60"
main()
{
	find $pathTodir -type f -mtime +$daystodelete -exec rm -f{} \;
}
main
