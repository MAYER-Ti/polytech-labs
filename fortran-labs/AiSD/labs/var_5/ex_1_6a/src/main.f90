! Задание
! 5. Дан список сотрудников научно-исследовательской лаборатории в виде:
! ФАМИЛИЯ   ДОЛЖНОСТЬ
! 15 симв.  15 симв.
! Пример входного файла:
! Иванов       техник
! Определить число одинаковых должностей. пример выходного файла:
! ведущий инженер - 2
! старший инженер - 3
! инженер         - 8
! техник          - 2
! Указание
! Завести логический массив длинной N. При обработке должности
! очередного сотрудника сразу найти все такие должности и поместить в логическом массиве, где они встречаются
! Должность следующего сотрудника обрабатывать, только если она прежде не встречалась (смотреть логический массив).
! Использовать Count с маской, Any. См. упражнение 5.16, 7.25
! Использовать динамические однонаправленные списки 
! Использовать хвостовую рекурсию
program ex_1_6a
   use Environment
   use IOEmployee
   use Process
   implicit none

   real(8) :: start_time = 0, end_time = 0
   !real(8) :: elapsed_time = 0.0
   character(*), parameter  :: input_file = "../data/class.txt", &
                               output_file = "output.txt", &
                               data_file   = "employee.dat"
   ! Массивы фамилий и должностей 
   type(nodeEmpl), pointer :: List 
   ! Массивы где хранится  должности и количество сотрудников этой должности
   type(nodePosCount), pointer :: Res
   ! Ввод данных
   List => ReadList(input_file) 
   ! Вывод исходных данных
   !call WriteList(output_file, List, 'rewind', 'Входные данные')
  ! call system_clock(count_rate=cpu_time)
  ! call system_clock(count=start_time)
   call cpu_time(start_time)
   ! Обработка данных
   call RecCalcPos(List, Res) 

   call cpu_time(end_time)

  ! call system_clock(count=end_time)
  ! elapsed_time = (real(end_time-start_time)/real(cpu_time))
  ! print *, start_time, end_time
  print *, 'Время выполнения', (end_time-start_time) * 1000, 'миллисекунд'
   ! Вывод обработанных данных.
   call WriteList(output_file, Res, 'append', 'Кол-во должностей')

end program ex_1_6a
