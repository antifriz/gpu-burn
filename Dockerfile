FROM nvidia/cuda:10.0-devel-ubuntu18.04 as builder
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        git \
    && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src
RUN git clone https://github.com/wilicc/gpu-burn
WORKDIR /usr/src/gpu-burn
RUN make


FROM nvidia/cuda:10.0-runtime-ubuntu18.04
WORKDIR /usr/src/app
COPY --from=builder /usr/src/gpu-burn/gpu_burn  .
COPY --from=builder /usr/src/gpu-burn/compare.ptx .
ENTRYPOINT ["./gpu_burn"]
