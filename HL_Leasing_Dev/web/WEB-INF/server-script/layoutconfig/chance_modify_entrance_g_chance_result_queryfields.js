var override_queryfields = [
		{
			name : 'not_status',
			queryexpression : "nvl(t1.chance_status,'NEW') not in ('CLOSED','PRJ_CREATED')"
		},
		{
			name : 'chance_number',
			queryexpression : "t1.chance_number like ${@chance_number}"
		},
		{
			field : 'employee_id',
			queryoperator : '='
		},
		{
			name : 'bp_name',
			queryexpression : "t1.bp_name like ${@bp_name}"
		},
		{
			field : 'chance_status',
			queryoperator : '='
		},
		{
			field : 'lease_organization',
			queryoperator : '='
		},
		{
			field : 'lease_channel',
			queryoperator : '='
		},
		{
			field : 'division',
			queryoperator : '='
		},
		{
			name : 'lease_item_short_name',
			queryexpression : 't1.lease_item_short_name like ${@lease_item_short_name}'
		},
		{
			name : 'create_date_from',
			queryexpression : "(t1.creation_date between to_date(${@create_date_from},'yyyy-mm-dd') and nvl(to_date(${@create_date_to},'yyyy-mm-dd'),e.creation_date))"
		},
		{
			name : 'create_date_to',
			queryexpression : "(t1.creation_date between nvl(to_date(${@create_date_from},'yyyy-mm-dd'),e.creation_date) and to_date(${@create_date_to},'yyyy-mm-dd'))"
		} ];

override();
