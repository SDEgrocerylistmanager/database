CREATE TABLE list_items (
    id               bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id          text NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    list_id          bigint NOT NULL,
    item_name        text NOT NULL CHECK (length(btrim(item_name)) > 0),
    category         text REFERENCES categories(name) ON DELETE SET NULL,
    quantity         numeric(10,2) NOT NULL DEFAULT 1 CHECK (quantity >= 0),
    last_added_at    timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT list_items_list_owner_fkey
        FOREIGN KEY (list_id, user_id)
        REFERENCES lists (id, owner_id)
        ON DELETE CASCADE
);

CREATE INDEX list_items_list_idx ON list_items (list_id, id DESC);
