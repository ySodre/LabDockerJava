FROM maven:3.5-jdk-8 as buildstage
RUN mkdir /opt/note
RUN chown -R notes:notes /opt/note
WORKDIR /opt/note
RUN git clone https://github.com/ySodre/spring-boot-mysql-rest-api-tutorial.git /opt/note
RUN mvn package -DskipTests=true

FROM openjdk:8-jdk-alpine
RUN addgroup -S notes && adduser -S notes -G notes 
RUN mkdir /opt/note
RUN chown -R notes:notes /opt/note
USER notes:notes
WORKDIR /opt/note 
COPY --from=buildstage /opt/note/target/easy-notes-1.0.0.jar .
COPY application.properties application.properties
ENTRYPOINT [ "java", "-jar", "/opt/note/easy-note.jar" ]
