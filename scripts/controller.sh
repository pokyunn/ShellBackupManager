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
    fnMakeMysqlDump $2
    fnSendMail
  ;;
esac

# Limpa o diretorio temporario
rm -rfv $DIR/../tmp/*

# corrige as permições
chmod 777 -R $DIR/../../
