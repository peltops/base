DO $$
DECLARE 
returned_user_id uuid;
name text;
schedules jsonb;
BEGIN
  name := 'test';
  -- MONDAY - 1
  -- TUESDAY - 2
  -- WEDNESDAY - 3
  -- THURSDAY - 4
  -- FRIDAY - 5
  -- SATURDAY - 6
  -- SUNDAY - 7
  schedules := '[
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
    }]
  ';

  -- Inserting into users table
  INSERT INTO auth.users (
    id,
    instance_id,
    aud,
    role,
    email,
    encrypted_password, 
    email_confirmed_at,
    raw_app_meta_data,
    raw_user_meta_data,
    created_at,
    updated_at
  )
  VALUES (
    gen_random_uuid(),
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    -- take name and append @test.com
    name || '@test.com',
    '$2a$10$If.z.4xfINJRXnvf1QfykulWzkXpgpZMT8tp9NNQnqiV510t2vjfC',
    now(),
    '{
    "provider": "email",
    "providers": [
      "email"
    ]
    }',
    ('{
    "full_name": "' || name || '"
    }')::jsonb,
    now(),
    now()
  )
  RETURNING id INTO returned_user_id;

  -- Update profession in profile table 
  UPDATE public.profiles
  SET profession = 'profesi test'
  WHERE user_id = returned_user_id;

  -- Inserting into practice_schedules table with looping from schedules jsonb
  FOR i IN 0..jsonb_array_length(schedules) - 1
  LOOP
    INSERT INTO public.practice_schedules (
      user_id,
      day_id,
      start_time,
      end_time
    )
    VALUES (
      returned_user_id,
      ((schedules->>i)::jsonb->>'day_id')::int,
      ((schedules->>i)::jsonb->>'start_time')::time,
      ((schedules->>i)::jsonb->>'end_time')::time
    );
  END LOOP;
END
$$;