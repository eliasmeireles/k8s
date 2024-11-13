# Getting test application

***Requires***

- [helm](https://helm.sh/docs/intro/install/)

***Note:*** Set up the host hosts with

```shell
sudo echo '127.0.0.1 k8s.local.service' >> /etc/hosts
```

```shell 
make app-up
```

***port forward to access the application***

- none sudo user

```shell
kubectl port-forward svc/internal-server 8080:80
```

- sudo user

```shell
sudo kubectl port-forward svc/internal-server 80:80
```

> If everything is ok, you can access the application
> at http://k8s.local.service/api/file-server/v1/swagger-ui/index.html
