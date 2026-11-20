CREATE TABLE product_history (
    product_id     bigint NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    user_id        text NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    action_ts      timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (product_id, user_id)
);
