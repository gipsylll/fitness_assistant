#!/bin/bash 
. ./func.sh

sep=' '
sep1="_"
date=$(date +"%d-%m-%Y")
echo "Сегодня $date"
date1=$(date +"%m_%Y")
date2=$(date +"%d/%m")
flag=0

echo "Приветствую Вас в калькуляторе ИМТ."
check_choice

read -p "выберите " choice
while [[ $choice -ne 0 || $choice -ne "0" ]]
do
    case "$choice" in
        1)
            calculate_IMT
            ;;
        2)
            calculate_drink
            ;;
        3)  
            calculate_CFP
            ;;
        4)
            paint IMT
            ;;
        5)
            paint drink
            ;;
        6) 
            paint_CFP
            ;;
        *) 
            echo "Неверный вввод"
            ;;

    esac
    check_choice
    read -p "выберите " choice
done
echo "До свидания!"

