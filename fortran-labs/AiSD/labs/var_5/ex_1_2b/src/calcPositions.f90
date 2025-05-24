module calcPositions 
   use Environment
   use globalVars
   implicit none

contains
    pure subroutine CalcPos(positions, positionsSize, outPos, outCount)
        character(kind=CH_), allocatable, intent(in)  :: positions(:,:)
        character(kind=CH_), allocatable, intent(out) :: outPos(:,:) 
        integer, allocatable, intent(out)             :: outCount(:)
        integer, intent(in)                           :: positionsSize  
        integer :: countPositions
        logical :: matched(positionsSize), locPosition(positionsSize)
        integer :: i, j, posAndCount(2, positionsSize)
        countPositions = 0 
        matched = .false.
        locPosition = .false.
        do i = 1, positionsSize
           ! Когда должность еще не обрабатывалась
           if (.not. matched(i)) then
               ! Посчитать новую должность
               countPositions = countPositions + 1
               ! Совпадает сама с собой 
               locPosition(i) = .true.
               ! Создание маски 
               do concurrent (j = i+1:positionsSize)
                  locPosition(j) = ALL(positions(:,j) == positions(:,i))
               end do
               !Трудности при замене на сечение!
               !locPosition(i+1:EMPLOYEE_COUNT) = positions(:,i+1:EMPLOYEE_COUNT) == positions(:,i)
               ! Записать количество одинаковых должностей 
               posAndCount(1, countPositions) = i ! Позиция с должностью 
               posAndCount(2, countPositions) = Count(locPosition) ! Кол-во сотрудников с этой должностью
               ! Обновить массив совпадений для следующих итераций цикла
               matched(i:positionsSize) = matched(i:positionsSize) .or. locPosition(i:positionsSize)
               locPosition = .false.
           end if
        end do
        ! Запись данных в массивы
        allocate(outPos(BLOCK_LEN, countPositions), outCount(countPositions))
        !do i = 1, countPositions
          outPos(:,:) = positions(:, posAndCount(1, :countPositions))
          outCount(:) = posAndCount(2, :countPositions) 
        !end do
   end subroutine CalcPos 


end module calcPositions 
