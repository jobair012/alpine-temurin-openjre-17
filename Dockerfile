# Use Alpine Linux as the base image
FROM alpine:3.19.0

ENV FILE_NAME "OpenJDK17U-jre_x64_alpine-linux_hotspot_17.0.9_9.tar.gz"
ENV DOWNLOAD_URL "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.9%2B9/"
ENV EXPECTED_CHECKSUM "70e5d108f51ae7c7b2435d063652df058723e303a18b4f72f17f75c5320052d3"

# Download the file, calculate the checksum, and compare
RUN wget ${DOWNLOAD_URL}${FILE_NAME} \
    && DOWNLOADED_CHECKSUM=$(sha256sum ${FILE_NAME} | awk '{print $1}') \
    && if [ "${DOWNLOADED_CHECKSUM}" != "${EXPECTED_CHECKSUM}" ]; then \
        echo "Checksums do not match. File may be corrupted or tampered with." \
        && exit 1; \
       else \
        echo "Checksums match. File is valid."; \
       fi \
    && mkdir /opt/java \
    && tar -xzf ${FILE_NAME} -C /opt/java \
    && rm ${FILE_NAME}

# Set the JAVA_HOME environment variable
ENV JAVA_HOME=/opt/java/jdk-17.0.9+9-jre

# Add Java binaries to the system PATH
ENV PATH=${PATH}:${JAVA_HOME}/bin

