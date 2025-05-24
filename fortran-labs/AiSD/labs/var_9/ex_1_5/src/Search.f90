module SearchesGroup 
   use Environment
   use IOGroup

   implicit none

contains
   
pure recursive function FirstForAlphIndex(surnames, GROUP_COUNT, minindex, i) result(searchIndex)
    character(SURNAME_LEN, kind=CH_), allocatable, intent(in) :: surnames(:)
    integer, intent(in)                          :: minindex, i, GROUP_COUNT
    integer                                      :: searchIndex

    if (i < GROUP_COUNT) then
        if (surnames(minindex) > surnames(i)) then
            searchIndex = FirstForAlphIndex(surnames, GROUP_COUNT, i, i+1)
        else 
            searchIndex = FirstForAlphIndex(surnames, GROUP_COUNT, minindex, i+1)
        end if
    else 
       searchIndex = minindex
    end if


end function FirstForAlphIndex

end module SearchesGroup 
