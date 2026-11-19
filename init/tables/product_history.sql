CREATE TABLE product_history (
    id               bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id          text NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name             text NOT NULL CHECK (length(btrim(name)) > 0),
    category         text NOT NULL DEFAULT 'Other'
                     CHECK (category IN ('Dairy', 'Produce', 'Household', 'Bakery', 'Other')),
    default_quantity numeric(10,2) NOT NULL DEFAULT 1,
    unit             text,
    times_added      integer NOT NULL DEFAULT 1,
    last_added_at    timestamptz NOT NULL DEFAULT now(),
    last_list_id     bigint REFERENCES lists(id) ON DELETE SET NULL,
    is_favorite      boolean NOT NULL DEFAULT false
);
CREATE UNIQUE INDEX product_history_dedup_idx ON product_history (user_id, lower(btrim(name)));
CREATE INDEX product_history_recent_idx ON product_history (user_id, last_added_at DESC);
