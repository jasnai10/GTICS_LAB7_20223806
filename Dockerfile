FROM openjdk:26-ea-17-trixie
VOLUME /tmp
EXPOSE 8080
ADD ./target/GTICS_LAB7_20223806-0.0.1-SNAPSHOT.jar lab7.jar
ENTRYPOINT ["java", "-jar", "lab7.jar"]