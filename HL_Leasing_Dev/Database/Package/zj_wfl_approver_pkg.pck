CREATE OR REPLACE PACKAGE zj_wfl_approver_pkg IS

	-- Author  : daibo
	-- Created : 2011-6-2 11:06:50
	-- Purpose :

	TYPE workflow_approver IS RECORD(
		user_id   NUMBER,
		user_name VARCHAR2(200));

	TYPE workflow_approver_list IS TABLE OF workflow_approver INDEX BY BINARY_INTEGER;

	g_workflow_approver_list workflow_approver_list;

	--获取审批人规则  提交人
	PROCEDURE get_submitter(p_parameter_1 VARCHAR2,
													p_parameter_2 VARCHAR2,
													p_parameter_3 VARCHAR2,
													p_parameter_4 VARCHAR2,
													p_parameter_5 VARCHAR2,
													p_company_id  NUMBER,
													p_instance_id NUMBER DEFAULT NULL);

	--获取审批人规则  历史审批人
	PROCEDURE get_history_approver(p_parameter_1 VARCHAR2,
																 p_parameter_2 VARCHAR2,
																 p_parameter_3 VARCHAR2,
																 p_parameter_4 VARCHAR2,
																 p_parameter_5 VARCHAR2,
																 p_company_id  NUMBER,
																 p_instance_id NUMBER DEFAULT NULL);

	--获取审批人规则  直接上级
	PROCEDURE get_parent_position(p_parameter_1 VARCHAR2,
																p_parameter_2 VARCHAR2,
																p_parameter_3 VARCHAR2,
																p_parameter_4 VARCHAR2,
																p_parameter_5 VARCHAR2,
																p_company_id  NUMBER,
																p_instance_id NUMBER DEFAULT NULL);

	--获取审批人规则  部门经理
	PROCEDURE get_unit_chief(p_parameter_1 VARCHAR2,
													 p_parameter_2 VARCHAR2,
													 p_parameter_3 VARCHAR2,
													 p_parameter_4 VARCHAR2,
													 p_parameter_5 VARCHAR2,
													 p_company_id  NUMBER,
													 p_instance_id NUMBER DEFAULT NULL);

	--获取审批人规则  指定人员(员工)
	PROCEDURE get_appointed_employee(p_parameter_1 VARCHAR2, --指定人员(员工)id
																	 p_parameter_2 VARCHAR2,
																	 p_parameter_3 VARCHAR2,
																	 p_parameter_4 VARCHAR2,
																	 p_parameter_5 VARCHAR2,
																	 p_company_id  NUMBER,
																	 p_instance_id NUMBER DEFAULT NULL);

	--获取审批人规则  指定岗位(员工)
	PROCEDURE get_appointed_position(p_parameter_1 VARCHAR2, --指定岗位id
																	 p_parameter_2 VARCHAR2,
																	 p_parameter_3 VARCHAR2,
																	 p_parameter_4 VARCHAR2,
																	 p_parameter_5 VARCHAR2,
																	 p_company_id  NUMBER,
																	 p_instance_id NUMBER DEFAULT NULL);

	--获取认领人
	PROCEDURE get_current_allocate_user(p_parameter_1 VARCHAR2,
																			p_parameter_2 VARCHAR2,
																			p_parameter_3 VARCHAR2,
																			p_parameter_4 VARCHAR2,
																			p_parameter_5 VARCHAR2,
																			p_company_id  NUMBER,
																			p_instance_id NUMBER DEFAULT NULL);
	PROCEDURE get_appointed_com_pos(p_parameter_1 VARCHAR2, --指定岗位id
																	p_parameter_2 VARCHAR2, --指定公司id
																	p_parameter_3 VARCHAR2,
																	p_parameter_4 VARCHAR2,
																	p_parameter_5 VARCHAR2,
																	p_company_id  NUMBER,
																	p_instance_id NUMBER DEFAULT NULL);
	--获取角色
	PROCEDURE get_appointed_role(p_parameter_1 VARCHAR2, --指定角色id
															 p_parameter_2 VARCHAR2,
															 p_parameter_3 VARCHAR2,
															 p_parameter_4 VARCHAR2,
															 p_parameter_5 VARCHAR2,
															 p_company_id  NUMBER,
															 p_instance_id NUMBER DEFAULT NULL);

	PROCEDURE get_con_agent(p_parameter_1 VARCHAR2, --指定con_id
													p_parameter_2 VARCHAR2,
													p_parameter_3 VARCHAR2,
													p_parameter_4 VARCHAR2,
													p_parameter_5 VARCHAR2,
													p_company_id  NUMBER,
													p_instance_id NUMBER DEFAULT NULL);

	--获取合同合规审查人员 add 20171011
	PROCEDURE get_con_approver(p_parameter_1 VARCHAR2,
														 p_parameter_2 VARCHAR2,
														 p_parameter_3 VARCHAR2,
														 p_parameter_4 VARCHAR2,
														 p_parameter_5 VARCHAR2,
														 p_company_id  NUMBER,
														 p_instance_id NUMBER DEFAULT NULL);
END zj_wfl_approver_pkg;
/
CREATE OR REPLACE PACKAGE BODY zj_wfl_approver_pkg IS

	--获取审批人规则  提交人
	PROCEDURE get_submitter(p_parameter_1 VARCHAR2,
													p_parameter_2 VARCHAR2,
													p_parameter_3 VARCHAR2,
													p_parameter_4 VARCHAR2,
													p_parameter_5 VARCHAR2,
													p_company_id  NUMBER,
													p_instance_id NUMBER DEFAULT NULL) IS
		v_submitted_by           zj_wfl_workflow_instance.submitted_by%TYPE;
		v_workflow_approver      workflow_approver;
		v_workflow_approver_list workflow_approver_list;
	BEGIN
		SELECT submitted_by
			INTO v_submitted_by
			FROM zj_wfl_workflow_instance
		 WHERE instance_id = p_instance_id;
	
		g_workflow_approver_list.delete;
		v_workflow_approver_list.delete;
	
		v_workflow_approver.user_id := v_submitted_by;
		v_workflow_approver.user_name := '';
		v_workflow_approver_list(v_workflow_approver_list.count + 1) := v_workflow_approver;
	
		g_workflow_approver_list := v_workflow_approver_list;
	
	END;

	--获取审批人规则  历史审批人
	PROCEDURE get_history_approver(p_parameter_1 VARCHAR2,
																 p_parameter_2 VARCHAR2,
																 p_parameter_3 VARCHAR2,
																 p_parameter_4 VARCHAR2,
																 p_parameter_5 VARCHAR2,
																 p_company_id  NUMBER,
																 p_instance_id NUMBER DEFAULT NULL) IS
		v_approve_count          zj_wfl_workflow_instance.approve_count%TYPE;
		v_workflow_approver      workflow_approver;
		v_workflow_approver_list workflow_approver_list;
	BEGIN
	
		g_workflow_approver_list.delete;
		v_workflow_approver_list.delete;
	
		SELECT approve_count
			INTO v_approve_count
			FROM zj_wfl_workflow_instance
		 WHERE instance_id = p_instance_id;
	
		FOR c_approvers IN (SELECT DISTINCT user_id
													FROM zj_wfl_approve_record
												 WHERE instance_id = p_instance_id
													 AND approve_count = v_approve_count
													 AND record_type IN ('TRANSFER', 'NORMAL')) LOOP
			v_workflow_approver.user_id := c_approvers.user_id;
			v_workflow_approver.user_name := '';
			v_workflow_approver_list(v_workflow_approver_list.count + 1) := v_workflow_approver;
		
		END LOOP;
	
		g_workflow_approver_list := v_workflow_approver_list;
	
	END;

	--获取审批人规则  直接上级
	PROCEDURE get_parent_position(p_parameter_1 VARCHAR2,
																p_parameter_2 VARCHAR2,
																p_parameter_3 VARCHAR2,
																p_parameter_4 VARCHAR2,
																p_parameter_5 VARCHAR2,
																p_company_id  NUMBER,
																p_instance_id NUMBER DEFAULT NULL) IS
		v_submitted_by           zj_wfl_workflow_instance.submitted_by%TYPE;
		v_workflow_approver      workflow_approver;
		v_workflow_approver_list workflow_approver_list;
	BEGIN
		SELECT submitted_by
			INTO v_submitted_by
			FROM zj_wfl_workflow_instance
		 WHERE instance_id = p_instance_id;
	
		g_workflow_approver_list.delete;
		v_workflow_approver_list.delete;
	
		FOR c_approvers IN (SELECT DISTINCT b1.user_id,
																				b1.description AS user_name
													FROM zj_wfl_users_v       a1,
															 exp_employee_assigns a2,
															 exp_org_position     a3,
															 exp_org_position     b3,
															 exp_employee_assigns b2,
															 zj_wfl_users_v       b1
												 WHERE a1.user_id = v_submitted_by
													 AND a1.employee_id = a2.employee_id
													 AND a2.enabled_flag = 'Y'
													 AND a2.company_id = p_company_id
													 AND a2.position_id = a3.position_id
													 AND a3.parent_position_id = b3.position_id
													 AND b3.position_id = b2.position_id
													 AND b2.enabled_flag = 'Y'
													 AND b2.company_id = p_company_id
													 AND b2.employee_id = b1.employee_id)
		
		 LOOP
			v_workflow_approver.user_id := c_approvers.user_id;
			v_workflow_approver.user_name := c_approvers.user_name;
			v_workflow_approver_list(v_workflow_approver_list.count + 1) := v_workflow_approver;
		
		END LOOP;
		g_workflow_approver_list := v_workflow_approver_list;
	
	END;

	--获取审批人规则  部门经理
	PROCEDURE get_unit_chief(p_parameter_1 VARCHAR2,
													 p_parameter_2 VARCHAR2,
													 p_parameter_3 VARCHAR2,
													 p_parameter_4 VARCHAR2,
													 p_parameter_5 VARCHAR2,
													 p_company_id  NUMBER,
													 p_instance_id NUMBER DEFAULT NULL) IS
		v_submitted_by           zj_wfl_workflow_instance.submitted_by%TYPE;
		v_workflow_approver      workflow_approver;
		v_workflow_approver_list workflow_approver_list;
	BEGIN
		SELECT submitted_by
			INTO v_submitted_by
			FROM zj_wfl_workflow_instance
		 WHERE instance_id = p_instance_id;
	
		g_workflow_approver_list.delete;
		v_workflow_approver_list.delete;
	
		FOR c_approvers IN (SELECT DISTINCT b1.user_id,
																				b1.description AS user_name
													FROM zj_wfl_users_v       a1,
															 exp_employee_assigns a2,
															 exp_org_position     a3,
															 exp_org_unit         a4,
															 exp_org_position     b3,
															 exp_employee_assigns b2,
															 zj_wfl_users_v       b1
												 WHERE a1.user_id = v_submitted_by
													 AND a1.employee_id = a2.employee_id
													 AND a2.enabled_flag = 'Y'
													 AND a2.company_id = p_company_id
													 AND a2.position_id = a3.position_id
													 AND a3.unit_id = a4.unit_id
													 AND a4.enabled_flag = 'Y'
													 AND a4.chief_position_id = b3.position_id
													 AND b3.position_id = b2.position_id
													 AND b2.enabled_flag = 'Y'
													 AND b2.company_id = p_company_id
													 AND b2.employee_id = b1.employee_id) LOOP
			v_workflow_approver.user_id := c_approvers.user_id;
			v_workflow_approver.user_name := c_approvers.user_name;
			v_workflow_approver_list(v_workflow_approver_list.count + 1) := v_workflow_approver;
		
		END LOOP;
	
		g_workflow_approver_list := v_workflow_approver_list;
	END;

	PROCEDURE get_appointed_employee(p_parameter_1 VARCHAR2, --指定人员(员工)id
																	 p_parameter_2 VARCHAR2,
																	 p_parameter_3 VARCHAR2,
																	 p_parameter_4 VARCHAR2,
																	 p_parameter_5 VARCHAR2,
																	 p_company_id  NUMBER,
																	 p_instance_id NUMBER DEFAULT NULL) IS
		v_workflow_approver      workflow_approver;
		v_workflow_approver_list workflow_approver_list;
	BEGIN
		g_workflow_approver_list.delete;
		v_workflow_approver_list.delete;
		zj_wfl_core_pkg.log(p_instance_id => p_instance_id,
												p_node_id     => 1212,
												p_source      => 'get_appointed_employee',
												p_text        => 'p_parameter_1=' || p_parameter_1,
												p_user_id     => 1);
		FOR c_approvers IN (SELECT b.user_id,
															 b.description AS user_name
													FROM exp_employees  a,
															 zj_wfl_users_v b
												 WHERE a.employee_id = to_number(p_parameter_1)
													 AND b.employee_id = a.employee_id) LOOP
			v_workflow_approver.user_id := c_approvers.user_id;
			v_workflow_approver.user_name := c_approvers.user_name;
			v_workflow_approver_list(v_workflow_approver_list.count + 1) := v_workflow_approver;
		END LOOP;
		g_workflow_approver_list := v_workflow_approver_list;
	END get_appointed_employee;

	PROCEDURE get_appointed_position(p_parameter_1 VARCHAR2, --指定岗位id
																	 p_parameter_2 VARCHAR2,
																	 p_parameter_3 VARCHAR2,
																	 p_parameter_4 VARCHAR2,
																	 p_parameter_5 VARCHAR2,
																	 p_company_id  NUMBER,
																	 p_instance_id NUMBER DEFAULT NULL) IS
		v_workflow_approver      workflow_approver;
		v_workflow_approver_list workflow_approver_list;
	BEGIN
		g_workflow_approver_list.delete;
		v_workflow_approver_list.delete;
		zj_wfl_core_pkg.log(p_instance_id => 111,
												p_node_id     => 11,
												p_source      => 'get_appointed_position',
												p_text        => 'p_parameter_1 = ' || p_parameter_1 || 'p_company_id=' ||
																				 p_company_id,
												p_user_id     => -1);
		FOR c_approvers IN (SELECT c.user_id,
															 c.description AS user_name
													FROM exp_employee_assigns a,
															 exp_employees        b,
															 zj_wfl_users_v       c
												 WHERE a.position_id = to_number(p_parameter_1)
													 AND a.company_id = p_company_id
													 AND b.employee_id = a.employee_id
													 AND c.employee_id = b.employee_id
													 AND a.enabled_flag = 'Y') LOOP
			v_workflow_approver.user_id := c_approvers.user_id;
			v_workflow_approver.user_name := c_approvers.user_name;
			v_workflow_approver_list(v_workflow_approver_list.count + 1) := v_workflow_approver;
		END LOOP;
		g_workflow_approver_list := v_workflow_approver_list;
	END get_appointed_position;
	--获取认领人
	PROCEDURE get_current_allocate_user(p_parameter_1 VARCHAR2,
																			p_parameter_2 VARCHAR2,
																			p_parameter_3 VARCHAR2,
																			p_parameter_4 VARCHAR2,
																			p_parameter_5 VARCHAR2,
																			p_company_id  NUMBER,
																			p_instance_id NUMBER DEFAULT NULL) IS
		v_allocated_by           NUMBER;
		v_workflow_approver      workflow_approver;
		v_workflow_approver_list workflow_approver_list;
	BEGIN
	
		g_workflow_approver_list.delete;
		v_workflow_approver_list.delete;
	
		SELECT t.user_id
			INTO v_allocated_by
			FROM yonda_doc_status_history t
		 WHERE t.instance_id = p_instance_id
					--   and t.current_status_flag = 'Y'
			 AND t.status = '30';
	
		v_workflow_approver.user_id := v_allocated_by;
		v_workflow_approver.user_name := '';
		v_workflow_approver_list(v_workflow_approver_list.count + 1) := v_workflow_approver;
		g_workflow_approver_list := v_workflow_approver_list;
	
	END;

	PROCEDURE get_appointed_com_pos(p_parameter_1 VARCHAR2, --指定岗位id
																	p_parameter_2 VARCHAR2, --指定公司id
																	p_parameter_3 VARCHAR2,
																	p_parameter_4 VARCHAR2,
																	p_parameter_5 VARCHAR2,
																	p_company_id  NUMBER,
																	p_instance_id NUMBER DEFAULT NULL) IS
		v_workflow_approver      workflow_approver;
		v_workflow_approver_list workflow_approver_list;
	BEGIN
		g_workflow_approver_list.delete;
		v_workflow_approver_list.delete;
		zj_wfl_core_pkg.log(p_instance_id => p_instance_id,
												p_node_id     => 121,
												p_source      => 'ZJ_WFL_APPROVER_PKG',
												p_text        => '测试:p_parameter_1 = ' || p_parameter_1 ||
																				 ' p_parameter_2 = ' || p_parameter_2,
												
												p_user_id => -1);
		FOR c_approvers IN (SELECT c.user_id,
															 c.description AS user_name
													FROM exp_employee_assigns a,
															 exp_employees        b,
															 zj_wfl_users_v       c
												 WHERE a.position_id = to_number(p_parameter_1)
													 AND a.company_id = to_number(p_parameter_2)
													 AND b.employee_id = a.employee_id
													 AND c.employee_id = b.employee_id
													 AND a.enabled_flag = 'Y'
												 ORDER BY c.user_id) LOOP
			v_workflow_approver.user_id := c_approvers.user_id;
			v_workflow_approver.user_name := c_approvers.user_name;
			v_workflow_approver_list(v_workflow_approver_list.count + 1) := v_workflow_approver;
		END LOOP;
		g_workflow_approver_list := v_workflow_approver_list;
	END get_appointed_com_pos;

	PROCEDURE get_appointed_role(p_parameter_1 VARCHAR2, --指定角色id
															 p_parameter_2 VARCHAR2,
															 p_parameter_3 VARCHAR2,
															 p_parameter_4 VARCHAR2,
															 p_parameter_5 VARCHAR2,
															 p_company_id  NUMBER,
															 p_instance_id NUMBER DEFAULT NULL) IS
		v_workflow_approver      workflow_approver;
		v_workflow_approver_list workflow_approver_list;
	BEGIN
		g_workflow_approver_list.delete;
		v_workflow_approver_list.delete;
	
		FOR c_approvers IN (SELECT t.user_id,
															 (SELECT su.description FROM sys_user su WHERE su.user_id = t.user_id) user_name
													FROM sys_user_role_groups_vl t
												 WHERE t.company_id = p_company_id
													 AND t.enabled_flag = 'Y'
													 AND (t.end_date IS NULL OR trunc(t.end_date) >= trunc(SYSDATE))
													 AND t.role_id = to_number(p_parameter_1)) LOOP
			v_workflow_approver.user_id := c_approvers.user_id;
			v_workflow_approver.user_name := c_approvers.user_name;
			v_workflow_approver_list(v_workflow_approver_list.count + 1) := v_workflow_approver;
		END LOOP;
		g_workflow_approver_list := v_workflow_approver_list;
	END;

	--指定经销商
	PROCEDURE get_con_agent(p_parameter_1 VARCHAR2, --指定con_id
													p_parameter_2 VARCHAR2,
													p_parameter_3 VARCHAR2,
													p_parameter_4 VARCHAR2,
													p_parameter_5 VARCHAR2,
													p_company_id  NUMBER,
													p_instance_id NUMBER DEFAULT NULL) IS
		v_workflow_approver      workflow_approver;
		v_workflow_approver_list workflow_approver_list;
	BEGIN
		g_workflow_approver_list.delete;
		v_workflow_approver_list.delete;
	
		FOR c_approvers IN (SELECT pp.owner_user_id user_id,
															 (SELECT su.description
																	FROM sys_user su
																 WHERE su.user_id = pp.owner_user_id) user_name
													FROM con_contract cc,
															 prj_project  pp
												 WHERE cc.contract_id =
															 (SELECT p.parameter_value
																	FROM zj_wfl_workflow_instance       wi,
																			 zj_wfl_workflow_instance_para  p,
																			 zj_wfl_workflow_type_parameter tp
																 WHERE wi.instance_id = p_instance_id
																	 AND wi.instance_id = p.instance_id
																	 AND wi.approve_count = p.approve_count
																	 AND p.workflow_type_para_id = tp.workflow_type_para_id
																	 AND tp.parameter_code = 'CONTRACT_ID')
													 AND cc.project_id = pp.project_id) LOOP
		
			v_workflow_approver.user_id   := c_approvers.user_id;
			v_workflow_approver.user_name := c_approvers.user_name;
		
			v_workflow_approver_list(v_workflow_approver_list.count + 1) := v_workflow_approver;
		
		END LOOP;
		g_workflow_approver_list := v_workflow_approver_list;
	
	END;

	--获取合同合规审查人员 add 20171011
	PROCEDURE get_con_approver(p_parameter_1 VARCHAR2,
														 p_parameter_2 VARCHAR2,
														 p_parameter_3 VARCHAR2,
														 p_parameter_4 VARCHAR2,
														 p_parameter_5 VARCHAR2,
														 p_company_id  NUMBER,
														 p_instance_id NUMBER DEFAULT NULL) IS
		v_workflow_type_code     VARCHAR2(30);
		v_document_id            NUMBER;
		v_count                  NUMBER;
		v_workflow_approver      zj_wfl_approver_pkg.workflow_approver;
		v_workflow_approver_list zj_wfl_approver_pkg.workflow_approver_list;
	BEGIN
		zj_wfl_approver_pkg.g_workflow_approver_list.delete;
		v_workflow_approver_list.delete;
	
		--工作流类型代码
		SELECT t.workflow_type_code
			INTO v_workflow_type_code
			FROM zj_wfl_workflow_instance i,
					 zj_wfl_workflow          w,
					 zj_wfl_workflow_type     t
		 WHERE i.workflow_id = w.workflow_id
			 AND w.workflow_type_id = t.workflow_type_id
			 AND i.instance_id = p_instance_id;
	
		IF v_workflow_type_code = 'CONTRACT_SIGN' THEN
			--合同签订流程   
			/*BEGIN
        SELECT t.parameter_value
          INTO v_document_id
          FROM zj_wfl_workflow_instance_para  t,
               zj_wfl_workflow_type_parameter p
         WHERE t.workflow_type_para_id = p.workflow_type_para_id
           AND t.instance_id = p_instance_id
           AND p.parameter_code = 'CONTRACT_ID'
           AND rownum = 1;
      EXCEPTION
        WHEN no_data_found THEN
          RAISE e_document_id_error;
      END;*/
		
			SELECT COUNT(1)
				INTO v_count
				FROM zj_wfl_workflow_instance i,
						 zj_wfl_workflow          w,
						 zj_wfl_workflow_type     t
			 WHERE i.workflow_id = w.workflow_id
				 AND w.workflow_type_id = t.workflow_type_id
				 AND w.workflow_code = 'CONTRACT_COMPLIANCE' --合规审查流程代码  
				 AND i.current_seq = 100 --100节点
				 AND i.instance_id = p_instance_id;
		
			IF v_count <> 0 THEN
				FOR c_approvers IN (SELECT *
															FROM (SELECT su.user_id,
																					 su.description AS user_name,
																					 COUNT(1)
																			FROM sys_user                       su,
																					 con_contract_reviewers         ccr,
																					 zj_wfl_instance_node_recipient zwinr
																		 WHERE ccr.user_id = su.user_id
																			 AND SYSDATE BETWEEN su.start_date AND
																					 nvl(su.end_date, SYSDATE)
																			 AND zwinr.user_id(+) = ccr.user_id
																			 AND ccr.review_type = 'COMPLIANCE_REVIEW'
																		 GROUP BY su.user_id,
																							su.description
																		 ORDER BY COUNT(1) ASC)
														 WHERE rownum <= 2) LOOP
					v_workflow_approver.user_id := c_approvers.user_id;
					v_workflow_approver.user_name := c_approvers.user_name;
					v_workflow_approver_list(v_workflow_approver_list.count + 1) := v_workflow_approver;
				END LOOP;
			END IF;
		END IF;
		zj_wfl_approver_pkg.g_workflow_approver_list := v_workflow_approver_list;
	END get_con_approver;

END zj_wfl_approver_pkg;
/
