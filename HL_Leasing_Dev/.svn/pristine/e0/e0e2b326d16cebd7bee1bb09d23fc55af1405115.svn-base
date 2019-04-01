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
  is '子系统凭证头表';
-- Add comments to the columns 
comment on column HLS_JOURNAL_SBO_HEADER.JOURNAL_HEADER_ID
  is '子系统凭证 ID';
comment on column HLS_JOURNAL_SBO_HEADER.SOURCE_TABLE
  is '来源数据表';
comment on column HLS_JOURNAL_SBO_HEADER.SOURCE_ID
  is '来源数据ID';
comment on column HLS_JOURNAL_SBO_HEADER.COMPANY_ID
  is '业务所属的公司';
comment on column HLS_JOURNAL_SBO_HEADER.JE_COMPANY_ID
  is '凭证所属的公司';
comment on column HLS_JOURNAL_SBO_HEADER.JOURNAL_NUM
  is '凭证编号';
comment on column HLS_JOURNAL_SBO_HEADER.JOURNAL_DATE
  is '凭证日期';
comment on column HLS_JOURNAL_SBO_HEADER.PERIOD_SET_CODE
  is '期间代码';
comment on column HLS_JOURNAL_SBO_HEADER.INTERNAL_PERIOD_NUM
  is '期间内部序号';
comment on column HLS_JOURNAL_SBO_HEADER.PERIOD_NAME
  is '期间名称';
comment on column HLS_JOURNAL_SBO_HEADER.PERIOD_YEAR
  is '年份';
comment on column HLS_JOURNAL_SBO_HEADER.PERIOD_NUM
  is '期间序号';
comment on column HLS_JOURNAL_SBO_HEADER.JE_TEMPLATE_SET_CODE
  is '凭证模板表代码';
comment on column HLS_JOURNAL_SBO_HEADER.JE_TRANSACTION_CODE
  is '凭证事务';
comment on column HLS_JOURNAL_SBO_HEADER.STATUS
  is '传送凭证状态';
comment on column HLS_JOURNAL_SBO_HEADER.CURRENCY_CODE
  is '币种';
comment on column HLS_JOURNAL_SBO_HEADER.EXCHANGE_RATE_QUOTATION
  is '汇率报价方法';
comment on column HLS_JOURNAL_SBO_HEADER.EXCHANGE_RATE_TYPE
  is '汇率类型';
comment on column HLS_JOURNAL_SBO_HEADER.EXCHANGE_RATE
  is '汇率';
comment on column HLS_JOURNAL_SBO_HEADER.ATTACHMENT_NUM
  is '附件数';
comment on column HLS_JOURNAL_SBO_HEADER.TOTAL_AMOUNT_DR
  is '借方金额合计';
comment on column HLS_JOURNAL_SBO_HEADER.TOTAL_AMOUNT_CR
  is '贷方金额合计';
comment on column HLS_JOURNAL_SBO_HEADER.TOTAL_AMOUNT_FUC_DR
  is '借方金额合计（本币）';
comment on column HLS_JOURNAL_SBO_HEADER.TOTAL_AMOUNT_FUC_CR
  is '贷方金额合计（本币）';
comment on column HLS_JOURNAL_SBO_HEADER.DESCRIPTION
  is '头摘要';
comment on column HLS_JOURNAL_SBO_HEADER.CREATION_DATE
  is '创建日期';
comment on column HLS_JOURNAL_SBO_HEADER.CREATED_BY
  is '创建者';
comment on column HLS_JOURNAL_SBO_HEADER.LAST_UPDATE_DATE
  is '最后更新日期';
comment on column HLS_JOURNAL_SBO_HEADER.LAST_UPDATED_BY
  is '最后更新者';
comment on column HLS_JOURNAL_SBO_HEADER.APPROVED_DATE
  is '复核日期';
comment on column HLS_JOURNAL_SBO_HEADER.APPROVED_BY
  is '复核人';
comment on column HLS_JOURNAL_SBO_HEADER.POST_GL_STATUS
  is '总账过账状态';
comment on column HLS_JOURNAL_SBO_HEADER.POST_GL_DATE
  is '总账过账日期';
comment on column HLS_JOURNAL_SBO_HEADER.POST_GL_BY
  is '总账过账者';
comment on column HLS_JOURNAL_SBO_HEADER.JE_BATCH_ID
  is '凭证批次ID';
comment on column HLS_JOURNAL_SBO_HEADER.REVERSED_JOURNAL_HEADER_ID
  is '反冲凭证 ID';
comment on column HLS_JOURNAL_SBO_HEADER.REVERSED_FLAG
  is '反冲标志';
comment on column HLS_JOURNAL_SBO_HEADER.REVERSED_DATE
  is '反冲日期';
comment on column HLS_JOURNAL_SBO_HEADER.EXTERNAL_JOURNAL_HD_ID
  is '外部凭证 ID';
comment on column HLS_JOURNAL_SBO_HEADER.EXTERNAL_JOURNAL_NUM
  is '外部凭证号';
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
