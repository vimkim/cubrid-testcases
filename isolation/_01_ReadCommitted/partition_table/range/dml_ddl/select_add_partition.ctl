/*
Test Case: add partition & select
Priority: 1
Reference case:
Author: Rong Xu
Test Point:
one user add partition, another select values

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col char(10)) partition by range(id)(partition p1 values less than (1000),partition p2 values less than (2001));
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),'a' from db_class a,db_class b,db_class c limit 2000;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: select count(id) from t;
MC: sleep 1;
C2: alter table t add partition(partition p3 values less than (3000)); 
MC: wait until C2 blocked;
/* expected 4000 */
C1: commit work;
MC: wait until C2 ready;
C2: commit;

C2: quit;
C1: quit;

