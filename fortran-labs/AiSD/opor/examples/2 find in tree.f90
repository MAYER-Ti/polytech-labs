recursive pure function Search_in_tree(current, elem) result (res)
   logical res
   type (Node), allocatable, intent (in) :: current
   integer, intent (in) :: elem
   
   if (.not. allocated(current)) then
      res = .false.
   elseif (elem == current%Num) then
      res = .true.
   elseif (elem < current%Num)
      call Search_in_tree(current%left)
   elseif (elem > current%Num)
      call Search_in_tree(current%right)
   end if
end function