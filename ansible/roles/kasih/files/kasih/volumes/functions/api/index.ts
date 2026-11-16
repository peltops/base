import { Hono } from "jsr:@hono/hono";
import { logger } from "jsr:@hono/hono/logger";
import { zValidator } from "npm:@hono/zod-validator";
import {
  handleCreateAppointment,
  handleGetAppointment,
} from "./handlers/appointment.ts";
import {
  createAppointmentSchema,
  getAppointmentSchema,
} from "./schemas/appointmentSchemas.ts";

const functionName = "api";
const app = new Hono().basePath(`/${functionName}`);

app.use(logger());

app.post(
  "/appointments",
  // @ts-expect-error not typed well
  zValidator("json", createAppointmentSchema),
  handleCreateAppointment
);

app.get(
  "/appointments/:id",
  // @ts-expect-error not typed well
  zValidator("param", getAppointmentSchema),
  handleGetAppointment
);

// HANDLE 404
app.notFound((c) => {
  console.warn(`[api] Route not found: ${c.req.method} ${c.req.path}`);
  return c.json(
    {
      is_successful: false,
      message: "Not Found",
    },
    404
  );
});

// HANDLE ERRORS
app.onError((err, c) => {
  console.error(`[api] Unhandled error on ${c.req.method} ${c.req.path}:`, err);
  return c.json(
    {
      is_successful: false,
      message: err.message || "Internal Server Error",
    },
    500
  );
});

Deno.serve(app.fetch);
