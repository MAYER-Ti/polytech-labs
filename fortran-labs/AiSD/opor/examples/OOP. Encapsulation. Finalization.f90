MODULE mobject
  TYPE :: tobject
    ! Data declarations
  CONTAINS
    FINAL :: finalize
  END TYPE
CONTAINS
  SUBROUTINE finalize(object)
    TYPE(tobject) object
    ...
  END SUBROUTINE
END MODULE