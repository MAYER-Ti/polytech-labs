! Задание 9
! Разработать чистую подпрограмму копирования группы
! строк данного текста от начальной строки First до конеч-
! ной Last и вставки их после M-ой строки. Правильному
! набору вводимых данных соответствует ситуация, когда
! 0≤First≤Last и M не входит в диапазон [First, Last].
! Указание. Элементом списка является строка.
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
   call SourceCode%ReadCode(source_file)
   call ReadInput(input_file, indexFirst, indexLast, indexPaste)
   ! Вывод исходных данных
   call SourceCode%WriteCode(output_file, "rewind", "------------------ Исходный файл ------------------")
   ! Обработка данных
   call SourceCode%CopyPastePartList(indexFirst, indexLast, indexPaste)
   ! Вывод обработанных данных
   call SourceCode%WriteCode(output_file, "append" , "----------------- Измененный файл ------------------")

end program ex_2
