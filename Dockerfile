FROM openjdk:17
COPY . /PetClinic
WORKDIR /PetClinic
RUN ./mvnw -U -Dmaven.test.skip=true -T 4 clean install -DskipTests
WORKDIR target
CMD ["java", "-jar", "spring-petclinic-3.0.0-SNAPSHOT.jar" ]