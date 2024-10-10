FROM golang:1.22-alpine AS builder

ARG path

ENV SVC_PATH ${path}

WORKDIR /app

COPY go.mod go.sum .

RUN go mod download

RUN go mod verify

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o bin/main $SVC_PATH

FROM alpine:latest

RUN apk --no-cache add ca-certificates tzdata

WORKDIR /root/

COPY --from=builder /app/bin .

CMD ["./main"]
