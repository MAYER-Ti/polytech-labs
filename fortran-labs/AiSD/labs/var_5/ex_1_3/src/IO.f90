module IOEmployee 
   use Environment
   use globalVars
   implicit none


   integer, parameter :: BLOCK_LEN = 15

   type employee
       character(BLOCK_LEN, kind=CH_) :: sur  = ""
       character(BLOCK_LEN, kind=CH_) :: pos = ""
   end type employee


contains
   subroutine CreateDataFile(input_file, data_file, EMPLOYEE_COUNT)
       character(*), intent(in) :: input_file, data_file
       integer, intent(inout)   :: EMPLOYEE_COUNT

       type(employee)            :: empl
       integer                   :: In, Out, IO, i, sizeOfOneEmployee 
       character(:), allocatable :: format

       open (file=input_file, encoding=E_, newunit=In)
       sizeOfOneEmployee = (BLOCK_LEN*2+1)*CH_ 
       open (file=data_file, form='unformatted', newunit=Out, access='direct', recl=sizeOfOneEmployee)
          read (In, '(i15)') EMPLOYEE_COUNT
          format = '(a, 1x, a)'
          do i = 1, EMPLOYEE_COUNT
             ! Чтение из входного файла
             read (In, format, iostat=IO) empl
             call Handle_IO_status(IO, "Ошибка чтения данных из входного файла")
             ! Запись в бинарный файл
             write (Out, iostat=IO, rec=i) empl
             call Handle_IO_status(IO, "Запись в бинарный файл некорректна!, строка - "//i)
          end do
       close (Out)
       close (In)
   end subroutine CreateDataFile

   subroutine ReadEmployees(data_file, employees, EMPLOYEE_COUNT) 
      character(*)                :: data_file 
      type(employee), allocatable :: employees(:)
      integer, intent(in)         :: EMPLOYEE_COUNT
      
      integer :: i, In, IO, sizeOfOneEmployee 
      
      allocate(employees(EMPLOYEE_COUNT))
      sizeOfOneEmployee = (BLOCK_LEN*2+1)*CH_ 
      open (file=data_file, form='unformatted', newunit=In, access='direct', recl=sizeOfOneEmployee)
      do i = 1, EMPLOYEE_COUNT
         read (In, iostat=IO, rec=i) employees(i) 
         call Handle_IO_status(IO, "Чтение из бинарного файла некорректно")
      end do
      close (In)
   end subroutine ReadEmployees 
   
   subroutine WriteEmployee(output_file, employees, writeFilePostion, writeLetter)
      character(*), intent(in)   :: output_file, writeFilePostion, writeLetter
      type(employee), allocatable, intent(in) :: employees(:)  

      integer                    :: Out = 0, IO = 0
      character(:), allocatable  :: format

      open (file=output_file, encoding=E_,position=writeFilePostion, newunit=Out)
         format = '(a, 1x, a1)'
         write(Out, '(/,a)') writeLetter
         write(Out, format, iostat=IO) employees 
         call Handle_IO_status(IO, "Некорректный вывод сотрудников")
      close (Out)
    end subroutine WriteEmployee

   subroutine WriteCountPositions(output_file, pos, counts, writeFilePostion, writeLetter)
      character(*), intent(in)                               :: output_file, writeFilePostion, writeLetter
      character(BLOCK_LEN,kind=CH_), allocatable, intent(in) :: pos(:)      
      integer, allocatable                                   :: counts(:)

      integer                                                :: countPositions
      integer                   :: i = 0, Out = 0, IO = 0
      character(:), allocatable :: format

      countPositions = Ubound(pos, 1)

      open (file=output_file, encoding=E_, position=writeFilePostion, newunit=Out)
            write (Out, '(a)') writeLetter
            format = '('//countPositions//'(a, 1x, i7,/))'
            write (Out, format, iostat=IO) (pos(i), counts(i), i = 1, countPositions) 
            call Handle_IO_status(IO, "write employee positions")
      close (Out)     

   end subroutine WriteCountPositions

end module IOEmployee 
