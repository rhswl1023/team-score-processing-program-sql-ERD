
--관리자
--○ 관리자는 등록된 모든 교수자의 정보출력                       
--1) 교수자명, 배정된과목명, 과목기간, 교재명, 강의실, 강의진행여부

SELECT *
FROM VIEW_PROF_PRINT
ORDER BY 1;


--○ 관리자는 등록된 모든 과정 정보를 출력할수있어야한다.   
--2) 과정명, 강의실, 과목명, 과목기간, 교재명, 교수자명 
                      
SELECT *
FROM VIEW_COU_PRINT;



--○ 관리자는 등록된 모든 학생 정보를 출력할 수 있어야한다.   
--3) 학생이름, 과정명, 수강과목, 수강과목 총점 (중도탈락이 아닌학생들만) 

SELECT *
FROM VIEW_STU;

    
--○ 관리자는 중도탈락 사실을 확인할 조회를 해야한다
--4) 중탈과목, 중도탈락한 학생 명단, 중도탈락한 날짜 

SELECT *
FROM VIEW_DROP_STU;

            
            
            
            
--교수
--○ 교수는 자신이 강의한 과목에 대한 성적을 최종적으로 출력하여 볼수있어야한다.
--1) 과목명, 과목기간, 교재명, 학생명, 출결, 실기, 필기, 총점, 등수(모든학생정보, 중탈자도 이미 수강했으면 출력 )
/*
SELECT *
FROM VIEW_PROF_STU_PRINT;
-->전체 교수가 나오는 뷰
*/
--이를 통해 프로시저 생성 후 교수코드를 입력받아 자신이 강의한 과목에 대한 성적만 보여줌
SET SERVEROUTPUT ON;
EXEC  PRC_PROF_NAME_PRINT('choi123');



--학생 
--○ 학생은 수강한 과목의 성적을 확인할수있어야한다()
--1) 학생이름, 과정명, 과목명, 교육기간, 교재명, 출결,실기,필기,총점,등수 (본인의 정보만, 여러개를 들었을시에는 여러과목이 나옴 ) 

/*
SELECT *
FROM VIEW_STU_GRADE;
-->전체 학생이 나오는 뷰
*/
--이를 통해 프로시저 생성 후 학생번호를 입력받아 자신이 수강한 과목에 대한 성적만 보여줌
EXEC PRC_STU_NAME_PRINT('20200001');
  
 --===============================================================================--
  
 --○관리자
--1) 관리자가 등록된 모든 교수자의 정보를 볼 수 있는 뷰
CREATE OR REPLACE VIEW VIEW_PROF_PRINT
AS
SELECT A.교수자명, B.배정된과목명, B.과목시작일, B.과목종료일
      , A.교재명, A.강의실번호, B.강의진행상황
FROM
(   SELECT B.PROF_NAME "교수자명" , C.BOOK_NAME "교재명" 
          , A.ROOM_NO "강의실번호" , A.OPEN_SUB_CODE
    FROM TBL_OPEN_SUB A LEFT JOIN TBL_PROF B
          ON A.PROF_ID = B.PROF_ID
          JOIN TBL_TEXTBOOK C
          ON C.BOOK_NO = A.BOOK_NO
)A
LEFT JOIN
(
SELECT A.OPEN_SUB_CODE , D.SUB_NAME "배정된과목명" , A.SUB_START "과목시작일", A.SUB_END "과목종료일"
      , CASE WHEN B.DROP_COU_CODE IS NOT NULL THEN '폐강'
        ELSE
            CASE WHEN SYSDATE BETWEEN A.SUB_START AND A.SUB_END THEN '진행 중'
                 WHEN A.SUB_END < SYSDATE THEN '진행 종료'
                 WHEN A.SUB_START > SYSDATE THEN '진행 예정'
            END
        END "강의진행상황"
FROM TBL_OPEN_SUB A LEFT JOIN TBL_DROP_COU B
ON A.OPEN_COU_CODE = B.OPEN_COU_CODE
                     LEFT JOIN TBL_OPEN_COU C
                     ON C.OPEN_COU_CODE = A.OPEN_COU_CODE
                     JOIN TBL_SUB D
                     ON D.SUB_CODE = A.SUB_CODE
)B
ON A.OPEN_SUB_CODE =  B.OPEN_SUB_CODE;




--2) 관리자가 등록된 모든 과정 정보를 볼 수 있는 뷰
CREATE OR REPLACE VIEW VIEW_COU_PRINT
AS
SELECT C.COU_NAME "과정명" , OC.OPEN_COU_CODE "개설과정코드"
,CR.ROOM_NO "강의실"
,S.SUB_NAME "과목명"
, OS.SUB_START "과정시작일"
, OS.SUB_END "과정종료일"
, TB.BOOK_NAME "교재명"
,  P.PROF_NAME "교수자명"
FROM TBL_COU C JOIN TBL_OPEN_COU OC
            ON C.COU_CODE = OC.COU_CODE
            JOIN TBL_OPEN_SUB OS
            ON OC.OPEN_COU_CODE = OS.OPEN_COU_CODE
            JOIN TBL_CLASSROOM CR
            ON CR.ROOM_NO = OS.ROOM_NO
            JOIN TBL_TEXTBOOK TB 
            ON TB.BOOK_NO = OS.BOOK_NO
            JOIN TBL_SUB S
            ON S.SUB_CODE = OS.SUB_CODE
            JOIN TBL_PROF P
            ON P.PROF_ID = OS.PROF_ID
            LEFT JOIN TBL_DROP_COU DC
            ON DC.OPEN_COU_CODE = OC.OPEN_COU_CODE
            WHERE DC.DROP_COU_CODE IS NULL
            ORDER BY 2;
     
     COMMIT;  


select *
from VIEW_STU;
--3) 관리자가 등록된 모든 학생 정보를 볼 수 있는 뷰
CREATE OR REPLACE VIEW VIEW_STU
AS
SELECT S.STU_NAME "학생이름"
, B.COU_NAME"과정명"
, U.SUB_NAME"수강과목"
, (G.ATTENDANCE+G.PRACTICAL+G.WRITE)"수강과목 총점"
FROM TBL_STU S,TBL_OPEN_SUB O,TBL_GRADE G,TBL_SUB U,TBL_OPEN_COU C,TBL_COU B,TBL_APPLY_COU A,TBL_DROP_STU D
WHERE A.STU_ID = S.STU_ID
  AND O.OPEN_SUB_CODE = G.OPEN_SUB_CODE
  AND O.SUB_CODE = U.SUB_CODE 
  AND O.OPEN_COU_CODE = C.OPEN_COU_CODE
  AND C.COU_CODE = B.COU_CODE
  AND A. APPLY_COU_CODE= G.APPLY_COU_CODE
  AND D.APPLY_COU_CODE!=A.APPLY_COU_CODE
  ORDER BY 1;
  
  --4) 관리자가 중도탈락한 과목과 학생명단, 날짜를 볼 수 있는 뷰
CREATE OR REPLACE VIEW VIEW_DROP_STU
AS
SELECT SU.SUB_NAME "과목명", ST.STU_NAME "탈락 학생명", DROP_DATE "중도탈락날짜"
FROM TBL_DROP_STU DS JOIN TBL_APPLY_COU AC
            ON DS.APPLY_COU_CODE = AC.APPLY_COU_CODE
            JOIN TBL_STU ST
            ON ST.STU_ID = AC.STU_ID 
            JOIN TBL_OPEN_COU OC
            ON OC.OPEN_COU_CODE = AC.OPEN_COU_CODE
            JOIN TBL_OPEN_SUB OS
            ON OS.OPEN_COU_CODE = OC.OPEN_COU_CODE
            JOIN TBL_SUB SU
            ON SU.SUB_CODE = OS.SUB_CODE
            WHERE OS.SUB_END >= DS.DROP_DATE;



--○교수    

--1) 교수가 자신이 강의한 과목의 성적을 출력해서 볼 수 있는 뷰
CREATE OR REPLACE VIEW VIEW_PROF_STU_PRINT
AS
SELECT  T2.교수명,T2.교수코드,T2.과목명, T2.과목시작일, T2.과목종료일, T2.교재명, T2.학생명, T2.출결, T2.실기, T2.필기, T2.총점, 
        T2.등수
FROM
(
SELECT T.과목명, T.과목시작일, T.과목종료일, T.교재명, T.학생명, T.출결, T.실기, T.필기, (T.출결+T.실기+T.필기)"총점", T.교수명,T.교수코드,
       RANK() OVER(PARTITION BY T.개설과목코드 ORDER BY T.출결+T.실기+T.필기 DESC) "등수", T.중도탈락날짜,
       CASE WHEN T.중도탈락날짜 IS NULL
            THEN 1
            WHEN T.중도탈락날짜 > T.과목종료일 
            THEN 1
            ELSE 0
      END "출력여부"
       
FROM 
(
SELECT  F.PROF_NAME"교수명",F.PROF_ID "교수코드", DC.DROP_DATE"중도탈락날짜", DC.APPLY_COU_CODE "중도탈락수강코드",AC.APPLY_COU_CODE"수강코드",G.ATTENDANCE"출결", G.PRACTICAL"실기", G.WRITE"필기"
      , ST.STU_ID"학번",ST.STU_NAME"학생명", OS.SUB_START"과목시작일"
      , OS.SUB_END"과목종료일", S.SUB_NAME "과목명", B.BOOK_NAME "교재명", OS.OPEN_SUB_CODE "개설과목코드"
      
FROM TBL_DROP_STU DC RIGHT JOIN TBL_APPLY_COU AC
     ON DC.APPLY_COU_CODE = AC.APPLY_COU_CODE
         
     JOIN TBL_STU ST
     ON AC.STU_ID = ST.STU_ID
     
     JOIN TBL_GRADE G
     ON AC.APPLY_COU_CODE = G.APPLY_COU_CODE 
          
     JOIN TBL_OPEN_SUB OS
     ON G.OPEN_SUB_CODE = OS.OPEN_SUB_CODE
     
     JOIN TBL_SUB S
     ON OS.SUB_CODE = S.SUB_CODE
     
     JOIN TBL_TEXTBOOK B
     ON OS.BOOK_NO = B.BOOK_NO    
     
     JOIN TBL_PROF F
     ON OS.PROF_ID=F.PROF_ID
)T
)T2
WHERE T2.출력여부 != 0;
--==>> View VIEW_PROF_STU_PRINT이(가) 생성되었습니다.

--위 뷰를 활용해 프로시저 생성
--( 아래의 PRC_STU_NAME_PRINT가 먼저 생성된 이후에 만들어야한다.)
CREATE OR REPLACE PROCEDURE PRC_PROF_NAME_PRINT 
( V_PROF_ID  IN TBL_PROF.PROF_ID%TYPE
)
IS
  V_PROF_NAME TBL_STU.STU_NAME%TYPE;
  V_PROF_ID1  TBL_STU.STU_ID%TYPE;
  V_SUB_NAME TBL_SUB.SUB_NAME%TYPE;
  V_SUB_START TBL_OPEN_SUB.SUB_START%TYPE;
  V_SUB_END TBL_OPEN_SUB.SUB_END%TYPE;
  V_BOOK_NAME TBL_TEXTBOOK.BOOK_NAME%TYPE;
  V_STU_NAME TBL_STU.STU_NAME%TYPE;
  V_ATTENDANCE TBL_GRADE.ATTENDANCE%TYPE;
  V_PRACTICAL TBL_GRADE.PRACTICAL%TYPE;
  V_WRITE TBL_GRADE.WRITE%TYPE;
  V_TOT VIEW_STU_GRADE.총점%TYPE;
  V_RANK VIEW_STU_GRADE.등수%TYPE;
  
  CURSOR CUR IS      
  SELECT 교수명,교수코드,과목명, 과목시작일, 과목종료일, 교재명, 학생명, 출결, 실기, 필기, 총점, 등수
  FROM VIEW_PROF_STU_PRINT
  WHERE 교수코드=V_PROF_ID;

BEGIN
  OPEN CUR;
  
    LOOP
    FETCH CUR INTO   V_PROF_NAME,V_PROF_ID1,V_SUB_NAME ,V_SUB_START ,V_SUB_END ,V_BOOK_NAME ,V_STU_NAME,V_ATTENDANCE ,V_PRACTICAL,V_WRITE,V_TOT,V_RANK;
    DBMS_OUTPUT.PUT_LINE(V_PROF_NAME ||V_PROF_ID1 ||V_SUB_NAME ||V_SUB_START ||V_SUB_END ||V_BOOK_NAME ||V_STU_NAME||V_ATTENDANCE ||V_PRACTICAL ||V_WRITE ||V_TOT ||V_RANK);
    EXIT WHEN CUR%NOTFOUND; 
    END LOOP;
  
  CLOSE CUR;
  COMMIT;
  
END;
  


--○학생

--1) 학생이 본인이 수강한 과목의 성적을 볼 수 있는 뷰
SELECT *
FROM VIEW_STU_GRADE;

CREATE OR REPLACE VIEW VIEW_STU_GRADE
AS
SELECT S.STU_NAME "학생이름"
,S.STU_ID"학생코드"
, B.COU_NAME"과정명"
, U.SUB_NAME"과목명"
, O.SUB_START"교육시작"
, O.SUB_END "교육종료"
, X.BOOK_NAME"교재명"
,G.ATTENDANCE"출결"
,G.PRACTICAL"실기"
,G.WRITE"필기"
,(G.ATTENDANCE+G.PRACTICAL+G.WRITE)"총점"
,RANK() OVER(PARTITION BY O.OPEN_SUB_CODE ORDER BY G.ATTENDANCE+G.PRACTICAL+G.WRITE DESC)"등수"
FROM TBL_STU S,TBL_OPEN_SUB O,TBL_GRADE G,TBL_SUB U,TBL_OPEN_COU C,TBL_COU B,TBL_APPLY_COU A,TBL_DROP_STU D,TBL_TEXTBOOK X
WHERE A.STU_ID = S.STU_ID
  AND O.OPEN_SUB_CODE = G.OPEN_SUB_CODE
  AND O.SUB_CODE = U.SUB_CODE 
  AND O.OPEN_COU_CODE = C.OPEN_COU_CODE
  AND C.COU_CODE = B.COU_CODE
  AND A. APPLY_COU_CODE= G.APPLY_COU_CODE
  AND D.APPLY_COU_CODE !=A.APPLY_COU_CODE
  AND O.BOOK_NO=X.BOOK_NO
  ORDER BY 1;
  
  SELECT *
  FROM TBL_APPLY_COU;
  

--위 뷰를 활용해 프로시저 생성

CREATE OR REPLACE PROCEDURE PRC_STU_NAME_PRINT
( V_STU_ID  IN TBL_STU.STU_ID%TYPE
)
IS
  V_STU_NAME TBL_STU.STU_NAME%TYPE;
  V_STU_ID1  TBL_STU.STU_ID%TYPE;
  V_COU_NAME TBL_COU.COU_NAME%TYPE;
  V_SUB_NAME TBL_SUB.SUB_NAME%TYPE;
  V_SUB_START TBL_OPEN_SUB.SUB_START%TYPE;
  V_SUB_END TBL_OPEN_SUB.SUB_END%TYPE;
  V_BOOK_NAME TBL_TEXTBOOK.BOOK_NAME%TYPE;
  V_ATTENDANCE TBL_GRADE.ATTENDANCE%TYPE;
  V_PRACTICAL TBL_GRADE.PRACTICAL%TYPE;
  V_WRITE TBL_GRADE.WRITE%TYPE;
  V_TOT VIEW_STU_GRADE.총점%TYPE;
  V_RANK VIEW_STU_GRADE.등수%TYPE;
  
  CURSOR CUR IS      
  SELECT 학생이름,학생코드,과정명,과목명,교육시작,교육종료,교재명,출결,실기,필기,총점,등수
  FROM VIEW_STU_GRADE
  WHERE 학생코드=V_STU_ID;

BEGIN
  OPEN CUR;
  
    LOOP
    FETCH CUR INTO   V_STU_NAME,V_STU_ID1,V_COU_NAME,V_SUB_NAME ,V_SUB_START ,V_SUB_END ,V_BOOK_NAME ,V_ATTENDANCE ,V_PRACTICAL,V_WRITE,V_TOT,V_RANK;
    DBMS_OUTPUT.PUT_LINE(V_STU_NAME ||V_STU_ID1 ||V_COU_NAME ||V_SUB_NAME ||V_SUB_START ||V_SUB_END ||V_BOOK_NAME ||V_ATTENDANCE ||V_PRACTICAL ||V_WRITE ||V_TOT ||V_RANK);
    EXIT WHEN CUR%NOTFOUND; 
    END LOOP;
  
  CLOSE CUR;
  COMMIT;
  
END; 

SELECT *
FROM TBL_OPEN_COU;