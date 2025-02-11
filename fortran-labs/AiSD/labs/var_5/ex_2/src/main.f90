! Задание 5
! Разработать чистую подпрограмму перемещения в тексте группы строк со строки First по строку Last после K-ой строки.
! Занчения First, last, K задаются во втором входном файле. Правильными данными считается ситуация, когда
! First <= Last, а K не принадлежит интервалу [First, Last]
! Указания
! Элементом списка является строка

program ex_2
   use Environment
   use Source_Process
   use mod_list

   implicit none
   character(:), allocatable :: source_file, input_file, output_file

   type(list) :: SourceCode ! Первоначальный код.
   integer    :: indexFirst = 0, indexLast = 0, indexPaste = 0

   source_file = "../data/source.f90"
   input_file  = "../data/input.txt"
   output_file = "Output.txt"
  
   ! Ввод данных  
   call SourceCode%ReadSourceCode(source_file)
   call ReadInput(input_file, indexFirst, indexLast, indexPaste)
   ! Вывод исходных данных
   call SourceCode%WriteCode(output_file, "rewind", "------------------ Исходный файл ------------------")
   ! Обработка данных
   call SourceCode%MovePartList(indexFirst, indexLast, indexPaste)
   ! Вывод обработанных данных
   call SourceCode%WriteCode(output_file, "append" , "----------------- Измененный файл ------------------")

end program ex_2
