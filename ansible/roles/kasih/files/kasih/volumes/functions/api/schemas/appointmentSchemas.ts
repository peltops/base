import { z } from "npm:zod";

const PAYMENT_GATEWAY = ["stripe", "midtrans"] as const;
export const createAppointmentSchema = z.object({
  parent_id: z.string().uuid(),
  child_id: z.string().uuid(),
  inspector_id: z.string().uuid(),
  date: z.string().date(),
  note: z.string().optional(),
  purpose: z.string().optional().default("Imunisasi"),
  start_time: z.string().time(),
  end_time: z.string().time(),
  gateway: z.enum(PAYMENT_GATEWAY).optional().default("midtrans"),
  currency: z.string().optional().default("IDR"),
});

export const getAppointmentSchema = z.object({
  id: z.string().uuid(),
});
