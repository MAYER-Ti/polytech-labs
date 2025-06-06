C     ����CTP�P���A� �PO�PAMMA ��� RKF45
C
      SUBROUTINE ORBIT(T,Y,YP)
      REAL T,Y(4),YP(4),R,ALFASQ
      COMMON ALFASQ
      R=Y(1)*Y(1)+Y(2)*Y(2)
      R=R*SQRT(R)/ALFASQ
      YP(1)=Y(3)
      YP(2)=Y(4)
      YP(3)=-Y(1)/R
      YP(4)=-Y(2)/R
      RETURN
      END
C
      EXTERNAL ORBIT
      REAL T,Y(4),TOUT,RELERR,ABSERR,
     *     TFINAL,TPRINT,ECC,ALFA,ALFASQ,WORK(27)
      INTEGER IWORK(5),IFLAG,NEQN
      COMMON ALFASQ
      ECC=0.25
      ALFA=3.1415927/4.0
      ALFASQ=ALFA*ALFA
      NEQN=4
      T=0.0
      Y(1)=1.0-ECC
      Y(2)=0.0
      Y(3)=0.0
      Y(4)=ALFA*SQRT((1.0+ECC)/(1.0-ECC))
      RELERR=0.1E-06
      ABSERR=0.0
      TFINAL=12.0
      TPRINT=0.5
      IFLAG=1
      TOUT=T
   10 CALL RKF45(ORBIT,NEQN,Y,T,TOUT,RELERR,ABSERR,
     *           IFLAG,WORK,IWORK)
      PRINT 11,T,Y(1),Y(2)
      GO TO (80,20,30,40,50,60,70,80),IFLAG
   20 TOUT=TPRINT+T
      IF(T.LT.TFINAL) GO TO 10
      STOP
   30 PRINT 31,RELERR,ABSERR
      GO TO 10
   40 PRINT 41
      GO TO 10
   50 ABSERR=0.1E-07
      PRINT 31,RELERR,ABSERR
      GO TO 10
   60 RELERR=RELERR*10.0
      PRINT 31,RELERR,ABSERR
      IFLAG=2
      GO TO 10
   70 PRINT 71
      IFLAG=2
      GO TO 10
   80 PRINT 81
      STOP
   11 FORMAT(' T=',F5.1,2X,'Y1=',F10.6,2X,'Y2=',F10.6)
   31 FORMAT(' �PAH��� �O�PE�HOCTE� ��MEHEH�  '/
     *' RELERR=',E10.3,2X,'ABSERR=',E10.3)
   41 FORMAT(' MHO�O �A�OB ')
   71 FORMAT(' MHO�O B�XO�OB ')
   81 FORMAT(' HE�PAB���H�� B��OB ')
      END
