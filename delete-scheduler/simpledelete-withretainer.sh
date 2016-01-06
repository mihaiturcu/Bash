#!/bin/bash
pathTodir="/var/log/something"
daystodelete="180"
main()
{
        todelete=$(find $pathTodir -type f -mtime +$daystodelete | wc -l)
        filenumber=$(ls -la $pathTodir | wc -l)
        ((remaining = filenumber - todelete))
        if [ $remaining -gt 5 ]
        then
                find $pathTodir -type f -mtime +$daystodelete -delete
        else
                exit
        fi
}
main
