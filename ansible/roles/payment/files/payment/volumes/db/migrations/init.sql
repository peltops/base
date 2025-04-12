CREATE TABLE IF NOT EXISTS "public.orders" (
    "order_id" UUID NOT NULL UNIQUE,
    "user_id" VARCHAR(255),
    "total_amount" NUMERIC,
    "currency" VARCHAR(255),
    "status" VARCHAR(255),
    "created_at" TIMESTAMPTZ,
    "updated_at" TIMESTAMPTZ,
    PRIMARY KEY("order_id")
);

ALTER TABLE "public.orders"
ADD FOREIGN KEY("order_id") REFERENCES "order_items"("order_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;

CREATE TABLE IF NOT EXISTS "public.order_items" (
    "order_item_id" UUID NOT NULL UNIQUE,
    "order_id" UUID,
    "product_id" UUID,
    "quantity" INTEGER,
    "price" NUMERIC,
    "created_at" TIMESTAMPTZ,
    "updated_at" TIMESTAMPTZ,
    PRIMARY KEY("order_item_id")
);

ALTER TABLE "public.order_items"
ADD FOREIGN KEY("product_id") REFERENCES "products"("product_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;

CREATE TABLE IF NOT EXISTS "public.products" (
    "product_id" UUID NOT NULL UNIQUE,
    "name" VARCHAR(255),
    "description" VARCHAR(255),
    "price" NUMERIC,
    "created_at" TIMESTAMPTZ,
    "updated_at" TIMESTAMPTZ,
    PRIMARY KEY("product_id")
);

CREATE TABLE IF NOT EXISTS "public.payments" (
    "payment_id" UUID NOT NULL UNIQUE,
    "gateway_payment_id" VARCHAR(255),
    "order_id" UUID,
    "gateway_id" UUID,
    "amount" NUMERIC,
    "currency" VARCHAR(255),
    "status" VARCHAR(255),
    "created_at" TIMESTAMPTZ,
    "updated_at" TIMESTAMPTZ,
    "user_id" VARCHAR(255),
    PRIMARY KEY("payment_id")
);

ALTER TABLE "public.payments"
ADD FOREIGN KEY("order_id") REFERENCES "orders"("order_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "public.payment_gateway"
ADD FOREIGN KEY("gateway_id") REFERENCES "payments"("gateway_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;

CREATE TABLE IF NOT EXISTS "public.payment_gateway" (
    "gateway_id" UUID NOT NULL UNIQUE,
    "name" VARCHAR(255),
    "created_at" TIMESTAMPTZ,
    "updated_at" TIMESTAMPTZ,
    PRIMARY KEY("gateway_id")
);

CREATE TABLE IF NOT EXISTS "public.transactions" (
    "transaction_id" UUID NOT NULL UNIQUE,
    "payment_id" UUID,
    "gateway_transaction_id" VARCHAR(255),
    "gateway_response" TEXT,
    "status" VARCHAR(255),
    "created_at" TIMESTAMPTZ,
    "updated_at" TIMESTAMPTZ,
    PRIMARY KEY("transaction_id")
);

ALTER TABLE "public.transactions"
ADD FOREIGN KEY("payment_id") REFERENCES "payments"("payment_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;

alter table "public"."orders" enable row level security;
alter table "public"."order_items" enable row level security;
alter table "public"."products" enable row level security;
alter table "public"."payments" enable row level security;
alter table "public"."payment_gateway" enable row level security;
alter table "public"."transactions" enable row level security;

create policy IF NOT EXISTS "order only for service_role."
on "public"."orders"
for ALL
to service_role
using ( true );

create policy IF NOT EXISTS "order_items only for service_role."
on "public"."order_items"
for ALL
to service_role
using ( true );

create policy IF NOT EXISTS "products only for service_role."
on "public"."products"
for ALL
to service_role
using ( true );

create policy IF NOT EXISTS "payments only for service_role."
on "public"."payments"
for ALL
to service_role
using ( true );

create policy IF NOT EXISTS "payment_gateway only for service_role."
on "public"."payment_gateway"
for ALL
to service_role
using ( true );

create policy IF NOT EXISTS "transactions only for service_role."
on "public"."transactions"
for ALL
to service_role
using ( true );
