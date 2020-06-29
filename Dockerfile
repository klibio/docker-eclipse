FROM ubuntu:20.10
RUN useradd dev
RUN apt-get update && apt-get install -y openjdk-8-jdk libswt-gtk-4-jni libswt-gtk-4-java
RUN javac -version
ADD ressources /usr/ressources
#Problem: Eclipse IDE nicht via CLI installable. Workaround via copying files and init script?
#COPY ./ressources /
#RUN chmod a+x init.sh
CMD [ "/usr/ressources/eclipse/eclipse", "-data", "~/ws" ]