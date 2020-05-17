SELECT *
FROM TAB;
--==========================================================================================================
--○교수자 업데이트 테스트
SELECT *
FROM TBL_PROF;

EXEC TBL_PROF_UPDATE('choi123', '최찰녕', '1023456', 'choi456');

--==========================================================================================================
--○학생 업데이트 테스트
SELECT *
FROM TBL_STU;
--==>> 20200002	길동뀨	77777777	1122334


EXEC TBL_STU_UPDATE('20200002', '길동뀨', '77777777','1122334');
--==========================================================================================================

--○성적 업데이트 테스트 
SELECT *
FROM TBL_GRADE;
--==>> 1000	1000	1000	0	0	0
--UPDATE후
--==>> 1000	1000	1000	20	40	39


EXEC TBL_GRADE_UPDATE(1000, 20, 40, 39);

--==========================================================================================================
--○개설과정 업데이트 
SELECT *
FROM TBL_OPEN_COU;
--==>> 1002	1003	20/05/12	20/09/12
--==>> (잘바뀜) 1002	1004	20/05/12	20/12/24
--==>> (잘바뀜) 1002	1004	20/05/12	20/09/12

SELECT *
FROM TBL_COU;
 

EXEC TBL_OPEN_COU_UPDATE(1000, '모바일 앱 개발자 양성과정',TO_DATE('2019-08-12', 'YYYY-MM-DD'), TO_DATE('2019-12-12', 'YYYY-MM-DD') );
--==>> 에러발생 
--(ORA-20003: 조건에 충족하지 못 하는 기간입니다.)  => 에러발생 정상

EXEC TBL_OPEN_COU_UPDATE(1002, '모바일 앱 개발자 양성과정',TO_DATE('2020-05-12', 'YYYY-MM-DD'), TO_DATE('2020-09-12', 'YYYY-MM-DD') );

--==========================================================================================================

--○개설과목 업데이트 
--개설과목시작전 교수,과목,개설과정코드 바꿀 수 있는 UPDATE문
CREATE OR REPLACE PROCEDURE TBL_OPEN_SUB_UPDATE1
( V_OPEN_SUB_CODE IN TBL_OPEN_SUB.OPEN_SUB_CODE%TYPE
, V_OPEN_COU_CODE IN TBL_OPEN_COU.OPEN_COU_CODE%TYPE
, V_SUB_NAME IN TBL_SUB.SUB_NAME%TYPE
, V_PROF_ID IN TBL_PROF.PROF_ID%TYPE
)

SELECT *
FROM TBL_OPEN_SUB;
SELECT *
FROM TBL_SUB
WHERE SUB_CODE = 1004;

SELECT *
FROM TBL_OPEN_COU;

SELECT *
FROM TBL_PROF;


--==>> 1006	1001	1003	choi123	1019	301	20/04/19	20/05/18	20	40	40

EXEC TBL_OPEN_SUB_UPDATE1(1006, 1001, 'DB', 'choi123');
--==>> 에러 발생
-- (ORA-20004: 존재하는 정보입니다) --정상
EXEC TBL_OPEN_SUB_UPDATE1(1006, 1001, '안드로이드', 'choi123'); --실행 성공
--==>> 1006	1001	1002	choi123	1019	301	20/04/30	20/05/30	30	40	30


-- 과목시작일, 과목종료일 UPDATE2문
EXEC TBL_OPEN_SUB_UPDATE2(1006, 1001, TO_DATE('2020-04-30', 'YYYY-MM-DD'), TO_DATE('2020-05-30', 'YYYY-MM-DD'));
--==>> 1006	1001	1003	choi123	1019	301	20/04/30	20/05/30	20	40	40 변경 성공



--교수가 출결배점, 실기배점, 필기배점 UPDATE3문
EXEC TBL_OPEN_SUB_UPDATE3(1006, 30,40,30);

SELECT *
FROM TBL_OPEN_SUB;
--==>> 1006	1001	1003	choi123	1019	301	20/04/30	20/05/30	30	40	30






