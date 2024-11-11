# Monitoreo de VPN con Prometheus

Se utilizara el software de Prometheus que nos permitira monitorear una VPN (OpenVPN) de tal forma que podamos obtener metricas que se almacenan en el sistema de almacenamiento interno de Prometheus. El file system se encuentra organizado de tal forma que consiste de una base de datos de series de tiempo que contiene informacion (opcionalmente) en forma de pares de "llave-valor".

Objetivos del proyecto
- Utilizar prometheus como plataforma de monitoreo
- Agregar autenticacion basica para iniciar sesion en la web UI
	- Se requiere usar el algoritmo bcrypt para el 'hashing' de las contrasenas
- Monitorear un servidor VPN
- Visualizar metricas del servidor VPN en prometheus
- Visualizar metricas del servidor VPN de forma grafica con Grafana
- Visualizar los logs en prometheus cuando la VPN tenga actividad

## Tecnologias a ser usadas

- Digital Ocean: cloud provider para colocar los VPS que contengan *prometheus* y la *vpn* respectivamente.
	- Para ello, es importante crear una cuenta de Digital Ocean
- Terraform: automatizacion de infraestructura
	- Es importante instalar la CLI tomando como referencia la documentacion oficial: https://developer.hashicorp.com/terraform/tutorials/docker-get-started/install-cli
- Ansible: automatizacion de los host (prometheus y la vpn) para evitar instalar los programas comando a comando
- Docker: contenedores que se encuentran aislados del SO pero pueden interactuar con el host por medio del *docker daemon*
	- En los contenedores se instalara el software necesario para poder prometheus en operacion
- OpenVPN: el software de VPN elegido para implementar una conexion segura entre dos hosts

https://developer.hashicorp.com/terraform/tutorials/docker-get-started/install-cli

## Generacion de un par de llaves ssh para Digital Ocean

```sh
ssh-keygen -t ed25519 -C "dodskorpen@proton.me"
```

Una vez generado el par de llaves, se utilizaran en **terraform** para poder acceder a los **VPS** de monitoreo y vpn respectivamente.

## Instalacion de dependencias (en el host administrador)

La instalacion de dependencias y las respectivas instrucciones se encuentran en las paginas oficiales:

- Docker:
- Terraform: 
- Ansible

### Prometheus y Grafana

**Prometheus**

En el archivo *docker-compose.yml* se encuentra definida la arquitectura de la aplicacion de prometheus junto con grafana para poder 'ejecutar' o 'destruir' la infraestructura de una forma mas sencilla al ser declarativa.

Las imagenes de docker de prometheus y de grafana se obtienen del **dockerhub** que es un repositorio donde se encuetran disintos tipos de software en forma de imagenes. De esta forma se evita tener que intalar localmente los programas en la PC y asi poder instalar o desinstalar el software con mayor facilidad.

Por defecto se puede acceder a la web UI de prometheus sin usar un usario y password. Para ello fue creado el archivo *web.yml* donde se colocan los usuarios con sus respectivas passwords que deben ser el resultado de aplicar la funcion de hash *bcrypt*.

1. Configurar las carpetas de Prometheus (en el host local)
```sh
mkdir -p prometheus-data
# Cambiar el ownership del directorio al usuario actual
chowm "$USER":"$USER" prometheus-data
# Cambiar los permisos (recursivamente) del directorio a RWX (read, write, execute)
chmod -R 777 prometheus-data
```

2. Configurar las carpetas de Grafana (en el host local)

**Grafana**

```sh
mkdir -p grafana-data/plugin
chown "$USER":"$USER" grafana-data
chmod -R 777 grafana-data
```      

3. Colocar arriba la infraestructura

```sh
# -d: detach from the process(run in the background)
sudo docker compose up -d
```

## Terraform

Inicializar los archivos de terraform
```
terraform init
```

Construir la infraestructura de terraform (de Digital Ocean)
```
terraform apply -var-file .tfvars
```

Destruir la infraestructura de terraform (de Digital Ocean)
```
terraform destroy
```

### Ansible

Configurar los hosts para instalar docker en cada uno de los *vps*:
```
ansible-playbook playbooks/setup_vps.yml
```


### OpenVPN