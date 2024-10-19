#!/bin/bash

outputReport=$1
installDir=`pwd`

echo "<table>" ;
printf "<table border=\"1\" style=\"text-align:center;\">"
print_header=true
while read INPUT ; do
  if $print_header;then
    echo "<tr><th>${INPUT//,/</th><th>}</tr>" ;
    print_header=false
    continue
  fi
  echo "<tr><td>${INPUT//,/</td><td>}</td></tr>" ;
done < $installDir/Logs/$outputReport;
echo "</table>"


