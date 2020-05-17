--○ 관리자는 교수정보를 삭제한다.
-- 교수이름, 교수비밀번호
DELETE
FROM TBL_PROF
WHERE PROF_ID='choi123';

--○ 관리자는 학생의 정보를 삭제한다.
-- 학생이름, 학생비밀번호
DELETE
FROM TBL_STU
WHERE STU_ID='20190001';

--○ 관리자는 과정에대한 삭제가 가능하다.
-- 과정명, 과정기간 
DELETE
FROM TBL_COU
WHERE COU_CODE='1001';

--○ 관리자는 과목에대한 삭제가 가능하다.
-- 과목명, 과목기간, 교재명, 강의실명 
DELETE
FROM TBL_SUB
WHERE SUB_CODE='1003';

--○ 교수는 학생에대한 성적 정보를 삭제한다. → 1_TEAM의 정책에 따라 출결, 실기, 필기의 성적을 삭제하는것이 아닌 성적 수정으로 변경하였음(중도탈락학생은 명단에서 제외)
-- 출결, 실기, 필기의 성적 