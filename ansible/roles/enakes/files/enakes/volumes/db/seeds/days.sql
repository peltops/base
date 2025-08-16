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
  ('7', 'MINGGU')
ON CONFLICT (id) DO NOTHING;
  