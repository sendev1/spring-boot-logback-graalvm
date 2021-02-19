.PHONY: build

build:
	./gradlew build

compile: build
	./compile-only.sh

profile:
	echo "profiling to generate config.."
	mkdir -p src/main/resources/META-INF/native-image
	java -agentlib:native-image-agent=config-output-dir=src/main/resources/META-INF/native-image \
			-jar build/libs/logback-0.0.1-SNAPSHOT.war \
			-Dorg.graalvm.nativeimage.imagecode=agent

clean:
	./gradlew clean

run:
	./build/native-image/logback

runJar:
	java -jar ./build/libs/logback-0.0.1-SNAPSHOT.war

build-docker:
	docker build \
		-f Dockerfile \
		-t logback-test:0.1 .

run-docker:
	docker run --rm -it -p 8080:8080 logback-test:0.1 /bin/bash