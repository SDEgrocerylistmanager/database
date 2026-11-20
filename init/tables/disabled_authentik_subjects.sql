CREATE TABLE disabled_authentik_subjects (
    subject     text PRIMARY KEY,
    disabled_at timestamptz NOT NULL DEFAULT now()
);
