      SUBROUTINE ROTDIST(I,AVL,QVL,VLAMV,SV,ERP)
C
C     THIS SRT CALCULATES RADIAL DISTANCES OF POINTS ON THE PHOTOSPHERE
C     FROM THE CENTER OF A NON-SYNCHRONOUSLY ROTATING COMPONENT.
C     THE ROTATION PARAMETER IS STORED IN FV(I), DEFINED AS THE RATIO
C     OF THE (UNIFORM) ROTATION RATE TO THE RATE OF SYNCHRONOUS 
C     ROTATION.
C     THE CALLING PROGRAM HAS ALREADY DETERMINED RADII FOR THE 
C     SYNCHRONOUS CASE. THIS HAS PROVIDED A VALUE FOR THE POLAR RADIUS.
C     THIS SRT ASSUMES TIDAL DISTORTION, ALREADY CALCULATED, ADDS IN
C     ARITHMETIC SUM TO THE ROTATIONAL DISTORTION FROM NON-SYNCHRONOUS
C     ROTATION.     
C     DIRECTION COSINES OF THE LINE MUST BE STORED IN ADVANCE IN  
C     ARRAYS ALM,AMU,ANU
C     THE PARAMETER I DESIGNATES THE COMPONENT IN QUESTION AND K  
C     SEQUENTIALLY NUMBERS POINTS ON THE SURFACE OF THAT COMPONENT
C     THE DETERMINED DISTANCE IS RETURNED VIA THE VR ARRAY 
C     L DESIGNATES THE THETA VALUE    
C     THE ERROR LIMIT IS IN ERP 
      INCLUDE 'COMA.FOR'
      INCLUDE 'COMM.FOR'
C      DIMENSION ERRV(MFV)
      ICT=0
C     If it is an overcontact system, return immediately.
      IF (ALMX(I).LT.1.D0) GO TO 2
C     The radius must be larger than the following RSV.
      RSV=VR(I,1,1)
	R1=RSV
	IF (AVL.LT.1.D-11) THEN
	R2=RSV
	GO TO 2
	END IF
	CALL ROTFN(I,AVL,R1,QVL,VLAMV,ER1)
	IF (ER1.LT.0.D0) CALL PMDSTOP
	DLR=0.1D0*RSV
    1 R2=R1+DLR
    4 CALL ROTFN(I,AVL,R2,QVL,VLAMV,ER2)
      DER=ER2-ER1
	IF (DABS(ER2).LT.ERP) GO TO 2
C     
      IF ((ER2.GT.0.D0).AND.(ER1.GT.0.D0)) THEN
		IF (DER.LT.0.D0) THEN
			ICT=ICT+1
			R1=R2
			ER1=ER2
			IF (ICT.LT.500) GO TO 1
			CALL PMDSTOP
		END IF
		IF (DER.GT.0.D0) THEN
    5			R1=R1-DLR
			R2=R2-DLR
			CALL ROTFN(I,AVL,R1,QVL,VLAMV,ER1)
			CALL ROTFN(I,AVL,R2,QVL,VLAMV,ER2)
			DER=ER2-ER1
			IF ((ER1.GT.0.D0).AND.(ER2.GT.0.D0)) THEN
				IF (DER.LT.0.D0) THEN
					DLR=DLR/2.D0
					ICT=ICT+1
					IF (ICT.LT.500) GO TO 1
					CALL PMDSTOP
				END IF
			END IF
		END IF
	END IF
C   
      IF ((ER2.LT.0.D0).AND.(ER1.GT.0.D0)) THEN
		IF (DER.LT.0.D0) THEN
			ICT=ICT+1
			R2=R2-DLR
			DLR=DLR/2.D0
			IF (ICT.LT.500) GO TO 1
			CALL PMDSTOP
		END IF
	END IF
	IF (ER2.EQ.0.D0) THEN
		SV=R2
		RETURN
	END IF
    2	SV=R2
      IF (DER.EQ.0.D0) CALL PMDSTOP
      RETURN
      END
