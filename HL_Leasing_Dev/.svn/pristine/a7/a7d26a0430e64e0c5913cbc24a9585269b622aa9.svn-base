var add_datafilters = [ {
	name : 'bp_id',
	expression : "(exists (select 1    from sys_user su     where (su.bp_category = 'EMPLOYEE' or       (t1.bp_id =  decode((SELECT linkage_flag     from hls_bp_master b, sys_user su   where b.bp_id = su.bp_id      and su.user_id = ${/session/@user_id}),      'N',    (select bp_id     from hls_bp_master     where parent_id =     (SELECT b.parent_id      from hls_bp_master b, sys_user su         where b.bp_id = su.bp_id    and su.user_id = ${/session/@user_id})        and linkage_flag = 'Y'),       su.bp_id) AND su.bp_category = 'AGENT_DF'))          and su.user_id = ${/session/@user_id}) )"
},
{
	name : 'confirm_flag',
	expression : "nvl(t1.confirm_flag,'N') ='Y'"
},
{
	name : 'status',
	expression : "nvl(t1.status,'NEW') ='APPROVED'"
}]

add_datafilter();

