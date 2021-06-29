#!/bin/bash -x
#
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#       Respaldos de BD
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Ruta al Respaldo
backupDir=/backup/database
# Ruta al Servidor (Montado con cifs)
bksrvrDir=/backup/SRVR/
# Ruta al Servidor (Montado con cifs)
bksrvrDbDir=/backup/SRVR/database
# Fecha del día
myDate=$(date '+%Y%m%d')
# Nombre de la base de datos a respaldar
database_name=database_name
# Nombre de Archivo de Salida
output=backup_$myDate.sql.gz
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Vamos al directorio de respaldos locales
cd $backupDir

# Comprobamos los directorios del año y del mes
thisYear=$(date '+%Y')
thisMonth=$(date '+%m')

# Comprobamos si existe la carpeta localmente y de ser necesario la creamos
[[ -d $thisYear ]] || mkdir $thisYear
cd $thisYear
[[ -d $thisMonth ]] || mkdir $thisMonth
cd $thisMonth

# Creamos el respaldo de la BD
mysqldump -u root -p"PASSWORD" $database_name | gzip > $output


# Revisamos que este montado el directorio de respaldos
if ! mount | grep $bksrvrDir > /dev/null; then
 sudo mount -t cifs -o username=sistemas,password=password //192.168.0.0/backup/ /root/backup/SRVR/
fi

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Ahora nos colocamos en la carpeta montada del servidor y revisamos
# que los directorios existan para luego copiar el archivo
if [ -d "$bksrvrDbDir" ]; then
        cd $bksrvrDbDir
                [[ -d $thisYear ]] || mkdir $thisYear
        cd $bksrvrDbDir
                [[ -d $thisYear ]] || mkdir $thisYear
        cd $thisYear
                [[ -d $thisMonth ]] || mkdir $thisMonth
        cd $thisMonth
        # Copiamos el archivo a la carpeta montada
        cp "$backupDir/$thisYear/$thisMonth/$output" "$bksrvrDbDir/$thisYear/$thisMonth/"
fi
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
