module SearchesGroup 
   use Environment
   use IOGroup

   implicit none

contains
    pure function SearchFirstForAlph(Surnames, GROUP_COUNT) result(searchIndex)
      character(kind=CH_), allocatable, intent(in) :: Surnames(:,:)
      integer, intent(in) :: GROUP_COUNT
 
      integer :: searchIndex, i
      ! i - Номер студента, j - номер символа в фамилии

       searchIndex = 1
       do i = 2, GROUP_COUNT
          if(LBTR(Surnames(:,searchIndex), Surnames(:,i))) then
              searchIndex = i
          end if
       end do
   end function SearchFirstForAlph 

   pure logical function LBTR(arr1, arr2)
       character(kind=CH_), intent(in) :: arr1(:), arr2(:)
 
       integer :: i
 
       do i = 1, Min(Size(arr1), Size(arr2)) - 1
          if (arr1(i) /= arr2(i)) &
             exit
       end do
       LBTR = arr1(i) > arr2(i)
    end function LBTR


    pure function SearchFirstForAlph1(Surnames, GROUP_COUNT) result(searchIndex) 
      character(kind=CH_), allocatable, intent(in) :: Surnames(:,:)
      integer, intent(in)                          :: GROUP_COUNT
 
      integer :: searchIndex, i, j 

      searchIndex = 1
      do i = 2, GROUP_COUNT
         do j = 1, SURNAME_LEN
            ! Если символ одинаковый, то сравнивать следующий
            if (Surnames(j,searchIndex) == Surnames(j,i)) then
                cycle
            end if 
            ! Если символ меньше, то запомнить индекс 
            if (Surnames(j,searchIndex) > Surnames(j,i)) then
               searchIndex = i 
            end if 
            ! Если символы не равны, то в любом случае переходим к след. студенту
            exit
         end do
      end do
 
   end function SearchFirstForAlph1 

   pure function SearchYoungest(Dates) result(searchIndex)
      integer, allocatable, intent(in) :: Dates(:)
 
      integer :: searchIndex  

      searchIndex = MaxLoc(Dates, 1)
      
   end function SearchYoungest

end module SearchesGroup 
