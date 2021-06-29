#!/bin/bash

# Ruta al Respaldo
backupDir=/root/backups/MntSistemas/Servidores/DataBase

# Ruta al Bkpsrvr (Montado con cifs)
bksrvrDir=/root/backups/MntSistemas/

# Revisamos que este montado el directorio de respaldos
if ! mount | grep $bksrvrDir > /dev/null; then
 mount -t cifs //192.168.0.0/backup "$bksrvrDir" -o username=username,password=password
fi


# Vamos al directorio de respaldos
cd $backupDir

# Comprobamos los directorios del año y del mes
thisYear=$(date '+%Y')
thisMonth=$(date '+%m')

# Comprobamos si existe la carpeta localmente y de ser necesario la creamos
[[ -d $thisYear ]] || mkdir $thisYear
cd $thisYear
[[ -d $thisMonth ]] || mkdir $thisMonth
cd $thisMonth


# MYSQL CONFIGURATION
mysql_user="user"
mysql_pass="password"

# SKip Databases in Backup
skip_databases=('information_schema' 'performance_schema' 'mysql')

# Get a list of all databases
databases=`mysql --user=$mysql_user --password=$mysql_pass -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

# Doing Backup
for db in $databases; do
        match=0
        for acc in "${skip_databases[@]}"; do

        if [[ $db == "$acc" ]]; then
                match=1
                break
        fi

                break
        fi
        done
        if [[ $match = 0 ]]; then
                mysqldump --force --opt --user=$mysql_user --password=$mysql_pass --databases $db | gzip > `date +%Y%m%d`"_$db".sql.gz
        fi
done
