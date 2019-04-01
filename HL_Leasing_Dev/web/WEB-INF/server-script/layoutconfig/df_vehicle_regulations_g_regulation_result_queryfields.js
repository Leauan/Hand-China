var override_queryfields = [

		{
			field : 'bp_id',
			queryoperator : "="
		},
		{
			field : 'project_number',
			queryoperator : "like"
		},
		{
			field : 'regulator_inventory_id',
			queryoperator : "="
		},
		{
			field : 'car_status',
			queryoperator : "="
		}

];
var add_datafilters = [
		{
			name : 'init_filter',
			expression : "exists (select 1 from sys_user su where su.bp_category = 'EMPLOYEE' and su.user_id = ${/session/@user_id})"
		}];

add_datafilter();

override();
