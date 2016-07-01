#!/bin/bash
echo "Carregando funções"

# Backup mysql usando mysqldump
function fnMakeMysqlDump(){
  echo "Carrega arquivo de configuração $1"
  source $DIR/../conf/$1

  # Cria o diretorio de trabalho caso não exista
  work_dir=$DIR/../tmp/$cfg_dir_db_work_name/"${db_ip}_${db_type}"
  if [ ! -d "$work_dir" ]; then
    mkdir -p $work_dir
  fi

  fnLogger "#"
  fnLogger "-- ${db_ip}_${db_type}"

  # Realiza o dump de cada esquema especificado em, dbs
  for db_name in ${db_databases//[$'\t\r\n ,']/ }; do
    fnLogger "--- ${db_name}"
  	# Rotina de backup MySQL
  	mysqldump --user=$db_user --password=$db_pass --host=$db_ip --port=3306 \
    --protocol=tcp --force --allow-keywords --compress --add-drop-table --add-locks \
    --default-character-set=utf8 --hex-blob --routines --events \
    --result-file=$work_dir/$db_name.sql --databases $db_name
  done

  # Compacta a pasta de trabalho, diretamente na pasta de destino
  echo $(cd $DIR/../tmp && rar a -r $db_save_path/$cfg_dir_db_work_name.rar $cfg_dir_db_work_name)

  if [ -e -d $db_copy_to_path ]; then
    cp -v $db_save_path/$cfg_dir_db_work_name.rar "${db_copy_path}"
  fi
}

function fnLogger(){
  echo "${1}" >> $DIR/../tmp/log.txt
}

function fnSendMail(){
  log_file="$( cat $DIR/../tmp/log.txt )"

  echo "$log_file" | mailx -v \
   -r $cfg_mail_user \
   -s "$cfg_mail_subject - $cfg_dir_db_work_name" \
   -S smtp=$cfg_mail_smtp \
   -S smtp-use-starttls \
   -S smtp-auth=login \
   -S smtp-auth-user=$cfg_mail_user \
   -S smtp-auth-password=$cfg_mail_pass \
   -S ssl-verify=ignore \
   ${cfg_mail_receivers//[$'\t\r\n ,']/ }
}

# Função da calcular o uso do disco
function fnVerificaDisco() {
	aux=( $( df -h $cfg_disk_path | awk '{print $5}' ) )
  sed -i "2i Uso do disco ${aux[1]}" $DIR/../tmp/log.txt

	if [ ${aux[1]//[$'%']/} -gt $cfg_disk_usage ]; then
      sed -i "2i Disco cheio" $DIR/../tmp/log.txt
	fi
}

function fnMakeBackupFiles(){
  echo "Carrega arquivo de configuração $1"
  source $DIR/../conf/$1

  fnLogger "#"
  fnLogger "-- ${fl_ip}_${fl_type}"

  # cria o arquivo rar
  for fl_name in ${fl_folder_list//[$'\t\r\n ,']/ }; do
    fnLogger "--- ${fl_name}"
    ssh $fl_user@$fl_ip "cd $fl_base_path && rar a -r /tmp/$cfg_dir_fl_work_name $fl_name && exit"
  done

  # baixa o arquivo rar
  scp $fl_user@$fl_ip:/tmp/$cfg_dir_fl_work_name.rar $fl_save_path

  # remove o arquivo
  ssh $fl_user@$fl_ip " rm -rfv /tmp/$cfg_dir_fl_work_name.rar && exit "
}
