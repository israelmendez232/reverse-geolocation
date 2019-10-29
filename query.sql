-- Usuários Ativos na Assinatura. Por cidade do estado de SP.
SELECT  
    address.city, 
    COUNT(CASE WHEN address.email IS NOT NULL THEN 1 ELSE NULL END) AS Apenas_Email,
    COUNT(CASE WHEN subscriptions.phone IS NOT NULL THEN 1 ELSE NULL END) AS Apenas_Telefone,
    COUNT(CASE WHEN address.email IS NOT NULL AND subscriptions.phone IS NOT NULL THEN 1 ELSE NULL END) AS Email_Telefone,
    COUNT(CASE WHEN signedUpForNewFeatures IS true THEN 1 ELSE NULL END) AS Early_Adopters,
    COUNT(subscriptions.email) AS Total
FROM (
    SELECT DISTINCT
        subscriptions.profile_id,
    	users.id AS user_id,
        phone 
    	LOWER(TRIM(subscriptions.email)) AS email
    FROM koala.subscriptions subscriptions
        JOIN koala.profiles profiles
        	ON subscriptions.profile_id = profiles.id
        JOIN beagle.spree_users users 
            ON LOWER(TRIM(subscriptions.email)) = LOWER(TRIM(users.email))
        WHERE 
            subscriptions.status = 'active'
            AND subscriptions.deleted_at IS NULL
            -- AND subscriptions.next_delivery_date BETWEEN (GETDATE()-4) AND (GETDATE()+7)
            AND subscriptions.num_skus > 0
) AS subscriptions
LEFT JOIN (
    SELECT DISTINCT 
    	orders.email, 
        orders.user_id,
    	address.city
    FROM beagle.spree_orders orders
    LEFT JOIN beagle.spree_addresses address
    ON orders.ship_address_id = address.id
    WHERE ( -- Define o Estado de SP como principal.
        state_id = 56
        OR state_name = 'SP'
    )
) AS address
ON subscriptions.user_id = address.user_id
WHERE address.city IS NOT NULL
	AND address.city != 'São Paulo'
	AND address.city != 'Sao Paulo'
GROUP BY address.city
ORDER BY Total DESC


-- Usuários Ativos na Assinatura. Com zipcode da cidade de SP.
SELECT  
    address.zipcode, 
    COUNT(CASE WHEN address.email IS NOT NULL THEN 1 ELSE NULL END) AS Apenas_Email,
    COUNT(CASE WHEN subscriptions.phone IS NOT NULL THEN 1 ELSE NULL END) AS Apenas_Telefone,
    COUNT(CASE WHEN address.email IS NOT NULL AND subscriptions.phone IS NOT NULL THEN 1 ELSE NULL END) AS Email_Telefone,
    COUNT(CASE WHEN signedUpForNewFeatures IS true THEN 1 ELSE NULL END) AS Early_Adopters,
    COUNT(subscriptions.email) AS Total
FROM (
    SELECT DISTINCT
        subscriptions.profile_id,
    	users.id AS user_id,
        phone, 
    	LOWER(TRIM(subscriptions.email)) AS email
    FROM koala.subscriptions subscriptions
        JOIN koala.profiles profiles
        	ON subscriptions.profile_id = profiles.id
        JOIN beagle.spree_users users 
            ON LOWER(TRIM(subscriptions.email)) = LOWER(TRIM(users.email))
        WHERE 
            subscriptions.status = 'active'
            AND subscriptions.deleted_at IS NULL
            -- AND subscriptions.next_delivery_date BETWEEN (GETDATE()-4) AND (GETDATE()+7)
            AND subscriptions.num_skus > 0
) AS subscriptions
LEFT JOIN (
    SELECT DISTINCT 
    	orders.email, 
        orders.user_id,
    	address.zipcode,
    	address.city
    FROM beagle.spree_orders orders
    LEFT JOIN beagle.spree_addresses address
    ON orders.ship_address_id = address.id
    WHERE ( -- Define o Estado de SP como principal.
        state_id = 56
        OR state_name = 'SP'
    )
) AS address
ON subscriptions.user_id = address.user_id
WHERE ( -- Focado para Puxar os CEPs apenas de SP
    	address.city = 'São Paulo'
    	OR address.city = 'Sao Paulo'
    )
GROUP BY address.zipcode
ORDER BY Total DESC





-- Usuários Inativos na Assinatura. Com cidade do estado de SP. =====> TESTAR DEPOIS!?!!!11 <======
SELECT  
    address.city, 
    COUNT(subscriptions.user_id) AS Total
FROM (
    SELECT DISTINCT
        subscriptions.profile_id,
    	users.id AS user_id
    FROM koala.subscriptions subscriptions
        JOIN beagle.spree_users users 
            ON subscriptions.profile_id = users.profile_id
        WHERE subscriptions.status != 'active'
) AS subscriptions
LEFT JOIN (
    SELECT DISTINCT 
    	orders.email, 
        orders.user_id,
    	address.city, 
    	address.zipcode
    FROM beagle.spree_orders orders
    LEFT JOIN beagle.spree_addresses address
    ON orders.ship_address_id = address.id
    WHERE ( -- Define o Estado de SP como principal.
        state_id = 56
        OR state_name = 'SP'
    )
) AS address
ON subscriptions.user_id = address.user_id
GROUP BY address.city
ORDER BY Total DESC

/* DÚVIDA: tá retornando essa quantidade de pessoas, é normal?
	CIDADE      TOTAL
    NULL        152793
    São Paulo	13816
    Sao Paulo	4493
    Guarulhos	906
    Santo André	658
    Osasco	    531
    Campinas	526
    Santos	    500
    São Bernardo do Campo	431
    Barueri	    327
*/



-- Usuários Inativos na Assinatura. Com zipcode da cidade de SP. =====> TESTAR DEPOIS!?!!!11 <======
SELECT  
    address.zipcode, 
    COUNT(subscriptions.user_id) AS Total
FROM (
    SELECT DISTINCT
        subscriptions.profile_id
    ,	users.id AS user_id
    FROM koala.subscriptions subscriptions
        JOIN beagle.spree_users users 
            ON subscriptions.profile_id = users.profile_id
        WHERE subscriptions.status != 'active'
) AS subscriptions
LEFT JOIN (
    SELECT DISTINCT 
    	orders.email, 
        orders.user_id,
    	address.zipcode
    FROM beagle.spree_orders orders
    LEFT JOIN beagle.spree_addresses address
    ON orders.ship_address_id = address.id
    WHERE ( -- Focado para Puxar os CEPs apenas de SP
    	address.city = 'São Paulo'
    	OR address.city = 'Sao Paulo'
    )
) AS address
ON subscriptions.user_id = address.user_id
GROUP BY address.zipcode
ORDER BY Total DESC

/* DÚVIDA: tá retornando essa quantidade de pessoas, é normal?
	ZIPCODE      TOTAL
	NULL        165571
    01404001	63
    04140000	34
    08310480	31
    01415000	30
    03186010	28
    01321000	26
    03423000	25
    01314000	22
    01322000	22
    */


