# =========================
# Stage 1: Build with Maven
# =========================
FROM maven:3.8.6-eclipse-temurin-8 AS builder

WORKDIR /app

# Copy pom.xml and download dependencies first (better caching)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and build
COPY src ./src

# Force compiler plugin to Java 8 (in case pom.xml not updated)
RUN mvn clean package -DskipTests -Dmaven.compiler.source=1.8 -Dmaven.compiler.target=1.8

# =========================
# Stage 2: Run on Tomcat
# =========================
FROM tomcat:9.0-jdk8-temurin

# Remove default ROOT app
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy built WAR from builder stage
COPY --from=builder /app/target/Presto.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]

