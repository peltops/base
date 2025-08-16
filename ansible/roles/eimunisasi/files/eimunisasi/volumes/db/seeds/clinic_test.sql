DO $$
DECLARE
returned_clinic_id uuid;
BEGIN
  INSERT INTO public.clinics (
    name,
    address,
    motto,
    phone_number,
    photos
  )
  VALUES (
    'Klinik Test',
    'Jl. Test',
    'Klinik Test',
    '081234567890',
    ARRAY['https://www.google.com']
  )
  RETURNING id INTO returned_clinic_id;

  INSERT INTO public.clinic_schedules (
    clinic_id,
    day_id,
    start_time,
    end_time
  )
  SELECT
    returned_clinic_id,
    (schedule ->> 'day_id')::int,
    (schedule ->> 'start_time')::time,
    (schedule ->> 'end_time')::time
  FROM jsonb_array_elements('[
    {
      "day_id": 1,
      "start_time": "08:00:00",
      "end_time": "10:00:00"
    },
    {
      "day_id": 1,
      "start_time": "12:00:00",
      "end_time": "14:00:00"
    },
    {
      "day_id": 3,
      "start_time": "15:00:00",
      "end_time": "17:00:00"
    },
    {
      "day_id": 5,
      "start_time": "09:00:00",
      "end_time": "10:00:00"
    }
  ]') AS schedule;
END $$;