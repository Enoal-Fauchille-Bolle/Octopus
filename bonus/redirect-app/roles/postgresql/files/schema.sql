CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    email_verified BOOLEAN DEFAULT FALSE NOT NULL,
    email_verification_token TEXT NULL,
    reset_token TEXT NULL,
    reset_token_expires TIMESTAMP WITH TIME ZONE NULL,
    is_locked BOOLEAN DEFAULT FALSE NOT NULL,
    failed_attempts INTEGER DEFAULT 0 NOT NULL,
    lockout_expires TIMESTAMP NULL,
    connection_verification_token TEXT NULL,
    connection_verification_expires TIMESTAMP NULL,
    connection_verification_country TEXT NULL,
    whitelisted_countries TEXT[] NULL,
    mfa_enabled BOOLEAN NOT NULL DEFAULT FALSE,
    mfa_secret TEXT,
    mfa_backup_codes TEXT[]
);
CREATE INDEX idx_users_email ON users (email);

CREATE TABLE redirects (
    id SERIAL PRIMARY KEY,
    original_url TEXT NOT NULL,
    custom_alias TEXT NOT NULL,
    user_id INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_redirects_user_id ON redirects (user_id);
CREATE INDEX idx_redirects_custom_alias ON redirects (custom_alias);

CREATE TABLE redirect_stats (
    id SERIAL PRIMARY KEY,
    redirect_id INTEGER NOT NULL,
    access_time TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_agent TEXT,
    os TEXT,
    browser TEXT,
    ip_address TEXT NOT NULL,
    country TEXT NOT NULL,
    FOREIGN KEY (redirect_id) REFERENCES redirects(id) ON DELETE CASCADE
);

CREATE INDEX idx_redirect_stats_redirect_id ON redirect_stats (redirect_id);
CREATE INDEX idx_redirect_stats_access_time ON redirect_stats (access_time);

CREATE TABLE sessions (
    id UUID PRIMARY KEY NOT NULL,
    user_id INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    last_activity TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    user_agent TEXT NOT NULL,
    os TEXT,
    browser TEXT,
    ip_address TEXT NOT NULL,
    country TEXT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_sessions_user_id ON sessions (user_id);
