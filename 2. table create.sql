--�� �������� VIEW ����
CREATE OR REPLACE VIEW VIEW_CONSTCHECK
AS
SELECT UC.OWNER "OWNER"
        , UC.CONSTRAINT_NAME "CONSTRAINT_NAME"
        , UC.TABLE_NAME "TABLE_NAME"
        , UC. CONSTRAINT_TYPE "CONSTRAINT_TYPE"
        , UCC.COLUMN_NAME "COLUMN_NAME"
        , UC.SEARCH_CONDITION " SEARCH_CONDITION"
        , UC.DELETE_RULE "DELETE_RULE"
FROM USER_CONSTRAINTS UC JOIN USER_CONS_COLUMNS UCC
ON UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME;
--==>>View VIEW_CONSTCHECK��(��) �����Ǿ����ϴ�.

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- [�� ���̺� ����] 

--�� ������ ���̺� ����
CREATE TABLE ADMIN
( ADMIN_ID   VARCHAR2(10) 
, PW               VARCHAR2(20) 

, CONSTRAINT ADMIN_ADMIN_ID_PK PRIMARY KEY (ADMIN_ID)
, CONSTRAINT ADMIN_PW_NN            CHECK(PW IS NOT NULL)
, CONSTRAINT ADMIN_PW_CK            CHECK (PW LIKE '_______%')
);
--==>> Table ADMIN��(��) �����Ǿ����ϴ�.
DESC ADMIN;
--==>>
/*
�̸�       ��?       ����           
-------- -------- ------------ 
ADMIN_ID NOT NULL VARCHAR2(10) 
PW                VARCHAR2(20) 
*/

--===============================================================

--�� ������ ���̺� ����
CREATE TABLE TBL_PROF
( PROF_ID           VARCHAR2(10) 
, PROF_NAME    VARCHAR2(20)
, PROF_PW         VARCHAR2(20)
, PROF_SSN        CHAR(7)        

, CONSTRAINT PROF_PROF_ID_PK          PRIMARY KEY(PROF_ID)
, CONSTRAINT PROF_PROF_NAME_NN CHECK (PROF_NAME IS NOT NULL)
, CONSTRAINT PROF_PROF_PW_NN      CHECK (PROF_PW IS NOT NULL)
, CONSTRAINT PROF_PROF_PW_CK      CHECK (PROF_PW LIKE '_______%')
, CONSTRAINT PROF_PROF_SSN_NN     CHECK (PROF_SSN IS NOT NULL)
, CONSTRAINT PROF_PROF_SSN_CK     CHECK (PROF_SSN LIKE '_______')
);
--==>> Table TBL_PROF��(��) �����Ǿ����ϴ�.
DESC TBL_PROF;
--==>> 
/*
�̸�        ��        ����           
--------- -------- ------------ 
PROF_ID   NOT NULL VARCHAR2(10) 
PROF_NAME          VARCHAR2(20) 
PROF_PW            VARCHAR2(20) 
PROF_SSN           CHAR(7)   
*/
--===============================================================


--�� �л� ���̺� ����
CREATE TABLE TBL_STU
( STU_ID             VARCHAR2(10)
, STU_NAME      VARCHAR2(20)
, STU_PW           VARCHAR2(20)
, STU_SSN          CHAR(7)
, CONSTRAINT STU_STU_ID_PK          PRIMARY KEY(STU_ID)
, CONSTRAINT STU_STU_NAME_NN  CHECK (STU_NAME IS NOT NULL)
, CONSTRAINT STU_STU_PW_NN       CHECK (STU_PW IS NOT NULL)
, CONSTRAINT STU_STU_PW_CK        CHECK (STU_PW LIKE '_______%')
, CONSTRAINT STU_STU_SSN_NN      CHECK (STU_SSN IS NOT NULL)
, CONSTRAINT STU_STU_SSN_CK       CHECK (STU_SSN LIKE '_______')
);
--==>> Table TBL_STU��(��) �����Ǿ����ϴ�.
DESC TBL_STU;
--==>>
/*
�̸�       ��        ����           
-------- -------- ------------ 
STU_ID   NOT NULL VARCHAR2(10) 
STU_NAME          VARCHAR2(20) 
STU_PW            VARCHAR2(20) 
STU_SSN           CHAR(7)    
*/
--===============================================================
--�� ���� ������ ����
CREATE SEQUENCE SEQ_SUB 
INCREMENT BY 1
START WITH 1000
NOMAXVALUE
NOCACHE
;
--==>> Sequence SEQ_SUB��(��) �����Ǿ����ϴ�.

--�� ���� ���̺� ����
CREATE TABLE TBL_SUB
( SUB_CODE     NUMBER(4)       
, SUB_NAME    VARCHAR2(20)
, CONSTRAINT SUB_SUB_CODE_PK   PRIMARY KEY(SUB_CODE)
, CONSTRAINT SUB_SUB_NAME_NN CHECK(SUB_NAME IS NOT NULL)
,CONSTRAINT SUB_SUB_NAME_UK   UNIQUE(SUB_NAME)
);
--SUB_CODE �� INSERT�ÿ� ������ ������ SEQ_SUB.NEXTVAL�� �־��ش�.
--==>> Table TBL_SUB��(��) �����Ǿ����ϴ�.


DESC TBL_SUB;
/*
�̸�       ��        ����           
-------- -------- ------------ 
SUB_CODE NOT NULL NUMBER(4)    
SUB_NAME          VARCHAR2(20) 

*/

--===============================================================
--�� ���� ������ ����
CREATE SEQUENCE SEQ_COU
INCREMENT BY 1
START WITH 1000
NOMAXVALUE
NOCACHE
;
--==>> Sequence SEQ_COU��(��) �����Ǿ����ϴ�.


--�� ���� ���̺� ����
CREATE TABLE TBL_COU
( COU_CODE     NUMBER(4)
, COU_NAME    VARCHAR2(50)
, CONSTRAINT COU_COU_CODE_PK   PRIMARY KEY(COU_CODE)
, CONSTRAINT COU_COU_NAME_NN  CHECK(COU_NAME IS NOT NULL)
, CONSTRAINT COU_COU_NAME_UK  UNIQUE(COU_NAME)
);
--==>> Table TBL_COU��(��) �����Ǿ����ϴ�.


DESC TBL_COU;
/*
�̸�       ��        ����           
-------- -------- ------------ 
COU_CODE NOT NULL NUMBER(4)    
COU_NAME          VARCHAR2(30)

*/
--===============================================================
--�� ���� ������ ����
CREATE SEQUENCE SEQ_TEXTBOOK
INCREMENT BY 1
START WITH 1000
NOMAXVALUE
NOCACHE
;
--==>> Sequence SEQ_TEXTBOOK��(��) �����Ǿ����ϴ�.


--�� ���� ���̺� ����
CREATE TABLE TBL_TEXTBOOK
( BOOK_NO       NUMBER(4)
, BOOK_NAME  VARCHAR2(50)
, CONSTRAINT TEXTBOOK_BOOK_NO_PK       PRIMARY KEY(BOOK_NO)
, CONSTRAINT TEXTBOOK_BOOK_NAME_NN CHECK(BOOK_NAME IS NOT NULL)
, CONSTRAINT TEXTBOOK_BOOK_NAME_UK UNIQUE(BOOK_NAME)
);
--==>> Table TBL_TEXTBOOK��(��) �����Ǿ����ϴ�.




DESC TBL_TEXTBOOK;
/*
�̸�        ��        ����           
--------- -------- ------------ 
BOOK_NO   NOT NULL NUMBER(4)    
BOOK_NAME          VARCHAR2(30) 

*/

--===============================================================


CREATE TABLE TBL_CLASSROOM
( ROOM_NO       NUMBER(4)
, ROOM_DATA   VARCHAR2(30)
, CONSTRAINT CLASSROOM_ROOM_NO_PK      PRIMARY KEY(ROOM_NO)
, CONSTRAINT CLASSROOM_ROOM_DATA_NN CHECK(ROOM_DATA IS NOT NULL)
);
--==>> Table TBL_CLASSROOM��(��) �����Ǿ����ϴ�.

DESC TBL_CLASSROOM;

/*
�̸�        ��        ����           
--------- -------- ------------ 
ROOM_NO   NOT NULL NUMBER(4)    
ROOM_DATA          VARCHAR2(30) 

*/

--===============================================================
--�� �������� ������ ����
CREATE SEQUENCE SEQ_OPEN_COU
INCREMENT BY 1
START WITH 1000
NOMAXVALUE
NOCACHE
;

--==>> Sequence SEQ_OPEN_COU��(��) �����Ǿ����ϴ�.
--�� �������� ���̺� ����

CREATE TABLE TBL_OPEN_COU
( OPEN_COU_CODE NUMBER(4)
, COU_CODE             NUMBER(4)
, COU_START            DATE
, COU_END                DATE
, CONSTRAINT OPEN_COU_OPEN_COU_CODE_PK PRIMARY KEY(OPEN_COU_CODE)
, CONSTRAINT OPEN_COU_COU_CODE_NN           CHECK(COU_CODE IS NOT NULL)
, CONSTRAINT OPEN_COU_COU_START_NN          CHECK(COU_START IS NOT NULL)
, CONSTRAINT OPEN_COU_COU_END_NN              CHECK(COU_END IS NOT NULL)
, CONSTRAINT OPEN_COU_DATE_INTERVAL         CHECK(COU_END > COU_START)
, CONSTRAINT OPEN_COU_COU_CODE_FK           FOREIGN KEY(COU_CODE)
                                               REFERENCES TBL_COU(COU_CODE)
                                               ON DELETE CASCADE
);
--==>> Table TBL_OPEN_COU��(��) �����Ǿ����ϴ�.

DESC TBL_OPEN_COU;
/*
�̸�            ��        ����        
------------- -------- --------- 
OPEN_COU_CODE NOT NULL NUMBER(4) 
COU_CODE               NUMBER(4) 
COU_START              DATE      
COU_END                DATE     
*/
--===============================================================

--�� ���������Ȳ ������ ����
CREATE SEQUENCE SEQ_DROP_COU
INCREMENT BY 1
START WITH 1000
NOMAXVALUE
NOCACHE
;
--==>> Sequence SEQ_DROP_COU��(��) �����Ǿ����ϴ�.

--�� ���������Ȳ ���̺� ����
CREATE TABLE TBL_DROP_COU
( DROP_COU_CODE     NUMBER(4)
, OPEN_COU_CODE     NUMBER(4)
, DROP_COU_DATE     DATE        DEFAULT SYSDATE

, CONSTRAINT DROP_COU_DR_C_CODE_PK  PRIMARY KEY(DROP_COU_CODE)
, CONSTRAINT DROP_COU_OP_C_CODE_NN CHECK(OPEN_COU_CODE IS NOT NULL)
, CONSTRAINT DROP_COU_DR_C_DATE_NN  CHECK(DROP_COU_DATE IS NOT NULL)
, CONSTRAINT DROP_COU_OP_C_CODE_FK  FOREIGN KEY(OPEN_COU_CODE)
                                               REFERENCES TBL_OPEN_COU(OPEN_COU_CODE)
                                               ON DELETE CASCADE
);
--==>> Table TBL_DROP_COU��(��) �����Ǿ����ϴ�.

DESC TBL_DROP_COU;
/*
�̸�            ��        ����        
------------- -------- --------- 
DROP_COU_CODE NOT NULL NUMBER(4) 
OPEN_COU_CODE          NUMBER(4) 
DROP_COU_DATE          DATE
*/


--===============================================================
--�� ������û ������ ����
CREATE SEQUENCE SEQ_APPLY_COU
INCREMENT BY 1
START WITH 1000
NOMAXVALUE
NOCACHE
; 
--�� ������û ���̺� ����
CREATE TABLE TBL_APPLY_COU
( APPLY_COU_CODE    NUMBER(4)
, OPEN_COU_CODE     NUMBER(4)
, STU_ID                        VARCHAR2(10)
, APPLY_DATE      DATE        DEFAULT SYSDATE

, CONSTRAINT APPLY_COU_AP_C_C_PK       PRIMARY KEY(APPLY_COU_CODE)
, CONSTRAINT APPLY_COU_OP_C_C_NN      CHECK(OPEN_COU_CODE IS NOT NULL)
, CONSTRAINT APPLY_COU_STU_ID_NN       CHECK(STU_ID IS NOT NULL)
, CONSTRAINT APPLY_COU_APP_DATE_NN CHECK(APPLY_DATE IS NOT NULL)
, CONSTRAINT APPLY_COU_OP_C_C_FK      FOREIGN KEY(OPEN_COU_CODE)
             REFERENCES TBL_OPEN_COU(OPEN_COU_CODE)
             ON DELETE CASCADE
, CONSTRAINT APPLY_COU_STU_ID_FK        FOREIGN KEY(STU_ID)
             REFERENCES TBL_STU(STU_ID)
             ON DELETE CASCADE
);
--==>> Table TBL_APPLY_COU��(��) �����Ǿ����ϴ�.

DESC TBL_APPLY_COU;
/*
�̸�             ��        ����           
-------------- -------- ------------ 
APPLY_COU_CODE NOT NULL NUMBER(4)    
OPEN_COU_CODE           NUMBER(4)    
STU_ID                  VARCHAR2(10) 
APPLY_DATE              DATE       
*/

--===============================================================
--�� ���� ���� ������ ����
CREATE SEQUENCE SEQ_OPEN_SUB
INCREMENT BY 1
START WITH 1000
NOMAXVALUE
NOCACHE
;


--==>> Sequence SEQ_OPEN_SUB��(��) �����Ǿ����ϴ�.


--�� ���� ���� ���̺� ����
CREATE TABLE TBL_OPEN_SUB
( OPEN_SUB_CODE      NUMBER(4)
, OPEN_COU_CODE      NUMBER(4)
, SUB_CODE                  NUMBER(4)
, PROF_ID                      VARCHAR2(10)
, BOOK_NO                   NUMBER(4)
, ROOM_NO                 NUMBER(4)
, SUB_START                DATE
, SUB_END                    DATE
, ATTE_RATIO               NUMBER(3)
, PRACT_RATIO             NUMBER(3)
, WRITE_RATIO             NUMBER(3)

, CONSTRAINT OPEN_SUB_OP_S_C_PK        PRIMARY KEY(OPEN_SUB_CODE)                                
, CONSTRAINT OPEN_SUB_OP_C_C_NN       CHECK(OPEN_COU_CODE IS NOT NULL)
, CONSTRAINT OPEN_SUB_SUB_C_NN         CHECK(SUB_CODE IS NOT NULL)
, CONSTRAINT OPEN_SUB_PROF_ID_NN      CHECK(PROF_ID IS NOT NULL)
, CONSTRAINT OPEN_SUB_ROOM_NO_NN  CHECK(ROOM_NO IS NOT NULL)
, CONSTRAINT OPEN_SUB_AT_R_NN            CHECK(ATTE_RATIO  IS NOT NULL)
, CONSTRAINT OPEN_SUB_PR_R_NN            CHECK(PRACT_RATIO IS NOT NULL)
, CONSTRAINT OPEN_SUB_WR_R_NN           CHECK(WRITE_RATIO IS NOT NULL)
, CONSTRAINT OPEN_SUB_DATE_INTERVAL CHECK(SUB_END > SUB_START)
, CONSTRAINT OPEN_SUB_AT_PR_WR_R_CK CHECK(ATTE_RATIO+PRACT_RATIO+WRITE_RATIO = 100)
, CONSTRAINT OPEN_SUB_OP_C_C_FK           FOREIGN KEY(OPEN_COU_CODE)
             REFERENCES TBL_OPEN_COU(OPEN_COU_CODE)
             ON DELETE CASCADE
, CONSTRAINT OPEN_SUB_SUB_C_FK             FOREIGN KEY(SUB_CODE)
                               REFERENCES TBL_SUB(SUB_CODE)
                               ON DELETE CASCADE
, CONSTRAINT OPEN_SUB_PROF_ID_FK         FOREIGN KEY(PROF_ID)
                               REFERENCES TBL_PROF(PROF_ID)
                               ON DELETE CASCADE          
, CONSTRAINT OPEN_SUB_BOOK_NO_FK       FOREIGN KEY(BOOK_NO)
                               REFERENCES TBL_TEXTBOOK(BOOK_NO)
                               ON DELETE CASCADE
, CONSTRAINT OPEN_SUB_ROOM_NO_FK      FOREIGN KEY(ROOM_NO)
                               REFERENCES TBL_CLASSROOM(ROOM_NO)
                               ON DELETE CASCADE    
);
--==>> Table TBL_OPEN_SUB��(��) �����Ǿ����ϴ�.

DESC TBL_OPEN_SUB;
/*
�̸�            ��        ����           
------------- -------- ------------ 
OPEN_SUB_CODE NOT NULL NUMBER(4)    
OPEN_COU_CODE          NUMBER(4)    
SUB_CODE               NUMBER(4)    
PROF_ID                VARCHAR2(10) 
BOOK_NO                NUMBER(4)    
ROOM_NO                NUMBER(4)    
SUB_START              DATE         
SUB_END                DATE         
ATTE_RATIO             NUMBER(3)    
PRACT_RATIO            NUMBER(3)    
WRITE_RATIO            NUMBER(3) 
*/

--===============================================================

--�� ���� ������ ����
CREATE SEQUENCE SEQ_TBL_GRADE
INCREMENT BY 1
START WITH 1000
NOMAXVALUE
NOCACHE
;
--==>> Sequence SEQ_TBL_GRADE��(��) �����Ǿ����ϴ�.

--�� ���� ���̺� ����
CREATE TABLE TBL_GRADE
( GRADE_CODE              NUMBER(4)
, APPLY_COU_CODE      NUMBER(4)
, OPEN_SUB_CODE        NUMBER(4)
, ATTENDANCE              NUMBER(3)
, PRACTICAL                  NUMBER(3)
, WRITE                          NUMBER(3)  
, CONSTRAINT GRADE_GRA_C_PK      PRIMARY KEY(GRADE_CODE)   
, CONSTRAINT GRADE_GR_CK CHECK(ATTENDANCE >=0 AND ATTENDANCE <=100 
                                AND PRACTICAL >=0 AND  PRACTICAL <=100
                                AND     WRITE >=0 AND      WRITE <=100)
, CONSTRAINT GRADE_OP_APP_C_CK   CHECK(APPLY_COU_CODE IS NOT NULL)
, CONSTRAINT GRADE_OP_S_C_CK       CHECK(OPEN_SUB_CODE IS NOT NULL)
, CONSTRAINT GRADE_APP_C_C_FK      FOREIGN KEY(APPLY_COU_CODE)
                               REFERENCES TBL_APPLY_COU(APPLY_COU_CODE)
                               ON DELETE CASCADE
, CONSTRAINT GRADE_OP_S_C_FK         FOREIGN KEY(OPEN_SUB_CODE)
                                 REFERENCES TBL_OPEN_SUB(OPEN_SUB_CODE)
                                 ON DELETE CASCADE     
);
--==>> Table TBL_GRADE��(��) �����Ǿ����ϴ�.

DESC TBL_GRADE;
/*

�̸�             ��        ����        
-------------- -------- --------- 
GRADE_CODE     NOT NULL NUMBER(4) 
APPLY_COU_CODE          NUMBER(4) 
OPEN_SUB_CODE           NUMBER(4) 
ATTENDANCE              NUMBER(3) 
PRACTICAL               NUMBER(3) 
WRITE                   NUMBER(3) 
*/

--===============================================================

--�� �ߵ�Ż�� ������ ����
CREATE SEQUENCE SEQ_TBL_DROP_STU
INCREMENT BY 1
START WITH 1000
NOMAXVALUE
NOCACHE
;
--==>> Sequence SEQ_TBL_DROP_STU��(��) �����Ǿ����ϴ�.


--�� �ߵ�Ż�� ���̺� ����
CREATE TABLE TBL_DROP_STU
( DROP_STU_CODE          NUMBER(4)
, APPLY_COU_CODE        NUMBER(4)
, DROP_DATE                   DATE       DEFAULT SYSDATE

, CONSTRAINT DROP_STU_DR_S_C_PK         PRIMARY KEY(DROP_STU_CODE)
, CONSTRAINT DROP_STU_APP_C_C_NN      CHECK(APPLY_COU_CODE IS NOT NULL)
, CONSTRAINT DROP_STU_DROP_DATE_NN CHECK(DROP_DATE IS NOT NULL)
, CONSTRAINT DROP_STU_APP_C_C_FK        FOREIGN KEY(APPLY_COU_CODE)
                                              REFERENCES TBL_APPLY_COU(APPLY_COU_CODE)
             ON DELETE CASCADE
);
--==>>Table TBL_DROP_STU��(��) �����Ǿ����ϴ�.

DESC TBL_DROP_STU;
/*
�̸�             ��        ����        
-------------- -------- --------- 
DROP_STU_CODE  NOT NULL NUMBER(4) 
APPLY_COU_CODE          NUMBER(4) 
DROP_DATE               DATE      

*/