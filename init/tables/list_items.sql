CREATE TABLE list_items (
    id       bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    list_id  bigint NOT NULL REFERENCES lists(id) ON DELETE CASCADE,
    name     text NOT NULL CHECK (length(btrim(name)) > 0),
    quantity numeric(10,2) NOT NULL DEFAULT 1 CHECK (quantity > 0),
    unit     text,
    category text NOT NULL DEFAULT 'Other'
             CHECK (category IN ('Dairy', 'Produce', 'Household', 'Bakery', 'Other')),
    checked  boolean NOT NULL DEFAULT false
);

CREATE UNIQUE INDEX list_items_dedup_idx ON list_items (list_id, lower(btrim(name)));
