#!/bin/bash
# hora acordar
echo “Qual o horário para despertar? HH:MM”
read horas_despertar;
echo "Hora para despertar definida em:" $horas_despertar
sleep 2

# garantir conexão com a internet USP NET
sleep 2

# download dos novos episodios
node index.js
sleep 10


# Verifica as horas
while true
do
    horas_agora=$(date +"%H:%M")
    if [ "$horas_agora" == $horas_despertar  ]; 
    then
      # monta o nome da playlist do dia
      arquivoDoDia="new_on_"$(date +"%m")"-"$(date +"%d")".m3u";
      # verifica se tem novos episódios
      node index.js
      sleep 10
      # abre a playlist no VLC
      nvlc $arquivoDoDia
      break
    else
      # calcular quanto falta para o despertar
        [[ $horas_despertar =~ ^([0-9]{2}):([0-9]{2})$ ]]
        despertar_hora=${BASH_REMATCH[1]}
        despertar_minuto=${BASH_REMATCH[2]}
        
        agora_hora=$(date +%H)
        agora_minuto=$(date +%M)
        
        agora_despertar_h=$[despertar_hora-agora_hora]
        agora_despertar_m=$[despertar_minuto-agora_minuto]

      # verificar se o resultado é negativo, se for, multiplica por -1
        if [ 0 -gt $agora_despertar_h ] 
        then
          agora_despertar_h=$[agora_despertar_h * -1]
        fi

        if [ 0 -gt $agora_despertar_m ] 
        then
          agora_despertar_m=$[agora_despertar_m * -1]
        fi

        segundos_esperar=$[(agora_despertar_h * 3600) + (agora_despertar_m * 60)]
        echo "Despertar defido para daqui" $[agora_despertar_h] "horas e" $[agora_despertar_m] "minutos"
        
        sleep $segundos_esperar
    fi
done