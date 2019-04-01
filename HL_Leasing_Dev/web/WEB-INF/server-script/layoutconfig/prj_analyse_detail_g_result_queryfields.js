var override_queryfields = [ 
{
	name : 'target',
	queryexpression : "((t1.target_type='WORK_UNIT' and matching_char(t1.target) = ${@target}) or(t1.target_type!='WORK_UNIT' and t1.target = ${@target}))"
}
];

override();