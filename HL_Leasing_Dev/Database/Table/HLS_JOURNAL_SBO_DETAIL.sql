-- Create table
create table HLS_JOURNAL_SBO_DETAIL
(
  JOURNAL_LINE_ID            NUMBER not null,
  JOURNAL_HEADER_ID          NUMBER not null,
  SOURCE_TABLE               VARCHAR2(30) not null,
  SOURCE_ID                  NUMBER,
  LINE_NUM                   VARCHAR2(30),
  LINE_DESCRIPTION           VARCHAR2(2000),
  JE_TEMPLATE_HD_ID          NUMBER,
  TRANSACTION_DATE           DATE,
  RESPONSIBILITY_CENTER_ID   NUMBER,
  ACCOUNT_ID                 NUMBER,
  USAGE_CODE                 VARCHAR2(30),
  EXCHANGE_RATE_TYPE         VARCHAR2(30),
  EXCHANGE_RATE              NUMBER,
  AMOUNT_DR                  NUMBER,
  AMOUNT_CR                  NUMBER,
  AMOUNT_FUC_DR              NUMBER,
  AMOUNT_FUC_CR              NUMBER,
  REFERENCE1                 VARCHAR2(240),
  REFERENCE2                 VARCHAR2(240),
  REFERENCE3                 VARCHAR2(240),
  REFERENCE4                 VARCHAR2(240),
  REFERENCE5                 VARCHAR2(240),
  REFERENCE6                 VARCHAR2(240),
  REFERENCE7                 VARCHAR2(240),
  REFERENCE8                 VARCHAR2(240),
  REFERENCE9                 VARCHAR2(240),
  ACCOUNT_INDICATOR          VARCHAR2(30),
  CREATION_DATE              DATE,
  CREATED_BY                 NUMBER,
  LAST_UPDATE_DATE           DATE,
  LAST_UPDATED_BY            NUMBER,
  LINE_QUANTITY              NUMBER,
  SOURCE_DOC_CATEGORY        VARCHAR2(30),
  SOURCE_DOC_TYPE            VARCHAR2(30),
  SOURCE_DOC_ID              NUMBER,
  SOURCE_DOC_LINE_ID         NUMBER,
  SOURCE_DOC_DETAIL_ID       NUMBER,
  LEASE_ORGANIZATION         VARCHAR2(4),
  LEASE_CHANNEL              VARCHAR2(2),
  DIVISION                   VARCHAR2(2),
  EMPLOYEE_ID                NUMBER,
  UNIT_ID                    NUMBER,
  PROJECT_ID                 NUMBER,
  CONTRACT_ID                NUMBER,
  CASHFLOW_ID                NUMBER,
  TIMES                      NUMBER,
  CF_ITEM                    NUMBER,
  CF_TYPE                    NUMBER,
  LOAN_CONTRACT_ID           NUMBER,
  LOAN_CONTRACT_REPAYMENT_ID NUMBER,
  CSH_TRX_ID                 NUMBER,
  BP_ID_TENANT               NUMBER,
  BP_ID_VENDER               NUMBER,
  BP_ID_AGENT                NUMBER,
  BP_ID_BANK                 NUMBER,
  BP_ID_BANK_BRANCH          NUMBER,
  LEASE_ITEM_ID              NUMBER,
  PRODUCT_SERIAL_NUM         VARCHAR2(100),
  SAP_POSTING_KEY            VARCHAR2(30),
  SAP_SGL_INDICATOR          VARCHAR2(30),
  JE_TEMPLATE_LN_ID          NUMBER
)
tablespace HL_DEV
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 8K
    minextents 1
    maxextents unlimited
  );
-- Add comments to the table 
comment on table HLS_JOURNAL_SBO_DETAIL
  is '��ϵͳƾ֤�б�';
-- Add comments to the columns 
comment on column HLS_JOURNAL_SBO_DETAIL.JOURNAL_LINE_ID
  is 'ƾ֤�� ID';
comment on column HLS_JOURNAL_SBO_DETAIL.JOURNAL_HEADER_ID
  is 'ƾ֤ ID';
comment on column HLS_JOURNAL_SBO_DETAIL.SOURCE_TABLE
  is '��Դ��';
comment on column HLS_JOURNAL_SBO_DETAIL.SOURCE_ID
  is '��Դ���� ID';
comment on column HLS_JOURNAL_SBO_DETAIL.LINE_NUM
  is '�к�';
comment on column HLS_JOURNAL_SBO_DETAIL.LINE_DESCRIPTION
  is '��ժҪ';
comment on column HLS_JOURNAL_SBO_DETAIL.JE_TEMPLATE_HD_ID
  is 'ƾ֤ģ��ͷ ID';
comment on column HLS_JOURNAL_SBO_DETAIL.TRANSACTION_DATE
  is 'ƾ֤����';
comment on column HLS_JOURNAL_SBO_DETAIL.RESPONSIBILITY_CENTER_ID
  is '��������';
comment on column HLS_JOURNAL_SBO_DETAIL.ACCOUNT_ID
  is '��Ŀ ID';
comment on column HLS_JOURNAL_SBO_DETAIL.USAGE_CODE
  is '��;����';
comment on column HLS_JOURNAL_SBO_DETAIL.EXCHANGE_RATE_TYPE
  is '��������';
comment on column HLS_JOURNAL_SBO_DETAIL.EXCHANGE_RATE
  is '����';
comment on column HLS_JOURNAL_SBO_DETAIL.AMOUNT_DR
  is '�跽��ԭ�ң�';
comment on column HLS_JOURNAL_SBO_DETAIL.AMOUNT_CR
  is '������ԭ�ң�';
comment on column HLS_JOURNAL_SBO_DETAIL.AMOUNT_FUC_DR
  is '�跽�����ң�';
comment on column HLS_JOURNAL_SBO_DETAIL.AMOUNT_FUC_CR
  is '���������ң�';
comment on column HLS_JOURNAL_SBO_DETAIL.REFERENCE1
  is '�ο���1';
comment on column HLS_JOURNAL_SBO_DETAIL.REFERENCE2
  is '�ο���2';
comment on column HLS_JOURNAL_SBO_DETAIL.REFERENCE3
  is '�ο���3';
comment on column HLS_JOURNAL_SBO_DETAIL.REFERENCE4
  is '�ο���4';
comment on column HLS_JOURNAL_SBO_DETAIL.REFERENCE5
  is '�ο���5';
comment on column HLS_JOURNAL_SBO_DETAIL.REFERENCE6
  is '�ο���6';
comment on column HLS_JOURNAL_SBO_DETAIL.REFERENCE7
  is '�ο���7';
comment on column HLS_JOURNAL_SBO_DETAIL.REFERENCE8
  is '�ο���8';
comment on column HLS_JOURNAL_SBO_DETAIL.REFERENCE9
  is '�ο���9';
comment on column HLS_JOURNAL_SBO_DETAIL.CREATION_DATE
  is '��������';
comment on column HLS_JOURNAL_SBO_DETAIL.CREATED_BY
  is '������';
comment on column HLS_JOURNAL_SBO_DETAIL.LAST_UPDATE_DATE
  is '����������';
comment on column HLS_JOURNAL_SBO_DETAIL.LAST_UPDATED_BY
  is '��������';
comment on column HLS_JOURNAL_SBO_DETAIL.LINE_QUANTITY
  is '����';
comment on column HLS_JOURNAL_SBO_DETAIL.SOURCE_DOC_CATEGORY
  is '��Դ�������';
comment on column HLS_JOURNAL_SBO_DETAIL.SOURCE_DOC_TYPE
  is '��Դ��������';
comment on column HLS_JOURNAL_SBO_DETAIL.SOURCE_DOC_ID
  is '��Դ���� ID';
comment on column HLS_JOURNAL_SBO_DETAIL.SOURCE_DOC_LINE_ID
  is '��Դ������ ID';
comment on column HLS_JOURNAL_SBO_DETAIL.SOURCE_DOC_DETAIL_ID
  is '��Դ������ϸ�� ID';
comment on column HLS_JOURNAL_SBO_DETAIL.LEASE_ORGANIZATION
  is '��ҵ��';
comment on column HLS_JOURNAL_SBO_DETAIL.LEASE_CHANNEL
  is '��ҵģʽ';
comment on column HLS_JOURNAL_SBO_DETAIL.DIVISION
  is '��Ʒ��';
comment on column HLS_JOURNAL_SBO_DETAIL.EMPLOYEE_ID
  is 'Ա��';
comment on column HLS_JOURNAL_SBO_DETAIL.UNIT_ID
  is '����';
comment on column HLS_JOURNAL_SBO_DETAIL.PROJECT_ID
  is '��Ŀ';
comment on column HLS_JOURNAL_SBO_DETAIL.CONTRACT_ID
  is '��ͬ';
comment on column HLS_JOURNAL_SBO_DETAIL.CASHFLOW_ID
  is '�ֽ���';
comment on column HLS_JOURNAL_SBO_DETAIL.TIMES
  is '����';
comment on column HLS_JOURNAL_SBO_DETAIL.CF_ITEM
  is '�ֽ�����Ŀ';
comment on column HLS_JOURNAL_SBO_DETAIL.CF_TYPE
  is '�ֽ�������';
comment on column HLS_JOURNAL_SBO_DETAIL.LOAN_CONTRACT_ID
  is '�����ͬ';
comment on column HLS_JOURNAL_SBO_DETAIL.LOAN_CONTRACT_REPAYMENT_ID
  is '�����ͬ����¼';
comment on column HLS_JOURNAL_SBO_DETAIL.CSH_TRX_ID
  is '�ֽ�����';
comment on column HLS_JOURNAL_SBO_DETAIL.BP_ID_TENANT
  is '������';
comment on column HLS_JOURNAL_SBO_DETAIL.BP_ID_VENDER
  is '��Ӧ��';
comment on column HLS_JOURNAL_SBO_DETAIL.BP_ID_AGENT
  is '������';
comment on column HLS_JOURNAL_SBO_DETAIL.BP_ID_BANK
  is '����';
comment on column HLS_JOURNAL_SBO_DETAIL.BP_ID_BANK_BRANCH
  is '���з���';
comment on column HLS_JOURNAL_SBO_DETAIL.LEASE_ITEM_ID
  is '������';
comment on column HLS_JOURNAL_SBO_DETAIL.PRODUCT_SERIAL_NUM
  is '��Ʒ���к�';
comment on column HLS_JOURNAL_SBO_DETAIL.SAP_POSTING_KEY
  is 'SAP������';
comment on column HLS_JOURNAL_SBO_DETAIL.SAP_SGL_INDICATOR
  is 'SAP�ر����˱�ʶ';
-- Create/Recreate primary, unique and foreign key constraints 
alter table HLS_JOURNAL_SBO_DETAIL
  add constraint HLS_JOURNAL_SBO_DETAIL_PK primary key (JOURNAL_LINE_ID)
  using index 
  tablespace HL_DEV
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Create/Recreate indexes 
create index HLS_JOURNAL_SBO_DETAIL_N1 on HLS_JOURNAL_SBO_DETAIL (JOURNAL_HEADER_ID)
  tablespace HL_DEV
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
