CREATE TABLE categories (
    name text NOT NULL CHECK (length(btrim(name)) > 0) PRIMARY KEY,
);
