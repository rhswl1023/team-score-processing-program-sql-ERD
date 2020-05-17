--(UPDATE 프로시저)


--○ 교수자 UPDATE
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
    THEN RAISE_APPLICATION_ERROR(-20001, '주민번호 오류');   
END;
--==>> Procedure TBL_PROF_UPDATE이(가) 컴파일되었습니다.


--==========================================================================================================
--○ 학생 UPDATE

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
    THEN RAISE_APPLICATION_ERROR(-20001, '주민번호 오류');   
END;
--==>> Procedure TBL_STU_UPDATE이(가) 컴파일되었습니다.

--==========================================================================================================

--○ 개설과정 UPDATE 
CREATE OR REPLACE PROCEDURE TBL_OPEN_COU_UPDATE
( V_OPEN_COU_CODE IN TBL_OPEN_COU.OPEN_COU_CODE%TYPE        --개설과정코드
, V_COU_NAME IN TBL_COU.COU_NAME%TYPE                       --과정이름
, V_COU_START IN TBL_OPEN_COU.COU_START%TYPE                --개설과정날짜수정
, V_COU_END IN TBL_OPEN_COU.COU_END%TYPE                    --개설과정날짜수정    
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

    --개설 과정 시작일
    SELECT COU_END INTO V_OPEN_COU_END
    FROM TBL_OPEN_COU
    WHERE OPEN_COU_CODE =V_OPEN_COU_CODE;
    
    --수정하려는 날이 개설 과정 끝나는 일보다 늦을 경우 수정 X
    IF(V_OPEN_COU_END <= SYSDATE)
    THEN RAISE USER_DEFINE_ERROR2;
    END IF;



 -- 과정 이름 존재 여부
 SELECT COUNT(*) INTO V_NUM
 FROM TBL_COU
 WHERE COU_NAME = V_COU_NAME;
 
 -- 과정 이름 존재 여부에 대한 예외처리
 IF (V_NUM = 0)
 THEN RAISE USER_DEFINE_ERROR; 
 END IF;
 
 -- 개설과목기간과 개설과정기간 비교
 
 SELECT MIN(SUB_START),MAX(SUB_END) INTO V_OPEN_SUB_START, V_OPEN_SUB_END
 FROM TBL_OPEN_SUB
 WHERE OPEN_COU_CODE=V_OPEN_COU_CODE;
 
 -- 예외처리
 IF( NOT(V_COU_START<=V_OPEN_SUB_START AND V_COU_END >=V_OPEN_SUB_END) )
 THEN RAISE USER_DEFINE_ERROR2;
 END IF;
 
 -- 과정코드 받기
 SELECT COU_CODE INTO V_COU_CODE
 FROM TBL_COU
 WHERE COU_NAME = V_COU_NAME;
  
 
 --업데이트
 UPDATE TBL_OPEN_COU
 SET COU_CODE=V_COU_CODE, COU_START= V_COU_START, COU_END = V_COU_END
 WHERE OPEN_COU_CODE = V_OPEN_COU_CODE;
 
 COMMIT;
 
 
 EXCEPTION
 WHEN USER_DEFINE_ERROR
 THEN RAISE_APPLICATION_ERROR(-20002, '존재하지않는 정보입니다.');  
 WHEN USER_DEFINE_ERROR2
 THEN RAISE_APPLICATION_ERROR(-20003, '조건에 충족하지 못 하는 기간입니다.');
 
END;
--==>> Procedure TBL_OPEN_COU_UPDATE이(가) 컴파일되었습니다.


--==========================================================================================================
--○ 개설과목 UPDATE

--개설과목시작전 교수,과목,개설과정코드 바꿀 수 있는 UPDATE문
CREATE OR REPLACE PROCEDURE TBL_OPEN_SUB_UPDATE1
( V_OPEN_SUB_CODE IN TBL_OPEN_SUB.OPEN_SUB_CODE%TYPE
, V_OPEN_COU_CODE IN TBL_OPEN_COU.OPEN_COU_CODE%TYPE
, V_SUB_NAME IN TBL_SUB.SUB_NAME%TYPE
, V_PROF_ID IN TBL_PROF.PROF_ID%TYPE
)
IS
   
  V_OR_SUB_START TBL_OPEN_SUB.SUB_START%TYPE;  -- 원래의 개설 과목 시작일
  
  V_SUB_CODE TBL_SUB.SUB_CODE%TYPE;
  
  FLAG NUMBER;
 
   --예외 처리
  USER_DEFINE_ERROR EXCEPTION;  --기간 에러
  USER_DEFINE_ERROR2 EXCEPTION; --존재안함 에러처리
  USER_DEFINE_ERROR3 EXCEPTION; -- 동일존재
  
BEGIN
    
    --개설 과목 시작일
    SELECT SUB_START INTO V_OR_SUB_START
    FROM TBL_OPEN_SUB
    WHERE OPEN_SUB_CODE =V_OPEN_SUB_CODE;
    
    --수정하려는 날이 개설 과목 시작일보다 늦을 경우 수정 X
    IF(V_OR_SUB_START<=SYSDATE)
    THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    
        --○ 과목 여부 확인
      SELECT COUNT(*) INTO FLAG
      FROM TBL_SUB
      WHERE SUB_NAME = V_SUB_NAME;
           
      -- 에러 처리 
      IF (FLAG = 0)
      THEN RAISE USER_DEFINE_ERROR2;
      END IF ;
      
      -- 과목 코드 받기
      SELECT SUB_CODE INTO V_SUB_CODE  
      FROM TBL_SUB
      WHERE SUB_NAME = V_SUB_NAME;
      
      
      --○교수 확인 변수 체크
      SELECT COUNT(*) INTO FLAG
      FROM TBL_PROF
      WHERE PROF_ID = V_PROF_ID;
      -- 에러 처리
      IF (FLAG =0)
        THEN RAISE USER_DEFINE_ERROR2;
      END IF;
      
      
      --○개설과정 확인 변수 체크
      SELECT COUNT(*) INTO FLAG
      FROM TBL_OPEN_COU
      WHERE OPEN_COU_CODE = V_OPEN_COU_CODE;
      -- 에러 처리
      IF (FLAG =0)
        THEN RAISE USER_DEFINE_ERROR2;
      END IF;
      
    -- 동일한 경우
    SELECT COUNT(*) INTO FLAG
    FROM TBL_OPEN_SUB
    WHERE OPEN_COU_CODE = V_OPEN_COU_CODE
     AND SUB_CODE = V_SUB_CODE
     AND PROF_ID = V_PROF_ID;
   
   -- 에러발생
   IF(FLAG = 1)
   THEN RAISE USER_DEFINE_ERROR3;  
   END IF;

    UPDATE TBL_OPEN_SUB
    SET OPEN_COU_CODE = V_OPEN_COU_CODE, SUB_CODE=V_SUB_CODE, PROF_ID = V_PROF_ID
    WHERE OPEN_SUB_CODE = V_OPEN_SUB_CODE;

    COMMIT;


    EXCEPTION
    WHEN USER_DEFINE_ERROR
    THEN RAISE_APPLICATION_ERROR(-20003, '조건에 충족하지 못 하는 기간입니다.');
    WHEN USER_DEFINE_ERROR2
    THEN RAISE_APPLICATION_ERROR(-20002, '존재하지않는 정보입니다.');  
    WHEN USER_DEFINE_ERROR3
    THEN RAISE_APPLICATION_ERROR(-20004, '존재하는 정보입니다');
    


END;
--==>> Procedure TBL_OPEN_SUB_UPDATE1이(가) 컴파일되었습니다.



-- 과목시작일, 과목종료일 UPDATE문
CREATE OR REPLACE PROCEDURE TBL_OPEN_SUB_UPDATE2
( V_OPEN_SUB_CODE IN TBL_OPEN_SUB.OPEN_SUB_CODE%TYPE
, V_OPEN_COU_CODE IN TBL_OPEN_COU.OPEN_COU_CODE%TYPE
, V_SUB_START IN TBL_OPEN_SUB.SUB_START%TYPE    --바꿀 개설 과목시작일
, V_SUB_END IN TBL_OPEN_SUB.SUB_END%TYPE        -- 바꿀 개설 과목 종료일
)
IS
 FLAG NUMBER;
 V_START TBL_OPEN_SUB.SUB_START%TYPE;
 V_END  TBL_OPEN_SUB.SUB_END%TYPE;
 
   --예외 처리
  USER_DEFINE_ERROR EXCEPTION;  --기간 에러
  
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
    THEN RAISE_APPLICATION_ERROR(-20003, '조건에 충족하지 못 하는 기간입니다.');
    
END;
--==>> Procedure TBL_OPEN_SUB_UPDATE2이(가) 컴파일되었습니다.



--교수가 출결배점, 실기배점, 필기배점 업데이트 
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
--==>> Procedure TBL_OPEN_SUB_UPDATE3이(가) 컴파일되었습니다.

--================================================================================================================

--○ 성적 업데이트 프로시저
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
--==>> Procedure TBL_GRADE_UPDATE이(가) 컴파일되었습니다.


/*
에러 
(-20001, '주민번호 오류');   
(-20002, '존재하지않는 정보입니다.');  
(-20003, '조건에 충족하지 못 하는 기간입니다.');
(-20004, '존재하는 정보입니다');
*/

