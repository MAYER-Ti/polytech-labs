TYPE, ABSTRACT :: FILE_HANDLE
CONTAINS
	PROCEDURE (OPEN_FILE), DEFERRED, PASS :: OPEN
	...
END TYPE
ABSTRACT INTERFACE
	SUBROUTINE OPEN_FILE(HANDLE)
		CLASS(FILE_HANDLE), INTENT(INOUT) :: HANDLE
	END SUBROUTINE OPEN_FILE
END INTERFACE

type, extends(FILE_HANDLE) :: vfs_handle
CONTAINS
	PROCEDURE, PASS :: OPEN
end type vfs_handle

procedure Open(Handle)
	class(FILE_HANDLE), intent(inout) :: Handle
	! type(vfs_handle), intent(inout) :: Handle
	...
end procedure Open

type(vfs_handle) :: vfs_h

vfs_h%Open