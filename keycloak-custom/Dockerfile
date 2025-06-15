FROM keycloak/keycloak:26.2

COPY entrypoint.sh /opt/keycloak/bin/entrypoint.sh
USER root
RUN chmod +x /opt/keycloak/bin/entrypoint.sh 
ENTRYPOINT ["/opt/keycloak/bin/entrypoint.sh"]
USER keycloak
# Default command (can be overridden)
CMD ["start"]
