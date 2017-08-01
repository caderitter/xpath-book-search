#!/bin/bash

if [ $# -ne 5 ]; then
    echo $0: usage: search_db_xpath [username] [servername] [xpath] [filename] [output-filename]
    echo example usage: search_db_xpath cade qa \"//*[local-name=\'definition\']\" index.cnxml output.csv
    exit 1
fi

username=$1
servername=$2
xpath=$3
filename=$4
outputfile=$5

connectionstring=$username@$servername.cnx.org

echo "SSH to server..."
ssh $connectionstring <<EOSSH || exit 1
psql -U rhaptos -h /var/run/postgresql -d repository <<EOSQL
\o $outputfile;
SELECT * FROM search_db_xpath(e'$xpath', '$filename');
\q
EOSQL
echo "...done."
exit
EOSSH
echo "Copying file to this machine..."
scp $connectionstring:~/$outputfile .
echo "...done"




