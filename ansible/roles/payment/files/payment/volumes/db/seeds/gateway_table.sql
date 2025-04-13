INSERT INTO "public.payment_gateway" ("gateway_id", "name", "created_at", "updated_at")
SELECT uuid_generate_v4(), gateway_name, now(), now()
FROM (
    VALUES 
        ('stripe'),
        ('midtrans')
) AS t(gateway_name)
WHERE NOT EXISTS (
    SELECT 1 
    FROM "public.payment_gateway" 
    WHERE "name" = t.gateway_name
);