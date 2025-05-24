pure recursive subroutine Delete_in_tree(current, value)
      type(node_tree), allocatable, intent(inout)  :: current
      integer, intent(in)  :: value

      type(node_tree), allocatable  :: left, right
     
      if (allocated(current)) then
        if (current%value == value) then
           call Mov_alloc(current%left, left)
		   call Mov_alloc(current%right, right)
           call Mov_alloc(right, current)
           if (allocated(left)) &
              call Put_to_left(current, left)
        else if (current%value > value) then
           call Delete_in_tree(current%left, value)
        else if (current%value < value) then
           call Delete_in_tree(current%right, value)
        end if
      end if
   end subroutine Delete_in_tree

   pure recursive subroutine Put_to_left(current, left)
      type(node_tree), allocatable  :: current
      type(node_tree), allocatable  :: left

      if (.not. allocated(current)) then
         call Mov_alloc(left, current)
      else
         call Put_to_left(current%left, left)
      end if
   end subroutine Put_to_left