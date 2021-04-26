FROM golang

RUN go get github.com/x-motemen/blogsync

ENTRYPOINT [ "blogsync" ]