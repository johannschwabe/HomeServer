package main

import (
	"fmt"
	"os"
	"strings"
	"syscall"
)

// readSecret reads a secret file and strips whitespace
func readSecret(secretFile, envVar string) error {
	content, err := os.ReadFile(secretFile)
	if err != nil {
		return fmt.Errorf("failed to read secret file %s: %v", secretFile, err)
	}

	// Strip all whitespace/newlines
	secretValue := strings.TrimSpace(string(content))
	secretValue = strings.ReplaceAll(secretValue, "\n", "")
	secretValue = strings.ReplaceAll(secretValue, "\r", "")
	secretValue = strings.ReplaceAll(secretValue, "\t", "")

	err = os.Setenv(envVar, secretValue)
	if err != nil {
		return fmt.Errorf("failed to set environment variable %s: %v", envVar, err)
	}

	fmt.Printf("Loaded secret: %s\n", envVar)
	return nil
}

func main() {
	// Load secrets
	if err := readSecret("/run/secrets/oidc_client_secret", "PROVIDERS_OIDC_CLIENT_SECRET"); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}

	if err := readSecret("/run/secrets/auth_secret", "SECRET"); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}

	// Execute traefik-forward-auth binary
	binary := "/traefik-forward-auth"
	args := []string{binary}

	// Add any command line arguments passed to this program
	if len(os.Args) > 1 {
		args = append(args, os.Args[1:]...)
	}

	// Use execve to replace this process with traefik-forward-auth
	err := syscall.Exec(binary, args, os.Environ())
	if err != nil {
		fmt.Fprintf(os.Stderr, "Failed to exec %s: %v\n", binary, err)
		os.Exit(1)
	}
}
