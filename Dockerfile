FROM tomcat:9.0-jdk17-temurin

# Remove default Tomcat apps (optional but recommended)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file into Tomcat
COPY target/maven-web-app.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]

