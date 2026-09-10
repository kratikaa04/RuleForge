# ---------- Stage 1: Build ----------
FROM haskell:9.10.3 AS build

WORKDIR /app

# Copy only dependency-related files first (for Docker caching)
COPY package.yaml stack.yaml stack.yaml.lock ./

# Install dependencies (this layer is cached unless deps change)
RUN stack setup
RUN stack build --only-dependencies

# Now copy the rest of the actual source code
COPY . .

# Build the real project
RUN stack build --copy-bins --local-bin-path /app/bin

# ---------- Stage 2: Runtime ----------
FROM debian:bookworm-slim

WORKDIR /app

# Install minimal runtime libraries Haskell binaries typically need
RUN apt-get update && apt-get install -y \
    libgmp10 \
    libnuma1 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy only the compiled binary from the build stage
COPY --from=build /app/bin/RuleForge-exe /app/RuleForge-exe

EXPOSE 3000

CMD ["/app/RuleForge-exe"]