--ACL授权
SELECT host,
       lower_port,
       upper_port,
       acl
  FROM dba_network_acls;

SELECT acl,
       principal,
       privilege,
       is_grant,
       to_char(start_date, 'DD-MON-YYYY') AS start_date,
       to_char(end_date, 'DD-MON-YYYY') AS end_date
  FROM dba_network_acl_privileges;

--acl��Ȩ:���۲��Ի����ʼ�������Ȩ
BEGIN
  dbms_network_acl_admin.drop_acl(acl => 'mxfl_test_send_mail.xml');


  dbms_network_acl_admin.create_acl(acl         => '/sys/acls/mxfl_test_send_mail.xml',
                    description => '���۲��Ի����ʼ�������Ȩ',
                    principal   => 'MXFL_TEST',
                    is_grant    => TRUE,
                    privilege   => 'connect');

  dbms_network_acl_admin.assign_acl(acl        => '/sys/acls/mxfl_test_send_mail.xml',
                    host       => '122.112.225.178', 
                    lower_port => 8088,
                    upper_port => 8088);

  dbms_network_acl_admin.add_privilege(acl       => '/sys/acls/mxfl_test_send_mail.xml',
                     principal => 'MXFL_TEST',
                     is_grant  => TRUE,
                     privilege => 'connect');
  COMMIT;
END;

--acl��Ȩ:�������������ʼ�������Ȩ
BEGIN
  dbms_network_acl_admin.drop_acl(acl => 'mxfl_prod_send_mail.xml');


  dbms_network_acl_admin.create_acl(acl         => '/sys/acls/mxfl_prod_send_mail.xml',
                    description => '�������������ʼ�������Ȩ',
                    principal   => 'MXFL_PROD',
                    is_grant    => TRUE,
                    privilege   => 'connect');

  dbms_network_acl_admin.assign_acl(acl        => '/sys/acls/mxfl_prod_send_mail.xml',
                    host       => '122.112.225.178', 
                    lower_port => 80,
                    upper_port => 80);

  dbms_network_acl_admin.add_privilege(acl       => '/sys/acls/mxfl_prod_send_mail.xml',
                     principal => 'MXFL_PROD',
                     is_grant  => TRUE,
                     privilege => 'connect');
  COMMIT;
END;