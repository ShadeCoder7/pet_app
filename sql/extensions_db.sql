-- Enable UUID generation and encryption functions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";    -- Needed for uuid_generate_v4()
CREATE EXTENSION IF NOT EXISTS "pgcrypto";     -- Useful for password encryption (e.g., crypt())