INSERT INTO "public.payment_gateway" ("gateway_id", "name", "created_at", "updated_at")
VALUES
    (uuid_generate_v4(), 'stripe', now(), now()),
    (uuid_generate_v4(), 'midtrans', now(), now()),