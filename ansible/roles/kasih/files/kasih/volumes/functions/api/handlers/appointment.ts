import { Context } from "jsr:@hono/hono";
import { paymentSupabaseAdmin } from "../../_shared/paymentSupabase.ts";
import { kasihSupabaseAdmin } from "../../_shared/kasihSupabase.ts";

export const handleCreateAppointment = async (c: Context) => {
  const body = await c.req.json();
  const headers: Record<string, string> = {};
  const authHeader = c.req.header("Authorization");
  if (authHeader) {
    headers["Authorization"] = authHeader;
  }
  const { gateway, currency, ...rest } = body;

  // 1. Inisiasi Pembayaran (Wajib & Strict: tidak boleh ada janji tanpa order_id)
  let initiatePaymentResult: any = null;
  try {
    const { data: initiatePayment, error: errorInitiatePayment } =
      await paymentSupabaseAdmin.functions.invoke("payments/initiate", {
        headers: headers,
        method: "POST",
        body: {
          gateway: gateway || "midtrans",
          currency: currency || "IDR",
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
      console.error("Payment initiation error:", errorInitiatePayment);
      return c.json(
        {
          is_successful: false,
          message: "Failed to initiate payment for appointment",
          error: errorInitiatePayment,
        },
        400
      );
    }
    initiatePaymentResult = initiatePayment;
  } catch (paymentErr) {
    console.error("Error invoking payment service:", paymentErr);
    return c.json(
      {
        is_successful: false,
        message: "Payment service is currently unavailable",
        error:
          paymentErr instanceof Error ? paymentErr.message : String(paymentErr),
      },
      400
    );
  }

  const orderId = initiatePaymentResult?.data?.order_id;
  if (!orderId) {
    console.error(
      "Payment service did not return an order_id:",
      initiatePaymentResult
    );
    return c.json(
      {
        is_successful: false,
        message: "Payment initiation did not produce a valid order ID",
        error: initiatePaymentResult,
      },
      400
    );
  }

  // 2. Buat Appointment di Database HANYA jika order_id sudah valid
  const model = {
    ...rest,
    order_id: orderId,
  };

  const { data: createAppointment, error: errorCreateAppointment } =
    await kasihSupabaseAdmin
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
        message: "Failed to create appointment in database",
        error: errorCreateAppointment,
      },
      500
    );
  }

  // 3. Ambil data health worker
  let healthWorkerData: any = null;
  if (model.inspector_id) {
    try {
      const { data: healthWorker, error: errorHealthWorker } =
        await kasihSupabaseAdmin.functions.invoke(
          "get-health-worker/" + model.inspector_id,
          {
            headers: headers,
            method: "GET",
          }
        );

      if (errorHealthWorker) {
        console.warn("Warning fetching health worker:", errorHealthWorker);
      } else if (healthWorker?.data) {
        healthWorkerData = healthWorker.data;
      }
    } catch (hwErr) {
      console.warn("Error invoking get-health-worker:", hwErr);
    }
  }

  // 4. Ambil data order
  let orderData: any = null;
  try {
    const { data: orderById, error: errorOrderById } =
      await paymentSupabaseAdmin.functions.invoke(
        "payments/order/" + orderId,
        {
          headers: headers,
          method: "GET",
        }
      );

    if (errorOrderById) {
      console.warn("Warning fetching order by ID:", errorOrderById);
    } else if (orderById?.data) {
      orderData = orderById.data;
    }
  } catch (orderErr) {
    console.warn("Error invoking payments/order:", orderErr);
  }

  const response = {
    is_successful: true,
    message: "Appointment created successfully",
    data: {
      ...createAppointment,
      health_worker: healthWorkerData,
      order: orderData,
    },
  };
  return c.json(response, 200);
};

export const handleGetAppointment = async (c: Context) => {
  const appointmentId = c.req.param("id");
  const { data: appointment, error: errorAppointment } =
    await kasihSupabaseAdmin
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

  if (errorAppointment || !appointment) {
    console.error("Error fetching appointment:", errorAppointment);
    const status = errorAppointment?.code === "PGRST116" ? 404 : 500;
    return c.json(
      {
        is_successful: false,
        message: "Failed to fetch appointment",
        error: errorAppointment,
      },
      status
    );
  }

  const headers: Record<string, string> = {};
  const authHeader = c.req.header("Authorization");
  if (authHeader) {
    headers["Authorization"] = authHeader;
  }

  let healthWorkerData: any = null;
  if (appointment.inspector_id) {
    try {
      const { data: healthWorker, error: errorHealthWorker } =
        await kasihSupabaseAdmin.functions.invoke(
          "get-health-worker/" + appointment.inspector_id,
          {
            headers: headers,
            method: "GET",
          }
        );

      if (errorHealthWorker) {
        console.warn("Warning fetching health worker:", errorHealthWorker);
      } else if (healthWorker?.data) {
        healthWorkerData = healthWorker.data;
      }
    } catch (hwErr) {
      console.warn("Error invoking get-health-worker:", hwErr);
    }
  }

  let orderData: any = null;
  if (appointment.order_id) {
    try {
      const { data: orderRes, error: errorOrder } =
        await paymentSupabaseAdmin.functions.invoke(
          "payments/order/" + appointment.order_id,
          {
            headers: headers,
            method: "GET",
          }
        );

      if (errorOrder) {
        console.warn("Warning fetching order:", errorOrder);
      } else if (orderRes?.data) {
        orderData = orderRes.data;
      }
    } catch (orderErr) {
      console.warn("Error invoking payments/order:", orderErr);
    }
  }

  return c.json(
    {
      is_successful: true,
      message: "Appointment fetched successfully",
      data: {
        ...appointment,
        health_worker: healthWorkerData,
        order: orderData,
      },
    },
    200
  );
};
