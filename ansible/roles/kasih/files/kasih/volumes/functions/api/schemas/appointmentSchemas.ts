import { z } from "npm:zod";

const PAYMENT_GATEWAY = ["stripe", "midtrans"] as const;
export const createAppointmentSchema = z.object({
  parent_id: z.string().uuid(),
  child_id: z.string().uuid(),
  inspector_id: z.string().uuid(),
  date: z.string().date(),
  note: z.string().optional(),
  purpose: z.string().optional(),
  start_time: z.string().time(),
  end_time: z.string().time(),
  gateway: z.enum(PAYMENT_GATEWAY),
  currency: z.string(),
});

export const getAppointmentSchema = z.object({
  id: z.string().uuid(),
});
