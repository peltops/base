import { createClient } from "jsr:@supabase/supabase-js@2";

const PAYMENT_SUPABASE_URL = Deno.env.get("PAYMENT_SUPABASE_URL");
const PAYMENT_SUPABASE_SERVICE_ROLE_KEY = Deno.env.get(
  "PAYMENT_SUPABASE_SERVICE_ROLE_KEY"
);
const PAYMENT_SUPABASE_ANON_KEY = Deno.env.get("PAYMENT_SUPABASE_ANON_KEY");

const paymentSupabaseAdmin = createClient(
  PAYMENT_SUPABASE_URL ?? "",
  PAYMENT_SUPABASE_SERVICE_ROLE_KEY ?? ""
);

const paymentSupabaseClient = (header: any) =>
  createClient(PAYMENT_SUPABASE_URL ?? "", PAYMENT_SUPABASE_ANON_KEY ?? "", {
    global: { headers: header },
  });

const getBookingProduct = async () => {
  const { data: bookingProduct, error: bookingProductError } =
    await paymentSupabaseAdmin
      .from("products")
      .select(
        `
            product_id,
            name,
            price
          `
      )
      .eq("product_id", "4cf70de1-35d6-4794-a249-9b79c328f086")
      .limit(1)
      .single();

  if (bookingProductError) {
    throw bookingProductError;
  }
  return bookingProduct;
};

export { paymentSupabaseAdmin, paymentSupabaseClient, getBookingProduct };
