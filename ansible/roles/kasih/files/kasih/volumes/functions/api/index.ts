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
  return c.json(
    {
      is_successful: false,
      message: "Not Found",
    },
    404
  );
});

Deno.serve(app.fetch);
