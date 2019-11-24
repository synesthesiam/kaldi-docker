DEBIAN_VERSION=1.0

debian-amd64:
	cd debian/ && fakeroot dpkg --build rhasspy-kaldi_$(DEBIAN_VERSION)_amd64

docker-amd64:
	docker build --build-arg BUILD_FROM=amd64/ubuntu:bionic . -t kaldi:amd64
	docker run -i kaldi:amd64 tar czvfh - -T /files-to-keep.txt > kaldi_amd64.tar.gz

docker-armhf:
	docker build --build-arg BUILD_FROM=arm32v7/ubuntu:bionic . -t kaldi:armhf
	docker run -i kaldi:armhf tar czvfh - -T /files-to-keep.txt > kaldi_armhf.tar.gz

docker-aarch64:
	docker build --build-arg BUILD_FROM=arm64v8/ubuntu:bionic . -t kaldi:aarch64
	docker run -i kaldi:aarch64 tar czvfh - -T /files-to-keep.txt > kaldi_amd64.tar.gz
