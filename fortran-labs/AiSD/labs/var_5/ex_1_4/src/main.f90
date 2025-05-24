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
! Использовать структуру массивов 
program ex_1_4
   use Environment
   use IOEmployee
   use calcPositions
   implicit none

  ! integer :: cpu_time = 0, start_time = 0, end_time = 0
   real(8):: start_time = 0, end_time = 0
  ! real(R_) :: elapsed_time = 0.0
   character(*), parameter  :: input_file = "../../ex_1_1/data/class.txt", &
                               output_file = "output.txt", &
                               data_file   = "employee.dat"
   ! Массивы фамилий и должностей 
   type(employees) :: empls 
   integer :: EMPLOYEE_COUNT = 0
   ! Массивы где хранится  должности и количество сотрудников этой должности
   character(BLOCK_LEN, kind=CH_), allocatable :: Poss(:)
   integer, allocatable                        :: Counts(:)
   ! Количество должностей
  ! integer :: countPositions = 0
   ! Создание файла данных
   call CreateDataFile(input_file, data_file, EMPLOYEE_COUNT)
  ! ! Ввод данных
   empls = ReadEmployees(data_file, EMPLOYEE_COUNT) 
   EMPLOYEE_COUNT = 14000
   ! Вывод исходных данных
  ! call WriteEmployee(output_file, empls, 'rewind', 'Входные данные')
  ! call system_clock(count_rate=cpu_time)
  ! call system_clock(count=start_time)
   call cpu_time(start_time)
   ! Обработка данных
   call  CalcPos(empls, EMPLOYEE_COUNT, Poss, Counts) 

   call cpu_time(end_time)
   print *, 'Время выполнения', (end_time-start_time) * 1000, 'миллисекунд'
  ! call system_clock(count=end_time)
  ! elapsed_time = (real(end_time-start_time)/real(cpu_time)) * 1000
  ! print *, start_time, end_time
  ! print *, 'Время выполнения', elapsed_time, 'миллисекунд'
   ! Вывод обработанных данных.
   call WriteCountPositions(output_file, Poss, Counts, 'rewind', 'Кол-во должностей')

end program ex_1_4
