
--������
--�� �����ڴ� ��ϵ� ��� �������� �������                       
--1) �����ڸ�, �����Ȱ����, ����Ⱓ, �����, ���ǽ�, �������࿩��

SELECT *
FROM VIEW_PROF_PRINT
ORDER BY 1;


--�� �����ڴ� ��ϵ� ��� ���� ������ ����Ҽ��־���Ѵ�.   
--2) ������, ���ǽ�, �����, ����Ⱓ, �����, �����ڸ� 
                      
SELECT *
FROM VIEW_COU_PRINT;



--�� �����ڴ� ��ϵ� ��� �л� ������ ����� �� �־���Ѵ�.   
--3) �л��̸�, ������, ��������, �������� ���� (�ߵ�Ż���� �ƴ��л��鸸) 

SELECT *
FROM VIEW_STU;

    
--�� �����ڴ� �ߵ�Ż�� ����� Ȯ���� ��ȸ�� �ؾ��Ѵ�
--4) ��Ż����, �ߵ�Ż���� �л� ���, �ߵ�Ż���� ��¥ 

SELECT *
FROM VIEW_DROP_STU;

            
            
            
            
--����
--�� ������ �ڽ��� ������ ���� ���� ������ ���������� ����Ͽ� �����־���Ѵ�.
--1) �����, ����Ⱓ, �����, �л���, ���, �Ǳ�, �ʱ�, ����, ���(����л�����, ��Ż�ڵ� �̹� ���������� ��� )
/*
SELECT *
FROM VIEW_PROF_STU_PRINT;
-->��ü ������ ������ ��
*/
--�̸� ���� ���ν��� ���� �� �����ڵ带 �Է¹޾� �ڽ��� ������ ���� ���� ������ ������
SET SERVEROUTPUT ON;
EXEC  PRC_PROF_NAME_PRINT('choi123');



--�л� 
--�� �л��� ������ ������ ������ Ȯ���Ҽ��־���Ѵ�()
--1) �л��̸�, ������, �����, �����Ⱓ, �����, ���,�Ǳ�,�ʱ�,����,��� (������ ������, �������� ������ÿ��� ���������� ���� ) 

/*
SELECT *
FROM VIEW_STU_GRADE;
-->��ü �л��� ������ ��
*/
--�̸� ���� ���ν��� ���� �� �л���ȣ�� �Է¹޾� �ڽ��� ������ ���� ���� ������ ������
EXEC PRC_STU_NAME_PRINT('20200001');
  
 --===============================================================================--
  
 --�۰�����
--1) �����ڰ� ��ϵ� ��� �������� ������ �� �� �ִ� ��
CREATE OR REPLACE VIEW VIEW_PROF_PRINT
AS
SELECT A.�����ڸ�, B.�����Ȱ����, B.���������, B.����������
      , A.�����, A.���ǽǹ�ȣ, B.���������Ȳ
FROM
(   SELECT B.PROF_NAME "�����ڸ�" , C.BOOK_NAME "�����" 
          , A.ROOM_NO "���ǽǹ�ȣ" , A.OPEN_SUB_CODE
    FROM TBL_OPEN_SUB A LEFT JOIN TBL_PROF B
          ON A.PROF_ID = B.PROF_ID
          JOIN TBL_TEXTBOOK C
          ON C.BOOK_NO = A.BOOK_NO
)A
LEFT JOIN
(
SELECT A.OPEN_SUB_CODE , D.SUB_NAME "�����Ȱ����" , A.SUB_START "���������", A.SUB_END "����������"
      , CASE WHEN B.DROP_COU_CODE IS NOT NULL THEN '��'
        ELSE
            CASE WHEN SYSDATE BETWEEN A.SUB_START AND A.SUB_END THEN '���� ��'
                 WHEN A.SUB_END < SYSDATE THEN '���� ����'
                 WHEN A.SUB_START > SYSDATE THEN '���� ����'
            END
        END "���������Ȳ"
FROM TBL_OPEN_SUB A LEFT JOIN TBL_DROP_COU B
ON A.OPEN_COU_CODE = B.OPEN_COU_CODE
                     LEFT JOIN TBL_OPEN_COU C
                     ON C.OPEN_COU_CODE = A.OPEN_COU_CODE
                     JOIN TBL_SUB D
                     ON D.SUB_CODE = A.SUB_CODE
)B
ON A.OPEN_SUB_CODE =  B.OPEN_SUB_CODE;




--2) �����ڰ� ��ϵ� ��� ���� ������ �� �� �ִ� ��
CREATE OR REPLACE VIEW VIEW_COU_PRINT
AS
SELECT C.COU_NAME "������" , OC.OPEN_COU_CODE "���������ڵ�"
,CR.ROOM_NO "���ǽ�"
,S.SUB_NAME "�����"
, OS.SUB_START "����������"
, OS.SUB_END "����������"
, TB.BOOK_NAME "�����"
,  P.PROF_NAME "�����ڸ�"
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
--3) �����ڰ� ��ϵ� ��� �л� ������ �� �� �ִ� ��
CREATE OR REPLACE VIEW VIEW_STU
AS
SELECT S.STU_NAME "�л��̸�"
, B.COU_NAME"������"
, U.SUB_NAME"��������"
, (G.ATTENDANCE+G.PRACTICAL+G.WRITE)"�������� ����"
FROM TBL_STU S,TBL_OPEN_SUB O,TBL_GRADE G,TBL_SUB U,TBL_OPEN_COU C,TBL_COU B,TBL_APPLY_COU A,TBL_DROP_STU D
WHERE A.STU_ID = S.STU_ID
  AND O.OPEN_SUB_CODE = G.OPEN_SUB_CODE
  AND O.SUB_CODE = U.SUB_CODE 
  AND O.OPEN_COU_CODE = C.OPEN_COU_CODE
  AND C.COU_CODE = B.COU_CODE
  AND A. APPLY_COU_CODE= G.APPLY_COU_CODE
  AND D.APPLY_COU_CODE!=A.APPLY_COU_CODE
  ORDER BY 1;
  
  --4) �����ڰ� �ߵ�Ż���� ����� �л����, ��¥�� �� �� �ִ� ��
CREATE OR REPLACE VIEW VIEW_DROP_STU
AS
SELECT SU.SUB_NAME "�����", ST.STU_NAME "Ż�� �л���", DROP_DATE "�ߵ�Ż����¥"
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



--�۱���    

--1) ������ �ڽ��� ������ ������ ������ ����ؼ� �� �� �ִ� ��
CREATE OR REPLACE VIEW VIEW_PROF_STU_PRINT
AS
SELECT  T2.������,T2.�����ڵ�,T2.�����, T2.���������, T2.����������, T2.�����, T2.�л���, T2.���, T2.�Ǳ�, T2.�ʱ�, T2.����, 
        T2.���
FROM
(
SELECT T.�����, T.���������, T.����������, T.�����, T.�л���, T.���, T.�Ǳ�, T.�ʱ�, (T.���+T.�Ǳ�+T.�ʱ�)"����", T.������,T.�����ڵ�,
       RANK() OVER(PARTITION BY T.���������ڵ� ORDER BY T.���+T.�Ǳ�+T.�ʱ� DESC) "���", T.�ߵ�Ż����¥,
       CASE WHEN T.�ߵ�Ż����¥ IS NULL
            THEN 1
            WHEN T.�ߵ�Ż����¥ > T.���������� 
            THEN 1
            ELSE 0
      END "��¿���"
       
FROM 
(
SELECT  F.PROF_NAME"������",F.PROF_ID "�����ڵ�", DC.DROP_DATE"�ߵ�Ż����¥", DC.APPLY_COU_CODE "�ߵ�Ż�������ڵ�",AC.APPLY_COU_CODE"�����ڵ�",G.ATTENDANCE"���", G.PRACTICAL"�Ǳ�", G.WRITE"�ʱ�"
      , ST.STU_ID"�й�",ST.STU_NAME"�л���", OS.SUB_START"���������"
      , OS.SUB_END"����������", S.SUB_NAME "�����", B.BOOK_NAME "�����", OS.OPEN_SUB_CODE "���������ڵ�"
      
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
WHERE T2.��¿��� != 0;
--==>> View VIEW_PROF_STU_PRINT��(��) �����Ǿ����ϴ�.

--�� �並 Ȱ���� ���ν��� ����
--( �Ʒ��� PRC_STU_NAME_PRINT�� ���� ������ ���Ŀ� �������Ѵ�.)
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
  V_TOT VIEW_STU_GRADE.����%TYPE;
  V_RANK VIEW_STU_GRADE.���%TYPE;
  
  CURSOR CUR IS      
  SELECT ������,�����ڵ�,�����, ���������, ����������, �����, �л���, ���, �Ǳ�, �ʱ�, ����, ���
  FROM VIEW_PROF_STU_PRINT
  WHERE �����ڵ�=V_PROF_ID;

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
  


--���л�

--1) �л��� ������ ������ ������ ������ �� �� �ִ� ��
SELECT *
FROM VIEW_STU_GRADE;

CREATE OR REPLACE VIEW VIEW_STU_GRADE
AS
SELECT S.STU_NAME "�л��̸�"
,S.STU_ID"�л��ڵ�"
, B.COU_NAME"������"
, U.SUB_NAME"�����"
, O.SUB_START"��������"
, O.SUB_END "��������"
, X.BOOK_NAME"�����"
,G.ATTENDANCE"���"
,G.PRACTICAL"�Ǳ�"
,G.WRITE"�ʱ�"
,(G.ATTENDANCE+G.PRACTICAL+G.WRITE)"����"
,RANK() OVER(PARTITION BY O.OPEN_SUB_CODE ORDER BY G.ATTENDANCE+G.PRACTICAL+G.WRITE DESC)"���"
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
  

--�� �並 Ȱ���� ���ν��� ����

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
  V_TOT VIEW_STU_GRADE.����%TYPE;
  V_RANK VIEW_STU_GRADE.���%TYPE;
  
  CURSOR CUR IS      
  SELECT �л��̸�,�л��ڵ�,������,�����,��������,��������,�����,���,�Ǳ�,�ʱ�,����,���
  FROM VIEW_STU_GRADE
  WHERE �л��ڵ�=V_STU_ID;

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