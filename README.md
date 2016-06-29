# Em desenvolvimento

## Gerador de backup Linux

Dependencias Ubuntu:

```sh
$ apt-get install mysql-client heirloom-mailx rar unrar
```

No diretório "conf" são armazenados os arquivos texto com a configuração dos backups

Exemplo de configuração crontab
```sh
$ crontab -e
....
# crontab do root
# minuto hora dia mes diaSemana  comando
     0     0   *   *    0-5      /srv/backup-dados/ShellBackupManager/scripts/controller.sh mysql db.teste.cfg,db.teste2.cfg
```
