# confluence

To build

```
docker build --rm --tag=pghalliday/confluence .
```

To run

```
docker run -p 0.0.0.0:8090:8090 -i -t pghalliday/confluence
```

Mounts the following volume for persistent data

```
/var/atlassian/application-data/confluence 
```

Set the following environment variables to configure the server

```
CONFLUENCE_PROXY_NAME - the host name if using a reverse proxy
CONFLUENCE_PROXY_PORT - the port if using a reverse proxy
```
