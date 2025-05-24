module Source_Process
   use Environment

   implicit none

contains
   subroutine ReadInput(input_file, indexFirst, indexLast, indexPaste)
      character(*), intent(in) :: input_file
      integer, intent(out)     :: indexFirst, indexLast, indexPaste

      integer :: In, IO 

      open (file=input_file, encoding=E_, newunit=In)
         read (In, '(i2, 1x, i2, 1x, i2)', iostat=IO) indexFirst, indexLast, indexPaste
         call Handle_IO_Status(IO, 'reading indexes in file')
      close (In)

   end subroutine ReadInput
end module Source_process
