! Copyright 2019 Fyodorov S. A.

program reference_lab_list
   use Environment
   use List_Process
   use List_IO

   implicit none
   character(:), allocatable :: input_file, output_file

   class(node), pointer   :: List => Null()

   input_file  = "../data/list.txt"
   output_file = "output.txt"
   
   List => Read_list(input_file)
   
   if (Associated(List)) then
      call Output_list(output_file, List, "Исходный список:", "rewind")
   end if
   
end program reference_lab_list
