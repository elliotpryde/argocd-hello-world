FROM httpd:alpine3.14

EXPOSE 80

RUN mkdir /etc/hello-world/
COPY ./build/VERSION /etc/hello-world/VERSION

RUN ver=$(cat /etc/hello-world/VERSION); echo "<html><body><h1>Hello World!</h1><p>version $ver</p></body></html>" > /usr/local/apache2/htdocs/index.html
