var override_queryfields = [
    {
        name : 'bp_id',
        queryexpression : "t1.bp_id_tenant = ${@bp_id}"
    },
    {
        name : 'date_from',
        queryexpression : "substr(t1.DATE_FROM_FLAG, 1, 6) >= ${@date_from}"
    },
    {
        name : 'date_to',
        queryexpression : "substr(t1.DATE_FROM_FLAG, 1, 6) <= ${@date_to}"
    }
];


override();