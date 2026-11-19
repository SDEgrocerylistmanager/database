CREATE TABLE lists (
    id             bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    owner_id       text NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name           text NOT NULL CHECK (length(btrim(name)) > 0),
    last_shared_at timestamptz
);

CREATE INDEX lists_owner_idx ON lists (owner_id, id DESC);
