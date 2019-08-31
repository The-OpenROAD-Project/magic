FROM centos:centos6 AS builder

# Common development tools and libraries (kitchen sink approach)
RUN yum groupinstall -y "Development Tools" "Development Libraries"

# magic dependencies
RUN yum install -y csh wget tcl-devel tk-devel libX11-devel cairo-devel ncurses-devel

COPY . /magic
WORKDIR /magic

RUN ./configure --prefix=/build && \
    make && \
    make install

FROM centos:centos6 AS runner
RUN yum update -y && yum install -y tcl-devel
COPY --from=builder /build /build
RUN useradd -ms /bin/bash openroad
USER openroad
WORKDIR /home/openroad

