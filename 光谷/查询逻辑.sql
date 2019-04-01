SELECT
    t.archives_number                            AS archives_number,
    t.file_name                                  AS file_name,
    ''                                           AS attachment,
    (SELECT COUNT(1)
        FROM fnd_atm_attachment_multi m
        WHERE m.table_name = t.table_name
            AND m.table_pk_value = t.table_pk_value) attachment_nums,
    hls_sys_upload_pkg.get_atm_file_href(t.table_pk_value,
                                            t.table_name,
                                            1)      AS attachment_name,

    nvl(t.is_archive_flag, 'N')                  AS is_archive_flag,
    nvl(t.is_original, 0)                        AS is_original,
    nvl(t.is_copy, 0)                            AS is_copy,
    to_char(t.archives_store_date, 'yyyy-mm-dd') AS archives_store_date,
    ''                                           AS seal_scanner,
    hls_sys_upload_pkg.get_atm_file_source(t.file_atm_id,
                                            'CON_SEAL_SCANNER_FILE',
                                            1)    AS edit_view,
    t.note,
    t.file_atm_id,
    t.file_management_id,
    t.cdd_list_id,
    t.table_name,
    t.table_pk_value,
    t.document_table
FROM con_file_atm t
where t.file_management_id = (SELECT cm.file_management_id
                                FROM con_file_management cm, con_file_atm ca
                                WHERE contract_id IN
                                    (SELECT cc.contract_id
                                        FROM con_contract cc
                                        WHERE project_id =
                                            (SELECT project_id
                                            FROM con_contract c, con_file_management m
                                            WHERE c.contract_id = m.contract_id
                                                    AND m.file_management_id = ${@file_management_id}))
                                    AND cm.file_management_id = ca.file_management_id
                                    AND ca.file_atm_id IS NOT NULL
                                    AND ca.document_table IN ('PROJECT', 'REVIEW')
                                    AND ROWNUM = 1)
        and t.document_table = ${@document_table}