var override_queryfields = [
    {
        name : 'project_number',
        queryexpression : "t1.project_number like '%'|| ${@project_number} || '%'"
    },
    {
        name : 'contract_number',
        queryexpression : "t1.contract_number like '%'|| ${@contract_number} || '%'"
    },
    {
        name : 'item_frame_number',
        queryexpression : "t1.item_frame_number like '%'|| ${@item_frame_number} || '%'"
    },
    {
        name : 'son_code',
        queryexpression : "t1.son_code like '%'|| ${@son_code} || '%'"
    }
];
override();

var add_datafilters = [ {
	name : 'owner_user_id',
	expression : "exists (select 1 from sys_user su where (su.bp_category = 'EMPLOYEE' or ( t1.owner_user_id=su.user_id AND su.bp_category = 'AGENT_DF')  ) and su.user_id = ${/session/@user_id})"
},
{
	name : 'will_move_flag',
	expression : "nvl(t1.will_move_flag,'N') ='N'"
},
{
	name : 'contract_status',
	expression : "nvl(t1.contract_status,'NEW') ='INCEPT'"
},
{
	name : 'car_status',
	expression : "nvl(t1.car_status,'NEW') ='STOCK_IN'"
},
{
	name : 'bp_id',
    expression : "exists (SELECT 1 FROM hls_bp_master hb where t1.bp_id = hb.bp_id and (hb.regulator <> '01' or hb.bp_code = 'B00000010'))"
}];

add_datafilter();

