--�� ���� ���̺� ���ν��� 

CREATE OR REPLACE PROCEDURE TBL_PROF_INSERT
( V_PROF_ID     IN TBL_PROF.PROF_ID%TYPE
, V_PROF_NAME IN TBL_PROF.PROF_NAME%TYPE
, V_PROF_SSN  IN TBL_PROF.PROF_SSN%TYPE
)
IS
    USER_DEFINE_ERROR EXCEPTION;
BEGIN
    IF  REGEXP_LIKE(V_PROF_SSN, '[^[:digit:]]')
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    
    INSERT INTO TBL_PROF(PROF_ID, PROF_NAME, PROF_PW, PROF_SSN)
    VALUES(V_PROF_ID, V_PROF_NAME, V_PROF_SSN ,V_PROF_SSN);
    COMMIT; 
    
    EXCEPTION
    WHEN USER_DEFINE_ERROR
    THEN RAISE_APPLICATION_ERROR(-20001, '�ֹι�ȣ ����');   
END;
--==>> Procedure TBL_PROF_INSERT��(��) �����ϵǾ����ϴ�.
/*

*/
--=====================================================================================================
--�� �л� ID ���� �Լ�,���ν��� ����
--�Լ�
CREATE OR REPLACE FUNCTION FN_GENERATE_STU_ID
RETURN VARCHAR2
IS
  V_STU_ID TBL_STU.STU_ID%TYPE;
  V_YEAR NUMBER;
BEGIN
  
   SELECT NVL(MAX(STU_ID), TO_CHAR(SYSDATE,'YYYY')||'0000') INTO V_STU_ID
   FROM TBL_STU;
   
   
   V_YEAR := TO_NUMBER(SUBSTR(V_STU_ID,1,4));
   
  IF (EXTRACT(YEAR FROM SYSDATE) != V_YEAR)
    THEN V_STU_ID := TO_CHAR(SYSDATE,'YYYY')||'0001';
  ELSE 
    V_STU_ID := TO_CHAR(TO_NUMBER(V_STU_ID) +1);
  END IF;
  
  RETURN V_STU_ID;

END;
--==>> Function FN_GENERATE_STU_ID��(��) �����ϵǾ����ϴ�.
--===========================================================================

-- �л� �����Է� ���ν���
CREATE OR REPLACE PROCEDURE TBL_STU_INSERT
( V_STU_NAME IN TBL_STU.STU_NAME%TYPE
, V_STU_SSN  IN TBL_STU.STU_SSN%TYPE
)
IS
    USER_DEFINE_ERROR EXCEPTION;
BEGIN
    IF  REGEXP_LIKE(V_STU_SSN, '[^[:digit:]]')
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    
    INSERT INTO TBL_STU(STU_ID, STU_NAME, STU_PW, STU_SSN)
    VALUES(FN_GENERATE_STU_ID(), V_STU_NAME, V_STU_SSN ,V_STU_SSN);
    COMMIT; 
    
    EXCEPTION
    WHEN USER_DEFINE_ERROR
    THEN RAISE_APPLICATION_ERROR(-20001, '�ֹι�ȣ ����');   
END;
--==>> Procedure TBL_STU_INSERT��(��) �����ϵǾ����ϴ�.

--=======================================================================

-- �н����� ����(SQL������ ó��)

CREATE OR REPLACE PROCEDURE TBL_STU_CHANGE_PW
( V_ID IN TBL_STU.STU_ID%TYPE 
, V_PW IN TBL_STU.STU_PW%TYPE 
)
IS
BEGIN

 UPDATE TBL_STU 
 SET STU_PW = V_PW
 WHERE STU_ID = V_ID;
COMMIT;
END;
--==>> Procedure TBL_STU_CHANGE_PW(��) �����ϵǾ����ϴ�.

--=====================================================================================================
--�� ���� ��� ���ν���

CREATE OR REPLACE PROCEDURE TBL_COU_INSERT
( V_COU_NAME   IN TBL_COU.COU_NAME%TYPE
)
IS
    V_NUM NUMBER;
    USER_DEFINE_ERROR EXCEPTION;
BEGIN

        SELECT COUNT(*) INTO V_NUM
        FROM TBL_COU
        WHERE COU_NAME = V_COU_NAME;
       
        IF(V_NUM != 0)
            THEN  RAISE USER_DEFINE_ERROR;
        END IF;
        
        INSERT INTO TBL_COU(COU_CODE, COU_NAME) VALUES (SEQ_COU.NEXTVAL, V_COU_NAME);
        COMMIT; 
        
        EXCEPTION
        WHEN USER_DEFINE_ERROR
        THEN RAISE_APPLICATION_ERROR(-20004, '�����ϴ� �����Դϴ�');
END;
--==>> Procedure TBL_COU_INSERT(��) �����ϵǾ����ϴ�.

--==========================================================================================================

--�� ���� ���� ��� ���ν���

CREATE OR REPLACE PROCEDURE TBL_OPEN_COU_INSERT
( V_COU_NAME IN TBL_COU.COU_NAME%TYPE
, V_COU_START IN TBL_OPEN_COU.COU_START%TYPE
, V_COU_END     IN TBL_OPEN_COU.COU_END%TYPE
)
IS
    V_COU_CODE TBL_COU.COU_CODE%TYPE;
    V_NUM NUMBER;
    USER_DEFINE_ERROR EXCEPTION;
BEGIN

        SELECT COUNT(*) INTO V_NUM
        FROM TBL_COU
        WHERE COU_NAME = V_COU_NAME;
        
        IF(V_NUM = 0)
          THEN RAISE USER_DEFINE_ERROR;
        END IF;
        
        SELECT COU_CODE INTO V_COU_CODE
        FROM TBL_COU
        WHERE COU_NAME = V_COU_NAME;
        
        INSERT INTO TBL_OPEN_COU(OPEN_COU_CODE,COU_CODE,COU_START,COU_END) 
              VALUES(SEQ_OPEN_COU.NEXTVAL, V_COU_CODE, V_COU_START, V_COU_END);
     
     
      COMMIT;
      
        EXCEPTION
        WHEN USER_DEFINE_ERROR
        THEN RAISE_APPLICATION_ERROR(-20002, '���������ʴ� �����Դϴ�.');  
        
END;
--==>> Procedure TBL_OPEN_COU_INSERT��(��) �����ϵǾ����ϴ�.

--============================================================================
-- ���� ���ν��� ����
CREATE OR REPLACE PROCEDURE TBL_SUB_INSERT
( V_SUB_NAME TBL_SUB.SUB_NAME%TYPE
)
IS
    FLAG NUMBER(1);
    
    USER_DEFINE_ERROR EXCEPTION;
BEGIN    
    
    SELECT COUNT(*) INTO FLAG
    FROM TBL_SUB
    WHERE SUB_NAME = V_SUB_NAME;

    IF(FLAG = 0)
    THEN
    
    INSERT INTO TBL_SUB(SUB_CODE, SUB_NAME)
    VALUES(SEQ_SUB.NEXTVAL, V_SUB_NAME);    
    
    COMMIT;
    
    ELSE 
      RAISE USER_DEFINE_ERROR;    
    END IF;
    
    EXCEPTION
    WHEN USER_DEFINE_ERROR
    THEN RAISE_APPLICATION_ERROR(-20004, '�����ϴ� �����Դϴ�.');
   
END;
--==>> Procedure TBL_SUB_INSERT��(��) �����ϵǾ����ϴ�.

--==========================================================================================

-- �� �������� ���ν���

CREATE OR REPLACE PROCEDURE TBL_OPEN_SUB_INSERT
( V_OPEN_COU_CODE  IN TBL_OPEN_COU.OPEN_COU_CODE%TYPE   -- ���������ڵ�
, V_SUB_NAME       IN TBL_SUB.SUB_NAME%TYPE             -- �����
, V_SUB_START      IN TBL_OPEN_SUB.SUB_START%TYPE       -- �������������
, V_SUB_END        IN TBL_OPEN_SUB.SUB_END%TYPE         -- ��������������
, V_BOOK_NAME      IN TBL_TEXTBOOK.BOOK_NAME%TYPE       -- ���� ��
, V_PROF_ID        IN TBL_PROF.PROF_ID%TYPE             -- ���� ��ȣ
, V_ROOM_NO        IN TBL_CLASSROOM.ROOM_NO%TYPE        -- ���ǽ� ��ȣ
)
IS
  V_COU_START TBL_OPEN_COU.COU_START%TYPE;              -- ���� ���� ������
  V_COU_END   TBL_OPEN_COU.COU_END%TYPE;                -- ���� ���� ������
 
  
  V_OPEN_COU_NUM NUMBER := 0;                                -- ���� ���� Ȯ�� ����
  V_LOOP_NUM     NUMBER := 0;                           -- ���� ���� LOOP���� ���� ����
  
  V_LOOP_SUB_START DATE;                                -- LOOP������ �޾ƿ� ���� �������� ������
  V_LOOP_SUB_END  DATE;                                 -- LOOP������ �޾ƿ� ���� �������� ������
  FLAG           NUMBER;                                -- ��/���� ��
  
  V_SUB_CODE TBL_SUB.SUB_CODE%TYPE;                     -- ���� �ڵ� �޴� ����
  V_BOOK_NO TBL_TEXTBOOK.BOOK_NO%TYPE;                  -- ���� �ڵ� �޴� ���� 
  
  V_EXIT_NUM NUMBER;
  
  
  USER_DEFINE_ERROR EXCEPTION;                          -- �������� �ʴ� �Ϳ� ���� ���� ó�� ����
  USER_DEFINE_ERROR2 EXCEPTION;                         -- �������� ���� �����Ⱓ �� ���� ó�� ����
  USER_DEFINE_ERROR3 EXCEPTION;                    -- ���� �ϴ� ���� ���� ó��
  
BEGIN

  --�� ���� ���� Ȯ��
  SELECT COUNT(*) INTO FLAG
  FROM TBL_SUB
  WHERE SUB_NAME = V_SUB_NAME;
 
  
  -- ���� ó�� 
  IF (FLAG = 0)
  THEN RAISE USER_DEFINE_ERROR;
  END IF ;
  
  -- ���� �ڵ� �ޱ�
  SELECT SUB_CODE INTO V_SUB_CODE  
  FROM TBL_SUB
  WHERE SUB_NAME = V_SUB_NAME;
  
  
  --�۱��� Ȯ�� ���� üũ
  SELECT COUNT(*) INTO FLAG
  FROM TBL_PROF
  WHERE PROF_ID = V_PROF_ID;
  -- ���� ó��
  IF (FLAG =0)
    THEN RAISE USER_DEFINE_ERROR;
  END IF;
  
  
  --�۰������� Ȯ�� ���� üũ
  SELECT COUNT(*) INTO FLAG
  FROM TBL_OPEN_COU
  WHERE OPEN_COU_CODE = V_OPEN_COU_CODE;
  -- ���� ó��
  IF (FLAG =0)
    THEN RAISE USER_DEFINE_ERROR;
  END IF;
  
  --�۰��ǽ� Ȯ�� ���� üũ
  SELECT COUNT(*) INTO FLAG
  FROM TBL_CLASSROOM
  WHERE ROOM_NO = V_ROOM_NO;
  -- ���� ó��
  IF (FLAG =0)
    THEN RAISE USER_DEFINE_ERROR;
  END IF;
  
  --�� ���� Ȯ�� ���� üũ
  SELECT COUNT(*) INTO FLAG
  FROM TBL_TEXTBOOK
  WHERE BOOK_NAME =V_BOOK_NAME;
  -- ���� ó�� 
  IF(FLAG = 0)
    THEN RAISE USER_DEFINE_ERROR;
  END IF;
  -- ���� ��ȣ �ޱ�
  SELECT BOOK_NO INTO V_BOOK_NO
  FROM TBL_TEXTBOOK
  WHERE BOOK_NAME =V_BOOK_NAME;
      
   
   
   --�� ���� ������ ������ Ȯ��
   -- 1. ������� ���� �Ⱓ �ȿ� ���� �ϴ���
   
   -- ���� ���� ������,������ �޾ƿ���   
   SELECT COU_START, COU_END INTO V_COU_START, V_COU_END
   FROM TBL_OPEN_COU
   WHERE OPEN_COU_CODE = V_OPEN_COU_CODE;
   -- ���� ó��
   IF(NOT ( (V_SUB_START >= V_COU_START AND V_SUB_START <=V_COU_END)
      AND (V_SUB_END >= V_COU_START AND V_SUB_END <= V_COU_END) ) )
      THEN RAISE USER_DEFINE_ERROR;
   END IF;
  
   
   -- �����������̺� ���� ���� �� 
   SELECT COUNT(*) INTO V_OPEN_COU_NUM
   FROM TBL_OPEN_SUB
   WHERE OPEN_COU_CODE = V_OPEN_COU_CODE;
  
   -- ������ ���� �Ѵٸ� ,��¥ ��ȿ�� �˻� ����
   IF (V_OPEN_COU_NUM != 0)
   THEN
   
   LOOP
   
   V_LOOP_NUM := V_LOOP_NUM+1;
   
    SELECT T.SUB_START, T.SUB_END INTO V_LOOP_SUB_START, V_LOOP_SUB_END
    FROM  
    ( SELECT RANK() OVER(ORDER BY SUB_START DESC) "RANK"
          ,  SUB_START, SUB_END
      FROM TBL_OPEN_SUB
      WHERE OPEN_COU_CODE = V_OPEN_COU_CODE
     )T
     WHERE T.RANK = V_LOOP_NUM;
   
   IF( (V_SUB_START NOT BETWEEN V_LOOP_SUB_START AND V_LOOP_SUB_END)
      AND (V_SUB_END  NOT BETWEEN V_LOOP_SUB_START AND V_LOOP_SUB_END) )
      THEN FLAG := 1;
      ELSE FLAG := 0;
      END IF;
         
   
   IF (FLAG = 0)        -- ��ĥ�� ���� �߻�
   THEN RAISE USER_DEFINE_ERROR2;   
   END IF;
   
   
 
    SELECT MAX(T.RANK) INTO V_EXIT_NUM
    FROM  
    ( SELECT RANK() OVER(ORDER BY SUB_START) "RANK"
      FROM TBL_OPEN_SUB
      WHERE OPEN_COU_CODE = V_OPEN_COU_CODE
    )T;
                        
   
   
   EXIT WHEN V_LOOP_NUM= V_EXIT_NUM;
   
   END LOOP;
   
   END IF;
   
   SELECT COUNT(*) INTO FLAG
   FROM TBL_OPEN_SUB
   WHERE OPEN_COU_CODE = V_OPEN_COU_CODE
     AND SUB_CODE = V_SUB_CODE
     AND PROF_ID = V_PROF_ID;
   
   
   IF(FLAG = 1)
   THEN RAISE USER_DEFINE_ERROR3;  
   END IF;
   
   -- ���� ������ DEFAULT �� ���:20, �Ǳ�:40, �ʱ�:40 
   INSERT INTO TBL_OPEN_SUB(OPEN_SUB_CODE,OPEN_COU_CODE, SUB_CODE, PROF_ID, BOOK_NO, ROOM_NO, SUB_START, SUB_END, ATTE_RATIO, PRACT_RATIO, WRITE_RATIO)
   VALUES(SEQ_OPEN_SUB.NEXTVAL ,V_OPEN_COU_CODE, V_SUB_CODE, V_PROF_ID, V_BOOK_NO, V_ROOM_NO, V_SUB_START, V_SUB_END, 20, 40, 40);
   
   COMMIT;
  
  
  EXCEPTION
    WHEN USER_DEFINE_ERROR
    THEN RAISE_APPLICATION_ERROR(-20002, '���������ʴ� �����Դϴ�.');   
    WHEN USER_DEFINE_ERROR2
    THEN RAISE_APPLICATION_ERROR(-20003, '���ǿ� �������� �� �ϴ� �Ⱓ�Դϴ�.');
    WHEN USER_DEFINE_ERROR3
    THEN RAISE_APPLICATION_ERROR(-20004, '�����ϴ� �����Դϴ�');
  

END;
--==>> Procedure TBL_OPEN_SUB_INSERT��(��) �����ϵǾ����ϴ�.



--============================================================================
--�� �������� ���

CREATE OR REPLACE PROCEDURE DROP_COU_INSERT
( V_OPEN_COU_CODE   IN  TBL_OPEN_COU.OPEN_COU_CODE%TYPE   
)
IS
    V_NUM NUMBER;
    USER_DEFINE_ERROR EXCEPTION;
    
     V_COU_START    TBL_OPEN_COU.COU_START%TYPE;              -- ���� ���� ������
     V_COU_END        TBL_OPEN_COU.COU_END%TYPE;                     -- ���� ���� ������
     
     USER_DEFINE_ERROR2 EXCEPTION;                                             -- ���ڿ� ���õ� �ͼ��� 
    
BEGIN
    SELECT COUNT(*)  INTO V_NUM
    FROM  TBL_DROP_COU
    WHERE OPEN_COU_CODE = V_OPEN_COU_CODE;
    
    IF(V_NUM!=0)
    THEN  RAISE USER_DEFINE_ERROR;
    END IF;
    
    SELECT COU_START, COU_END INTO V_COU_START, V_COU_END
    FROM TBL_OPEN_COU
    WHERE OPEN_COU_CODE = V_OPEN_COU_CODE;
    
    IF( SYSDATE < V_COU_START OR SYSDATE>  V_COU_END)       -- ���� ��¥�� ���۳����� ��
    THEN RAISE USER_DEFINE_ERROR2;
    END IF;
    
    INSERT INTO TBL_DROP_COU (DROP_COU_CODE, OPEN_COU_CODE) VALUES (SEQ_DROP_COU.NEXTVAL, V_OPEN_COU_CODE);
    
    EXCEPTION
    WHEN USER_DEFINE_ERROR
    THEN RAISE_APPLICATION_ERROR(-20004, '�����ϴ� �����Դϴ�');
    WHEN USER_DEFINE_ERROR2
    THEN RAISE_APPLICATION_ERROR(-20003, '���ǿ� �������� �� �ϴ� �Ⱓ�Դϴ�.');
    
END;
--==>> Procedure DROP_COU_INSERT(��) �����ϵǾ����ϴ�.

--=======================================================================

--�� ������ 
CREATE OR REPLACE PROCEDURE TBL_TEXTBOOK_INSERT
( V_BOOK_NAME IN TBL_TEXTBOOK.BOOK_NAME%TYPE
)
IS
    V_NUM       NUMBER;
    USER_DEFINE_ERROR EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO V_NUM
    FROM TBL_TEXTBOOK
    WHERE BOOK_NAME = V_BOOK_NAME;
    
    IF(V_NUM!=0)
    THEN 
    RAISE USER_DEFINE_ERROR;
    END IF;
    
    INSERT INTO TBL_TEXTBOOK(BOOK_NO, BOOK_NAME)
    VALUES(SEQ_TEXTBOOK.NEXTVAL, V_BOOK_NAME);
    
    COMMIT;
    
    EXCEPTION
    WHEN USER_DEFINE_ERROR
    THEN RAISE_APPLICATION_ERROR(-20004, '�����ϴ� �����Դϴ�');
END;
--==>> Procedure TBL_TEXTBOOK_INSERT(��) �����ϵǾ����ϴ�.

--=========================================================
--�� ���� ���� �Է� ���ν��� 

CREATE OR REPLACE PROCEDURE TBL_GRADE_INSERT
( V_APPLY_COU_CODE IN TBL_APPLY_COU.APPLY_COU_CODE%TYPE --�����ڵ�
, V_OPEN_SUB_CODE IN TBL_OPEN_SUB.OPEN_SUB_CODE%TYPE --���������ڵ�
)
IS
     V_ATTENDANCE TBL_GRADE.ATTENDANCE%TYPE := 0; --��� --> ������ ����Ʈ�� 0
     V_PRACTICAL TBL_GRADE.PRACTICAL%TYPE :=0 ; --�Ǳ�
     V_WRITE TBL_GRADE.WRITE%TYPE := 0; --�ʱ�
    USER_DEFINE_ERROR EXCEPTION; --����ó��
    USER_DEFINE_ERROR2 EXCEPTION; --����ó��
    CUR_APPLY_COU_CODE  TBL_APPLY_COU.APPLY_COU_CODE%TYPE; --Ŀ���� ���� �����ڵ�
    CUR_OPEN_SUB_CODE  TBL_OPEN_SUB.OPEN_SUB_CODE%TYPE; --Ŀ���� ���� ���������ڵ�
    FLAG NUMBER :=0; --����
    V_GR_AP TBL_GRADE.APPLY_COU_CODE%TYPE; --(���� ���̺��� ������)Ŀ���� ���� �����ڵ�
    V_GR_SUB TBL_GRADE.OPEN_SUB_CODE%TYPE ;--(���� ���̺��� ������)Ŀ���� ���� ���������ڵ�
    
    CURSOR CUR_AP IS       -- �����ڵ�
    SELECT APPLY_COU_CODE
    FROM TBL_APPLY_COU;
    
    CURSOR CUR_SUB IS      -- ���������ڵ�
    SELECT OPEN_SUB_CODE
    FROM TBL_OPEN_SUB;
    
    CURSOR CUR_GR IS      -- �������̺� ���� �����ڵ�� ���������ڵ尡 �����ϴ��� �Ǻ�
    SELECT APPLY_COU_CODE,OPEN_SUB_CODE
    FROM TBL_GRADE;

    
BEGIN
    OPEN CUR_AP;      -- �Է��Ϸ��� �����ڵ尡 �����ϴ��� ����
    LOOP
    FETCH CUR_AP INTO CUR_APPLY_COU_CODE;
      IF(CUR_APPLY_COU_CODE = V_APPLY_COU_CODE)
      THEN FLAG :=1; --��
      END IF;
    EXIT WHEN CUR_AP%NOTFOUND; 
    END LOOP;
    CLOSE CUR_AP;
    
    IF(FLAG=0) -- �����ڵ尡 ��������������
    THEN 
    RAISE USER_DEFINE_ERROR;
    END IF;
    
    FLAG :=0;
    
    OPEN CUR_SUB;      -- �Է��Ϸ��� ���������ڵ尡 �����ϴ��� ����
    LOOP
    FETCH CUR_SUB INTO CUR_OPEN_SUB_CODE;
      IF(CUR_OPEN_SUB_CODE = V_OPEN_SUB_CODE)
      THEN FLAG :=1; --��
      END IF;
    EXIT WHEN CUR_SUB%NOTFOUND; 
    END LOOP;
    CLOSE CUR_SUB;
    
    IF(FLAG=0) --  -- ���������ڵ尡 ��������������
    THEN 
    RAISE USER_DEFINE_ERROR;
    END IF;
    
    FLAG :=0;
    
    
 --���̺� ���� �������� ������ ������ �����߻� 
 
    OPEN CUR_GR;      -- �Է��Ϸ��� ���������ڵ尡 �����ϴ��� ����
    LOOP
    FETCH CUR_GR INTO V_GR_AP,V_GR_SUB;
    IF(V_GR_AP = V_APPLY_COU_CODE AND V_GR_SUB=V_OPEN_SUB_CODE) 
    THEN FLAG :=1; --��
    END IF;
    EXIT WHEN CUR_GR%NOTFOUND; 
    END LOOP;
    CLOSE CUR_GR;
    
    IF(FLAG=1) -- �������̺� ���� �����Ͱ� �����Ѵٸ� �����߻�
    THEN 
    RAISE USER_DEFINE_ERROR2;
    END IF;
    

    INSERT INTO TBL_GRADE(GRADE_CODE,APPLY_COU_CODE,OPEN_SUB_CODE,ATTENDANCE,PRACTICAL,WRITE)--������,�����ڵ�,���������ڵ�, ���, �Ǳ�, �ʱ�
    VALUES(SEQ_TBL_GRADE.NEXTVAL,V_APPLY_COU_CODE,V_OPEN_SUB_CODE,V_ATTENDANCE,V_PRACTICAL,V_WRITE);

    COMMIT;
    
    EXCEPTION
    WHEN USER_DEFINE_ERROR
    THEN RAISE_APPLICATION_ERROR(-20002, '���������ʴ� �����Դϴ�.'); 
    WHEN USER_DEFINE_ERROR2
    THEN RAISE_APPLICATION_ERROR(-20004, '�����ϴ� �����Դϴ�');
    
END;
--==>> Procedure TBL_GRADE_INSERT(��) �����ϵǾ����ϴ�.

--==========================================================================
--���ߵ�Ż�� ���ν���
CREATE OR REPLACE PROCEDURE TBL_DROP_STU_INSERT
( V_APPLY_COU_CODE IN TBL_APPLY_COU.APPLY_COU_CODE%TYPE
)
IS
    CUR_APPLY_COU_CODE  TBL_APPLY_COU.APPLY_COU_CODE%TYPE; --Ŀ���� �����ڵ�
    V_DROP_DATE TBL_DROP_STU.DROP_DATE%TYPE := SYSDATE;
    USER_DEFINE_ERROR EXCEPTION;
    USER_DEFINE_ERROR2 EXCEPTION; --����ó��
    USER_DEFINE_ERROR3 EXCEPTION;
    
    FLAG NUMBER :=0; --����
    V_CUR_STU TBL_APPLY_COU.APPLY_COU_CODE%TYPE; --(�ߵ�Ż�� ���̺� ���� �л��� �����ϴ��� �Ǻ�)Ŀ���� ���� ����
    
    CURSOR CUR IS      
    SELECT APPLY_COU_CODE
    FROM TBL_APPLY_COU;
      
    CURSOR CUR_STU IS      -- �ߵ�Ż�� ���̺� ���� �����ڵ尡 �����ϴ��� �Ǻ�
    SELECT APPLY_COU_CODE
    FROM TBL_DROP_STU;
    
    V_OPEN_COU_START    TBL_OPEN_COU.COU_START%TYPE;
    V_OPEN_COU_END      TBL_OPEN_COU.COU_END%TYPE;

BEGIN
   
    
    
    OPEN CUR;
    
    LOOP
    FETCH CUR INTO CUR_APPLY_COU_CODE;
      IF(CUR_APPLY_COU_CODE = V_APPLY_COU_CODE)
      THEN FLAG :=1; --��
      END IF;
    --�ݺ��ؼ� ó���� �κ�
    EXIT WHEN CUR%NOTFOUND; 
    END LOOP;


    IF(FLAG=0)
    THEN 
    RAISE USER_DEFINE_ERROR;
    END IF;
    
    FLAG:=0;
        
        
 --���̺� ���� �������� ������ ������ �����߻� 
 
    OPEN CUR_STU;     
    LOOP
    FETCH CUR_STU INTO V_CUR_STU;
    IF(V_CUR_STU=V_APPLY_COU_CODE) 
    THEN FLAG :=1; --��
    END IF;
    EXIT WHEN CUR_STU%NOTFOUND; 
    END LOOP;
    CLOSE CUR_STU;
    
    
    IF(FLAG=1) -- �������̺� ���� �����Ͱ� �����Ѵٸ� �����߻�
    THEN 
    RAISE USER_DEFINE_ERROR2;
    END IF;
    
    SELECT OC.COU_START, OC.COU_END INTO V_OPEN_COU_START, V_OPEN_COU_END
    FROM TBL_OPEN_COU OC JOIN TBL_APPLY_COU AC
      ON OC.OPEN_COU_CODE = AC.OPEN_COU_CODE
    WHERE AC.APPLY_COU_CODE = V_APPLY_COU_CODE;
    
    IF(SYSDATE NOT BETWEEN V_OPEN_COU_START AND V_OPEN_COU_END)
    THEN RAISE USER_DEFINE_ERROR3;
    END IF;
    
    
    INSERT INTO TBL_DROP_STU(DROP_STU_CODE,APPLY_COU_CODE,DROP_DATE)
    VALUES(SEQ_TBL_DROP_STU.NEXTVAL,V_APPLY_COU_CODE,V_DROP_DATE);
    
    CLOSE CUR;
    COMMIT;
    
    EXCEPTION
    WHEN USER_DEFINE_ERROR
    THEN RAISE_APPLICATION_ERROR(-20002, '���������ʴ� �����Դϴ�.'); 
    WHEN USER_DEFINE_ERROR2
    THEN RAISE_APPLICATION_ERROR(-20004, '�����ϴ� �����Դϴ�');
    WHEN USER_DEFINE_ERROR3
    THEN RAISE_APPLICATION_ERROR(-20003, '���ǿ� �������� �� �ϴ� �Ⱓ�Դϴ�.');
    
END;
--==>> Procedure TBL_DROP_STU_INSERT(��) �����ϵǾ����ϴ�.

--�� ������û ���ν���

CREATE OR REPLACE PROCEDURE TBL_APPLY_COU_INSERT
( V_OPEN_COU_CODE TBL_COU.COU_CODE%TYPE
, V_STU_ID TBL_STU.STU_ID%TYPE
)
IS
 FLAG NUMBER :=0 ;    
 USER_DEFINE_ERROR EXCEPTION;
 USER_DEFINE_ERROR2 EXCEPTION;
 
 V_OPEN_SUB_CODE TBL_OPEN_SUB.OPEN_SUB_CODE%TYPE;
 V_OPEN_SUB_NUM  NUMBER;
 V_NUM NUMBER := 0;
 
 -- Ŀ�� ���� ����
 CURSOR OPEN_SUB_CUR
 IS 
 SELECT OPEN_SUB_CODE
 FROM TBL_OPEN_SUB
 WHERE OPEN_COU_CODE = V_OPEN_COU_CODE;
 
 V_APPLY_COU_CODE TBL_APPLY_COU.APPLY_COU_CODE%TYPE;
 
BEGIN

     -- ���� ���� ���� ����  
     SELECT COUNT(*) INTO FLAG   
     FROM TBL_OPEN_COU
     WHERE OPEN_COU_CODE =V_OPEN_COU_CODE;
     -- ���� ó��
     IF(FLAG = 0)
     THEN RAISE USER_DEFINE_ERROR;
     END IF;
     
     -- �й� ���� ����
     SELECT COUNT(*) INTO FLAG   
     FROM TBL_STU
     WHERE STU_ID =V_STU_ID;
     -- ���� ó��
     IF(FLAG = 0)
     THEN RAISE USER_DEFINE_ERROR;
     END IF;
     
     -- �й�, ���������� �ߺ� �Ǵ� ���
     SELECT COUNT(*) INTO FLAG
     FROM TBL_APPLY_COU
     WHERE STU_ID = V_STU_ID 
       AND OPEN_COU_CODE = V_OPEN_COU_CODE;
     
     
     IF(FLAG !=0)
     THEN RAISE USER_DEFINE_ERROR2;     
     END IF;
        
     
     
     
     V_APPLY_COU_CODE := SEQ_APPLY_COU.NEXTVAL;
     
     INSERT INTO TBL_APPLY_COU(APPLY_COU_CODE, OPEN_COU_CODE, STU_ID, APPLY_DATE)
     VALUES(V_APPLY_COU_CODE, V_OPEN_COU_CODE, V_STU_ID, SYSDATE);   
     
     OPEN OPEN_SUB_CUR;
     
      LOOP
         
         FETCH OPEN_SUB_CUR INTO V_OPEN_SUB_CODE;
         
         EXIT WHEN OPEN_SUB_CUR%NOTFOUND;
         
         TBL_GRADE_INSERT(V_APPLY_COU_CODE,V_OPEN_SUB_CODE);
               
         
     END LOOP;
       
     CLOSE OPEN_SUB_CUR;  
     COMMIT;
   
   
   
 EXCEPTION
 WHEN USER_DEFINE_ERROR
 THEN RAISE_APPLICATION_ERROR(-20002, '�������� �ʴ� �����Դϴ�.');
 WHEN USER_DEFINE_ERROR2
 THEN RAISE_APPLICATION_ERROR(-20004, '���� �ϴ� �����Դϴ�.');
 WHEN OTHERS
 THEN ROLLBACK;
 
END;
--==>> Procedure TBL_APPLY_COU_INSERT��(��) �����ϵǾ����ϴ�.