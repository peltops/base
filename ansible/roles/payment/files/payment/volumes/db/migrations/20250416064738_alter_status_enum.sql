-- migrate:up
CREATE TYPE IF NOT EXISTS transactions_status_enum AS ENUM (
  'initiated',         -- Transaksi baru dibuat
  'pending',           -- Menunggu customer bayar
  'processing',        -- Sudah bayar tapi belum settle
  'success',           -- Berhasil (settlement/succeeded)
  'failed',            -- Gagal bayar (deny/failed)
  'expired',           -- Waktu habis
  'cancelled',         -- Dibatalkan
  'refunded'           -- Sudah direfund
);

CREATE TYPE IF NOT EXISTS payments_status_enum AS ENUM (
  'initiated',
  'waiting_payment',
  'processing',
  'paid',
  'failed',
  'expired',
  'cancelled',
  'refunded'
);

CREATE TYPE IF NOT EXISTS orders_status_enum AS ENUM (
  'draft',
  'waiting_payment',
  'processing',
  'paid',
  'failed',
  'cancelled',
  'refunded'
);

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

