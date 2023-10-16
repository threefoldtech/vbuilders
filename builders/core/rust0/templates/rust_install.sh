set -eux

RUSTUP_HOME=/usr/local/rustup
CARGO_HOME=/usr/local/cargo
PATH=/usr/local/cargo/bin:$PATH

apkArch="$(apk --print-arch)"

case "$apkArch" in
    x86_64) rustArch='x86_64-unknown-linux-musl';;
    aarch64) rustArch='aarch64-unknown-linux-musl';;
    *) echo >&2 "unsupported architecture: $apkArch"; exit 1 ;;
esac

curl https://sh.rustup.rs -sSf | sh -s --  -y --profile minimal --default-toolchain $RUST_VERSION --default-host ${rustArch}

source $HOME/.cargo/env


rustup --version
cargo --version
rustc --version


rustup target add x86_64-unknown-linux-musl



# chmod -R a+w $RUSTUP_HOME $CARGO_HOME
