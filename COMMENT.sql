--�� ���̺� �ڸ�Ʈ ��ȸ
SELECT *
FROM USER_TAB_COMMENTS
ORDER BY COMMENTS;


--���̺� Comment ����
--COMMENT ON TABLE [���̺��] IS [Comment];

--�� ADMIN �����ڰ����� �ڸ�Ʈ �ޱ�
COMMENT ON TABLE ADMIN IS '0. ������ ����';

--�� TBL_PROF �����ڰ����� �ڸ�Ʈ �ޱ�
COMMENT ON TABLE TBL_PROF IS '1-1. ������ ����';

--�� TBL_STU �л������� �ڸ�Ʈ �ޱ�
COMMENT ON TABLE TBL_STU IS '1-2. �л� ����';

--�� TBL_COU ���������� �ڸ�Ʈ �ޱ�
COMMENT ON TABLE TBL_COU IS '1-3. ���� ����';

--�� TBL_SUB ��������� �ڸ�Ʈ �ޱ�
COMMENT ON TABLE TBL_SUB IS '1-4. ���� ����';

--�� TBL_GRADE ���������� �ڸ�Ʈ �ޱ�
COMMENT ON TABLE TBL_GRADE IS '1-5. ���� ����';

--�� TBL_TEXTBOOK ��������� �ڸ�Ʈ �ޱ�
COMMENT ON TABLE TBL_TEXTBOOK IS '1-6. ���� ����';

--�� TBL_CLASSROOM ���ǽǰ����� �ڸ�Ʈ �ޱ�
COMMENT ON TABLE TBL_CLASSROOM IS '1-7. ���ǽ� ����';

--�� TBL_OPEN_COU �������������� �ڸ�Ʈ �ޱ�
COMMENT ON TABLE TBL_OPEN_COU IS '2-1. ������������';

--�� TBL_APPLY_COU ������û������ �ڸ�Ʈ �ޱ�
COMMENT ON TABLE TBL_APPLY_COU IS '3-1. ������û����';

--�� TBL_DROP_COU �����󰭰����� �ڸ�Ʈ �ޱ�
COMMENT ON TABLE TBL_DROP_COU IS '3-2. �����󰭰���';

--�� TBL_OPEN_SUB ������������� �ڸ�Ʈ �ޱ�
COMMENT ON TABLE TBL_OPEN_SUB IS '4-1. �����������';

--�� TBL_DROP_STU �ߵ�Ż�������� �ڸ�Ʈ �ޱ�
COMMENT ON TABLE TBL_DROP_STU IS '4-2. �ߵ�Ż������';

--�� VIEW_CONSTCHECK ��������Ȯ�ΰ��� �ڸ�Ʈ �ޱ�
COMMENT ON TABLE VIEW_CONSTCHECK IS '��������Ȯ�ΰ���';

--�� ���̺� �� �����÷� �ڸ�Ʈ ��ȸ
SELECT *
FROM ALL_COL_COMMENTS
WHERE TABLE_NAME = 'TBL_GRADE';


--�÷� Comment ����
--COMMENT ON COLUMN [���̺��].[�÷���] IS '[Comment]';

--�� TBL_GRADE �������� �� �÷��� �ڸ�Ʈ �ޱ�
COMMENT ON COLUMN TBL_GRADE.GRADE_CODE IS '����';
COMMENT ON COLUMN TBL_GRADE.APPLY_COU_CODE IS '����';
COMMENT ON COLUMN TBL_GRADE.OPEN_SUB_CODE IS '��������';
COMMENT ON COLUMN TBL_GRADE.ATTENDANCE IS '�������';
COMMENT ON COLUMN TBL_GRADE.PRACTICAL IS '�Ǳ�����';
COMMENT ON COLUMN TBL_GRADE.WRITE IS '�ʱ�����';


--�� ���̺� �� �����÷� �ڸ�Ʈ ��ȸ
SELECT *
FROM ALL_COL_COMMENTS
WHERE TABLE_NAME = 'TBL_OPEN_SUB';

--�� TBL_OPEN_SUB �������� �÷� �ڸ�Ʈ ��ȸ
COMMENT ON COLUMN TBL_OPEN_SUB.OPEN_SUB_CODE IS '��������';
COMMENT ON COLUMN TBL_OPEN_SUB.OPEN_COU_CODE IS '��������';
COMMENT ON COLUMN TBL_OPEN_SUB.SUB_CODE IS '����';
COMMENT ON COLUMN TBL_OPEN_SUB.PROF_ID IS '������ȣ';
COMMENT ON COLUMN TBL_OPEN_SUB.BOOK_NO IS '�����ȣ';
COMMENT ON COLUMN TBL_OPEN_SUB.ROOM_NO IS '���ǽ��ڵ�';
COMMENT ON COLUMN TBL_OPEN_SUB.SUB_START IS '���������';
COMMENT ON COLUMN TBL_OPEN_SUB.SUB_END IS '����������';
COMMENT ON COLUMN TBL_OPEN_SUB.ATTE_RATIO IS '������';
COMMENT ON COLUMN TBL_OPEN_SUB.PRACT_RATIO IS '�Ǳ����';
COMMENT ON COLUMN TBL_OPEN_SUB.WRITE_RATIO IS '�ʱ����';
