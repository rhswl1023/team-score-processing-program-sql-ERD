--������ ������ �Է�
INSERT INTO ADMIN VALUES('cjfsud23','cc123456');

--���� ������ �Է�
EXEC TBL_PROF_INSERT('choi123', '��ö��', '1023456' );
EXEC TBL_PROF_INSERT('song123', '�ۼ���', '2765433');
EXEC TBL_PROF_INSERT('lee1234', '��ä��', '2990087' );
EXEC TBL_PROF_INSERT('kim1234', '�赿��', '2344589');


--�л� ������ �Է�
--2019�⵵�� 
EXEC TBL_STU_INSERT('������' ,'1205518');  -- 20190001
EXEC TBL_STU_INSERT('������' ,'2233445');  -- 20190002

--2020�⵵�� 
EXEC TBL_STU_INSERT('��ȣ��', '1234567');  --20200001
EXEC TBL_STU_INSERT('�浿��', '1122334');  --20200002
EXEC TBL_STU_INSERT('�����', '2344556');  --20200003
EXEC TBL_STU_INSERT('������', '2678999');  --20200004
EXEC TBL_STU_INSERT('���±�', '1111111');  --20200005
EXEC TBL_STU_INSERT('������', '2222222');  --20200006
EXEC TBL_STU_INSERT('���Ѻ�', '2233333');  --20200007
EXEC TBL_STU_INSERT('����ȭ', '2888888');  --20200008



--���� ������ �Է� 

EXEC TBL_TEXTBOOK_INSERT('�ڹ��� ����');
EXEC TBL_TEXTBOOK_INSERT('ȥ�� �����ϴ� �ڹ�');
EXEC TBL_TEXTBOOK_INSERT('����Ŭ SQL�� PL/SQL');
EXEC TBL_TEXTBOOK_INSERT('�̰��� MySQL�̴�');
EXEC TBL_TEXTBOOK_INSERT('���伥/�Ϸ���Ʈ������ CC');
EXEC TBL_TEXTBOOK_INSERT('����Ʈ���� ���� ù����');
EXEC TBL_TEXTBOOK_INSERT('Do it! �ȵ���̵� �� ���α׷���');
EXEC TBL_TEXTBOOK_INSERT('������ �����ӿ�ũ �������� ����');

DESC TBL_TEXTBOOK;

--���ǽ� ������ �Է� 

INSERT INTO TBL_CLASSROOM(ROOM_NO, ROOM_DATA) VALUES (101,'���ǽ� 101ȣ');
INSERT INTO TBL_CLASSROOM(ROOM_NO, ROOM_DATA) VALUES (102,'���ǽ� 102ȣ');
INSERT INTO TBL_CLASSROOM(ROOM_NO, ROOM_DATA) VALUES (103,'���ǽ� 103ȣ');
INSERT INTO TBL_CLASSROOM(ROOM_NO, ROOM_DATA) VALUES (103,'���ǽ� 103ȣ');

INSERT INTO TBL_CLASSROOM(ROOM_NO, ROOM_DATA) VALUES (201,'���ǽ� 201ȣ');
INSERT INTO TBL_CLASSROOM(ROOM_NO, ROOM_DATA) VALUES (202,'���ǽ� 202ȣ');
INSERT INTO TBL_CLASSROOM(ROOM_NO, ROOM_DATA) VALUES (203,'���ǽ� 203ȣ');
INSERT INTO TBL_CLASSROOM(ROOM_NO, ROOM_DATA) VALUES (204,'���ǽ� 204ȣ');

INSERT INTO TBL_CLASSROOM(ROOM_NO, ROOM_DATA) VALUES (301,'���ǽ� 301ȣ');
INSERT INTO TBL_CLASSROOM(ROOM_NO, ROOM_DATA) VALUES (302,'���ǽ� 302ȣ');
INSERT INTO TBL_CLASSROOM(ROOM_NO, ROOM_DATA) VALUES (303,'���ǽ� 303ȣ');
INSERT INTO TBL_CLASSROOM(ROOM_NO, ROOM_DATA) VALUES (304,'���ǽ� 304ȣ');

INSERT INTO TBL_CLASSROOM(ROOM_NO, ROOM_DATA) VALUES (401,'���ǽ� 401ȣ');
INSERT INTO TBL_CLASSROOM(ROOM_NO, ROOM_DATA) VALUES (402,'���ǽ� 402ȣ');
INSERT INTO TBL_CLASSROOM(ROOM_NO, ROOM_DATA) VALUES (403,'���ǽ� 403ȣ');
INSERT INTO TBL_CLASSROOM(ROOM_NO, ROOM_DATA) VALUES (404,'���ǽ� 404ȣ');

--���� ������ �Է�

EXEC TBL_COU_INSERT('JAVA �� ������ �缺����');     
EXEC TBL_COU_INSERT('����� �� ������ �缺����');      
EXEC TBL_COU_INSERT('�� �����̳� �缺����');          


--���� ���� ������ �Է�

EXEC TBL_OPEN_COU_INSERT('JAVA �� ������ �缺����',TO_DATE('2019-08-12'),TO_DATE('2019-12-12'));        
EXEC TBL_OPEN_COU_INSERT('JAVA �� ������ �缺����',TO_DATE('2020-02-18'),TO_DATE('2020-06-18'));       
EXEC TBL_OPEN_COU_INSERT('JAVA �� ������ �缺����',TO_DATE('2020-05-12'),TO_DATE('2020-09-12'));        
EXEC TBL_OPEN_COU_INSERT('����� �� ������ �缺����',TO_DATE('2020-03-12'),TO_DATE('2020-06-12'));       
EXEC TBL_OPEN_COU_INSERT('����� �� ������ �缺����',TO_DATE('2020-05-12'),TO_DATE('2020-08-12'));        
EXEC TBL_OPEN_COU_INSERT('�� �����̳� �缺����',TO_DATE('2019-12-12'),TO_DATE('2020-03-12'));        
EXEC TBL_OPEN_COU_INSERT('�� �����̳� �缺����',TO_DATE('2020-05-12'),TO_DATE('2020-08-12'));       

--���� ������ �Է� 

--�۰���

EXEC TBL_SUB_INSERT('�ڹ�');
EXEC TBL_SUB_INSERT('DB');
EXEC TBL_SUB_INSERT('�ȵ���̵�');
EXEC TBL_SUB_INSERT('����Ʈ����');
EXEC TBL_SUB_INSERT('������');
EXEC TBL_SUB_INSERT('�Ϸ���Ʈ');
EXEC TBL_SUB_INSERT('���伥');

--���� ���� ������ �Է�
--1000
EXEC TBL_OPEN_SUB_INSERT(1000, '�ڹ�',  TO_DATE('2019/08/12', 'YYYY-MM-DD'), TO_DATE('2019/09/12', 'YYYY-MM-DD') , '�ڹ��� ����', 'choi123', 201);
EXEC TBL_OPEN_SUB_INSERT(1000, 'DB',  TO_DATE('2019/09/13', 'YYYY-MM-DD'), TO_DATE('2019/10/12', 'YYYY-MM-DD') , '����Ŭ SQL�� PL/SQL', 'choi123', 201);
EXEC TBL_OPEN_SUB_INSERT(1000, '����Ʈ����',  TO_DATE('2019/10/13', 'YYYY-MM-DD'), TO_DATE('2019/11/12', 'YYYY-MM-DD') , '����Ʈ���� ���� ù����', 'choi123', 201);
EXEC TBL_OPEN_SUB_INSERT(1000, '������',  TO_DATE('2019/11/13', 'YYYY-MM-DD'), TO_DATE('2019/12/12', 'YYYY-MM-DD') , '������ �����ӿ�ũ �������� ����', 'choi123', 201);

--1001
EXEC TBL_OPEN_SUB_INSERT(1001, '�ڹ�',  TO_DATE('2020/02/18', 'YYYY-MM-DD'), TO_DATE('2020/03/18', 'YYYY-MM-DD') , '�ڹ��� ����', 'choi123', 301);
EXEC TBL_OPEN_SUB_INSERT(1001, 'DB',  TO_DATE('2020/03/19', 'YYYY-MM-DD'), TO_DATE('2020/04/18', 'YYYY-MM-DD') , '����Ŭ SQL�� PL/SQL', 'choi123', 301);
EXEC TBL_OPEN_SUB_INSERT(1001, '����Ʈ����',  TO_DATE('2020/04/19', 'YYYY-MM-DD'), TO_DATE('2020/05/18', 'YYYY-MM-DD') , '����Ʈ���� ���� ù����', 'choi123', 301);
EXEC TBL_OPEN_SUB_INSERT(1001, '������',  TO_DATE('2020/05/19', 'YYYY-MM-DD'), TO_DATE('2020/06/18', 'YYYY-MM-DD') , '������ �����ӿ�ũ �������� ����', 'choi123', 301);

--1002
EXEC TBL_OPEN_SUB_INSERT(1002, '�ڹ�',  TO_DATE('2020/05/12', 'YYYY-MM-DD'), TO_DATE('2020/06/12', 'YYYY-MM-DD') , 'ȥ�� �����ϴ� �ڹ�', 'choi123', 201);
EXEC TBL_OPEN_SUB_INSERT(1002, 'DB',  TO_DATE('2020/06/13', 'YYYY-MM-DD'), TO_DATE('2020/07/12', 'YYYY-MM-DD') , '�̰��� MySQL�̴�', 'choi123', 201);
EXEC TBL_OPEN_SUB_INSERT(1002, '����Ʈ����',  TO_DATE('2020/07/13', 'YYYY-MM-DD'), TO_DATE('2020/08/12', 'YYYY-MM-DD') , '����Ʈ���� ���� ù����', 'choi123', 201);
EXEC TBL_OPEN_SUB_INSERT(1002, '������',  TO_DATE('2020/08/13', 'YYYY-MM-DD'), TO_DATE('2020/09/12', 'YYYY-MM-DD') , '������ �����ӿ�ũ �������� ����', 'choi123', 201);

--1003
EXEC TBL_OPEN_SUB_INSERT(1003, '�ڹ�',  TO_DATE('2020/03/12', 'YYYY-MM-DD'), TO_DATE('2020/04/12', 'YYYY-MM-DD') , 'ȥ�� �����ϴ� �ڹ�', 'lee1234', 202);
EXEC TBL_OPEN_SUB_INSERT(1003, 'DB',  TO_DATE('2020/04/13', 'YYYY-MM-DD'), TO_DATE('2020/05/12', 'YYYY-MM-DD') , '�̰��� MySQL�̴�', 'song123', 202);
EXEC TBL_OPEN_SUB_INSERT(1003, '�ȵ���̵�',  TO_DATE('2020/05/13', 'YYYY-MM-DD'), TO_DATE('2020/06/12', 'YYYY-MM-DD') , 'Do it! �ȵ���̵� �� ���α׷���', 'lee1234', 202);

--1004
EXEC TBL_OPEN_SUB_INSERT(1004, '�ڹ�',  TO_DATE('2020/05/12', 'YYYY-MM-DD'), TO_DATE('2020/06/12', 'YYYY-MM-DD') , '�ڹ��� ����', 'lee1234', 202);
EXEC TBL_OPEN_SUB_INSERT(1004, 'DB',  TO_DATE('2020/06/13', 'YYYY-MM-DD'), TO_DATE('2020/07/12', 'YYYY-MM-DD') , '����Ŭ SQL�� PL/SQL', 'song123', 202);
EXEC TBL_OPEN_SUB_INSERT(1004, '�ȵ���̵�',  TO_DATE('2020/07/13', 'YYYY-MM-DD'), TO_DATE('2020/08/12', 'YYYY-MM-DD') , 'Do it! �ȵ���̵� �� ���α׷���', 'lee1234', 202);

--1005
EXEC TBL_OPEN_SUB_INSERT(1005, '�Ϸ���Ʈ',  TO_DATE('2019/12/12', 'YYYY-MM-DD'), TO_DATE('2020/01/12', 'YYYY-MM-DD') , '���伥/�Ϸ���Ʈ������ CC', 'kim1234', 404);
EXEC TBL_OPEN_SUB_INSERT(1005, '���伥',  TO_DATE('2020/01/13', 'YYYY-MM-DD'), TO_DATE('2020/02/12', 'YYYY-MM-DD') , '���伥/�Ϸ���Ʈ������ CC', 'kim1234', 404);
EXEC TBL_OPEN_SUB_INSERT(1005, '����Ʈ����',  TO_DATE('2020/02/13', 'YYYY-MM-DD'), TO_DATE('2020/03/12', 'YYYY-MM-DD') , '����Ʈ���� ���� ù����', 'song123', 404);

--1006
EXEC TBL_OPEN_SUB_INSERT(1006, '�Ϸ���Ʈ',  TO_DATE('2020/05/12', 'YYYY-MM-DD'), TO_DATE('2020/06/12', 'YYYY-MM-DD') , '���伥/�Ϸ���Ʈ������ CC', 'kim1234', 404);
EXEC TBL_OPEN_SUB_INSERT(1006, '���伥',  TO_DATE('2020/06/13', 'YYYY-MM-DD'), TO_DATE('2020/07/12', 'YYYY-MM-DD') , '���伥/�Ϸ���Ʈ������ CC', 'kim1234', 404);
EXEC TBL_OPEN_SUB_INSERT(1006, '����Ʈ����',  TO_DATE('2020/07/13', 'YYYY-MM-DD'), TO_DATE('2020/08/12', 'YYYY-MM-DD') , '����Ʈ���� ���� ù����', 'song123', 404);


--������û
EXEC TBL_APPLY_COU_INSERT(1000, 20190001);            -- ������,  19�� 8������ JAVA �� ������ �缺����     --1000
EXEC TBL_APPLY_COU_INSERT(1000, 20190002);            -- ������,  19�� 12�������� �����̳� �缺����                --1001

EXEC TBL_APPLY_COU_INSERT(1001, 20200001);            -- ��ȣ��,  2������ JAVA �� ������ �缺����                  --1002
EXEC TBL_APPLY_COU_INSERT(1001, 20200002);            -- �浿��,  2������ JAVA �� ������ �缺����                  --1003
EXEC TBL_APPLY_COU_INSERT(1001, 20200003);            -- �����,  2������ JAVA �� ������ �缺����                  --1004

EXEC TBL_APPLY_COU_INSERT(1003, 20200004);            -- ������,  3������ ����� �� ������ �缺����                  --1005
EXEC TBL_APPLY_COU_INSERT(1003, 20200005);            -- ���±�,  3������ ����� �� ������ �缺����                  --1006
EXEC TBL_APPLY_COU_INSERT(1003, 20200006);            -- ������,  3������ ����� �� ������ �缺����                  --1007


EXEC TBL_APPLY_COU_INSERT(1002, 20200007);            -- ���Ѻ�,  5�� ���� JAVA �� ������ �缺����                  --1008

EXEC TBL_APPLY_COU_INSERT(1005, 20200008);            -- ����ȭ,  5�� ���� �� �����̳� �缺����                  --1009

--�л� �ߵ� ���� 
EXEC TBL_DROP_STU_INSERT(1003);   --�浿���л� �ߵ�Ż�� 
EXEC TBL_DROP_STU_INSERT(1006);   --���±��л� �ߵ�Ż�� 

EXEC DROP_COU_INSERT(1003);        -- 3������ ����� �缺 ���� �� 
