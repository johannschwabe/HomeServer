#!/bin/bash

# Function to read secret from file and strip whitespace
read_secret() {
    local secret_file="$1"
    local env_var="$2"
    
    if [ -f "$secret_file" ]; then
        local secret_value=$(cat "$secret_file" | tr -d '\n\r\t ' | tr -d '[:space:]')
        export "$env_var"="$secret_value"
        echo "Loaded secret: $env_var"
        return 0
    else
        echo "Error: Secret file $secret_file not found"
        exit 1
    fi
}

# Load secrets
read_secret "/run/secrets/postgres_password" "KC_DB_PASSWORD"
read_secret "/run/secrets/keycloak_admin_password" "KC_BOOTSTRAP_ADMIN_PASSWORD"

# Start Keycloak
exec /opt/keycloak/bin/kc.sh "$@"
