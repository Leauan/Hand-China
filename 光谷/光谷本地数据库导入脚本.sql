-- drop�û�
drop user GCC_DEV cascade;
--drop ��ռ�
drop tablespace GCC_DEV including contents and datafiles;


--�½���ռ�
CREATE TABLESPACE GCC_DEV DATAFILE 'D:\app\Leauan\ORADATA\ORCL\GCC_DEV.DBF' SIZE 1024M AUTOEXTEND ON; 
--�½��û�
create user GCC_DEV identified by GCC_DEV default tablespace GCC_DEV; 
-- ��Ȩ
grant connect,resource,dba to GCC_DEV;
grant read,write on directory DATA_PUMP_DIR to GCC_DEV;
grant connect,resource to GCC_DEV;
grant create view to GCC_DEV;
grant create any table to GCC_DEV;
grant debug any procedure, debug connect session to GCC_DEV;
grant unlimited tablespace to GCC_DEV;
grant create public synonym to GCC_DEV;
grant create synonym to GCC_DEV;


-- ����DMP�ļ�
impdp GCC_DEV/GCC_DEV remap_tablespace=GCC_DEV:GCC_DEV remap_schema=GCC_DEV:GCC_DEV directory=DATA_PUMP_DIR dumpfile=GCC_DEV20190131.DMP 


-- ����DMP�ļ�
expdp zh_dev/zh_dev directory=SYSLOAD_FILE_DIR dumpfile=zy_dev20161114.dmp logfile=SYSLOAD_FILE_DIR:zy_dev20161114.log EXCLUDE=STATISTICS;
