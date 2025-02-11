TYPE matrix(kind, m, n)
	INTEGER, KIND :: kind
	INTEGER, LEN :: m, n
	REAL(kind) :: element(m, n)
CONTAINS
	GENERIC :: OPERATOR(+) => plus1, plus2, plus3
	GENERIC :: ASSIGNMENT(=) => assign1, assign2
END TYPE

TYPE(matrix(KIND(0.0D0), m=10, n=20))) :: a, b, c

a = b + c 