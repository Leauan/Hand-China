  --  add by CLiyuan 终极版归档
  PROCEDURE create_con_file_management(p_contract_id        NUMBER,
                                       p_file_management_id IN OUT NUMBER,
                                       -- p_cdd_list_id        IN OUT NUMBER,
                                       p_archives_num VARCHAR2,
                                       p_user_id      NUMBER) IS
    v_count_ins    NUMBER;
    v_count_del    NUMBER;
    v_archives_num VARCHAR2(200);
    v_project_id   NUMBER;
    v_tab_group_id NUMBER; --  分组ID
    v_count        NUMBER;
    --  弱类型游标绑定动态sql的使用
    TYPE ref_cdd_cur IS REF CURSOR;
    l_cdd_cur     ref_cdd_cur; --  定义弱类型游标变量
    l_dynamic_sql VARCHAR(5000) := NULL;
    TYPE cdd_record IS RECORD(
      cdd_item     VARCHAR2(30),
      description  VARCHAR2(100),
      order_seq    NUMBER,
      check_id     NUMBER,
      sys_flag     VARCHAR2(1),
      cdd_list_id  NUMBER,
      cdd_item_id  NUMBER,
      tab_group_id NUMBER,
      tab_group    VARCHAR2(100),
      seq_num      NUMBER);
    TYPE cdd_records_type IS TABLE OF cdd_record INDEX BY BINARY_INTEGER;
    cdd_records cdd_records_type;
  
  BEGIN
    -- 归档表file_management
    IF p_file_management_id IS NULL THEN
      INSERT INTO con_file_management
        (file_management_id,
         created_by,
         creation_date,
         last_updated_by,
         last_update_date,
         contract_id,
         archives_num)
      VALUES
        (con_file_management_s.nextval,
         p_user_id,
         SYSDATE,
         p_user_id,
         SYSDATE,
         p_contract_id,
         p_archives_num)
      RETURNING file_management_id INTO p_file_management_id;
    ELSE
      UPDATE con_file_management cfm
         SET cfm.archives_num = p_archives_num
       WHERE cfm.file_management_id = p_file_management_id;
    END IF;
    -- 资料清单部分
    l_dynamic_sql := 'SELECT pci.cdd_item,
                              pci.description, 
                              pci.order_seq,
                              pp.check_id,
                              pci.sys_flag, 
                              pci.cdd_list_id,
                              pci.cdd_item_id,
                              tg.tab_group_id,
                              tg.tab_group, 
                              lgt.seq_num
                         FROM (SELECT pcf.check_id,
                                      pcf.document_id,
                                      pcf.document_table,
                                      pck.cdd_item_id,
                                      pck.creation_date,
                                      pck.order_no
                                 FROM prj_cdd_item_doc_ref pcf, prj_cdd_item_check pck
                                WHERE pcf.document_table = :1
                                  AND pcf.document_id = :2
                                  AND pck.check_id = pcf.check_id) pp,
                              prj_cdd_item pci,
                              prj_cdd_item_list_grp_tab lgt,
                              prj_cdd_item_tab_group tg
                        WHERE pci.cdd_item_id = lgt.cdd_item_id
                          AND lgt.tab_group_id = tg.tab_group_id
                          AND lgt.enabled_flag = ''Y''
                          AND tg.enabled_flag = ''Y''
                          AND (tg.tab_group_id = :3 OR EXISTS
                               (SELECT 1
                                  FROM prj_cdd_item_tab_group_def pcd
                                 WHERE pcd.tab_group_id = tg.tab_group_id
                                   AND pcd.parent_tab_group_id = :4))
                          AND pci.cdd_item_id = pp.cdd_item_id(+)
                          AND (nvl(pci.sys_flag, ''N'') = ''Y'' OR
                              (nvl(pci.sys_flag, ''N'') = ''N'' AND pp.check_id IS NOT NULL))
                          AND pci.cdd_list_id = nvl(:5, :6)
                          AND pci.enabled_flag = ''Y''
                          AND lgt.cdd_list_id = pci.cdd_list_id
                          AND pp.document_id = lgt.document_id
                          AND pp.document_table = lgt.document_table
                        ORDER BY nvl(pp.order_no, 999999),
                                 pp.creation_date DESC,
                                 pci.sys_flag,
                                 lgt.seq_num';
  
    FOR cur_cdd_list IN (SELECT p.cdd_list_id,
                                'PRJ_PROJECT' document_table,
                                p.project_id document_id,
                                p.lease_channel,
                                CASE
                                  WHEN p.lease_channel = 60 AND
                                       t.tab_group = 'INDUSTRY' THEN
                                   141
                                  ELSE
                                   t.tab_group_id
                                END AS tab_group_id
                           FROM prj_project p,
                                (SELECT lgt.tab_group_id,
                                        lgt.cdd_list_id,
                                        tg.tab_group
                                   FROM prj_cdd_item_tab_group    tg,
                                        prj_cdd_item_list_grp_tab lgt
                                  WHERE tg.tab_group_id = lgt.tab_group_id
                                    AND tg.tab_group IN
                                        ('INDUSTRY',
                                         'LEGAL_OPINION',
                                         'RISK_ANALYSIS')
                                 --  附件分组 项目：产业类  评审：法律，信审
                                  GROUP BY lgt.tab_group_id,
                                           lgt.cdd_list_id,
                                           tg.tab_group) t
                          WHERE p.cdd_list_id = t.cdd_list_id
                            AND p.project_id =
                                (SELECT c.project_id
                                   FROM con_contract c
                                  WHERE c.contract_id = p_contract_id)
                         
                         UNION
                         
                         SELECT c.cdd_list_id,
                                'CON_CONTRACT' document_table,
                                c.contract_id document_id,
                                NULL lease_channel,
                                t.tab_group_id
                           FROM con_contract c,
                                (SELECT lgt.tab_group_id,
                                        lgt.cdd_list_id,
                                        tg.tab_group
                                   FROM prj_cdd_item_tab_group    tg,
                                        prj_cdd_item_list_grp_tab lgt
                                  WHERE tg.tab_group_id = lgt.tab_group_id
                                    AND tg.tab_group IN
                                        ('CONTRACT', 'CHANGE_REQ')
                                 --  附件分组 合同(含租前变更), 提前结清
                                  GROUP BY lgt.tab_group_id,
                                           lgt.cdd_list_id,
                                           tg.tab_group) t
                          WHERE c.cdd_list_id = t.cdd_list_id
                            AND c.contract_id = p_contract_id
                         
                         UNION
                         
                         SELECT ch.cdd_list_id,
                                'CSH_PAYMENT_REQ_HD' document_table,
                                ch.payment_req_id document_id,
                                NULL lease_channel,
                                103 tab_group_id
                           FROM csh_payment_req_hd ch
                          WHERE ch.payment_req_id =
                                (SELECT cl.payment_req_id
                                   FROM csh_payment_req_ln cl
                                  WHERE cl.ref_doc_category = 'CONTRACT'
                                    AND cl.ref_doc_id = p_contract_id
                                    AND rownum = 1)) LOOP
      
      OPEN l_cdd_cur FOR l_dynamic_sql
        USING cur_cdd_list.document_table, cur_cdd_list.document_id, cur_cdd_list.tab_group_id, cur_cdd_list.tab_group_id, cur_cdd_list.cdd_list_id, cur_cdd_list.cdd_list_id;
      FETCH l_cdd_cur BULK COLLECT
        INTO cdd_records;
    
      FOR i IN 1 .. cdd_records.count LOOP
      -- 判断同一项目下不同合同是否跳过插入相同项目及评审资料清单
        -- insert 操作 暂时不考虑附件清单删除的联动
        SELECT COUNT(1)
          INTO v_count_ins
          FROM con_file_atm cf
         WHERE /*cf.file_management_id = p_file_management_id
           AND*/ cf.cdd_item_id = cdd_records(i).cdd_item_id
           AND cf.cdd_list_id = cdd_records(i).cdd_list_id;
      
        IF v_count_ins = 0 THEN
          insert_con_file_atm(p_file_management_id,
                              cdd_records         (i).description,
                              cdd_records         (i).order_seq,
                              'PRJ_CDD_ITEM_CHECK',
                              cdd_records         (i).check_id,
                              cdd_records         (i).sys_flag,
                              cdd_records         (i).cdd_list_id,
                              cdd_records         (i).cdd_item_id,
                              cdd_records         (i).tab_group,
                              p_user_id);
        END IF;
      END LOOP;
      CLOSE l_cdd_cur;
    END LOOP;
    v_count_ins := 0;
    v_count_del := 0;
    v_count     := 0;
    -- 非资料清单部分  无cdd_list_id
    SELECT cc.project_id
      INTO v_project_id
      FROM con_contract_lv cc
     WHERE cc.contract_id = p_contract_id;
    FOR cur_list IN ( -- 信审和法审
                     SELECT fam.table_name,
                             fam.table_pk_value,
                             decode(fam.table_name,
                                    'PRJ_PROJECT_LEGAL',
                                    '信用审查意见-其他授信附件',
                                    '法律合规意见-其他授信附件') descriptions
                       FROM fnd_atm_attachment_multi fam
                      WHERE fam.table_name IN
                            ('PRJ_PROJECT_LEGAL', 'PRJ_PROJECT_LEGAL_LAW')
                        AND fam.table_pk_value IN
                            (SELECT ppl.legal_id
                               FROM prj_project_legal ppl
                              WHERE ppl.project_id = v_project_id)
                      GROUP BY fam.table_name, fam.table_pk_value
                     
                     UNION ALL
                     -- 决议附件
                     SELECT fam.table_name,
                             fam.table_pk_value,
                             decode(t.reply_type,
                                    'COMPANY',
                                    '光谷决议附件',
                                    'BLOC',
                                    '集团决议附件',
                                    '决策小组决议附件') descriptions
                       FROM fnd_atm_attachment_multi fam,
                             (SELECT ppd.decision_id, ppd.reply_type
                                FROM prj_project_decision ppd
                               WHERE ppd.project_id = v_project_id) t
                      WHERE fam.table_name IN
                            ('PRJ_PROJECT_DECISION_GROUP',
                             'PRJ_PROJECT_DECISION')
                        AND fam.table_pk_value IN t.decision_id
                      GROUP BY fam.table_name,
                                fam.table_pk_value,
                                t.reply_type
                     
                     UNION ALL
                     -- 资产处置附件
                     SELECT fam.table_name,
                             fam.table_pk_value,
                             '资产处置附件' AS descriptions
                       FROM fnd_atm_attachment_multi fam
                      WHERE fam.table_name = 'AAP_CDD_ITEM'
                        AND fam.table_pk_value IN
                            (SELECT a.aap_cdd_id
                               FROM aap_cdd_item a, ast_asset_process aa
                              WHERE a.aap_id = aa.aap_id
                                AND aa.contract_id = p_contract_id)
                      GROUP BY fam.table_name, fam.table_pk_value
                     
                     UNION ALL
                     -- 诉讼申请附件
                     SELECT fam.table_name,
                             fam.table_pk_value,
                             t.item_info AS descriptions
                       FROM fnd_atm_attachment_multi fam,
                             (SELECT lc.law_cdd_id, lc.item_info
                                FROM law_cdd_item lc, con_contract_law cl
                               WHERE lc.law_id = cl.law_id
                                 AND cl.contract_id = p_contract_id) t
                      WHERE fam.table_name = 'LEG_LEGAL_LETTER'
                        AND fam.table_pk_value IN t.law_cdd_id
                      GROUP BY fam.table_name,
                                fam.table_pk_value,
                                t.item_info
                     
                     UNION ALL
                     -- 诉讼维护附件
                     SELECT fam.table_name,
                             fam.table_pk_value,
                             decode(fam.table_name,
                                    'LEG_LAWSUIT',
                                    '诉讼附件-诉讼',
                                    '诉讼附件-执行') AS descriptions
                       FROM fnd_atm_attachment_multi fam
                      WHERE fam.table_name IN ('LEG_LAWSUIT', 'LEG_EXECUTE')
                        AND fam.table_pk_value = p_contract_id
                      GROUP BY fam.table_name, fam.table_pk_value
                     
                     UNION ALL
                     -- 巡检报告附件
                     SELECT fam.table_name,
                             fam.table_pk_value,
                             '巡检报告明细附件' AS descriptions
                       FROM fnd_atm_attachment_multi fam
                      WHERE fam.table_name = 'BP_POLLING_REPORT'
                        AND fam.table_pk_value =
                            (SELECT br.bp_report_id
                               FROM bp_polling_report br
                              WHERE br.contract_id = p_contract_id)
                      GROUP BY fam.table_name, fam.table_pk_value) LOOP
      -- 判断同一项目下不同合同是否跳过插入相同项目评审资料
      SELECT COUNT(1)
        INTO v_count_ins
        FROM con_file_atm cf
       WHERE /*cf.file_management_id = p_file_management_id
         AND*/ cf.table_name = cur_list.table_name
         AND cf.table_pk_value = cur_list.table_pk_value;
      --  判断重复插入
      IF v_count_ins = 0 THEN
        insert_con_file_atm(p_file_management_id,
                            cur_list.descriptions,
                            NULL,
                            cur_list.table_name,
                            cur_list.table_pk_value,
                            'N',
                            NULL,
                            NULL,
                            NULL,
                            p_user_id);
      END IF;
    END LOOP;
  END create_con_file_management;
  -- 资料清单插入归档表
  PROCEDURE insert_con_file_atm(p_file_management_id NUMBER,
                                p_description        VARCHAR2,
                                p_order_seq          NUMBER,
                                p_table_name         VARCHAR2,
                                p_table_pk_value     NUMBER,
                                p_sys_flag           VARCHAR2,
                                p_cdd_list_id        NUMBER,
                                p_cdd_item_id        NUMBER,
                                p_tab_group          VARCHAR2,
                                p_user_id            NUMBER) IS
    v_document_table VARCHAR2(30);
  BEGIN
    /* CASE 
    WHEN p_tab_group IS NOT NULL THEN */
    CASE
      WHEN p_tab_group IN ('PLATFROM', 'INDUSTRY') THEN
        IF p_order_seq = 705 OR p_order_seq = 730 THEN
          -- 项目资料有两列归为评审资料
          v_document_table := 'REVIEW';
        ELSE
          v_document_table := 'PROJECT';
        END IF;
      WHEN p_tab_group IN ('LEGAL_OPINION', 'RISK_ANALYSIS') THEN
        v_document_table := 'REVIEW';
      WHEN p_tab_group = 'CONTRACT' THEN
        v_document_table := 'CONTRACT';
      WHEN p_tab_group = 'PAYMENT_REQ' THEN
        v_document_table := 'PAYMENT';
      ELSE
        CASE
          WHEN p_table_name IN
               ('PRJ_PROJECT_LEGAL',
                'PRJ_PROJECT_LEGAL_LAW',
                'PRJ_PROJECT_DECISION',
                'PRJ_PROJECT_DECISION_GROUP') THEN
            v_document_table := 'REVIEW';
          ELSE
            v_document_table := 'RENTAL';
        END CASE;
    END CASE;
    /*ELSE
       CASE 
         WHEN p_table_name IN ('PRJ_PROJECT_LEGAL', 'PRJ_PROJECT_LEGAL_LAW', 'PRJ_PROJECT_DECISION', 'PRJ_PROJECT_DECISION_GROUP') THEN 
           v_document_table := 'REVIEW';
         ELSE 
           v_document_table := 'RENTAL';
       END CASE;
    END CASE;*/
  
    INSERT INTO con_file_atm
      (file_atm_id,
       file_management_id,
       cdd_list_id,
       cdd_item_id,
       file_name,
       sys_flag,
       table_name,
       table_pk_value,
       document_table,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
    VALUES
      (con_file_atm_s.nextval,
       p_file_management_id,
       p_cdd_list_id,
       p_cdd_item_id,
       p_description,
       p_sys_flag,
       p_table_name,
       p_table_pk_value,
       v_document_table,
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE);
  END insert_con_file_atm;