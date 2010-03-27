      SUBROUTINE DFB(AR2,AR3,JL,NL,KL)
C     VERSION OF 8/11/83
C     SRT TO CALCULATE A SPECIFIED NUMBER OF HORIZONTAL DIFFERENCES      
C     AR2 IS THE ARRAY OF ORDINATES TO BE DIFFERENCED      
C     AR3 IS THE ARRAY IN WHICH TO STORE THE DIFFERENCES   
C     JL IS THE LENGTH OF THE ARRAY AR2      
C     NL IS THE LENGTH OF THE ARRAY AR3      
C     KL IS THE NUMBER OF DIFFERENCES TO CALCULATE  
C     THE PROPER LENGTH FOR THE NL PARAMETER MUST BE SET EXTERNALLY      
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      DIMENSION AR2(JL),AR3(NL)
      IF (KL.LE.JL-1) GO TO 5  
      CALL PMDSTOP      
    5 LS=2
      K=1 
      DO 1 J=LS,JL      
      KV=(K-1)*JL+J     
      AR3(KV)=AR2(J)-AR2(J-1)  
    1 CONTINUE   
      DO 3 K=2,KL
      LS=LS+1    
      DO 2 J=LS,JL      
      KV=(K-1)*JL+J     
      AR3(KV)=AR3(KV-JL)-AR3(KV-JL-1) 
    2 CONTINUE   
    3 CONTINUE   
    4 RETURN     
      END 
