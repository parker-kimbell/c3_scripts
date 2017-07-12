SELECT 
    translation_key, translation_value, description, translation
FROM
    common_config.common_translation t1
        INNER JOIN
    common_config.common_locale t2 ON t1.locale_id = t2.id
WHERE
    translation_key LIKE 'msg.hp.tou.%'
        AND service_id = 28
