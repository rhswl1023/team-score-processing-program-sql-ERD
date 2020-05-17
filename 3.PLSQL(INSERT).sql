--○ 교수 테이블 프로시저 

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
    THEN RAISE_APPLICATION_ERROR(-20001, '주민번호 오류');   
END;
--==>> Procedure TBL_PROF_INSERT이(가) 컴파일되었습니다.
/*

*/
--=====================================================================================================
--○ 학생 ID 생성 함수,프로시저 생성
--함수
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
--==>> Function FN_GENERATE_STU_ID이(가) 컴파일되었습니다.
--===========================================================================

-- 학생 정보입력 프로시저
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
    THEN RAISE_APPLICATION_ERROR(-20001, '주민번호 오류');   
END;
--==>> Procedure TBL_STU_INSERT이(가) 컴파일되었습니다.

--=======================================================================

-- 패스워드 변경(SQL문에서 처리)

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
--==>> Procedure TBL_STU_CHANGE_PW(가) 컴파일되었습니다.

--=====================================================================================================
--○ 과정 등록 프로시저

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
        THEN RAISE_APPLICATION_ERROR(-20004, '존재하는 정보입니다');
END;
--==>> Procedure TBL_COU_INSERT(가) 컴파일되었습니다.

--==========================================================================================================

--○ 개설 과정 등록 프로시저

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
        THEN RAISE_APPLICATION_ERROR(-20002, '존재하지않는 정보입니다.');  
        
END;
--==>> Procedure TBL_OPEN_COU_INSERT이(가) 컴파일되었습니다.

--============================================================================
-- 과목 프로시저 생성
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
    THEN RAISE_APPLICATION_ERROR(-20004, '존재하는 정보입니다.');
   
END;
--==>> Procedure TBL_SUB_INSERT이(가) 컴파일되었습니다.

--==========================================================================================

-- ○ 개설과목 프로시저

CREATE OR REPLACE PROCEDURE TBL_OPEN_SUB_INSERT
( V_OPEN_COU_CODE  IN TBL_OPEN_COU.OPEN_COU_CODE%TYPE   -- 개설과정코드
, V_SUB_NAME       IN TBL_SUB.SUB_NAME%TYPE             -- 과목명
, V_SUB_START      IN TBL_OPEN_SUB.SUB_START%TYPE       -- 개설과목시작일
, V_SUB_END        IN TBL_OPEN_SUB.SUB_END%TYPE         -- 개설과목종료일
, V_BOOK_NAME      IN TBL_TEXTBOOK.BOOK_NAME%TYPE       -- 교재 명
, V_PROF_ID        IN TBL_PROF.PROF_ID%TYPE             -- 교수 번호
, V_ROOM_NO        IN TBL_CLASSROOM.ROOM_NO%TYPE        -- 강의실 번호
)
IS
  V_COU_START TBL_OPEN_COU.COU_START%TYPE;              -- 개설 과정 시작일
  V_COU_END   TBL_OPEN_COU.COU_END%TYPE;                -- 개설 과정 종료일
 
  
  V_OPEN_COU_NUM NUMBER := 0;                                -- 개설 과정 확인 변수
  V_LOOP_NUM     NUMBER := 0;                           -- 개설 과정 LOOP문을 위한 변수
  
  V_LOOP_SUB_START DATE;                                -- LOOP문에서 받아온 동일 개설과목 시작일
  V_LOOP_SUB_END  DATE;                                 -- LOOP문에서 받아온 동일 개설과목 종료일
  FLAG           NUMBER;                                -- 참/거짓 형
  
  V_SUB_CODE TBL_SUB.SUB_CODE%TYPE;                     -- 과목 코드 받는 변수
  V_BOOK_NO TBL_TEXTBOOK.BOOK_NO%TYPE;                  -- 교재 코드 받는 변수 
  
  V_EXIT_NUM NUMBER;
  
  
  USER_DEFINE_ERROR EXCEPTION;                          -- 존재하지 않는 것에 대한 예외 처리 변수
  USER_DEFINE_ERROR2 EXCEPTION;                         -- 개설과목에 대한 과정기간 비교 예외 처리 변수
  USER_DEFINE_ERROR3 EXCEPTION;                    -- 존재 하는 정보 에러 처리
  
BEGIN

  --○ 과목 여부 확인
  SELECT COUNT(*) INTO FLAG
  FROM TBL_SUB
  WHERE SUB_NAME = V_SUB_NAME;
 
  
  -- 에러 처리 
  IF (FLAG = 0)
  THEN RAISE USER_DEFINE_ERROR;
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
    THEN RAISE USER_DEFINE_ERROR;
  END IF;
  
  
  --○개설과정 확인 변수 체크
  SELECT COUNT(*) INTO FLAG
  FROM TBL_OPEN_COU
  WHERE OPEN_COU_CODE = V_OPEN_COU_CODE;
  -- 에러 처리
  IF (FLAG =0)
    THEN RAISE USER_DEFINE_ERROR;
  END IF;
  
  --○강의실 확인 변수 체크
  SELECT COUNT(*) INTO FLAG
  FROM TBL_CLASSROOM
  WHERE ROOM_NO = V_ROOM_NO;
  -- 에러 처리
  IF (FLAG =0)
    THEN RAISE USER_DEFINE_ERROR;
  END IF;
  
  --○ 교재 확인 변수 체크
  SELECT COUNT(*) INTO FLAG
  FROM TBL_TEXTBOOK
  WHERE BOOK_NAME =V_BOOK_NAME;
  -- 에러 처리 
  IF(FLAG = 0)
    THEN RAISE USER_DEFINE_ERROR;
  END IF;
  -- 교재 번호 받기
  SELECT BOOK_NO INTO V_BOOK_NO
  FROM TBL_TEXTBOOK
  WHERE BOOK_NAME =V_BOOK_NAME;
      
   
   
   --○ 과목 시작일 종료일 확인
   -- 1. 과목들이 과정 기간 안에 존재 하는지
   
   -- 개설 과정 시작일,종료일 받아오기   
   SELECT COU_START, COU_END INTO V_COU_START, V_COU_END
   FROM TBL_OPEN_COU
   WHERE OPEN_COU_CODE = V_OPEN_COU_CODE;
   -- 예외 처리
   IF(NOT ( (V_SUB_START >= V_COU_START AND V_SUB_START <=V_COU_END)
      AND (V_SUB_END >= V_COU_START AND V_SUB_END <= V_COU_END) ) )
      THEN RAISE USER_DEFINE_ERROR;
   END IF;
  
   
   -- 개설과목테이블에 동일 과정 수 
   SELECT COUNT(*) INTO V_OPEN_COU_NUM
   FROM TBL_OPEN_SUB
   WHERE OPEN_COU_CODE = V_OPEN_COU_CODE;
  
   -- 과정이 존재 한다면 ,날짜 유효성 검사 시행
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
         
   
   IF (FLAG = 0)        -- 겹칠때 에러 발생
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
   
   -- 성적 배점의 DEFAULT 값 출결:20, 실기:40, 필기:40 
   INSERT INTO TBL_OPEN_SUB(OPEN_SUB_CODE,OPEN_COU_CODE, SUB_CODE, PROF_ID, BOOK_NO, ROOM_NO, SUB_START, SUB_END, ATTE_RATIO, PRACT_RATIO, WRITE_RATIO)
   VALUES(SEQ_OPEN_SUB.NEXTVAL ,V_OPEN_COU_CODE, V_SUB_CODE, V_PROF_ID, V_BOOK_NO, V_ROOM_NO, V_SUB_START, V_SUB_END, 20, 40, 40);
   
   COMMIT;
  
  
  EXCEPTION
    WHEN USER_DEFINE_ERROR
    THEN RAISE_APPLICATION_ERROR(-20002, '존재하지않는 정보입니다.');   
    WHEN USER_DEFINE_ERROR2
    THEN RAISE_APPLICATION_ERROR(-20003, '조건에 충족하지 못 하는 기간입니다.');
    WHEN USER_DEFINE_ERROR3
    THEN RAISE_APPLICATION_ERROR(-20004, '존재하는 정보입니다');
  

END;
--==>> Procedure TBL_OPEN_SUB_INSERT이(가) 컴파일되었습니다.



--============================================================================
--○ 개설강의 폐쇄

CREATE OR REPLACE PROCEDURE DROP_COU_INSERT
( V_OPEN_COU_CODE   IN  TBL_OPEN_COU.OPEN_COU_CODE%TYPE   
)
IS
    V_NUM NUMBER;
    USER_DEFINE_ERROR EXCEPTION;
    
     V_COU_START    TBL_OPEN_COU.COU_START%TYPE;              -- 개설 과정 시작일
     V_COU_END        TBL_OPEN_COU.COU_END%TYPE;                     -- 개설 과정 종료일
     
     USER_DEFINE_ERROR2 EXCEPTION;                                             -- 일자에 관련된 익셉션 
    
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
    
    IF( SYSDATE < V_COU_START OR SYSDATE>  V_COU_END)       -- 현재 날짜가 시작날보다 자
    THEN RAISE USER_DEFINE_ERROR2;
    END IF;
    
    INSERT INTO TBL_DROP_COU (DROP_COU_CODE, OPEN_COU_CODE) VALUES (SEQ_DROP_COU.NEXTVAL, V_OPEN_COU_CODE);
    
    EXCEPTION
    WHEN USER_DEFINE_ERROR
    THEN RAISE_APPLICATION_ERROR(-20004, '존재하는 정보입니다');
    WHEN USER_DEFINE_ERROR2
    THEN RAISE_APPLICATION_ERROR(-20003, '조건에 충족하지 못 하는 기간입니다.');
    
END;
--==>> Procedure DROP_COU_INSERT(가) 컴파일되었습니다.

--=======================================================================

--○ 교재등록 
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
    THEN RAISE_APPLICATION_ERROR(-20004, '존재하는 정보입니다');
END;
--==>> Procedure TBL_TEXTBOOK_INSERT(가) 컴파일되었습니다.

--=========================================================
--○ 성적 정보 입력 프로시저 

CREATE OR REPLACE PROCEDURE TBL_GRADE_INSERT
( V_APPLY_COU_CODE IN TBL_APPLY_COU.APPLY_COU_CODE%TYPE --수강코드
, V_OPEN_SUB_CODE IN TBL_OPEN_SUB.OPEN_SUB_CODE%TYPE --개설과목코드
)
IS
     V_ATTENDANCE TBL_GRADE.ATTENDANCE%TYPE := 0; --출결 --> 성적의 디폴트값 0
     V_PRACTICAL TBL_GRADE.PRACTICAL%TYPE :=0 ; --실기
     V_WRITE TBL_GRADE.WRITE%TYPE := 0; --필기
    USER_DEFINE_ERROR EXCEPTION; --예외처리
    USER_DEFINE_ERROR2 EXCEPTION; --예외처리
    CUR_APPLY_COU_CODE  TBL_APPLY_COU.APPLY_COU_CODE%TYPE; --커서에 넣을 수강코드
    CUR_OPEN_SUB_CODE  TBL_OPEN_SUB.OPEN_SUB_CODE%TYPE; --커서에 넣을 개설과목코드
    FLAG NUMBER :=0; --거짓
    V_GR_AP TBL_GRADE.APPLY_COU_CODE%TYPE; --(성적 테이블의 데이터)커서에 넣을 수강코드
    V_GR_SUB TBL_GRADE.OPEN_SUB_CODE%TYPE ;--(성적 테이블의 데이터)커서에 넣을 개설과목코드
    
    CURSOR CUR_AP IS       -- 수강코드
    SELECT APPLY_COU_CODE
    FROM TBL_APPLY_COU;
    
    CURSOR CUR_SUB IS      -- 개설과목코드
    SELECT OPEN_SUB_CODE
    FROM TBL_OPEN_SUB;
    
    CURSOR CUR_GR IS      -- 성적테이블에 같은 수강코드와 개설과목코드가 존재하는지 판별
    SELECT APPLY_COU_CODE,OPEN_SUB_CODE
    FROM TBL_GRADE;

    
BEGIN
    OPEN CUR_AP;      -- 입력하려는 수강코드가 존재하는지 여부
    LOOP
    FETCH CUR_AP INTO CUR_APPLY_COU_CODE;
      IF(CUR_APPLY_COU_CODE = V_APPLY_COU_CODE)
      THEN FLAG :=1; --참
      END IF;
    EXIT WHEN CUR_AP%NOTFOUND; 
    END LOOP;
    CLOSE CUR_AP;
    
    IF(FLAG=0) -- 수강코드가 존재하지않으면
    THEN 
    RAISE USER_DEFINE_ERROR;
    END IF;
    
    FLAG :=0;
    
    OPEN CUR_SUB;      -- 입력하려는 개설과목코드가 존재하는지 여부
    LOOP
    FETCH CUR_SUB INTO CUR_OPEN_SUB_CODE;
      IF(CUR_OPEN_SUB_CODE = V_OPEN_SUB_CODE)
      THEN FLAG :=1; --참
      END IF;
    EXIT WHEN CUR_SUB%NOTFOUND; 
    END LOOP;
    CLOSE CUR_SUB;
    
    IF(FLAG=0) --  -- 개설과목코드가 존재하지않으면
    THEN 
    RAISE USER_DEFINE_ERROR;
    END IF;
    
    FLAG :=0;
    
    
 --테이블에 현재 넣으려는 정보가 같으면 에러발생 
 
    OPEN CUR_GR;      -- 입력하려는 개설과목코드가 존재하는지 여부
    LOOP
    FETCH CUR_GR INTO V_GR_AP,V_GR_SUB;
    IF(V_GR_AP = V_APPLY_COU_CODE AND V_GR_SUB=V_OPEN_SUB_CODE) 
    THEN FLAG :=1; --참
    END IF;
    EXIT WHEN CUR_GR%NOTFOUND; 
    END LOOP;
    CLOSE CUR_GR;
    
    IF(FLAG=1) -- 성적테이블에 같은 데이터가 존재한다면 에러발생
    THEN 
    RAISE USER_DEFINE_ERROR2;
    END IF;
    

    INSERT INTO TBL_GRADE(GRADE_CODE,APPLY_COU_CODE,OPEN_SUB_CODE,ATTENDANCE,PRACTICAL,WRITE)--시퀀스,수강코드,개설과목코드, 출결, 실기, 필기
    VALUES(SEQ_TBL_GRADE.NEXTVAL,V_APPLY_COU_CODE,V_OPEN_SUB_CODE,V_ATTENDANCE,V_PRACTICAL,V_WRITE);

    COMMIT;
    
    EXCEPTION
    WHEN USER_DEFINE_ERROR
    THEN RAISE_APPLICATION_ERROR(-20002, '존재하지않는 정보입니다.'); 
    WHEN USER_DEFINE_ERROR2
    THEN RAISE_APPLICATION_ERROR(-20004, '존재하는 정보입니다');
    
END;
--==>> Procedure TBL_GRADE_INSERT(가) 컴파일되었습니다.

--==========================================================================
--○중도탈락 프로시저
CREATE OR REPLACE PROCEDURE TBL_DROP_STU_INSERT
( V_APPLY_COU_CODE IN TBL_APPLY_COU.APPLY_COU_CODE%TYPE
)
IS
    CUR_APPLY_COU_CODE  TBL_APPLY_COU.APPLY_COU_CODE%TYPE; --커서에 넣을코드
    V_DROP_DATE TBL_DROP_STU.DROP_DATE%TYPE := SYSDATE;
    USER_DEFINE_ERROR EXCEPTION;
    USER_DEFINE_ERROR2 EXCEPTION; --예외처리
    USER_DEFINE_ERROR3 EXCEPTION;
    
    FLAG NUMBER :=0; --거짓
    V_CUR_STU TBL_APPLY_COU.APPLY_COU_CODE%TYPE; --(중도탈락 테이블에 같은 학생이 존재하는지 판별)커서에 넣을 변수
    
    CURSOR CUR IS      
    SELECT APPLY_COU_CODE
    FROM TBL_APPLY_COU;
      
    CURSOR CUR_STU IS      -- 중도탈락 테이블에 같은 수강코드가 존재하는지 판별
    SELECT APPLY_COU_CODE
    FROM TBL_DROP_STU;
    
    V_OPEN_COU_START    TBL_OPEN_COU.COU_START%TYPE;
    V_OPEN_COU_END      TBL_OPEN_COU.COU_END%TYPE;

BEGIN
   
    
    
    OPEN CUR;
    
    LOOP
    FETCH CUR INTO CUR_APPLY_COU_CODE;
      IF(CUR_APPLY_COU_CODE = V_APPLY_COU_CODE)
      THEN FLAG :=1; --참
      END IF;
    --반복해서 처리할 부분
    EXIT WHEN CUR%NOTFOUND; 
    END LOOP;


    IF(FLAG=0)
    THEN 
    RAISE USER_DEFINE_ERROR;
    END IF;
    
    FLAG:=0;
        
        
 --테이블에 현재 넣으려는 정보가 같으면 에러발생 
 
    OPEN CUR_STU;     
    LOOP
    FETCH CUR_STU INTO V_CUR_STU;
    IF(V_CUR_STU=V_APPLY_COU_CODE) 
    THEN FLAG :=1; --참
    END IF;
    EXIT WHEN CUR_STU%NOTFOUND; 
    END LOOP;
    CLOSE CUR_STU;
    
    
    IF(FLAG=1) -- 성적테이블에 같은 데이터가 존재한다면 에러발생
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
    THEN RAISE_APPLICATION_ERROR(-20002, '존재하지않는 정보입니다.'); 
    WHEN USER_DEFINE_ERROR2
    THEN RAISE_APPLICATION_ERROR(-20004, '존재하는 정보입니다');
    WHEN USER_DEFINE_ERROR3
    THEN RAISE_APPLICATION_ERROR(-20003, '조건에 충족하지 못 하는 기간입니다.');
    
END;
--==>> Procedure TBL_DROP_STU_INSERT(가) 컴파일되었습니다.

--○ 수강신청 프로시저

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
 
 -- 커서 변수 선언
 CURSOR OPEN_SUB_CUR
 IS 
 SELECT OPEN_SUB_CODE
 FROM TBL_OPEN_SUB
 WHERE OPEN_COU_CODE = V_OPEN_COU_CODE;
 
 V_APPLY_COU_CODE TBL_APPLY_COU.APPLY_COU_CODE%TYPE;
 
BEGIN

     -- 개설 과정 존재 여부  
     SELECT COUNT(*) INTO FLAG   
     FROM TBL_OPEN_COU
     WHERE OPEN_COU_CODE =V_OPEN_COU_CODE;
     -- 에러 처리
     IF(FLAG = 0)
     THEN RAISE USER_DEFINE_ERROR;
     END IF;
     
     -- 학번 존재 여부
     SELECT COUNT(*) INTO FLAG   
     FROM TBL_STU
     WHERE STU_ID =V_STU_ID;
     -- 에러 처리
     IF(FLAG = 0)
     THEN RAISE USER_DEFINE_ERROR;
     END IF;
     
     -- 학번, 개설과정이 중복 되는 경우
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
 THEN RAISE_APPLICATION_ERROR(-20002, '존재하지 않는 정보입니다.');
 WHEN USER_DEFINE_ERROR2
 THEN RAISE_APPLICATION_ERROR(-20004, '존재 하는 정보입니다.');
 WHEN OTHERS
 THEN ROLLBACK;
 
END;
--==>> Procedure TBL_APPLY_COU_INSERT이(가) 컴파일되었습니다.