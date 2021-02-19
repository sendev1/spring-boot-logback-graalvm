#!/usr/bin/env bash

ARTIFACT=logback
MAINCLASS=com.example.logback.LogbackApplication
VERSION=0.0.1-SNAPSHOT

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

mkdir -p build/native-image

JAR="$ARTIFACT-$VERSION.war"
rm -f $ARTIFACT
echo "Unpacking $JAR"
cd build/native-image
jar -xvf ../libs/$JAR >/dev/null 2>&1
cp -R META-INF WEB-INF/classes

# To run tracing agent
# java -cp WEB-INF/classes:WEB-INF/lib/*:WEB-INF/lib-provided/* -agentlib:native-image-agent=config-output-dir=../graal-agent com.vue.labs.LocalAbeServiceApplication

LIBPATH=$(find WEB-INF/lib | tr '\n' ':')
CP=WEB-INF/classes:$LIBPATH

GRAALVM_VERSION=$(native-image --version)
echo "Compiling $ARTIFACT with $GRAALVM_VERSION"
native-image \
  --no-server \
  --no-fallback \
  -H:Debug=2 \
  -H:Optimize=0 \
  --install-exit-handlers \
  --enable-all-security-services \
  --verbose \
  -H:Name=$ARTIFACT \
  -H:+RemoveSaturatedTypeFlows \
  -H:+ReportExceptionStackTraces \
  -H:+PrintClassInitialization \
  -Dspring.native.mode=agent \
  -Dspring.native.remove-yaml-support=true \
  -Dspring.xml.ignore=false \
  -Dspring.native.verbose=true \
  -cp $CP $MAINCLASS

#   --allow-incomplete-classpath \
#   --report-unsupported-elements-at-runtime \
#  --initialize-at-build-time=org.springframework.util.unit.DataSize \
#   --report-unsupported-elements-at-runtime \
#  --trace-class-initialization=org.springframework.util.unit.DataSize \
#  --initialize-at-build-time=org.springframework.util.unit.DataSize \

#   --rerun-class-initialization-at-runtime=org.bouncycastle.jcajce.provider.drbg.DRBG$Default,org.bouncycastle.jcajce.provider.drbg.DRBG$NonceAndIV \
#  --trace-class-initialization=org.bouncycastle.jcajce.provider.drbg.DRBG \
#  --initialize-at-run-time=org.bouncycastle.jcajce.provider.drbg.DRBG \
