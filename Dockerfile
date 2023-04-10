FROM openjdk:17
COPY ./target /PetClinic
WORKDIR /PetClinic
CMD ["java", "-jar", "spring-petclinic-3.0.0-SNAPSHOT.jar" ]