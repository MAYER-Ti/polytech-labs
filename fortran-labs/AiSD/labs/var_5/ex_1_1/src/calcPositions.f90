module calcPositions 
   use Environment
   use globalVars
   implicit none

contains
   pure subroutine CalcPos(positions, positionsSize, outPos, outCount)
      character(BLOCK_LEN, kind=CH_), allocatable, intent(in)    :: positions(:)
      integer, allocatable, intent(out)                          :: outCount(:)
      character(BLOCK_LEN, kind=CH_), allocatable, intent(inout) :: outPos(:)
      integer, intent(in)                                        :: positionsSize
      integer :: countPositions   
      logical :: matched(positionsSize), locPosition(positionsSize)
      integer :: i, posAndCount(positionsSize, 2)
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
             locPosition(i+1:positionsSize) = positions(i+1:positionsSize) == positions(i)
             ! Записать количество одинаковых должностей 
             posAndCount(countPositions, 1) = i ! Позиция с должностью 
             posAndCount(countPositions, 2) = Count(locPosition) ! Кол-во сотрудников с этой должностью
             ! Обновить массив совпадений для следующих итераций цикла
             matched(i:positionsSize) = matched(i:positionsSize) .or. locPosition(i:positionsSize)
             locPosition = .false.
         end if
      end do
      allocate(outPos(countPositions), outCount(countPositions))
      outPos(:)   = positions(posAndCount(:countPositions, 1))
      outCount(:) = posAndCount(:countPositions, 2) 
   end subroutine CalcPos 
end module calcPositions 
