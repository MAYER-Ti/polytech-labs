TYPE matrix_R
	REAL(R_) :: element(10, 20)
	!REAL(R_), allocatable :: element(:, :)
contains
   ...
END TYPE

TYPE matrix_R2
	REAL(R2_) :: element(10, 20)
contains
   ...
   ! 1.23d
   ! 1.23_R2_
END TYPE

TYPE matrix(kind, m, n)
	INTEGER, KIND :: kind=R_
	INTEGER, LEN :: m, n
	REAL(kind) :: element(m, n)
END TYPE

TYPE(matrix(R2_, 10, 20)) :: a
TYPE(matrix(kind=R2_, m=10, n=20)) :: a, b
TYPE(matrix(m=10, n=20)) :: b

type(real(R_)) :: x(10, 20) ! real(R_) :: x(10, 20)

a%kind, a%m ! = XXX
a%element(10, 20) =

LOGICAL(L_) :: L
WRITE (*,*) L%KIND

TYPE(matrix(R_, :, :)), ALLOCATABLE :: a(:)
TYPE(matrix(R2_, :, :)), ALLOCATABLE :: b

allocate(matrix(R_, 10, 20) :: a(30))
b = type(matrix(kind=R2_, m=10, n=20))

TYPE double_matrix(kind,m,n)
	INTEGER, KIND :: kind
	INTEGER, LEN :: m, n
	TYPE(matrix(kind, m, n)) :: a, b
END TYPE

