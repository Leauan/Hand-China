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
  is '子系统凭证行表';
-- Add comments to the columns 
comment on column HLS_JOURNAL_SBO_DETAIL.JOURNAL_LINE_ID
  is '凭证行 ID';
comment on column HLS_JOURNAL_SBO_DETAIL.JOURNAL_HEADER_ID
  is '凭证 ID';
comment on column HLS_JOURNAL_SBO_DETAIL.SOURCE_TABLE
  is '来源表';
comment on column HLS_JOURNAL_SBO_DETAIL.SOURCE_ID
  is '来源单据 ID';
comment on column HLS_JOURNAL_SBO_DETAIL.LINE_NUM
  is '行号';
comment on column HLS_JOURNAL_SBO_DETAIL.LINE_DESCRIPTION
  is '行摘要';
comment on column HLS_JOURNAL_SBO_DETAIL.JE_TEMPLATE_HD_ID
  is '凭证模板头 ID';
comment on column HLS_JOURNAL_SBO_DETAIL.TRANSACTION_DATE
  is '凭证日期';
comment on column HLS_JOURNAL_SBO_DETAIL.RESPONSIBILITY_CENTER_ID
  is '责任中心';
comment on column HLS_JOURNAL_SBO_DETAIL.ACCOUNT_ID
  is '科目 ID';
comment on column HLS_JOURNAL_SBO_DETAIL.USAGE_CODE
  is '用途代码';
comment on column HLS_JOURNAL_SBO_DETAIL.EXCHANGE_RATE_TYPE
  is '汇率类型';
comment on column HLS_JOURNAL_SBO_DETAIL.EXCHANGE_RATE
  is '汇率';
comment on column HLS_JOURNAL_SBO_DETAIL.AMOUNT_DR
  is '借方金额（原币）';
comment on column HLS_JOURNAL_SBO_DETAIL.AMOUNT_CR
  is '贷方金额（原币）';
comment on column HLS_JOURNAL_SBO_DETAIL.AMOUNT_FUC_DR
  is '借方金额（本币）';
comment on column HLS_JOURNAL_SBO_DETAIL.AMOUNT_FUC_CR
  is '贷方金额（本币）';
comment on column HLS_JOURNAL_SBO_DETAIL.REFERENCE1
  is '参考段1';
comment on column HLS_JOURNAL_SBO_DETAIL.REFERENCE2
  is '参考段2';
comment on column HLS_JOURNAL_SBO_DETAIL.REFERENCE3
  is '参考段3';
comment on column HLS_JOURNAL_SBO_DETAIL.REFERENCE4
  is '参考段4';
comment on column HLS_JOURNAL_SBO_DETAIL.REFERENCE5
  is '参考段5';
comment on column HLS_JOURNAL_SBO_DETAIL.REFERENCE6
  is '参考段6';
comment on column HLS_JOURNAL_SBO_DETAIL.REFERENCE7
  is '参考段7';
comment on column HLS_JOURNAL_SBO_DETAIL.REFERENCE8
  is '参考段8';
comment on column HLS_JOURNAL_SBO_DETAIL.REFERENCE9
  is '参考段9';
comment on column HLS_JOURNAL_SBO_DETAIL.CREATION_DATE
  is '创建日期';
comment on column HLS_JOURNAL_SBO_DETAIL.CREATED_BY
  is '创建者';
comment on column HLS_JOURNAL_SBO_DETAIL.LAST_UPDATE_DATE
  is '最后更新日期';
comment on column HLS_JOURNAL_SBO_DETAIL.LAST_UPDATED_BY
  is '最后更新者';
comment on column HLS_JOURNAL_SBO_DETAIL.LINE_QUANTITY
  is '行数';
comment on column HLS_JOURNAL_SBO_DETAIL.SOURCE_DOC_CATEGORY
  is '来源单据类别';
comment on column HLS_JOURNAL_SBO_DETAIL.SOURCE_DOC_TYPE
  is '来源单据类型';
comment on column HLS_JOURNAL_SBO_DETAIL.SOURCE_DOC_ID
  is '来源单据 ID';
comment on column HLS_JOURNAL_SBO_DETAIL.SOURCE_DOC_LINE_ID
  is '来源单据行 ID';
comment on column HLS_JOURNAL_SBO_DETAIL.SOURCE_DOC_DETAIL_ID
  is '来源单据明细行 ID';
comment on column HLS_JOURNAL_SBO_DETAIL.LEASE_ORGANIZATION
  is '事业部';
comment on column HLS_JOURNAL_SBO_DETAIL.LEASE_CHANNEL
  is '商业模式';
comment on column HLS_JOURNAL_SBO_DETAIL.DIVISION
  is '产品线';
comment on column HLS_JOURNAL_SBO_DETAIL.EMPLOYEE_ID
  is '员工';
comment on column HLS_JOURNAL_SBO_DETAIL.UNIT_ID
  is '部门';
comment on column HLS_JOURNAL_SBO_DETAIL.PROJECT_ID
  is '项目';
comment on column HLS_JOURNAL_SBO_DETAIL.CONTRACT_ID
  is '合同';
comment on column HLS_JOURNAL_SBO_DETAIL.CASHFLOW_ID
  is '现金流';
comment on column HLS_JOURNAL_SBO_DETAIL.TIMES
  is '期数';
comment on column HLS_JOURNAL_SBO_DETAIL.CF_ITEM
  is '现金流项目';
comment on column HLS_JOURNAL_SBO_DETAIL.CF_TYPE
  is '现金流类型';
comment on column HLS_JOURNAL_SBO_DETAIL.LOAN_CONTRACT_ID
  is '贷款合同';
comment on column HLS_JOURNAL_SBO_DETAIL.LOAN_CONTRACT_REPAYMENT_ID
  is '贷款合同提款记录';
comment on column HLS_JOURNAL_SBO_DETAIL.CSH_TRX_ID
  is '现金事务';
comment on column HLS_JOURNAL_SBO_DETAIL.BP_ID_TENANT
  is '承租人';
comment on column HLS_JOURNAL_SBO_DETAIL.BP_ID_VENDER
  is '供应商';
comment on column HLS_JOURNAL_SBO_DETAIL.BP_ID_AGENT
  is '代理商';
comment on column HLS_JOURNAL_SBO_DETAIL.BP_ID_BANK
  is '银行';
comment on column HLS_JOURNAL_SBO_DETAIL.BP_ID_BANK_BRANCH
  is '银行分行';
comment on column HLS_JOURNAL_SBO_DETAIL.LEASE_ITEM_ID
  is '租赁物';
comment on column HLS_JOURNAL_SBO_DETAIL.PRODUCT_SERIAL_NUM
  is '产品序列号';
comment on column HLS_JOURNAL_SBO_DETAIL.SAP_POSTING_KEY
  is 'SAP记账码';
comment on column HLS_JOURNAL_SBO_DETAIL.SAP_SGL_INDICATOR
  is 'SAP特别总账标识';
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
