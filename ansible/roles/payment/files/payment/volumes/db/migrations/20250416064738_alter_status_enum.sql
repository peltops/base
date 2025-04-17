-- migrate:up
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_type
        WHERE typname = 'transactions_status_enum'
    ) THEN
        CREATE TYPE transactions_status_enum AS ENUM (
            'initiated',         -- Transaksi baru dibuat
            'pending',           -- Menunggu customer bayar
            'processing',        -- Sudah bayar tapi belum settle
            'success',           -- Berhasil (settlement/succeeded)
            'failed',            -- Gagal bayar (deny/failed)
            'expired',           -- Waktu habis
            'cancelled',         -- Dibatalkan
            'refunded'           -- Sudah direfund
        );
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_type
        WHERE typname = 'payments_status_enum'
    ) THEN
        CREATE TYPE payments_status_enum AS ENUM (
            'initiated',
            'waiting_payment',
            'processing',
            'paid',
            'failed',
            'expired',
            'cancelled',
            'refunded'
        );
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_type
        WHERE typname = 'orders_status_enum'
    ) THEN
        CREATE TYPE orders_status_enum AS ENUM (
            'draft',
            'waiting_payment',
            'processing',
            'paid',
            'failed',
            'cancelled',
            'refunded'
        );
    END IF;
END $$;

ALTER TABLE transactions
ALTER COLUMN status TYPE transactions_status_enum
USING status::transactions_status_enum;
ALTER TABLE payments
ALTER COLUMN status TYPE payments_status_enum
USING status::payments_status_enum;
ALTER TABLE orders
ALTER COLUMN status TYPE orders_status_enum
USING status::orders_status_enum;

-- migrate:down
ALTER TABLE transactions
ALTER COLUMN status TYPE VARCHAR(50);
ALTER TABLE payments
ALTER COLUMN status TYPE VARCHAR(50);
ALTER TABLE orders
ALTER COLUMN status TYPE VARCHAR(50);
DROP TYPE IF EXISTS transactions_status_enum;
DROP TYPE IF EXISTS payments_status_enum;
DROP TYPE IF EXISTS orders_status_enum;

