module Process 
   use Environment
   use IOEmployee
   implicit none

contains

    pure recursive subroutine RecCalcPos(elemEmpl, ListPosAndCount) 
       type(nodeEmpl), pointer, intent(inout)     :: elemEmpl
       type(nodePosCount), pointer, intent(inout) :: ListPosAndCount

       if (Associated(elemEmpl)) then
          ! Если такой дожности нету, то добавить, если есть, то увеличить кол-во 
          call AddOrPlusPos(elemEmpl, ListPosAndCount)
          ! Следующий узел
          call RecCalcPos(elemEmpl%next, ListPosAndCount) 
       end if
    end subroutine RecCalcPos

    pure recursive subroutine AddOrPlusPos(elemEmpl, elemPosAndCount)
       type(nodeEmpl), pointer, intent(inout)     :: elemEmpl
       type(nodePosCount), pointer, intent(inout) :: elemPosAndCount

       if(Associated(elemPosAndCount)) then
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
