-- Create table
create table HLS_JOURNAL_SBO_HEADER
(
  JOURNAL_HEADER_ID          NUMBER not null,
  SOURCE_TABLE               VARCHAR2(30) not null,
  SOURCE_ID                  NUMBER,
  COMPANY_ID                 NUMBER not null,
  JE_COMPANY_ID              NUMBER,
  JOURNAL_NUM                VARCHAR2(30),
  JOURNAL_DATE               DATE,
  PERIOD_SET_CODE            VARCHAR2(30) not null,
  INTERNAL_PERIOD_NUM        NUMBER not null,
  PERIOD_NAME                VARCHAR2(30),
  PERIOD_YEAR                NUMBER,
  PERIOD_NUM                 NUMBER,
  JE_TEMPLATE_SET_CODE       VARCHAR2(100),
  JE_TRANSACTION_CODE        VARCHAR2(100),
  STATUS                     VARCHAR2(30),
  CURRENCY_CODE              VARCHAR2(30),
  EXCHANGE_RATE_QUOTATION    VARCHAR2(30),
  EXCHANGE_RATE_TYPE         VARCHAR2(30),
  EXCHANGE_RATE              NUMBER,
  ATTACHMENT_NUM             NUMBER,
  TOTAL_AMOUNT_DR            NUMBER,
  TOTAL_AMOUNT_CR            NUMBER,
  TOTAL_AMOUNT_FUC_DR        NUMBER,
  TOTAL_AMOUNT_FUC_CR        NUMBER,
  DESCRIPTION                VARCHAR2(2000),
  CREATION_DATE              DATE,
  CREATED_BY                 NUMBER,
  LAST_UPDATE_DATE           DATE,
  LAST_UPDATED_BY            NUMBER,
  APPROVED_DATE              DATE,
  APPROVED_BY                NUMBER,
  POST_GL_STATUS             VARCHAR2(30),
  POST_GL_DATE               DATE,
  POST_GL_BY                 NUMBER,
  POST_GL_LOG                VARCHAR2(2000),
  JE_BATCH_ID                NUMBER,
  REVERSED_JOURNAL_HEADER_ID NUMBER,
  REVERSED_FLAG              VARCHAR2(1),
  REVERSED_DATE              DATE,
  EXTERNAL_JOURNAL_HD_ID     NUMBER,
  EXTERNAL_JOURNAL_NUM       VARCHAR2(100),
  JE_TEMPLATE_HD_ID          NUMBER,
  DOCUMENT_CATEGORY          VARCHAR2(30),
  DOCUMENT_TYPE              VARCHAR2(30),
  MERGE_FLAG                 VARCHAR2(2) default 'N',
  MERGE_PARENT_FLAG          VARCHAR2(2) default 'N'
)
tablespace HL_DEV
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the table 
comment on table HLS_JOURNAL_SBO_HEADER
  is '��ϵͳƾ֤ͷ��';
-- Add comments to the columns 
comment on column HLS_JOURNAL_SBO_HEADER.JOURNAL_HEADER_ID
  is '��ϵͳƾ֤ ID';
comment on column HLS_JOURNAL_SBO_HEADER.SOURCE_TABLE
  is '��Դ���ݱ�';
comment on column HLS_JOURNAL_SBO_HEADER.SOURCE_ID
  is '��Դ����ID';
comment on column HLS_JOURNAL_SBO_HEADER.COMPANY_ID
  is 'ҵ�������Ĺ�˾';
comment on column HLS_JOURNAL_SBO_HEADER.JE_COMPANY_ID
  is 'ƾ֤�����Ĺ�˾';
comment on column HLS_JOURNAL_SBO_HEADER.JOURNAL_NUM
  is 'ƾ֤���';
comment on column HLS_JOURNAL_SBO_HEADER.JOURNAL_DATE
  is 'ƾ֤����';
comment on column HLS_JOURNAL_SBO_HEADER.PERIOD_SET_CODE
  is '�ڼ����';
comment on column HLS_JOURNAL_SBO_HEADER.INTERNAL_PERIOD_NUM
  is '�ڼ��ڲ����';
comment on column HLS_JOURNAL_SBO_HEADER.PERIOD_NAME
  is '�ڼ�����';
comment on column HLS_JOURNAL_SBO_HEADER.PERIOD_YEAR
  is '���';
comment on column HLS_JOURNAL_SBO_HEADER.PERIOD_NUM
  is '�ڼ����';
comment on column HLS_JOURNAL_SBO_HEADER.JE_TEMPLATE_SET_CODE
  is 'ƾ֤ģ������';
comment on column HLS_JOURNAL_SBO_HEADER.JE_TRANSACTION_CODE
  is 'ƾ֤����';
comment on column HLS_JOURNAL_SBO_HEADER.STATUS
  is '����ƾ֤״̬';
comment on column HLS_JOURNAL_SBO_HEADER.CURRENCY_CODE
  is '����';
comment on column HLS_JOURNAL_SBO_HEADER.EXCHANGE_RATE_QUOTATION
  is '���ʱ��۷���';
comment on column HLS_JOURNAL_SBO_HEADER.EXCHANGE_RATE_TYPE
  is '��������';
comment on column HLS_JOURNAL_SBO_HEADER.EXCHANGE_RATE
  is '����';
comment on column HLS_JOURNAL_SBO_HEADER.ATTACHMENT_NUM
  is '������';
comment on column HLS_JOURNAL_SBO_HEADER.TOTAL_AMOUNT_DR
  is '�跽���ϼ�';
comment on column HLS_JOURNAL_SBO_HEADER.TOTAL_AMOUNT_CR
  is '�������ϼ�';
comment on column HLS_JOURNAL_SBO_HEADER.TOTAL_AMOUNT_FUC_DR
  is '�跽���ϼƣ����ң�';
comment on column HLS_JOURNAL_SBO_HEADER.TOTAL_AMOUNT_FUC_CR
  is '�������ϼƣ����ң�';
comment on column HLS_JOURNAL_SBO_HEADER.DESCRIPTION
  is 'ͷժҪ';
comment on column HLS_JOURNAL_SBO_HEADER.CREATION_DATE
  is '��������';
comment on column HLS_JOURNAL_SBO_HEADER.CREATED_BY
  is '������';
comment on column HLS_JOURNAL_SBO_HEADER.LAST_UPDATE_DATE
  is '����������';
comment on column HLS_JOURNAL_SBO_HEADER.LAST_UPDATED_BY
  is '��������';
comment on column HLS_JOURNAL_SBO_HEADER.APPROVED_DATE
  is '��������';
comment on column HLS_JOURNAL_SBO_HEADER.APPROVED_BY
  is '������';
comment on column HLS_JOURNAL_SBO_HEADER.POST_GL_STATUS
  is '���˹���״̬';
comment on column HLS_JOURNAL_SBO_HEADER.POST_GL_DATE
  is '���˹�������';
comment on column HLS_JOURNAL_SBO_HEADER.POST_GL_BY
  is '���˹�����';
comment on column HLS_JOURNAL_SBO_HEADER.JE_BATCH_ID
  is 'ƾ֤����ID';
comment on column HLS_JOURNAL_SBO_HEADER.REVERSED_JOURNAL_HEADER_ID
  is '����ƾ֤ ID';
comment on column HLS_JOURNAL_SBO_HEADER.REVERSED_FLAG
  is '�����־';
comment on column HLS_JOURNAL_SBO_HEADER.REVERSED_DATE
  is '��������';
comment on column HLS_JOURNAL_SBO_HEADER.EXTERNAL_JOURNAL_HD_ID
  is '�ⲿƾ֤ ID';
comment on column HLS_JOURNAL_SBO_HEADER.EXTERNAL_JOURNAL_NUM
  is '�ⲿƾ֤��';
-- Create/Recreate primary, unique and foreign key constraints 
alter table HLS_JOURNAL_SBO_HEADER
  add constraint HLS_JOURNAL_SBO_HEADER_PK primary key (JOURNAL_HEADER_ID)
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
create index HLS_JOURNAL_SBO_HEADER_N1 on HLS_JOURNAL_SBO_HEADER (JOURNAL_DATE, COMPANY_ID)
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
create index HLS_JOURNAL_SBO_HEADER_N2 on HLS_JOURNAL_SBO_HEADER (PERIOD_YEAR, PERIOD_NUM, COMPANY_ID)
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
create index HLS_JOURNAL_SBO_HEADER_N3 on HLS_JOURNAL_SBO_HEADER (JE_BATCH_ID)
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
create unique index HLS_JOURNAL_SBO_HEADER_U1 on HLS_JOURNAL_SBO_HEADER (JOURNAL_NUM, INTERNAL_PERIOD_NUM, COMPANY_ID)
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
