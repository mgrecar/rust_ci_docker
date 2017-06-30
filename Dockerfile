# Start with a light weight base
# I would use Alpine, but Rust doesn't work there due to glibc issues
FROM debian:stretch
MAINTAINER mgrecar@gmail.com
WORKDIR /root
# Install Curl -> for rustup
# Install Gcc -> build dependency for Rust
# Remove apt cache after to save space
RUN apt-get update \
    && apt-get install -qqy curl gcc \
    && rm -rf /var/lib/apt/lists/*
# Install Stable Rust, Nightly Rust, and Clippy
# If Clippy ever works with Stable, we can drop Nightly entirely
RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain stable -y \
    && /root/.cargo/bin/rustup update nightly \
    && /root/.cargo/bin/rustup run nightly cargo install clippy
# Set the path so subsequent cargo commands are short
ENV PATH "/root/.cargo/bin:$PATH"
# Clear out CMD
CMD []
