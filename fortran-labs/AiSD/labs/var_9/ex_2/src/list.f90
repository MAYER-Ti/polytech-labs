module mod_list
   use Environment

   implicit none
   private

   ! Структура данных для хранения строки исходного текста.
   type, public :: node 
      character(:, CH_), allocatable :: string
      type(node), allocatable        :: next
   end type node 

   type, public :: list 
      type(node), allocatable :: head
      contains
          procedure, public :: ReadCode
          procedure, public :: WriteCode
          procedure, public :: CopyPastePartList
   end type list

contains

    pure subroutine CopyPastePartList(SourceCode, i_F, i_L, i_P)
      integer, intent(in)        :: i_F, i_L
      integer, intent(inout)     :: i_P
      class(list), intent(inout) :: SourceCode 

      type(list) :: ListDiap
      
      ! Копировать диапазон
      call CopyPartInList(SourceCode%head, ListDiap%head, i_F, i_L, 0)
      ! Вставить диапазон
      call PastePartInList(SourceCode%head, ListDiap%head, i_P, 0)
   end subroutine CopyPastePartList

   pure recursive subroutine PastePartInList(curNode, diapHead, i_P, i) 
      type(node), allocatable, intent(inout) :: curNode, diapHead
      integer, intent(in)                    :: i_P, i

      type(node), allocatable :: tmp

      if(Allocated(curNode)) then 
         if(i == i_P) then 
            call move_alloc(curNode, tmp)
            call move_alloc(diapHead, curNode)
            call AppendLastPart(curNode, tmp)
         else 
            call PastePartInList(curNode%next, diapHead, i_P, i+1)
         end if
      end if 
   end subroutine PastePartInList

   pure recursive subroutine AppendLastPart(curNode, nodeToAppend) 
      type(node), allocatable, intent(inout) :: curNode, nodeToAppend

      if(Allocated(curNode)) then 
         call AppendLastPart(curNode%next, nodeToAppend)
      else
         call move_alloc(nodeToAppend, curNode)
      end if

   end subroutine AppendLastPart

   pure recursive subroutine CopyPartInList(curNode, diapNode, i_F, i_L, i)
      type(node), allocatable, intent(inout) :: curNode, diapNode
      integer, intent(in)       :: i_F, i_L, i

      !type(node), allocatable :: tmp
      if(Allocated(curNode) .and. i <= i_L) then 
         ! Находимся внутри диапазона
         if(i >= i_F) then
            allocate(diapNode)
            diapNode%string = curNode%string
            call CopyPartInList(curNode%next, diapNode%next, i_F, i_L, i+1)
         else 
            call CopyPartInList(curNode%next, diapNode, i_F, i_L, i+1)
         end if
      end if
   end subroutine CopyPartInList

   ! Чтение исходного кода. 
   subroutine ReadCode(Code, InputFile)
      character(*), intent(in)  :: InputFile
      class(list), intent(inout) :: Code

      integer    :: In
      
      open (file=InputFile, encoding=E_, newunit=In)
         call ReadSourceLine(in, Code%head)
      close (In)
   end subroutine ReadCode

   ! Чтение строки исходного кода.
   recursive subroutine ReadSourceLine(in, line)
      type(node), allocatable, intent(inout) :: line
      integer, intent(in)                    :: In

      integer, parameter      :: max_len = 1024
      character(max_len, CH_) :: string
      integer                 :: IO

      ! Чтение строки во временную строку бОльшей длины.
      read (In, "(a)", iostat=IO) string
      call Handle_IO_Status(IO, "reading line from source code")
      if (IO == 0) then
         allocate (line)
         ! Хранение в размещаемом поле символов без завершающих пробелов.
         line%String = Trim(string)
         call ReadSourceLine(In, line%Next)
      end if
   end subroutine ReadSourceLine
 
   ! Вывод исходного кода.
   subroutine WriteCode(Code, outputFile, writePosition, writeLetter)
      character(*), intent(in) :: outputFile, writePosition, writeLetter 
      class(list), intent(in)   :: Code 

      integer  :: Out
      
      open (file=outputFile, encoding=E_, position=writePosition, newunit=Out)
         write (Out, '(/,a)') writeLetter 
         call WriteLine(Out, Code%head)
      close (Out)

   end subroutine WriteCode

   ! Вывод строки исходного кода.
   recursive subroutine WriteLine(Out, line)
      integer, intent(in)                 :: Out
      type(node), allocatable, intent(in) :: line

      integer  :: IO

      write (Out, "(a)", iostat=IO) line%String
      call Handle_IO_Status(IO, "writing line to file")
      if (Allocated(line%next)) &
         call WriteLine(Out, line%next)

   end subroutine WriteLine


end module mod_list 
