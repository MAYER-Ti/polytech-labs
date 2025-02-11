module IOEmployee 
   use Environment
   use globalVars
   implicit none


   integer, parameter :: BLOCK_LEN = 15

   type employees
       character(BLOCK_LEN, kind=CH_), allocatable :: sur(:)
       character(BLOCK_LEN, kind=CH_), allocatable :: pos(:)
   end type employees


contains
   subroutine CreateDataFile(input_file, data_file, EMPLOYEE_COUNT)
       character(*), intent(in) :: input_file, data_file
       integer, intent(inout)   :: EMPLOYEE_COUNT

       type(employees)           :: empl
       integer                   :: In, Out, IO, i, sizeOfOneEmployee 
       character(:), allocatable :: format

       open (file=input_file, encoding=E_, newunit=In)
       sizeOfOneEmployee = (BLOCK_LEN*2+1)*CH_ 
       open (file=data_file, form='unformatted', newunit=Out, access='direct', recl=sizeOfOneEmployee)
          read(In, '(i7)') EMPLOYEE_COUNT
          allocate(empl%sur(EMPLOYEE_COUNT), empl%pos(EMPLOYEE_COUNT))
          format = '(a, 1x, a)'
          do i = 1, EMPLOYEE_COUNT
             ! Чтение из входного файла
             read (In, format, iostat=IO) empl%sur(i), empl%pos(i)
             call Handle_IO_status(IO, "Ошибка чтения данных из входного файла")
             ! Запись в бинарный файл
             write (Out, iostat=IO, rec=i) empl%sur(i), empl%pos(i)
             call Handle_IO_status(IO, "Запись в бинарный файл некорректна!, строка - "//i)
          end do
       close (Out)
       close (In)
   end subroutine CreateDataFile

   function ReadEmployees(data_file, EMPLOYEE_COUNT) result(empls) 
      character(*)     :: data_file 
      type(employees)  :: empls
      integer          :: EMPLOYEE_COUNT
      
      integer :: i, In, IO, sizeOfOneEmployee 
      
      sizeOfOneEmployee = (BLOCK_LEN*2+1)*CH_ 
      allocate(empls%sur(EMPLOYEE_COUNT), empls%pos(EMPLOYEE_COUNT))
      open (file=data_file, form='unformatted', newunit=In, access='direct', recl=sizeOfOneEmployee)
      do i = 1, EMPLOYEE_COUNT
         read (In, iostat=IO, rec=i) empls%sur(i), empls%pos(i) 
         call Handle_IO_status(IO, "Чтение из бинарного файла некорректно")
      end do
      close (In)
   end function ReadEmployees 
   
   subroutine WriteEmployee(output_file, empls, writeFilePostion, writeLetter)
      character(*), intent(in)   :: output_file, writeFilePostion, writeLetter
      type(employees), intent(in) :: empls  

      integer                    :: Out = 0, i = 0, IO = 0
      character(:), allocatable  :: format

      open (file=output_file, encoding=E_,position=writeFilePostion, newunit=Out)
         format = '(a, 1x, a1)'
         write(Out, '(/,a)') writeLetter
         write(Out, format, iostat=IO) (empls%sur(i), empls%pos(i), i=1, Ubound(empls%pos, 1)) 
         call Handle_IO_status(IO, "Некорректный вывод сотрудников")
      close (Out)
    end subroutine WriteEmployee

   subroutine WriteCountPositions(output_file, pos, counts, writeFilePostion, writeLetter)
      character(*), intent(in)                               :: output_file, writeFilePostion, writeLetter
      character(BLOCK_LEN,kind=CH_), allocatable, intent(in) :: pos(:)      
      integer, allocatable                                   :: counts(:)

      integer                   :: i = 0, Out = 0, IO = 0
      character(:), allocatable :: format

      open (file=output_file, encoding=E_, position=writeFilePostion, newunit=Out)
            write (Out, '(a)') writeLetter
            format = '('//Ubound(pos,1)//'(a, 1x, i7,/))'
            write (Out, format, iostat=IO) (pos(i), counts(i), i = 1, Ubound(pos, 1)) 
            call Handle_IO_status(IO, "write employee positions")
      close (Out)     

   end subroutine WriteCountPositions

end module IOEmployee 
