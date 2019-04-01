var override_queryfields = [
		{
			name : 'new_date',
			queryexpression : "trunc(t1.new_date) = to_date(${@new_date},'yyyy-mm-dd')"
		}];

override();
