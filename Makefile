ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

all: php71.zip php73.zip php74.zip

php71.zip:
	docker run --rm -e http_proxy=${http_proxy} -v $(ROOT_DIR):/opt/layer lambci/lambda:build-provided /opt/layer/build.sh

php73.zip:
	docker run --rm -e http_proxy=${http_proxy} -v $(ROOT_DIR):/opt/layer lambci/lambda:build-provided /opt/layer/build-php-remi.sh 3

php74.zip:
	docker run --rm -e http_proxy=${http_proxy} -v $(ROOT_DIR):/opt/layer lambci/lambda:build-provided.al2 /opt/layer/build-php-74.sh

upload71: php71.zip
	./upload.sh 7.1

upload73: php73.zip
	./upload.sh 7.3

upload74: php74.zip
        ./upload.sh 7.4

publish71: php71.zip
	./publish.sh 7.1

publish73: php73.zip
	./publish.sh 7.3

publish74: php74.zip
        ./publish.sh 7.4

clean:
	rm -f php71.zip php73.zip php74.zip

