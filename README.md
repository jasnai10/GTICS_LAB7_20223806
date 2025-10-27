# Laboratorio 7: Contenerización y Despliegue con Docker

Este proyecto despliega una aplicación web simple de Spring Boot y Thymeleaf que se conecta a una base de datos MySQL. El despliegue se realiza tanto localmente como en un entorno de nube (AWS EC2), utilizando contenedores Docker.

## 1. Archivos de Configuración

El repositorio incluye el código fuente completo. Los archivos clave para el despliegue son:

### `Dockerfile`
(Ruta: `/Dockerfile`)
```dockerfile
# Imagen base de OpenJDK 17
FROM openjdk:26-ea-17-trixie
VOLUME /tmp
EXPOSE 8080
# Copia el .jar generado por Maven y lo renombra
ADD ./target/lab7-0.0.1-SNAPSHOT.jar lab7.jar
# Comando para ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "lab7.jar"]
```

### `lab7.sql`
(Ruta: `/lab7.sql`)
```sql
CREATE DATABASE IF NOT EXISTS trabajadores_db;
USE trabajadores_db;

CREATE TABLE IF NOT EXISTS trabajadores (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL,
  cargo VARCHAR(255) NOT NULL
);

INSERT INTO trabajadores (nombre, cargo) VALUES
('Juan Perez', 'Desarrollador'),
('Maria Garcia', 'Diseñadora'),
('Carlos Lopez', 'Gerente de Proyecto');
```

---

## 2. Ejercicio 2: Despliegue Local

Pasos para construir y ejecutar la aplicación de forma local.

### 2.1. Levantar Base de Datos MySQL Local

Se levanta el contenedor de MySQL, mapeando el puerto `3307` del host (ya que el 3306 estaba en uso) y montando el `lab7.sql` para inicializar la base de datos.

**Comando (Windows - PowerShell/CMD):**
```bash
# Reemplazar "C:\Ruta\Completa\..." con la ruta absoluta al archivo lab7.sql
docker run -d ^
-p 3307:3306 ^
--name mysql-local ^
-v "C:\Ruta\Completa\a\lab7.sql":/docker-entrypoint-initdb.d/init.sql ^
-e MYSQL_ROOT_PASSWORD=admin ^
mysql:8.0
```

**Salida de `docker ps`:**
<img width="1236" height="76" alt="Image" src="https://github.com/user-attachments/assets/5d38dec9-2461-455f-aef3-ccbdf5cf75aa" />

### 2.2. Construir Imagen de la App

Se construye la imagen de la aplicación web usando el `Dockerfile`.

**Comando:**
```bash
docker build -t miwebapp:local .
```

**Salida de la construcción:**
<img width="1346" height="507" alt="Image" src="https://github.com/user-attachments/assets/b613497b-238e-417e-af9d-a7beb739a168" />

### 2.3. Ejecutar Contenedor de la App Local

Se ejecuta la aplicación web, conectándola a la base de datos local a través de `host.docker.internal:3307`.

**Comando (Windows - PowerShell/CMD):**
```bash
docker run -d ^
-p 8080:8080 ^
--name webapp-local ^
-e SPRING_DATASOURCE_URL="jdbc:mysql://host.docker.internal:3307/trabajadores_db" ^
-e SPRING_DATASOURCE_USERNAME=root ^
-e SPRING_DATASOURCE_PASSWORD=admin ^
miwebapp:local
```

**Salida de `docker ps`:**
<img width="1352" height="134" alt="Image" src="https://github.com/user-attachments/assets/9c5c4fa0-c848-4be2-be76-feab24bc7411" />

### 2.4. Resultado Local

La aplicación se ejecuta exitosamente en `http://localhost:8080`.

**Captura:**
<img width="1365" height="716" alt="Image" src="https://github.com/user-attachments/assets/8829d314-9304-457a-a00a-ace53f0efd5e" />

---

## 3. Ejercicio 3: Despliegue Remoto (Nube)

Despliegue de la pila completa en una instancia de AWS EC2 (t3.micro, Amazon Linux 2023).

### 3.1. Instalación de Docker en la VM

Comandos ejecutados en la terminal SSH para preparar la instancia:

```bash
# Actualizar paquetes
sudo yum update -y
# Instalar Docker (para Amazon Linux 2023)
sudo yum install -y docker
# Iniciar y habilitar el servicio
sudo systemctl start docker
sudo systemctl enable docker
# Añadir usuario 'ec2-user' al grupo de docker
sudo usermod -a -G docker ec2-user
```
(Se requiere `exit` y reconexión por SSH para aplicar los permisos)

**Salida de `docker info`:**

<img width="1031" height="679" alt="Image" src="https://github.com/user-attachments/assets/0ad19456-26d3-4f64-8354-a638f5198715" />

### 3.2. Levantar Base de Datos MySQL Remota

Se crea el archivo `lab7.sql` en la VM usando `nano` y se ejecuta el contenedor.

**Comando (Terminal SSH):**
```bash
docker run -d --name mysql-remote -p 3306:3306 -v "$(pwd)/lab7.sql:/docker-entrypoint-initdb.d/init.sql" -e MYSQL_ROOT_PASSWORD=laboratorio7 mysql:8.0
```

**Salida de `docker ps` (en VM):**
<img width="1358" height="126" alt="Image" src="https://github.com/user-attachments/assets/b76d0cef-84b7-442c-81d0-c951e5d54929" />

### 3.3. Configuración del Grupo de Seguridad (Firewall AWS)

Se configuran las reglas de entrada del Grupo de Seguridad de AWS para permitir el tráfico en los puertos `22` (SSH), `3306` (MySQL) y `8080` (App Web).

**Captura:**
<img width="1306" height="381" alt="Image" src="https://github.com/user-attachments/assets/abcf9622-be37-411b-ad7e-603fb3682eb8" />

### 3.4. Despliegue de la App con IntelliJ

Se configura una nueva ejecución de tipo `Dockerfile` en IntelliJ para desplegar en el Docker daemon remoto vía SSH.

**Configuración de IntelliJ:**
<img width="797" height="688" alt="Image" src="https://github.com/user-attachments/assets/4a7535bd-840d-4034-a2e5-0a188f62195a" />


