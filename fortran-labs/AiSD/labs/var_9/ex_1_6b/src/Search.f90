module SearchesGroup 
   use Environment
   use IOGroup

   implicit none

contains

   pure recursive subroutine FirstForAlph(searchStud, stud, firstStud)
      type(student), pointer, intent(inout)             :: searchStud
      type(student), allocatable, target, intent(inout) :: stud, firstStud
      
      if(Allocated(stud)) then
         if(stud%sur < firstStud%sur) then
            call FirstForAlph(searchStud, stud%next, stud)
         else 
            call FirstForAlph(searchStud, stud%next, firstStud)
         end if
     else
         searchStud => firstStud
      end if
   end subroutine FirstForAlph 

   pure recursive subroutine Youngest(searchStud, stud, youngestStud)
      type(student), pointer, intent(inout)             :: searchStud
      type(student), allocatable, target, intent(inout) :: stud, youngestStud
      
      if(Allocated(stud)) then
         if(stud%date > youngestStud%date) then
            call Youngest(searchStud, stud%next, stud)
        else
            call Youngest(searchStud, stud%next, youngestStud)
         end if
     else
         searchStud => youngestStud
      end if
   end subroutine Youngest 

end module SearchesGroup 
