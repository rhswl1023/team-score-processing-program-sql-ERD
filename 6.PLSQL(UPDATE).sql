--(UPDATE ���ν���)


--�� ������ UPDATE
CREATE OR REPLACE PROCEDURE TBL_PROF_UPDATE
( V_PROF_ID     IN TBL_PROF.PROF_ID%TYPE
, V_PROF_NAME IN TBL_PROF.PROF_NAME%TYPE
, V_PROF_SSN  IN TBL_PROF.PROF_SSN%TYPE
, V_PROF_PW   IN TBL_PROF.PROF_PW%TYPE
)
IS
    USER_DEFINE_ERROR EXCEPTION;
BEGIN
    
    
    IF  REGEXP_LIKE(V_PROF_SSN, '[^[:digit:]]')
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    
    UPDATE TBL_PROF
    SET  PROF_NAME = V_PROF_NAME , PROF_SSN = V_PROF_SSN , PROF_PW = V_PROF_PW
    WHERE PROF_ID = V_PROF_ID;
    
   
    COMMIT; 
    
    EXCEPTION
    WHEN USER_DEFINE_ERROR
    THEN RAISE_APPLICATION_ERROR(-20001, '�ֹι�ȣ ����');   
END;
--==>> Procedure TBL_PROF_UPDATE��(��) �����ϵǾ����ϴ�.


--==========================================================================================================
--�� �л� UPDATE

CREATE OR REPLACE PROCEDURE TBL_STU_UPDATE
( V_STU_ID   IN TBL_STU.STU_ID%TYPE
, V_STU_NAME IN TBL_STU.STU_NAME%TYPE
, V_STU_PW   IN TBL_STU.STU_PW%TYPE
, V_STU_SSN  IN TBL_STU.STU_SSN%TYPE
)
IS
    USER_DEFINE_ERROR EXCEPTION;
BEGIN
    IF  REGEXP_LIKE(V_STU_SSN, '[^[:digit:]]')
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    
    UPDATE TBL_STU
    SET  STU_NAME = V_STU_NAME , STU_PW = V_STU_PW, STU_SSN = V_STU_SSN 
    WHERE STU_ID = V_STU_ID;
    
    COMMIT; 
    
    EXCEPTION
    WHEN USER_DEFINE_ERROR
    THEN RAISE_APPLICATION_ERROR(-20001, '�ֹι�ȣ ����');   
END;
--==>> Procedure TBL_STU_UPDATE��(��) �����ϵǾ����ϴ�.

--==========================================================================================================

--�� �������� UPDATE 
CREATE OR REPLACE PROCEDURE TBL_OPEN_COU_UPDATE
( V_OPEN_COU_CODE IN TBL_OPEN_COU.OPEN_COU_CODE%TYPE        --���������ڵ�
, V_COU_NAME IN TBL_COU.COU_NAME%TYPE                       --�����̸�
, V_COU_START IN TBL_OPEN_COU.COU_START%TYPE                --����������¥����
, V_COU_END IN TBL_OPEN_COU.COU_END%TYPE                    --����������¥����    
)
IS
  
  V_COU_CODE TBL_COU.COU_CODE%TYPE;
  V_NUM NUMBER;
  
  USER_DEFINE_ERROR EXCEPTION;
  USER_DEFINE_ERROR2 EXCEPTION;
  
  V_OPEN_SUB_START TBL_OPEN_SUB.SUB_START%TYPE;
  V_OPEN_SUB_END TBL_OPEN_SUB.SUB_END%TYPE; 
  
  V_OPEN_COU_END TBL_OPEN_COU.COU_END%TYPE;
  
BEGIN

    --���� ���� ������
    SELECT COU_END INTO V_OPEN_COU_END
    FROM TBL_OPEN_COU
    WHERE OPEN_COU_CODE =V_OPEN_COU_CODE;
    
    --�����Ϸ��� ���� ���� ���� ������ �Ϻ��� ���� ��� ���� X
    IF(V_OPEN_COU_END <= SYSDATE)
    THEN RAISE USER_DEFINE_ERROR2;
    END IF;



 -- ���� �̸� ���� ����
 SELECT COUNT(*) INTO V_NUM
 FROM TBL_COU
 WHERE COU_NAME = V_COU_NAME;
 
 -- ���� �̸� ���� ���ο� ���� ����ó��
 IF (V_NUM = 0)
 THEN RAISE USER_DEFINE_ERROR; 
 END IF;
 
 -- ��������Ⱓ�� ���������Ⱓ ��
 
 SELECT MIN(SUB_START),MAX(SUB_END) INTO V_OPEN_SUB_START, V_OPEN_SUB_END
 FROM TBL_OPEN_SUB
 WHERE OPEN_COU_CODE=V_OPEN_COU_CODE;
 
 -- ����ó��
 IF( NOT(V_COU_START<=V_OPEN_SUB_START AND V_COU_END >=V_OPEN_SUB_END) )
 THEN RAISE USER_DEFINE_ERROR2;
 END IF;
 
 -- �����ڵ� �ޱ�
 SELECT COU_CODE INTO V_COU_CODE
 FROM TBL_COU
 WHERE COU_NAME = V_COU_NAME;
  
 
 --������Ʈ
 UPDATE TBL_OPEN_COU
 SET COU_CODE=V_COU_CODE, COU_START= V_COU_START, COU_END = V_COU_END
 WHERE OPEN_COU_CODE = V_OPEN_COU_CODE;
 
 COMMIT;
 
 
 EXCEPTION
 WHEN USER_DEFINE_ERROR
 THEN RAISE_APPLICATION_ERROR(-20002, '���������ʴ� �����Դϴ�.');  
 WHEN USER_DEFINE_ERROR2
 THEN RAISE_APPLICATION_ERROR(-20003, '���ǿ� �������� �� �ϴ� �Ⱓ�Դϴ�.');
 
END;
--==>> Procedure TBL_OPEN_COU_UPDATE��(��) �����ϵǾ����ϴ�.


--==========================================================================================================
--�� �������� UPDATE

--������������� ����,����,���������ڵ� �ٲ� �� �ִ� UPDATE��
CREATE OR REPLACE PROCEDURE TBL_OPEN_SUB_UPDATE1
( V_OPEN_SUB_CODE IN TBL_OPEN_SUB.OPEN_SUB_CODE%TYPE
, V_OPEN_COU_CODE IN TBL_OPEN_COU.OPEN_COU_CODE%TYPE
, V_SUB_NAME IN TBL_SUB.SUB_NAME%TYPE
, V_PROF_ID IN TBL_PROF.PROF_ID%TYPE
)
IS
   
  V_OR_SUB_START TBL_OPEN_SUB.SUB_START%TYPE;  -- ������ ���� ���� ������
  
  V_SUB_CODE TBL_SUB.SUB_CODE%TYPE;
  
  FLAG NUMBER;
 
   --���� ó��
  USER_DEFINE_ERROR EXCEPTION;  --�Ⱓ ����
  USER_DEFINE_ERROR2 EXCEPTION; --������� ����ó��
  USER_DEFINE_ERROR3 EXCEPTION; -- ��������
  
BEGIN
    
    --���� ���� ������
    SELECT SUB_START INTO V_OR_SUB_START
    FROM TBL_OPEN_SUB
    WHERE OPEN_SUB_CODE =V_OPEN_SUB_CODE;
    
    --�����Ϸ��� ���� ���� ���� �����Ϻ��� ���� ��� ���� X
    IF(V_OR_SUB_START<=SYSDATE)
    THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    
        --�� ���� ���� Ȯ��
      SELECT COUNT(*) INTO FLAG
      FROM TBL_SUB
      WHERE SUB_NAME = V_SUB_NAME;
           
      -- ���� ó�� 
      IF (FLAG = 0)
      THEN RAISE USER_DEFINE_ERROR2;
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
        THEN RAISE USER_DEFINE_ERROR2;
      END IF;
      
      
      --�۰������� Ȯ�� ���� üũ
      SELECT COUNT(*) INTO FLAG
      FROM TBL_OPEN_COU
      WHERE OPEN_COU_CODE = V_OPEN_COU_CODE;
      -- ���� ó��
      IF (FLAG =0)
        THEN RAISE USER_DEFINE_ERROR2;
      END IF;
      
    -- ������ ���
    SELECT COUNT(*) INTO FLAG
    FROM TBL_OPEN_SUB
    WHERE OPEN_COU_CODE = V_OPEN_COU_CODE
     AND SUB_CODE = V_SUB_CODE
     AND PROF_ID = V_PROF_ID;
   
   -- �����߻�
   IF(FLAG = 1)
   THEN RAISE USER_DEFINE_ERROR3;  
   END IF;

    UPDATE TBL_OPEN_SUB
    SET OPEN_COU_CODE = V_OPEN_COU_CODE, SUB_CODE=V_SUB_CODE, PROF_ID = V_PROF_ID
    WHERE OPEN_SUB_CODE = V_OPEN_SUB_CODE;

    COMMIT;


    EXCEPTION
    WHEN USER_DEFINE_ERROR
    THEN RAISE_APPLICATION_ERROR(-20003, '���ǿ� �������� �� �ϴ� �Ⱓ�Դϴ�.');
    WHEN USER_DEFINE_ERROR2
    THEN RAISE_APPLICATION_ERROR(-20002, '���������ʴ� �����Դϴ�.');  
    WHEN USER_DEFINE_ERROR3
    THEN RAISE_APPLICATION_ERROR(-20004, '�����ϴ� �����Դϴ�');
    


END;
--==>> Procedure TBL_OPEN_SUB_UPDATE1��(��) �����ϵǾ����ϴ�.



-- ���������, ���������� UPDATE��
CREATE OR REPLACE PROCEDURE TBL_OPEN_SUB_UPDATE2
( V_OPEN_SUB_CODE IN TBL_OPEN_SUB.OPEN_SUB_CODE%TYPE
, V_OPEN_COU_CODE IN TBL_OPEN_COU.OPEN_COU_CODE%TYPE
, V_SUB_START IN TBL_OPEN_SUB.SUB_START%TYPE    --�ٲ� ���� ���������
, V_SUB_END IN TBL_OPEN_SUB.SUB_END%TYPE        -- �ٲ� ���� ���� ������
)
IS
 FLAG NUMBER;
 V_START TBL_OPEN_SUB.SUB_START%TYPE;
 V_END  TBL_OPEN_SUB.SUB_END%TYPE;
 
   --���� ó��
  USER_DEFINE_ERROR EXCEPTION;  --�Ⱓ ����
  
 CURSOR OPEN_SUB_CUR
 IS 
 SELECT SUB_START, SUB_END
 FROM TBL_OPEN_SUB
 WHERE OPEN_COU_CODE = V_OPEN_COU_CODE
   AND OPEN_SUB_CODE != V_OPEN_SUB_CODE;
 
BEGIN
  
   OPEN OPEN_SUB_CUR;
     
      LOOP
         
         FETCH OPEN_SUB_CUR INTO V_START, V_END;
         
         IF( (V_SUB_START BETWEEN V_START AND V_END)
         AND (V_SUB_END BETWEEN V_START AND V_END))
         THEN RAISE USER_DEFINE_ERROR;
         END IF;
         
         EXIT WHEN OPEN_SUB_CUR%NOTFOUND;            
         
     END LOOP;
       
     CLOSE OPEN_SUB_CUR; 
     
    UPDATE TBL_OPEN_SUB
    SET SUB_START  = V_SUB_START,
        SUB_END = V_SUB_END
    WHERE V_OPEN_SUB_CODE = OPEN_SUB_CODE;
    
    COMMIT;
    
    EXCEPTION
    WHEN USER_DEFINE_ERROR
    THEN RAISE_APPLICATION_ERROR(-20003, '���ǿ� �������� �� �ϴ� �Ⱓ�Դϴ�.');
    
END;
--==>> Procedure TBL_OPEN_SUB_UPDATE2��(��) �����ϵǾ����ϴ�.



--������ ������, �Ǳ����, �ʱ���� ������Ʈ 
CREATE OR REPLACE PROCEDURE TBL_OPEN_SUB_UPDATE3
( V_OPEN_SUB_CODE IN TBL_OPEN_SUB.OPEN_SUB_CODE%TYPE
, V_ATTE_RATIO IN TBL_OPEN_SUB.ATTE_RATIO%TYPE
, V_PRACT_RATIO IN TBL_OPEN_SUB.PRACT_RATIO%TYPE
, V_WRITE_RATIO IN TBL_OPEN_SUB.WRITE_RATIO%TYPE
)
IS
  

BEGIN
    
    UPDATE TBL_OPEN_SUB
    SET ATTE_RATIO=V_ATTE_RATIO, PRACT_RATIO=V_PRACT_RATIO, WRITE_RATIO =V_WRITE_RATIO
    WHERE OPEN_SUB_CODE = V_OPEN_SUB_CODE;
    
    COMMIT;

END;
--==>> Procedure TBL_OPEN_SUB_UPDATE3��(��) �����ϵǾ����ϴ�.

--================================================================================================================

--�� ���� ������Ʈ ���ν���
CREATE OR REPLACE PROCEDURE TBL_GRADE_UPDATE
( V_GRADE_CODE IN TBL_GRADE.GRADE_CODE%TYPE
, V_ATTENDANCE IN TBL_GRADE.ATTENDANCE%TYPE
, V_PRACTICAL  IN TBL_GRADE.PRACTICAL%TYPE
, V_WRITE      IN TBL_GRADE.WRITE%TYPE 
)
IS
BEGIN
    UPDATE TBL_GRADE
    SET ATTENDANCE =  V_ATTENDANCE
      , PRACTICAL  =  V_PRACTICAL 
      , WRITE     =  V_WRITE
    WHERE GRADE_CODE = V_GRADE_CODE;
    
    COMMIT;
END;
--==>> Procedure TBL_GRADE_UPDATE��(��) �����ϵǾ����ϴ�.


/*
���� 
(-20001, '�ֹι�ȣ ����');   
(-20002, '���������ʴ� �����Դϴ�.');  
(-20003, '���ǿ� �������� �� �ϴ� �Ⱓ�Դϴ�.');
(-20004, '�����ϴ� �����Դϴ�');
*/

