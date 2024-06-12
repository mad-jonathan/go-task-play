# Use the official Go builder image as the builder stage
FROM golang:1.22 AS builder

# Set the working directory inside the container
WORKDIR /app

# pre-copy/cache go.mod for pre-downloading dependencies and
# only redownloading them in subsequent builds if they change
COPY go.mod go.sum ./
RUN go mod download && go mod verify

# Copy the source code into the container
COPY . .

# Build the Go application
RUN go build -o bin/go-task-play cmd/main.go

# Start a new stage using a scratch container
FROM scratch

# Copy the built binary from the builder stage to the scratch container
COPY --from=builder /app/bin/go-task-play /

# Set the command to run when the container starts
CMD ["/go-task-play"]