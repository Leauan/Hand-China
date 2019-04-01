-- Create table
create table HL_TRANSACTION_SPLIT
(
  HL_SP_ID           NUMBER,
  TRANSACTION_ID     NUMBER,
  TRANSACTION_AMOUNT NUMBER,
  CREATED_BY         NUMBER,
  CREATED_DATE       DATE,
  LAST_UPDATE_BY     NUMBER,
  LAST_UPDATE_DATE   DATE
)
tablespace HL_DEV
  pctfree 10
  initrans 1
  maxtrans 255;
-- Add comments to the table 
comment on table HL_TRANSACTION_SPLIT
  is '宏菱项目_现金事物拆分';
-- Add comments to the columns 
comment on column HL_TRANSACTION_SPLIT.HL_SP_ID
  is '主键/PK';
comment on column HL_TRANSACTION_SPLIT.TRANSACTION_ID
  is '现金事物ID';
comment on column HL_TRANSACTION_SPLIT.TRANSACTION_AMOUNT
  is '金额';
comment on column HL_TRANSACTION_SPLIT.CREATED_BY
  is '创建人';
comment on column HL_TRANSACTION_SPLIT.CREATED_DATE
  is '创建时间';
comment on column HL_TRANSACTION_SPLIT.LAST_UPDATE_BY
  is '最后修改人';
comment on column HL_TRANSACTION_SPLIT.LAST_UPDATE_DATE
  is '最后修改时间';
--create sequence
  CREATE SEQUENCE
 HL_TRANSACTION_SPLIT_S start with 1 increment by 1;