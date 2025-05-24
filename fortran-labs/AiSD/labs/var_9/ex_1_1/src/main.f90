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
! Использовать массив строк

program ex_1_1
   use Environment
   use SearchesGroup 
   use IOGroup

   implicit none
   !integer, parameter       :: BLOCK_LEN = 15, EMPLOYEE_COUNT  = 5
   character(*), parameter :: input_file = "../data/class.txt", output_file = "output.txt"
   ! Массивы фамилий, инициалов и года рождения 
   character(SURNAME_LEN, kind=CH_), allocatable  :: Surnames(:)
   character(INITIALS_LEN, kind=CH_), allocatable :: Initials(:)
   integer, allocatable                           :: Dates(:)
   ! Массивы где хранится  должности и количество сотрудников этой должности
   integer  :: indexFirstForAlph = 0, indexYoungest = 0, GROUP_COUNT = 0
   real(8):: start_time = 0, end_time = 0
   ! Ввод данных
   call ReadGroup(input_file, Surnames, Initials, Dates) 
   GROUP_COUNT = Ubound(Surnames, 1)
   ! Вывод исходных данных
   !call WriteGroup(output_file, Surnames, Initials, Dates, 'rewind', 'Входные данные')
   call cpu_time(start_time)
   ! Обработка данных
   ! Найти первого работника по алфавиту
   indexFirstForAlph = SearchFirstForAlph(Surnames, GROUP_COUNT) 
   ! Найти самого молодого
   indexYoungest = SearchYoungest(Dates)

   call cpu_time(end_time)
   print *, 'Время выполнения', (end_time-start_time), 's'
   ! Вывод обработанных данных.
   call WriteElement(output_file, Surnames(indexFirstForAlph), Initials(indexFirstForAlph), Dates(indexFirstForAlph),&
       'rewind', 'Первый по алфавиту:')
   call WriteElement(output_file, Surnames(indexYoungest), Initials(indexYoungest), Dates(indexYoungest),&
       'append', 'Самый молодой:')

end program ex_1_1
