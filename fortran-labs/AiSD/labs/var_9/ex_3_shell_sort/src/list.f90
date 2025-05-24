module mod_list
   use Environment

   implicit none
!   private

   type, public :: node
      character(:, kind=CH_), allocatable :: string
      type(node), allocatable :: next    
   end type node

   type, public :: list
      type(node), allocatable :: head
      contains
          procedure, public         :: ReadList
          procedure, public         :: WriteList
          procedure, public, nopass :: InsertionSort
          procedure, public         :: ShellSort
          final                     :: Delete
   end type

contains

   pure recursive subroutine ShellSort(dList, gap)
      class(list), intent(inout) :: dList
      integer, intent(in) :: gap

      if(gap >= 1) then 
         call ShellSort_iter(dList%head, gap)

         call dList%ShellSort(gap/2)
      end if 
   end subroutine ShellSort

   pure recursive subroutine ShellSort_iter(current, gap)
      type(node), allocatable, intent(inout) :: current
      integer, intent(in) :: gap

      call Swap(current, current, gap, 1)

      if(Allocated(current%next)) &
          call ShellSort_iter(current%next, gap)
   end subroutine ShellSort_iter


   pure recursive subroutine Swap(left, right, gap, i)
      type(node), allocatable, intent(inout) :: left, right
      integer, intent(in) :: gap, i
      type(node), allocatable :: tmp, tmp2

      if(Allocated(right)) then
         !Сравнение
         if(i == gap) then
            if( left%string < right%string) then 
               !Поменять
              ! call move_alloc(Current, temp)
              ! call move_alloc(temp%next, Current)
              ! call move_alloc(Current%next, temp%next)
              ! call move_alloc(temp, Current%next)

              ! call move_alloc(left, tmp)
              ! call move_alloc(right, left)
              ! call move_alloc(left%next, tmp2)
              ! call move_alloc(tmp, right)
              ! call move_alloc(right%next, left%next)
              ! call move_alloc(tmp2, right%next)

              ! call move_alloc(left, tmp)
              ! call move_alloc(right, left)
              ! call move_alloc(tmp, right)
            end if
         else
            call Swap(left, right%next, gap, i+1)
         end if
      end if
      

   end subroutine Swap

   !------------------------------------------------------------

   recursive subroutine InsertionSort(List, lastSorted)
      type(node), allocatable, intent(inout) :: List 
      type(node), allocatable, intent(inout) :: lastSorted
      type(node), allocatable :: tmp

      if(Allocated(lastSorted%next)) then 
         if(lastSorted%next%string < lastSorted%string) then
            ! Вырезать из списка элемент
            call move_alloc(lastSorted%next, tmp)
            call move_alloc(tmp%next, lastSorted%next)
            ! Вставить в нужное место
            call Paste(List, tmp)
            call InsertionSort(List, lastSorted)
         else 
            call InsertionSort(List, lastSorted%next)
         end if
      end if

   end subroutine InsertionSort

   pure recursive subroutine Paste(current, nodeToInsert)
      type(node), allocatable, intent(inout) :: current, nodeToInsert

      if(nodeToInsert%string < current%string) then
         call move_alloc(current, nodeToInsert%next)
         call move_alloc(nodeToInsert, current) 
      else 
         call Paste(current%next, nodeToInsert)
      end if

   end subroutine Paste

   pure subroutine Delete(dList)

      type(list), intent(inout) :: dList
      deallocate(dList%head)
   end subroutine Delete

   subroutine ReadList(dList, inputFile)
      character(*), intent(in) :: inputFile
      class(list)              :: dList

      integer :: In

      open (file=inputFile, encoding=E_, newunit=In)
        call ReadValue(In, dList%head)
      close (In)
   end subroutine ReadList

   recursive subroutine ReadValue(In, current)
      type(node), allocatable, target :: current
      integer, intent(in)             :: In

      integer, parameter      :: max_len = 1024
      character(max_len, CH_) :: string
      integer                 :: IO
      
      read(In, "(a)", iostat=IO) string
      call Handle_IO_status(IO, "reading value from file")
      if (IO == 0) then
          allocate(current)
          current%string = Trim(string)
         call ReadValue(In, current%next)
      end if
   end subroutine ReadValue
  
   subroutine WriteList(dList, outputFile, writeLetter, writePosition)
      character(*), intent(in) :: outputFile, writeLetter, writePosition
      class(list)              :: dList

      integer  :: Out
      
      open (file=outputFile, encoding=E_, position=writePosition, newunit=Out)
         write (out, '(/a)') writeLetter
         call WriteValue(Out, dList%head)
      close (Out)
   end subroutine WriteList

   recursive subroutine WriteValue(Out, Elem)
      integer, intent(in)     :: Out
      type(node), allocatable :: Elem
      
      integer  :: IO

      if (Allocated(Elem)) then 
         write (Out, '(a)', iostat=IO) Elem%string 
         call Handle_IO_status(IO, "writing list")
         call WriteValue(Out, Elem%next)
      end if
   end subroutine WriteValue 
   
end module mod_list 
