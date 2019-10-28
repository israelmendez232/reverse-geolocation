-- Usuários Ativos na Assinatura. Com cidade do estado de SP.
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
        WHERE 
            subscriptions.status = 'active'
            AND subscriptions.deleted_at IS NULL
            AND subscriptions.next_delivery_date BETWEEN (GETDATE()-4) AND (GETDATE()+7)
            AND subscriptions.num_skus > 0
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
	CIDADE      QUANTIDADE
    NULL        2.107
    São Paulo	182
    Sao Paulo	54
    Santos	    41
    Guarulhos	20
    Santo André	10
    Campinas	8
    Mauá	    7
    Osasco	    7
    Araras	    6

*/

-- Usuários Ativos na Assinatura. Com zipcode da cidade de SP.
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
        WHERE 
            subscriptions.status='active'
            AND subscriptions.deleted_at IS NULL
            AND subscriptions.next_delivery_date BETWEEN (GETDATE()-4) AND (GETDATE()+7)
            AND subscriptions.num_skus > 0
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
	ZIPCODE     QUANTIDADE
    NULL        2.306
    03003030	7
    02203010	4
    01317000	3
    05065010	3
    02415000	3
    04576080	2
    04456000	2
    03068000	2
    03019020	2
*/

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
