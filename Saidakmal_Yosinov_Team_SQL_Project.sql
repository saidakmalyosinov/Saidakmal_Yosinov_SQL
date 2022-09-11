SELECT 
    `cx`.`customer_id`,
    `t`.`type_of_client`,
    COUNT(`cx`.`customer_id`) AS `total_ytd_order`,
    SUM(`il`.`unit_price` * `il`.`quantity`)
         AS `total_order_amount_ytd`,
    IF(SUM(`il`.`unit_price` * `il`.`quantity`) < 0,
        0,
        1) AS `YTD_amount_negative`,
    SUM(CASE
        WHEN MONTH(`i`.`date`) = 10 THEN `il`.`unit_price` * `il`.`quantity`
        WHEN MONTH(`i`.`date`) = 11 THEN `il`.`unit_price` * `il`.`quantity`
        WHEN MONTH(`i`.`date`) = 12 THEN `il`.`unit_price` * `il`.`quantity`
        ELSE 0
    END) AS `total_order_amount_Q4`,
    IF(SUM(CASE
            WHEN MONTH(`i`.`date`) = 10 THEN `il`.`unit_price` * `il`.`quantity`
            WHEN MONTH(`i`.`date`) = 11 THEN `il`.`unit_price` * `il`.`quantity`
            WHEN MONTH(`i`.`date`) = 12 THEN `il`.`unit_price` * `il`.`quantity`
            ELSE 0
        END) < 0,
        0,
        1) AS `Q4_amount_negative`,
    IF(`cx`.`sex_at_birth` = 'F', 0, 1) AS `sex`,
    IF(`m`.`marital_status` LIKE 'M%', 1, 0) AS `marital_status`,
    IF(`e`.`employment_type` = '?',
        (SELECT 
                `e`.`employment_type`
            FROM
                `H_Retail`.`customer` AS `cx`
                    INNER JOIN
                `H_Retail`.`employment_type` AS `e` ON `e`.`employment_type_id` = `cx`.`employment_type_id`
            GROUP BY `e`.`employment_type`
            ORDER BY (COUNT(`cx`.`customer_id`)) DESC
            LIMIT 1),
        `e`.`employment_type`) AS `employment_type`,
    IF(`o`.`occupation` = '?',
        (SELECT 
                `o`.`occupation`
            FROM
                `H_Retail`.`customer` AS `cx`
                    INNER JOIN
                `H_Retail`.`occupation` AS `o` ON `o`.`occupation_id` = `cx`.`occupation_id`
            GROUP BY o.occupation
            ORDER BY (COUNT(`cx`.`customer_id`)) DESC
            LIMIT 1),
        `o`.`occupation`) AS ` occupation`,
    IF(`c`.`country` = '?',
        (SELECT 
                `c`.`country`
            FROM
                `H_Retail`.`customer` AS `cx`
                    INNER JOIN
                `H_Retail`.`country` AS `c` ON `c`.`country_id` = `cx`.`original_country_of_citizenship_id`
            GROUP BY `c`.`country`
            ORDER BY (COUNT(`cx`.`customer_id`)) DESC
            LIMIT 1),
        `c`.`country`) AS ` country_of_origins`,
    TIMESTAMPDIFF(YEAR,
        `cx`.`birthdate`,
        CURDATE()) AS `age`,
    `ed`.`education`,
    `cx`.`completed_years_of_education`,
    `m`.`marital_status`,
    `rh`.`relationship_in_household`,
    `r`.`race`
FROM
    `H_Retail`.`invoice14` AS `i`
        LEFT JOIN
    `H_Retail`.`customer` AS `cx` ON `i`.`customer_id` = `cx`.`customer_id`
        LEFT JOIN
    `H_Retail`.`type_of_client_staging14` AS `t` ON `cx`.`customer_id` = `t`.`customer_id`
        LEFT JOIN
    `H_Retail`.`invoice_line` AS `il` ON `i`.`invoice_id` = `il`.`invoice_id`
        LEFT JOIN
    `H_Retail`.`occupation` AS `o` ON `cx`.`occupation_id` = `o`.`occupation_id`
        LEFT JOIN
    `H_Retail`.`employment_type` AS `e` ON `cx`.`employment_type_id` = `e`.`employment_type_id`
        LEFT JOIN
    `H_Retail`.`education` AS `ed` ON `cx`.`education_id` = `ed`.`education_id`
        LEFT JOIN
    `H_Retail`.`marital_status` AS `m` ON `cx`.`marital_status_id` = `m`.`marital_status_id`
        LEFT JOIN
    `H_Retail`.`relationship_in_household` AS `rh` ON `cx`.`relationship_in_household_id` = `rh`.`relationship_in_household_id`
        LEFT JOIN
    `H_Retail`.`race` AS `r` ON `cx`.`race_id` = `r`.`race_id`
        LEFT JOIN
    `H_Retail`.`country` AS `c` ON `cx`.`original_country_of_citizenship_id` = `c`.`country_id`
WHERE
    `cx`.`customer_id` != 0
GROUP BY `cx`.`customer_id`
;
