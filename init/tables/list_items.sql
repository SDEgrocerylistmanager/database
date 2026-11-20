CREATE TABLE list_items (
    id       bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id          text NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    item_name        text NOT NULL CHECK (length(btrim(item_name)) > 0),
    category         text FOREIGN KEY REFERENCES categories(name) ON DELETE SET NULL,
    quantity         numeric(10,2) NOT NULL DEFAULT 1 CHECK (quantity >= 0),
    last_added_at    timestamptz NOT NULL DEFAULT now(),
);
