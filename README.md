# Em desenvolvimento

## Gerador de backup Linux

Dependencias Ubuntu:

```sh
$ apt-get install mysql-client heirloom-mailx rar unrar openssh-server
```

No diretório "conf" são armazenados os arquivos texto com a configuração dos backups

Para utilizar o backup de arquivos é nescessario se autentificar na origem dos arquivos:
* Gerar o par de chave `ssh-keygen`
* Copiar a chave para a origem `ssh-copy-id root@ip_origem`
* Realizar o teste de login `ssh root@ip_origem`

Exemplo de configuração crontab
```sh
$ crontab -e
....
# crontab do root
# minuto hora dia mes diaSemana  comando
     0     0   *   *    0-5      /srv/backup-dados/ShellBackupManager/scripts/controller.sh mysql db.teste.cfg,db.teste2.cfg
     0     0   *   *    0-5      /srv/backup-dados/ShellBackupManager/scripts/controller.sh files fl.teste.cfg,fl.teste2.cfg
```
