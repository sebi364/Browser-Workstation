#!/usr/bin/bash
ALPINE_BASE_URL="https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/x86/alpine-minirootfs-3.20.3-x86.tar.gz"
BUILD_DIR="/tmp/weblinux"
CHUNK_SIZE=2048

# preparation
mkdir -p "$BUILD_DIR/rootfs"
mkdir -p "$BUILD_DIR/webfs"
wget -O "$BUILD_DIR/alpine.tar.gz" "$ALPINE_BASE_URL"
tar -xf "$BUILD_DIR/alpine.tar.gz" -C "$BUILD_DIR/rootfs"
cp ./bin/* "$BUILD_DIR/rootfs/bin/"

# run install script
chroot "$BUILD_DIR/rootfs/" /bin/sh /bin/install

# convert to filesystem image file
dd if=/dev/zero of="$BUILD_DIR/filesystem.img" bs=1M count=512
mke2fs -t ext2 -d "$BUILD_DIR/rootfs" "$BUILD_DIR/filesystem.img"

# build webfs image
rm $BUILD_DIR/webfs/*

cat << EOF | python3
chunk_count = 0
with open("$BUILD_DIR/filesystem.img", 'rb') as f:
    chunk_index = 0
    while True:
        chunk = f.read($CHUNK_SIZE * 1024)

        if not chunk:
            break

        with open(f"$BUILD_DIR/webfs/blk{chunk_index:09d}.bin", 'wb') as chunk_file:
            chunk_file.write(chunk)

        chunk_index += 1

    chunk_count = chunk_index
with open("$BUILD_DIR/webfs/blk.txt", "w") as f:
    f.write("{\n")
    f.write(f"  block_size: $CHUNK_SIZE,\n")
    f.write(f"  n_block: {chunk_count},\n")
    f.write("}")
EOF

# cleanup
sudo rm -rf "$BUILD_DIR/rootfs"
sudo rm -rf "$BUILD_DIR/filesystem.img"

# move linux into html dir
mkdir ../deploy/linux/root-x86/
cp $BUILD_DIR/webfs/* ../deploy/linux/root-x86/