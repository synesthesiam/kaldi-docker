all:
	docker build . -t kaldi:build
	docker run -i kaldi:build tar czvfh - -T /files-to-keep.txt > kaldi.tar.gz
