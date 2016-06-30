#!/bin/bash
echo "Iniciando..."
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Lendo arquivos de configuração..."
source $DIR/../conf/parameters.cfg
source $DIR/../scripts/functions.sh

if [ ! -d "$DIR/../tmp" ];then
  mkdir $DIR/../tmp
fi

echo "Tipo de backup.. $1"
fnLogger "Log do gerador de backup do servidor: $(hostname)"

case "$1" in
  "mysql")
  fnLogger "## Bakup de banco de dados"
  for db_file in ${2//[$'\t\r\n ,']/ }
  do
    fnMakeMysqlDump $db_file
  done
  ;;
  "files")
  fnLogger "## Bakup de arquivos"
  for fl_file in ${2//[$'\t\r\n ,']/ }
  do
    fnMakeBackupFiles $fl_file
  done
  ;;
esac

# Verifica os espaço utilizado do disco
fnVerificaDisco $cfg_disk_path

# Envia o email com o log
fnSendMail

# Limpa o diretorio temporario
rm -rfv $DIR/../tmp/*

# corrige as permições
chmod 777 -R $DIR/../../
