CREATE TABLE users (
    id               text PRIMARY KEY,
    username         text NOT NULL UNIQUE,
    password_hash    text,
    email            text UNIQUE,
    telegram_chat_id text
);
