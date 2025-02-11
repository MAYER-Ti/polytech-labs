! Задание
! 9. Дан список сотрудников группы в виде:
! ФАМИЛИЯ   И. О.   Год рождения
! 15 симв.  5 симв. 4 симв. 
! Пример входного файла:
! Иванов И. И. 1994
! Петров Д. Т. 1992
! Выделить первого по алфавиту и самого малодого. пример выходного файла:
! Первый по алфавиту:
! Иванов И. И. 1994
! Самый молодой: 
! Петров Д. Т. 1992
! 
! Использовать массив структур 

program ex_1_3
   use Environment
   use SearchesGroup 
   use IOGroup

   implicit none
   character(*), parameter  :: input_file  = "../../ex_1_1/data/class.txt", &
                               output_file = "output.txt", &
                               data_file   = "group.dat" 

   ! Массивы фамилий, инициалов и года рождения 
   type(student), allocatable :: Group(:)
   integer       :: GROUP_COUNT = 0, indexFirstForAlph = 0, indexYoungest = 0 
   real(8)       :: start_time = 0, end_time = 0
   ! Создание файла должностей
   call CreateDataFile(input_file, data_file, GROUP_COUNT)
   ! Ввод данных
   Group = ReadGroup(data_file, GROUP_COUNT) 
   ! Вывод исходных данных
   !call WriteGroup(output_file, Group, 'rewind', 'Входные данные')
   ! Обработка данных
   call cpu_time(start_time)
   ! Найти первого работника по алфавиту
   indexFirstForAlph = SearchFirstForAlph(Group, GROUP_COUNT) 
   ! Найти самого молодого
   indexYoungest = SearchYoungest(Group)

   call cpu_time(end_time)
   print *, 'Время выполнения', (end_time-start_time), 'миллисекунд'
   ! Вывод обработанных данных.
   call WriteElement(output_file, Group(indexFirstForAlph), 'rewind', 'Первый по алфавиту:')
   call WriteElement(output_file, Group(indexYoungest), 'append', 'Самый молодой:')

end program ex_1_3
