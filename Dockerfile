# Build application from source.
FROM golang:1.13.3-alpine3.10 AS build-env

WORKDIR /app

# Copy go.mod and download
ADD go.* ./
RUN go mod download

# Copy the rest of the code
ADD . .

# Test and build
# RUN CGO_ENABLED=0 go test ./...
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o goapp ./cmd/main.go

# Create final application image
FROM alpine:3.10
WORKDIR /app
COPY --from=build-env /app/goapp .
ENTRYPOINT ./goapp
