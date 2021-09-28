FROM docker.io/golang:1.17.1@sha256:285cf0cb73ab995caee61b900b2be123cd198f3541ce318c549ea5ff9832bdf0 AS build
WORKDIR /app
COPY . /app
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' -o /app/main .
RUN go get github.com/google/go-licenses && go-licenses save ./... --save_path=/notices

FROM gcr.io/distroless/static:nonroot@sha256:7cb5539ebb7b99352d736ed97668060cee123285f01705b910891acdf7d945e3
LABEL org.opencontainers.image.source="https://github.com/greboid/docker-tags-action"
COPY --from=build /notices /notices
COPY --from=build /app/main /docker-tags
WORKDIR /
ENTRYPOINT ["/docker-tags"]
