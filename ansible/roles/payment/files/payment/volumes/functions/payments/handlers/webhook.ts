import { Context } from "jsr:@hono/hono";
import {
  verifyMidtransSignature,
  handleMidtransWebhook,
} from "../gateways/midtrans.ts";
import {
  verifyStripeSignature,
  handleStripeWebhook,
} from "../gateways/stripe.ts";
import { Buffer } from "node:buffer";

export const handleWebhook = async (c: Context) => {
  try {
    const rawBody = await c.req.text();
    const jsonBody = JSON.parse(rawBody);

    // Detect webhook source
    const midtransSignatureKey = jsonBody?.signature_key;
    if (midtransSignatureKey) {
      if (!verifyMidtransSignature(midtransSignatureKey, jsonBody)) {
        console.error("Invalid Midtrans signature");
        return c.json({ error: "Invalid Midtrans signature" }, 403);
      }
      await handleMidtransWebhook(jsonBody);
      return c.json({ message: "Midtrans webhook processed" });
    }

    const stripeSignature = c.req.header("stripe-signature");
    if (stripeSignature) {
      const stripeResult = await verifyStripeSignature(
        stripeSignature,
        rawBody
      );
      if (!stripeResult.valid) {
        console.error("Invalid Stripe signature");
        return c.json({ error: "Invalid Stripe signature" }, 403);
      }

      await handleStripeWebhook(stripeResult.event);
      console.log("Stripe webhook processed:", stripeResult.event);
      return c.json({ message: "Stripe webhook processed" });
    }

    return c.json({ error: "Unknown webhook source" }, 400);
  } catch (error) {
    console.error("Error processing webhook:", error);
    return c.json({ error: "Internal server error" }, 500);
  }
};
