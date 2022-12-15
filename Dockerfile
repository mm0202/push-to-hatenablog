FROM golang

RUN go install github.com/x-motemen/blogsync@v0.12.1

ENTRYPOINT [ "blogsync" ]
