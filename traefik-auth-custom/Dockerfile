# Build the Go entrypoint
FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY entrypoint.go .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o entrypoint entrypoint.go

# Use the original minimal image
FROM thomseddon/traefik-forward-auth:2
COPY --from=builder /app/entrypoint /entrypoint
ENTRYPOINT ["/entrypoint"]
