FROM golang

RUN go get github.com/motemen/blogsync

CMD blogsync --help