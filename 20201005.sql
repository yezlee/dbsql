달력만들기 다시
1. 행을 인위적으로 만들기
    CONNECT BY LEVEL
    
2. 그룹 함수
    여러행을 하나의 행으로 만드는 방법
    
3. EXPRESSION
    테이블에 존재하지는 않지만, 수식/함수를 이용하여 새로운 컬럼을 만드는 방법

4. 부수적인 것들
    DATE 관련함수
    - 월의 마지막일자 구하기
    
5. 



만드는 순서
1. 인위적으로 여러개의 행을 만들기 
(계층쿼리 : 행과 행을 연결하는 거)
CONNECT BY LEVEL ==> CROSS JOIN 과 비슷한 개념

(조인 : 테이블의 행과, 다른 테이블의 행을 연결. 즉 컬럼이 확장.);

SELECT *
FROM dual
CONNECT BY LEVEL <= 10;
이거는 행이 하나밖에 없으니까 10 X 1 이 되는거야
만약 행이 두개면 2의 2승 / 4의 2승  이런식으로 계속 늘어나. 그래서 행이 많을땐 CONNECT BY LEVEL 잘 안써.
수가 그렇게 많은걸 원한게 아니라서

SELECT LEVEL, dummy, LTIRM(SYS_CONNECT_BY_PATH
FROM dual
CONNECT BY LEVEL <= 31;

년월 문자열이 주어졌을 때 해당 월의 일수 구하기

EX : '202010' ==> 31
     날짜가 있으면 원하는 항목(년, 월, 일, 시, 분, 초)만 추출 할 수 있다.
     TO_CHAR(날짜, '원하는 항목')
     
     SELECT TO_CHAR(LAST_DAY(TO_DATE('201010', 'YYYYMM')), 'DD')
     FROM dual;
    
     SELECT LEVEL, dummy
     FROM dual
     CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('201010', 'YYYYMM')), 'DD');
    
    실제 필요한 값은 날짜. (20201001 ~ 20201031)
    DATE + 정수 = DATE에서 정수를 일자로 취급해서 더한 날짜
    2020.10.05 + 5 = 2020.10.10
    
    2020년 10월 1일자를 만들려면??
    주언진 값은 단 : '202010'
    
    '202010' || '01' ==> '20201001' 문자열끼리 결합해서 이런 모양이 만들어지지 이걸 다시 데이트화 시키는거야
    TO_DATE('202010' || '01' , 'YYYYMMDD')
    근데 위에 
    이거랑 같아 TO_DATE('202010', 'YYYYMM') 이러면 어차피 1일부터 나와
    
    2020년 10월 1일의 날짜 타입을 구함.
    날짜 + 숫자(LEVEL 1~31) 연산을 통해 2020년 10월의 모든 일자를 구할 수 있다.
    ==> LEVEL은 1부터 시작하므로 2020년 10월 1일 값을 유지 하기 위해서는
    날짜 + LEVEL-1
    
    SELECT TO_DATE('202010', 'YYYYMM') + LEVEL-1 day,
           TO_CHAR(TO_DATE('202010', 'YYYYMM') + LEVEL-1, 'D') d,
           TO_CHAR(TO_DATE('202010', 'YYYYMM') + LEVEL-1, 'iw') iw
    FROM dual
    CONNECT BY LEVEL <=  TO_CHAR(LAST_DAY(TO_DATE('202010', 'YYYYMM')) , 'DD');
                         날짜만 필요하니깐 캐릭터로 바꿔서 DD만 잘라내는거지
                         
                      
    SELECT day, d, iw, DECODE(d, 1, day) d1
    FROM (SELECT TO_DATE('202010', 'YYYYMM') + LEVEL-1 day,
                 TO_CHAR(TO_DATE('202010', 'YYYYMM') + LEVEL-1, 'D') d,
                 TO_CHAR(TO_DATE('202010', 'YYYYMM') + LEVEL-1, 'iw') iw
          FROM dual
          CONNECT BY LEVEL <=  TO_CHAR(LAST_DAY(TO_DATE('202010', 'YYYYMM')) , 'DD'));
 일요일만 한거
    
    
    SELECT day, d, iw, DECODE(d, 1, day) d1,  DECODE(d, 2, day) d2,
                       DECODE(d, 3, day) d3,  DECODE(d, 4, day) d4, 
                       DECODE(d, 5, day) d5,  DECODE(d, 6, day) d6,
                       DECODE(d, 7, day) d7
    
    FROM (SELECT TO_DATE('202010', 'YYYYMM') + LEVEL-1 day,
                 TO_CHAR(TO_DATE('202010', 'YYYYMM') + LEVEL-1, 'D') d,
                 TO_CHAR(TO_DATE('202010', 'YYYYMM') + LEVEL-1, 'iw') iw
          FROM dual
          CONNECT BY LEVEL <=  TO_CHAR(LAST_DAY(TO_DATE('202010', 'YYYYMM')) , 'DD'));
                             
                             
    SELECT /*day, d,*/ iw, DECODE(d, 1, day) d1,  DECODE(d, 2, day) d2,
                       DECODE(d, 3, day) d3,  DECODE(d, 4, day) d4, 
                       DECODE(d, 5, day) d5,  DECODE(d, 6, day) d6,
                       DECODE(d, 7, day) d7
    
    FROM (SELECT TO_DATE('202010', 'YYYYMM') + LEVEL-1 day,
                 TO_CHAR(TO_DATE('202010', 'YYYYMM') + LEVEL-1, 'D') d,
                 TO_CHAR(TO_DATE('202010', 'YYYYMM') + LEVEL-1, 'iw') iw
          FROM dual
          CONNECT BY LEVEL <=  TO_CHAR(LAST_DAY(TO_DATE('202010', 'YYYYMM')) , 'DD'));
                             
    지금 이렇게 하면 iw를 가지고 그룹핑을 하면돼.
    그룹함수에서 널값을 무시하니까.
    max를 구해도 값 있는것만 min을 해도 값 있는것만 나오니까.
    근데 MIN을 쓸거야. MIN이 연산이 더 빠르대.
    
    SELECT /*day, d,*/ iw, 
                       MIN(DECODE(d, 1, day)) d1,  MIN(DECODE(d, 2, day)) d2,
                       MIN(DECODE(d, 3, day)) d3,  MIN(DECODE(d, 4, day)) d4, 
                       MIN(DECODE(d, 5, day)) d5,  MIN(DECODE(d, 6, day)) d6,
                       MIN(DECODE(d, 7, day)) d7    
    FROM (SELECT TO_DATE('202010', 'YYYYMM') + LEVEL-1 day,
                 TO_CHAR(TO_DATE('202010', 'YYYYMM') + LEVEL-1, 'D') d,
                 TO_CHAR(TO_DATE('202010', 'YYYYMM') + LEVEL-1, 'iw') iw
          FROM dual
          CONNECT BY LEVEL <=  TO_CHAR(LAST_DAY(TO_DATE('202010', 'YYYYMM')) , 'DD'))
    GROUP BY iw
    ORDER BY iw;                         
    
    
    SELECT /*day, d,*/ DECODE(d, 1, iw+1, iw), 
                       MIN(DECODE(d, 1, day)) d1,  MIN(DECODE(d, 2, day)) d2,
                       MIN(DECODE(d, 3, day)) d3,  MIN(DECODE(d, 4, day)) d4, 
                       MIN(DECODE(d, 5, day)) d5,  MIN(DECODE(d, 6, day)) d6,
                       MIN(DECODE(d, 7, day)) d7    
    FROM (SELECT TO_DATE('202010', 'YYYYMM') + LEVEL-1 day,
                 TO_CHAR(TO_DATE('202010', 'YYYYMM') + LEVEL-1, 'D') d,
                 TO_CHAR(TO_DATE('202010', 'YYYYMM') + LEVEL-1, 'iw') iw
          FROM dual
          CONNECT BY LEVEL <=  TO_CHAR(LAST_DAY(TO_DATE('202010', 'YYYYMM')) , 'DD'))
    GROUP BY iw
    ORDER BY iw;                         
    
    
    SELECT /*day, d,*/ DECODE(d, 1, iw+1, iw), 
                       MIN(DECODE(d, 1, day)) d1,  MIN(DECODE(d, 2, day)) d2,
                       MIN(DECODE(d, 3, day)) d3,  MIN(DECODE(d, 4, day)) d4, 
                       MIN(DECODE(d, 5, day)) d5,  MIN(DECODE(d, 6, day)) d6,
                       MIN(DECODE(d, 7, day)) d7    
    FROM (SELECT TO_DATE('202010', 'YYYYMM') + LEVEL-1 day,
                 TO_CHAR(TO_DATE('202010', 'YYYYMM') + LEVEL-1, 'D') d,
                 TO_CHAR(TO_DATE('202010', 'YYYYMM') + LEVEL-1, 'iw') iw
          FROM dual
          CONNECT BY LEVEL <=  TO_CHAR(LAST_DAY(TO_DATE('202010', 'YYYYMM')) , 'DD'))
    GROUP BY DECODE(d, 1, iw+1, iw)
    ORDER BY DECODE(d, 1, iw+1, iw);                         
   
   
    SELECT MIN(DECODE(d, 1, day)) d1,  MIN(DECODE(d, 2, day)) d2,
           MIN(DECODE(d, 3, day)) d3,  MIN(DECODE(d, 4, day)) d4, 
           MIN(DECODE(d, 5, day)) d5,  MIN(DECODE(d, 6, day)) d6,
           MIN(DECODE(d, 7, day)) d7    
    FROM (SELECT TO_DATE('202010', 'YYYYMM') + LEVEL-1 day,
                 TO_CHAR(TO_DATE('202010', 'YYYYMM') + LEVEL-1, 'D') d,
                 TO_CHAR(TO_DATE('202010', 'YYYYMM') + LEVEL-1, 'iw') iw
          FROM dual
          CONNECT BY LEVEL <=  TO_CHAR(LAST_DAY(TO_DATE('202010', 'YYYYMM')) , 'DD'))
    GROUP BY DECODE(d, 1, iw+1, iw)
    ORDER BY DECODE(d, 1, iw+1, iw);                         
     
     
     
     
     
     
10/05 진도

PL / SQL 
Prodedual Language / SQL

SQL은 집합적인 언어인데, 여기에다 절차적 요소를 더함
절차적요소( 반복문, 조건 제어 - 분기처리)

결론 : 절차적으로 잘 못 만들면 속도 느리다.
     ==> sql로 한번에 처리할 수 없는 지 고민
     
절차적인 처리가 필요한 부분은 존재한다 : 인사 시스템 급여, 연말정산 -> 이건 느려도 pl/sql을 써야돼

PL/SQL 사용방법 : PL/SQL block을 통해서 실행

PL/SQL block 구조 : JAVA에서 TRY/CATCH랑 비슷
DECLARE 
    선언부(생략가능)
          - PL/SQL 블럭에서 사용 할 변수
            TYPE(CLASS), CURSOR(SQL - 정보)등을 선언하는 절
            JAVA랑 다르게 변수 선언을 블로 어디서나 할 수 없음
     
BEGIN
    실행부(생략불가)
        로직 - 데이터를 조회해서 변수에 담기, 루프, 조건제어
        
EXCEPTION 
    예외부(생략가능)
        BEGIN 절에서 발생한 예외를 처리하는 부분
        
END;
/       -> SLASH : PL/SQL의 끝을 알리는 세미콜론같은 역할.


PL/SQL 식별자 규칙 : 오라클 객체(TABLE, INDEX....) 생성시와 동일
                    30글자 넘어가면 안됨(FK시 길어지게 되는 경우가 간혹 있음.
                    오라클 객체명은 내부적으로 대문자로 관리. 내가 소문자로 입력해도 USERS_TABLE에 들어가서 보면 대문자로 되어있음.
                                        
PL/SQL 연산자 : SQL과 동일
               프로그래밍 언어의 특성(변수, 반복문, 조건문)
               대입 연산자 주의(SQL에 존재하지 않음)
               JAVA = 
               PL/SQL :=
               
               
10번 부서의 이름과, 부서번호를 각 변수에 담아서 CONSOLE에 출력
부서번호 : v_deptno, 부서이름 : v_deptnm
변수 선언 : java와 순서가 다름
    java : 타입 변수명
    pl/sql : 변수명 타입
    
CONSOLE 출력
JAVA : syso();
PL/SQL : DBMS_OUTPUT.PUT_LINE(...);

ORACLE 은 결과출력을 위해 출력 기능을 활성화 해야함
SET SERVEROUTPUT ON;
(이걸 매번 실행할 필요는 없고, 오라클 접속 후 한번만 실행하면 됨. 하루에 한번)

DECLARE
BEGIN
END;
/

SET SERVEROUTPUT ON;
DECLARE
    v_deptno NUMBER(2);
    v_dname VARCHAR2(14);
BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = 10;
    DBMS_OUTPUT.PUT_LINE('v_deptno : ' || v_deptno || 'v_dname : ' || v_dname);
END;
/
 
 
 
참조타입 : 변수 타입을 테이블의 컬럼 정보를 통해 선언
          변수명 테이블명 컬럼병 %TYPE;
          ==> 특정 테이블 컬럼의 타입을 참조하여 선언.
              해당 컬럼의 타입이 변경이 되더라도 PL/SQL 코드는 수정을 하지 않아도 된다.
              

DECLARE
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = 10;
    DBMS_OUTPUT.PUT_LINE('v_deptno : ' || v_deptno || 'v_dname : ' || v_dname);
END;
/            
          
          
PL/SQL PROCEDURE : 오라클 DBMS에 저장한 PL/SQL 블럭
                   함수와 다르게 리턴값이 없다.
                   
생성방법
CREATE OR REPLACE PROCEDURE 프로시저명 [(입력값...)] IS
    선언부
BEGIN
END;
/

CREATE OR REPLACE PROCEDURE printdept IS
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = 10;
    DBMS_OUTPUT.PUT_LINE('v_deptno : ' || v_deptno || 'v_dname : ' || v_dname);
    
END;
/


실행방법
EXEC 프로시저명;

EXEC printdept;



printdept 프로시저는 begin절에 10번 부서의 정보를 조회하도록
hard coding이 되어있음
프로시저가 인자를 받도록 수정

EXEC printdept(20);
EXEC printdept(30);



CREATE OR REPLACE PROCEDURE printdept (p_deptno IN dept.deptno%TYPE) IS
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = p_deptno;
    DBMS_OUTPUT.PUT_LINE('v_deptno : ' || v_deptno || 'v_dname : ' || v_dname);    
END;
/

EXEC printdept(20);
EXEC printdept(10);

SELECT *
FROM emp;

실습 pro_1

CREATE OR REPLACE PROCEDURE printemp (p_empno IN emp.empno%TYPE) IS
    v_empno emp.empno%TYPE;
    v_dname dept.dname%TYPE;
    v_ename emp.ename%TYPE;
BEGIN
    SELECT empno, dname, ename INTO v_empno, v_dname, v_ename
    FROM emp, dept
    WHERE empno = p_empno AND emp.deptno = dept.deptno;
    DBMS_OUTPUT.PUT_LINE('v_empno : ' || v_empno || 'v_dname : ' || v_dname || 'v_ename : ' || v_ename);    
END;
/

EXEC printemp(7369);
EXEC printemp(7521);


실습 por_2

SELECT *
FROM dept_test;

SELECT 
FROM



CREATE OR REPLACE PROCEDURE registdept_test (p_deptno IN dept_test.deptno%TYPE, p_dname IN dept_test.dname%TYPE, p_loc IN dept_test.loc%TYPE) IS    
/*변수선언을 꼭 안해줘도 된다!*/
BEGIN
    INSERT INTO DEPT_TEST VALUES(p_deptno, p_dname, p_loc);
    COMMIT;
END;
/

EXEC registdept_test (99, 'ddit', 'daejeon');

SELECT *
FROM dept;


실습 PRO_3 과제
CREATE OR REPLACE PROCEDURE UPDATEdept_test (p_deptno IN dept_test.deptno%TYPE, p_dname IN dept_test.dname%TYPE, p_loc IN dept_test.loc%TYPE) IS
    v_deptno dept_test.deptno%TYPE;
    v_dname dept_test.dname%TYPE;
    v_loc dept_test.loc%TYPE;
BEGIN
    UPDATE DEPT_TEST SET dname = 'ddit_m'
    WHERE deptno = 99;
    COMMIT;
END;
/

EXEC UPDATEdept_test (99, 'ddit_m', 'daejeon');
