FROM golang

RUN go get github.com/motemen/blogsync

ENTRYPOINT [ "blogsync" ]