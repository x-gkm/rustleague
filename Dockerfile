FROM fedora:44

RUN sudo dnf install -y rustup-init clang jq wabt wasi-libc-devel \
    && rustup-init -y --default-toolchain nightly -c rust-src \
  	&& dnf clean all \
  	&& rm -rf /var/cache/yum

COPY rustleague /usr/local/bin