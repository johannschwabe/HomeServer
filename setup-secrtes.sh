#!/bin/bash
# Create Docker secrets for the Traefik stack
# Run this on your Docker Swarm manager node

echo "Setting up Docker secrets..."

# Generate secure passwords
POSTGRES_PASSWORD=$(openssl rand -base64 32)
KEYCLOAK_ADMIN_PASSWORD=$(openssl rand -base64 24)
AUTH_SECRET=$(openssl rand -base64 32)

# You need to get this from your Keycloak admin console
# Client -> main -> Credentials tab
read -p "Enter your OIDC Client Secret from Keycloak: " OIDC_CLIENT_SECRET

# Create secrets (note the -n flag to prevent newlines)
echo -n "$POSTGRES_PASSWORD" | docker secret create postgres_password -
echo -n "$KEYCLOAK_ADMIN_PASSWORD" | docker secret create keycloak_admin_password -
echo -n "$OIDC_CLIENT_SECRET" | docker secret create oidc_client_secret -
echo -n "$AUTH_SECRET" | docker secret create auth_secret -

echo ""
echo "✅ Docker secrets created successfully!"
echo ""
echo "📝 IMPORTANT: Save these credentials in your password manager:"
echo "   Postgres password: $POSTGRES_PASSWORD"
echo "   Keycloak admin password: $KEYCLOAK_ADMIN_PASSWORD"
echo "   Auth secret: $AUTH_SECRET"
echo "   OIDC client secret: $OIDC_CLIENT_SECRET"
echo ""
echo "🔑 Keycloak admin login:"
echo "   Username: admin"
echo "   Password: $KEYCLOAK_ADMIN_PASSWORD"
echo ""
echo "🚀 Now you can deploy with:"
echo "   docker stack deploy -c traefik-compose.yml traefik"
