C     ����CTP�P���A� �PO�PAMMA ��� DECOMP
C     B �P�MEPE ��ETC� PA��O�EH�E MATP��� A
C     � O�EH�BAETC� EE O��C�OB�EHHOCT�
C
      INTEGER NDIM/3/,N/3/,IPVT(3)
      REAL A(3,3),WORK(3),COND
      DATA A/10.,-3., 5.,
     *       -7., 2.,-1.,
     *        0., 6., 5./
C
      PRINT 101,((A(I,J),J=1,N),I=1,N)
C
      CALL DECOMP(NDIM,N,A,COND,IPVT,WORK)
C
      PRINT 102,COND
      CONDP1=COND+1.0
      IF(CONDP1.EQ.COND) PRINT 103
      IF(CONDP1.EQ.COND) STOP
C
      STOP
  101 FORMAT(13X,'A',3(/5X,3F5.0))
  102 FORMAT(5X,'COND=',E12.5)
  103 FORMAT(5X,'MATP��A K�ACC�����P�ETC� KAK B�PO��EHHA�')
      END
