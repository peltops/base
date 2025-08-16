import { Context } from "jsr:@hono/hono";
import { paymentSupabaseAdmin } from "../../_shared/paymentSupabase.ts";
import { eImunisasiSupabaseAdmin } from "../../_shared/eimunisasiSupabase.ts";

export const handleCreateAppointment = async (c: Context) => {
  const body = await c.req.json();
  const headers: Record<string, string> = {};
  const authHeader = c.req.header("Authorization");
  if (authHeader) {
    headers["Authorization"] = authHeader;
  }
  const { gateway, currency, ...rest } = body;

  const { data: initiatePayment, error: errorInitiatePayment } =
    await paymentSupabaseAdmin.functions.invoke("payments/initiate", {
      headers: headers,
      method: "POST",
      body: {
        gateway: gateway,
        currency: currency,
        items: [
          {
            // HARD CODED BOOKING FEE PRODUCT ID
            id: "4cf70de1-35d6-4794-a249-9b79c328f086",
            quantity: 1,
          },
        ],
      },
    });

  if (errorInitiatePayment) {
    console.error("Error initiating payment:", errorInitiatePayment);
    return c.json(
      {
        is_successful: false,
        message: "Failed to create appointment",
        error: errorInitiatePayment,
      },
      400
    );
  }

  const model = {
    ...rest,
    order_id: initiatePayment.data?.order_id,
  };
  const { data: createAppointment, error: errorCreateAppointment } =
    await eImunisasiSupabaseAdmin
      .from("appointments")
      .insert(model)
      .select(
        `
            *,
            profiles!parent_id(*),
            children!child_id(*)
          `
      )
      .limit(1)
      .single();

  if (errorCreateAppointment) {
    console.error("Error creating appointment:", errorCreateAppointment);
    return c.json(
      {
        is_successful: false,
        message: "Failed to create appointment",
        error: errorCreateAppointment,
      },
      500
    );
  }
  const { data: healthWorker, error: errorHealthWorker } =
    await eImunisasiSupabaseAdmin.functions.invoke(
      "get-health-worker/" + model.inspector_id,
      {
        headers: headers,
        method: "GET",
      }
    );

  if (errorHealthWorker) {
    console.error("Error fetching health worker:", errorHealthWorker);
    return c.json(
      {
        is_successful: false,
        message: "Failed to fetch health worker",
        error: errorHealthWorker,
      },
      500
    );
  }

  const { data: orderById, error: errorOrderById } =
    await paymentSupabaseAdmin.functions.invoke(
      "payments/order/" + model.order_id,
      {
        headers: headers,
        method: "GET",
      }
    );

  if (errorOrderById) {
    console.error("Error fetching order by ID:", errorOrderById);
    return c.json(
      {
        is_successful: false,
        message: "Failed to fetch order by ID",
        error: errorOrderById,
      },
      500
    );
  }

  const order = orderById.data;

  if (!order) {
    return c.json(
      {
        is_successful: false,
        message: "Order not found",
      },
      404
    );
  }
  const response = {
    is_successful: true,
    message: "Appointment created successfully",
    data: {
      ...createAppointment,
      health_worker: healthWorker.data,
      order,
    },
  };
  return c.json(response, 200);
};

export const handleGetAppointment = async (c: Context) => {
  const appointmentId = c.req.param("id");
  const { data: appointment, error: errorAppointment } =
    await eImunisasiSupabaseAdmin
      .from("appointments")
      .select(
        `
            *,
            profiles!parent_id(*),
            children!child_id(*)
        `
      )
      .eq("id", appointmentId)
      .limit(1)
      .single();

  if (errorAppointment) {
    console.error("Error fetching appointment:", errorAppointment);
    return c.json(
      {
        is_successful: false,
        message: "Failed to fetch appointment",
        error: errorAppointment,
      },
      500
    );
  }

  const headers: Record<string, string> = {};
  const authHeader = c.req.header("Authorization");
  if (authHeader) {
    headers["Authorization"] = authHeader;
  }

  const { data: healthWorker, error: errorHealthWorker } =
    await eImunisasiSupabaseAdmin.functions.invoke(
      "get-health-worker/" + appointment.inspector_id,
      {
        headers: headers,
        method: "GET",
      }
    );

  if (errorHealthWorker) {
    console.error("Error fetching health worker:", errorHealthWorker);
    const status = errorHealthWorker?.context?.status || 500;
    const message =
      status === 401
        ? "Unauthorized access to health worker"
        : "Failed to fetch health worker";
    return c.json(
      {
        is_successful: false,
        message: message,
        error: errorHealthWorker,
      },
      status
    );
  }

  const { data: orderData, error: errorOrder } =
    await paymentSupabaseAdmin.functions.invoke(
      "payments/order/" + appointment.order_id,
      {
        headers: headers,
        method: "GET",
      }
    );

  if (errorOrder) {
    console.error("Error fetching order:", errorOrder);
    const status = errorOrder?.context?.status || 500;
    const message =
      status === 401 ? "Unauthorized access to order" : "Failed to fetch order";
    return c.json(
      {
        is_successful: false,
        message: message,
        error: errorOrder,
      },
      status
    );
  }

  return c.json(
    {
      is_successful: true,
      message: "Appointment fetched successfully",
      data: {
        ...appointment,
        health_worker: healthWorker.data,
        order: orderData.data,
      },
    },
    200
  );
};
