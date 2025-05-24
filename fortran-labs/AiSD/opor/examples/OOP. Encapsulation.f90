TYPE T
   private
	...
CONTAINS
   PROCEDURE :: proc => my_proc
   PROCEDURE :: proc2
   GENERIC :: gen => proc3, proc4, proc5
END TYPE T

type(T) a

CALL a%proc(x, y)

call a%gen(x, y, z) ! proc3
call a%gen(x, y) ! proc4
call a%gen(x) ! proc5
call a%gen() ! XXX