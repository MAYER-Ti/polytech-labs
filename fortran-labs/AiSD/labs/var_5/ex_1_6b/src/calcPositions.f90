module Process 
   use Environment
   use IOEmployee
   implicit none

contains

    pure recursive subroutine RecCalcPos(elemEmpl, ListPosAndCount) 
       type(nodeEmpl), allocatable, intent(inout)     :: elemEmpl
       type(nodePosCount), allocatable, intent(inout) :: ListPosAndCount

       if (Allocated(elemEmpl)) then
          ! Если такой дожности нету, то добавить, если есть, то увеличить кол-во 
          call AddOrPlusPos(elemEmpl, ListPosAndCount)
          ! Следующий узел
          call RecCalcPos(elemEmpl%next, ListPosAndCount) 
       end if
    end subroutine RecCalcPos

    pure recursive subroutine AddOrPlusPos(elemEmpl, elemPosAndCount)
       type(nodeEmpl), allocatable, intent(inout)     :: elemEmpl
       type(nodePosCount), allocatable, intent(inout) :: elemPosAndCount

       if(Allocated(elemPosAndCount)) then
          ! Если такая должность уже встречалась
          if(elemEmpl%pos == elemPosAndCount%pos) then
              elemPosAndCount%counts = elemPosAndCount%counts + 1
          else 
              ! Если должность не та, то сравнить следующую
              call AddOrPlusPos(elemEmpl, elemPosAndCount%next)
          end if
       else
           ! Если должность не нашли, то добавить
           allocate(elemPosAndCount)
           elemPosAndCount%pos    = elemEmpl%pos
           elemPosAndCount%counts = 1
       end if
    end subroutine AddOrPlusPos

end module Process 
