function print_graf {
    process=$1
    month=$2
    year=$3
    file=".db/db_$process$sep1$month$sep1$year"
    file1="graph/graph_$process$sep1$month$sep1$year"

    if [ -f $file ];then
    input_file="$file"
    output_file="$file1.png"


gnuplot_script=$(cat << EOF
set terminal png
set output "${output_file}"
set style data histograms
set style histogram cluster gap 1
set style fill solid
set yrange [0:*]
set auto x
plot "${input_file}" using 2:xtic(1) title "$process"
EOF
)


    echo "$gnuplot_script" > temp_script.gp


    gnuplot temp_script.gp

    echo "График создан и сохранен в файле '${output_file}'"
    rm temp_script.gp
    else 
        echo "Нет данных за этот период"
    fi
}

function check_choice {
    echo '1. посчитать ИМТ'
    echo '2. добавить кол-во воды'
    echo '3. добавить БЖУ' 
    echo '4. график ИМТ' 
    echo '5. график употребления воды'
    echo '6. графики БЖУ'
    echo '0. выйти из скрипта'
}



function write_in_base {
    write_in=$1
    value=$2
    
    echo "$date2$sep$value" >> ".db/db_$write_in$sep1$date1"
    echo "Данные записаны!"
}

function calculate_IMT {
    echo "Введите ваш вес в килограммах:"
    read weight
    echo "Введите ваш рост в метрах:"
    read height
    bmi=$(bc -l <<< "scale=1; $weight / ($height * $height)")
    echo "Ваш ИМТ: $bmi"
    if (( $(echo "$bmi < 18.5" | bc -l) )); then
      echo "У вас дефицит массы тела"
    elif (( $(echo "$bmi < 25" | bc -l) )); then
      echo "Ваш вес в пределах нормы"
    elif (( $(echo "$bmi < 30" | bc -l) )); then
      echo "У вас избыточный вес"
    else
      echo "У вас ожирение"
    fi
    
  write_in=IMT
   file=.db/db_$write_in$sep1$date1
  for line in $(cat $file)
  do 
      if [[ $line == $date2 ]]
      then
      flag=1
      fi
  done
    if [[ $flag -eq 0 ]]
    then
    write_in_base $write_in $bmi
    else
    echo "Вы сегодня уже вводили данные!!!"
  fi
}

function calculate_drink {
    
    write_in='drink'
    file=.db/db_$write_in$sep1$date1
  for line in $(cat $file)
  do 
      if [[ $line == $date2 ]]
      then
      flag=1
      fi
  done
    if [[ $flag -eq 0 ]]
    then
    echo "сколько вы выпили воды за сегодня(в мл)?"
    read drink
    write_in_base $write_in $drink
    else
    echo "Вы сегодня уже вводили данные!!!"
  fi
}

function calculate_CFP {
    write_in=carbohydrates
    file=.db/db_$write_in$sep1$date1
  for line in $(cat $file)
  do 
      if [[ $line == $date2 ]]
      then
      flag=1
      fi
  done
    if [[ $flag -eq 0 ]]
    then

    echo "сколько вы съели углеводов за сегодня?"
    read carbohydrates
    write_in_base $write_in $carbohydrates

    write_in=protein
    echo "Сколько за сегодня вы съели белков?"
    read protein
    write_in_base $write_in $protein

    echo "Сколько за сегодня вы съели жиров?"
    read fats
    write_in=fats
    write_in_base $write_in $fats
    else
    echo "Вы сегодня уже вводили данные!!!"
  fi
    
}


function paint {
    echo "За какой месяц вы хотите построить график?(введите в форматe: 05)"
    read month
    echo "За какой год вы хотите простроить график?(введите в формате 2024)"
    read year
    process=$1
    print_graf $process $month $year
}
function paint_CFP {
  echo "За какой месяц вы хотите построить график?(введите в форматe: 05)"
  read month
  echo "За какой год вы хотите простроить график?(введите в формате 2024)"
  read year
  process=carbohydrates
  print_graf $process $month $year
  process=fats
  print_graf $process $month $year
  process=protein
  print_graf $process $month $year
}
