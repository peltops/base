-- INIT DATA FOR TABLE days
INSERT into days
  (id, name)
VALUES
  ('1', 'SENIN'),
  ('2', 'SELASA'),
  ('3', 'RABU'),
  ('4', 'KAMIS'),
  ('5', 'JUMAT'),
  ('6', 'SABTU'),
  ('7', 'MINGGU');

  --  Enable RLS for the days table
  ALTER TABLE public.days ENABLE ROW LEVEL SECURITY;

  -- Create a policy that just allows SELECT on the days table
  CREATE POLICY select_days_policy
  ON public.days
  FOR SELECT
  TO authenticated
  USING (true);
  