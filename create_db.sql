DROP SCHEMA public cascade;
create schema public;

CREATE TABLE IF NOT EXISTS "UserInfo"(
    "user_id" VARCHAR(255) NOT NULL, 
    "username" VARCHAR(255) NOT NULL, 
    "user_email" VARCHAR(255) NOT NULL, 
    "user_password" VARCHAR(255) NOT NULL, 
    "user_bio_text" VARCHAR(255),
    "follower_ids" VARCHAR(255)[], 
    "following_ids" VARCHAR(255)[], 
    "style_description" VARCHAR(255), 
    "top_style_pics" INT[], 
    PRIMARY KEY("user_id")
);

CREATE TABLE IF NOT EXISTS "UserPreferenceMapping"(
    "user_id" VARCHAR(255) NOT NULL, 
    "sleeve_length" INT[] NOT NULL,
    CONSTRAINT "sleeve_length_size" CHECK (array_length(sleeve_length, 1) = 6), 
    "lower_clothing_length" INT[] NOT NULL, 
    CONSTRAINT "lower_clothing_length_size" CHECK (array_length(lower_clothing_length, 1) = 5), 
    "socks" INT[] NOT NULL, 
    CONSTRAINT "socks_size" CHECK (array_length(socks, 1) = 4), 
    "hat" INT[] NOT NULL, 
    CONSTRAINT "hat_size" CHECK (array_length(hat, 1) = 3), 
    "glasses" INT[] NOT NULL, 
    CONSTRAINT "glasses_size" CHECK (array_length(glasses, 1) = 5), 
    "neckwear" INT[] NOT NULL, 
    CONSTRAINT "neckwear_size" CHECK (array_length(neckwear, 1) = 3), 
    "wrist_wearing" INT[] NOT NULL, 
    CONSTRAINT "wrist_wearing_size" CHECK (array_length(wrist_wearing, 1) = 3), 
    "ring" INT[] NOT NULL, 
    CONSTRAINT "ring_size" CHECK (array_length(ring, 1) = 3), 
    "waist_accessories" INT[] NOT NULL, 
    CONSTRAINT "waist_accessories_size" CHECK (array_length(waist_accessories, 1) = 5), 
    "neckline" INT[] NOT NULL, 
    CONSTRAINT "neckline_size" CHECK (array_length(neckline, 1) = 7), 
    "outer_clothing" INT[] NOT NULL, 
    CONSTRAINT "outer_clothing_size" CHECK (array_length(outer_clothing, 1) = 3), 
    "upper_clothing" INT[] NOT NULL, 
    CONSTRAINT "upper_clothing_size" CHECK (array_length(upper_clothing, 1) = 3),
    "upper_fabric" INT[] NOT NULL, 
    CONSTRAINT "upper_fabric_size" CHECK (array_length(upper_fabric, 1) = 8),
    "lower_fabric" INT[] NOT NULL, 
    CONSTRAINT "lower_fabric_size" CHECK (array_length(lower_fabric, 1) = 8),
    "outer_fabric" INT[] NOT NULL, 
    CONSTRAINT "outer_fabric_size" CHECK (array_length(outer_fabric, 1) = 8),
    "upper_color" INT[] NOT NULL, 
    CONSTRAINT "upper_color_size" CHECK (array_length(upper_color, 1) = 8),
    "lower_color" INT[] NOT NULL, 
    CONSTRAINT "lower_color_size" CHECK (array_length(lower_color, 1) = 8),
    "outer_color" INT[] NOT NULL, 
    CONSTRAINT "outer_color_size" CHECK (array_length(outer_color, 1) = 8), 
    PRIMARY KEY("user_id"),
	FOREIGN KEY("user_id") REFERENCES "UserInfo"("user_id")
);

CREATE TABLE IF NOT EXISTS "ChatInfo"(
	"chat_id" VARCHAR(255) NOT NULL,
	"chat_members" VARCHAR(255)[] NOT NULL,
	PRIMARY KEY("chat_id")
);

CREATE TABLE IF NOT EXISTS "MessageInfo"(
	"message_id" VARCHAR(255) NOT NULL,
	"sender_id" VARCHAR(255) NOT NULL,
	"chat_id" VARCHAR(255) NOT NULL,
	"message_text" VARCHAR(255),
    "timestamp" VARCHAR(255),
	PRIMARY KEY("message_id"),
	FOREIGN KEY("sender_id") REFERENCES "UserInfo"("user_id"),
	FOREIGN KEY("chat_id") REFERENCES "ChatInfo"("chat_id")
);