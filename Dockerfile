FROM fedora:44

RUN dnf install -y rustup-init clang jq wabt wasi-libc-devel \
    && rustup-init -y --default-toolchain nightly -c rust-src \
  	&& dnf clean all \
  	&& rm -rf /var/cache/yum

ENV RUSTFLAGS="-L/usr/wasm32-wasi/lib/wasm32-wasi"

COPY rustleague /usr/local/bin
