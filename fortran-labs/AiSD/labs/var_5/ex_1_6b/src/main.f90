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
! Использовать recursive allocatable списки 
! Использовать хвостовую рекурсию
program ex_1_6b
   use Environment
   use IOEmployee
   use Process

   implicit none
   real(8) :: start_time = 0, end_time = 0
   character(*), parameter  :: input_file = "../data/class.txt", &
                               output_file = "output.txt", &
                               data_file   = "employee.dat"
   ! Массивы фамилий и должностей 
   type(nodeEmpl), allocatable :: List 
   ! Массивы где хранится  должности и количество сотрудников этой должности
   type(nodePosCount), allocatable :: Res
   ! Ввод данных
   List = ReadList(input_file) 
   ! Вывод исходных данных
   !call WriteList(output_file, List, 'rewind', 'Входные данные')
   call cpu_time(start_time)
   ! Обработка данных
   call RecCalcPos(List, Res) 

   call cpu_time(end_time)
   print *, 'Время выполнения', (end_time-start_time) * 1000, 'миллисекунд'
   ! Вывод обработанных данных.
   call WriteList(output_file, Res, 'append', 'Кол-во должностей')

end program ex_1_6b
