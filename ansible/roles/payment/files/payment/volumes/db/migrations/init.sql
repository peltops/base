CREATE TABLE IF NOT EXISTS "public.payment_gateway" (
    "gateway_id" UUID NOT NULL UNIQUE,
    "name" VARCHAR(255),
    "created_at" TIMESTAMPTZ,
    "updated_at" TIMESTAMPTZ,
    PRIMARY KEY("gateway_id")
);