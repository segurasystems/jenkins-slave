GIT_SHORT_COMMIT=`git rev-parse --short HEAD`
DATE=`date +%Y-%m-%d`
ARCH = x86

all: prepare build push

prepare:
	docker pull jenkins/jnlp-slave

build:
	docker build -t index.segurasystems.com/jenkins/slave:latest -f Dockerfile .
	docker tag index.segurasystems.com/jenkins/slave:latest index.segurasystems.com/jenkins/slave:$(DATE)

push:
	docker push index.segurasystems.com/jenkins/slave:latest
	docker push index.segurasystems.com/jenkins/slave:$(DATE)
