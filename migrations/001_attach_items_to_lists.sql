-- Authentik-backed accounts do not have a local password credential.
ALTER TABLE users
    ALTER COLUMN password_hash DROP NOT NULL;

CREATE TABLE IF NOT EXISTS disabled_authentik_subjects (
    subject     text PRIMARY KEY,
    disabled_at timestamptz NOT NULL DEFAULT now()
);

-- Preserve existing items by assigning each to that user's first list.
-- Create a default list only for users who have items but no lists yet.
INSERT INTO lists (owner_id, list_name)
SELECT DISTINCT item.user_id, 'Default'
FROM list_items AS item
WHERE NOT EXISTS (
    SELECT 1
    FROM lists AS existing
    WHERE existing.owner_id = item.user_id
);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conrelid = 'lists'::regclass
          AND conname = 'lists_id_owner_unique'
    ) THEN
        ALTER TABLE lists
            ADD CONSTRAINT lists_id_owner_unique UNIQUE (id, owner_id);
    END IF;
END
$$;

ALTER TABLE list_items
    ADD COLUMN IF NOT EXISTS list_id bigint;

UPDATE list_items AS item
SET list_id = (
    SELECT list.id
    FROM lists AS list
    WHERE list.owner_id = item.user_id
    ORDER BY list.id
    LIMIT 1
)
WHERE item.list_id IS NULL;

ALTER TABLE list_items
    ALTER COLUMN list_id SET NOT NULL;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conrelid = 'list_items'::regclass
          AND conname = 'list_items_list_owner_fkey'
    ) THEN
        ALTER TABLE list_items
            ADD CONSTRAINT list_items_list_owner_fkey
                FOREIGN KEY (list_id, user_id)
                REFERENCES lists (id, owner_id)
                ON DELETE CASCADE;
    END IF;
END
$$;

CREATE INDEX IF NOT EXISTS list_items_list_idx ON list_items (list_id, id DESC);
