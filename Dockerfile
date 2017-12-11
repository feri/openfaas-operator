FROM golang:1.9

RUN mkdir -p /go/src/github.com/stefanprodan/faas-k8s/

WORKDIR /go/src/github.com/stefanprodan/faas-k8s

COPY . .

RUN gofmt -l -d $(find . -type f -name '*.go' -not -path "./vendor/*") \
  && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o faas-k8s .

FROM alpine:3.7
RUN apk --no-cache add ca-certificates
WORKDIR /root/

COPY --from=0 /go/src/github.com/stefanprodan/faas-k8s/faas-k8s .

ENTRYPOINT ["/faas-k8s"]
CMD ["-logtostderr"]
