module calcPositions 
   use Environment
   use IOEmployee
   implicit none

contains
    pure subroutine SearchPositions(positions, EMPLOYEE_COUNT, Res)
        character(BLOCK_LEN,kind=CH_), allocatable, intent(in) :: positions(:)
        type(ResPosAndCount), intent(out)         :: Res
        integer, intent(in)                        :: EMPLOYEE_COUNT

        integer :: i, OutCountAndPos(2, EMPLOYEE_COUNT), sizeCountAndPos
        logical :: matched(EMPLOYEE_COUNT), locPosition(EMPLOYEE_COUNT)
        
        sizeCountAndPos = 0
        matched         = .false.
        locPosition     = .false.
        ! Рекурсивный подсчет должностей
        call RecCalcPos(positions, EMPLOYEE_COUNT, OutCountAndPos, sizeCountAndPos, matched, locPosition, 1)     
        ! Запись полученных данных 
        allocate(Res%pos(sizeCountAndPos), Res%counts(sizeCountAndPos))
        Res%sizePos = sizeCountAndPos
        !do i = 1, Res%sizePos 
           Res%pos(:)    = positions(OutCountAndPos(1,:sizeCountAndPos))
           Res%counts(:) = OutCountAndPos(2,:sizeCountAndPos)
        !end do

    end subroutine SearchPositions   

    pure recursive subroutine RecCalcPos(positions, EMPLOYEE_COUNT, OutCountAndPos, sizeCountAndPos, matched, locPosition, i) 
       character(BLOCK_LEN,kind=CH_), allocatable, intent(in) :: positions(:)
       integer, intent(in)    :: i, EMPLOYEE_COUNT 
       integer, intent(inout) :: OutCountAndPos(2, EMPLOYEE_COUNT), sizeCountAndPos
       logical, intent(inout) :: matched(EMPLOYEE_COUNT), locPosition(EMPLOYEE_COUNT)
       
       if (.not. matched(i)) then
          ! Посчитать новую должность
          sizeCountAndPos = sizeCountAndPos + 1
          ! Совпадает сама с собой 
          locPosition(i) = .true.
          ! Создание маски 
          locPosition(i+1:EMPLOYEE_COUNT) = positions(i+1:EMPLOYEE_COUNT) == positions(i)
          ! Записать количество одинаковых должностей 
          OutCountAndPos(1, sizeCountAndPos) = i ! Позиция с должностью 
          OutCountAndPos(2, sizeCountAndPos) = Count(locPosition) ! Кол-во сотрудников с этой должностью
          ! Обновить массив совпадений для следующих итераций цикла
          matched(i:) = matched(i:) .or. locPosition(i:)
          locPosition = .false.
       end if 
       if(i < EMPLOYEE_COUNT) then
          call RecCalcPos(positions, EMPLOYEE_COUNT, OutCountAndPos, sizeCountAndPos, matched, locPosition, i + 1)
       end if
    end subroutine RecCalcPos

    pure subroutine CalcPos(empls, EMPLOYEE_COUNT, outPos, outCount)
        type(employees), intent(in)                              :: empls
        character(BLOCK_LEN, kind=CH_), allocatable, intent(out) :: outPos(:) 
        integer, allocatable, intent(out)                        :: outCount(:)
        integer, intent(inout)                                   :: EMPLOYEE_COUNT   
        
        integer :: countPositions
        logical :: matched(EMPLOYEE_COUNT), locPosition(EMPLOYEE_COUNT)
        integer :: i, posAndCount(2, EMPLOYEE_COUNT)

        countPositions = 0 
        matched = .false.
        locPosition = .false.
        do i = 1,EMPLOYEE_COUNT
           ! Когда должность еще не обрабатывалась
           if (.not. matched(i)) then
               ! Посчитать новую должность
               countPositions = countPositions + 1
               ! Совпадает сама с собой 
               locPosition(i) = .true.
               ! Создание маски 
               locPosition(i+1:EMPLOYEE_COUNT) = empls%pos(i+1:EMPLOYEE_COUNT) == empls%pos(i)
               ! Записать количество одинаковых должностей 
               posAndCount(1, countPositions) = i ! Позиция с должностью 
               posAndCount(2, countPositions) = Count(locPosition) ! Кол-во сотрудников с этой должностью
               ! Обновить массив совпадений для следующих итераций цикла
               matched(i:EMPLOYEE_COUNT) = matched(i:EMPLOYEE_COUNT) .or. locPosition(i:EMPLOYEE_COUNT)
               locPosition = .false.
           end if
        end do
        ! Запись данных в массивы
        allocate(outPos(countPositions), outCount(countPositions))
        do i = 1, countPositions
          outPos(i) = empls%pos(posAndCount(1, i))
          outCount(i) = posAndCount(2, i) 
        end do
   end subroutine CalcPos 


end module calcPositions 
