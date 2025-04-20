import { Context } from "jsr:@hono/hono";
import {
  verifyMidtransSignature,
  handleMidtransWebhook,
} from "../gateways/midtrans.ts";
import {
  verifyStripeSignature,
  handleStripeWebhook,
} from "../gateways/stripe.ts";

export const handleWebhook = async (c: Context) => {
  const rawBody = await c.req.text();

  // Detect webhook source
  const midtransSignatureKey = c.req.header('signature-key');
  if (midtransSignatureKey) {
    if (!verifyMidtransSignature(midtransSignatureKey, rawBody)) {
      return c.json({ error: "Invalid Midtrans signature" }, 403);
    }

    const json = JSON.parse(rawBody);
    await handleMidtransWebhook(json);
    return c.json({ message: "Midtrans webhook processed" });
  }

  const stripeSignature = c.req.header('stripe-signature');
  if (stripeSignature) {
    const stripeResult = await verifyStripeSignature(
      stripeSignature,
      rawBody
    );
    if (!stripeResult.valid) {
      return c.json({ error: "Invalid Stripe signature" }, 403);
    }

    await handleStripeWebhook(stripeResult.event);
    return c.json({ message: "Stripe webhook processed" });
  }

  return c.json({ error: "Unknown webhook source" }, 400);
};
