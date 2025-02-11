program prog
integer, pointer :: p3, p2 => Null()

if (associated(p2)) &
    write (*, *) p2 ! недопустимо

allocate(p3)

! ...

deallocate(p3)
if (associated(p3)) &
    write (*, *) "размещена"
! без deallocate утечка памяти (memory leak)!
! не нужно занулять после deallocate:
p3 => Null() 

end