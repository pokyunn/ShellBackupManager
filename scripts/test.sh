#!/bin/bash
echo "Arquivo teste..."

# Captura a hora atual
scriptStartTime=$(date +%s)

for (( i = 0; i < 1000000; i++ )); do
  sssss=$i
done

#Realiza o calculo da duração do script
scriptEndTime=$(date +%s)
#soma=$(expr $datafinal - $datainicial)
#resultado=$(expr 10800 + $(expr $datafinal - $datainicial) )
tempo=$(date -d @$(expr 10800 + $(expr $scriptEndTime - $scriptStartTime) ) +%Hh:%Mm:%Ss)
echo $scriptEndTime
echo $scriptStartTime
echo "Tempo gasto: $tempo "
