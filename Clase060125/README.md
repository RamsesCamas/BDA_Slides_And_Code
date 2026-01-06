# 📚 BDA - Clase 1: Scripts de Inicio

Scripts automatizados para levantar los 3 proyectos de la práctica de Base de Datos Avanzada.

## 🚀 Inicio Rápido

### Levantar un proyecto específico:

```bash
# Opción 1: Usar el script principal
./start-all.sh 1              # VisualizacionSQLIntro
./start-all.sh 2              # EjemploDockerfile
./start-all.sh 3              # RepoOptimizado

# Opción 2: Ir directamente al directorio del proyecto
cd VisualizacionSQLIntro && ./start.sh
cd EjemploDockerfile && ./start.sh
cd RepoOptimizado && ./start.sh
```

## 📦 Proyectos

### 1️⃣ VisualizacionSQLIntro (Fase 1)

**SQL Lab Web con React + FastAPI + PostgreSQL**

```bash
./start-all.sh 1
# o
cd VisualizacionSQLIntro && ./start.sh
```

**Características:**
- ✅ Frontend React con wizard de 7 pasos
- ✅ Backend FastAPI con Basic Auth y rate limiting
- ✅ PostgreSQL con aislamiento por schema
- ✅ Cloudflare Tunnel para acceso público de alumnos

**Links generados:**
- 📱 Frontend (alumnos): `https://<random>.trycloudflare.com` (URL pública)
- 🌐 Frontend (local): http://localhost:3000
- ⚙️ Backend API: http://localhost:8000
- 📚 API Docs: http://localhost:8000/docs

**Credenciales:**
- Usuario: `student`
- Contraseña: `lab123`

---

### 2️⃣ EjemploDockerfile (Fase 2)

**Migración por Script con Python + PostgreSQL**

```bash
./start-all.sh 2
# o
cd EjemploDockerfile && ./start.sh
```

**Características:**
- ✅ Imagen PostgreSQL personalizada
- ✅ Script migrate.py que espera DB y ejecuta scripts
- ✅ Ejecuta schema → seed → queries en orden
- ✅ Muestra resultados en formato tabular

**Links generados:**
- 🗄️ PostgreSQL: `psql -h localhost -p 5432 -U postgres -d mydb`
- 🌐 Conexión desde apps: `host=localhost:5432, db=mydb, user=postgres`

**Ejecución manual:**
```bash
python3 migrate.py
```

---

### 3️⃣ RepoOptimizado (Fase 3)

**Repo del Profe con Makefile + Volumen (Sin Rebuild)**

```bash
./start-all.sh 3
# o
cd RepoOptimizado && ./start.sh
```

**Características:**
- ✅ Scripts SQL montados como volumen
- ✅ Migraciones sin rebuild (instantáneo)
- ✅ Makefile con comandos de automatización
- ✅ `make migrate` ejecuta scripts al instante

**Links generados:**
- 🗄️ PostgreSQL: `psql -h localhost -p 5432 -U postgres -d mydb`
- 🌐 Conexión desde apps: `host=localhost:5432, db=mydb, user=postgres`

**Comandos make:**
```bash
make help          # Ver todos los comandos
make up            # Iniciar servicios
make down          # Detener servicios
make migrate       # Ejecutar migraciones
make shell         # Abrir psql interactivo
make logs          # Ver logs
```

---

## 🛠️ Requisitos Previos

### Requeridos para todos los proyectos:
- ✅ Docker (v20.10+)
- ✅ Docker Compose (v2.0+)

### Requeridos por proyecto:

**VisualizacionSQLIntro (1):**
- `cloudflared` (opcional, para tunnel público)
  ```bash
  # macOS
  brew install cloudflared
  
  # Linux
  wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O cloudflared
  sudo install cloudflared /usr/local/bin
  ```

**EjemploDockerfile (2):**
- Python 3.8+
- pip

**RepoOptimizado (3):**
- `make` (makefile)
  ```bash
  # macOS
  xcode-select --install
  
  # Linux (Ubuntu/Debian)
  sudo apt-get install build-essential
  
  # Linux (CentOS/RHEL)
  sudo yum groupinstall 'Development Tools'
  ```

---

## 📋 Qué hacen los scripts

### Verificaciones:
1. ✅ Docker está corriendo
2. ✅ docker compose está disponible
3. ✅ Dependencias específicas del proyecto
4. ✅ Archivos necesarios existen

### Proceso:
1. 🧹 Limpieza de contenedores previos
2. 🔨 Construcción e inicio de servicios
3. ⏳ Espera a que los servicios estén listos
4. 📋 Muestra logs recientes
5. 🔄 Ejecuta migraciones (según el proyecto)
6. 📊 Muestra estado de servicios
7. 🎉 Muestra links de acceso

### Logs:
- Los scripts muestran logs detallados
- Al final, quedan en modo "follow" para ver logs en tiempo real
- Presiona `Ctrl+C` para detener todo

---

## 🎯 Flujo de Trabajo

### Para la clase con alumnos:

```bash
# 1. Levantar el proyecto 1 (VisualizacionSQLIntro)
./start-all.sh 1

# 2. Copiar la URL del Cloudflare Tunnel
#    Ejemplo: https://abc123.trycloudflare.com

# 3. Compartir la URL + credenciales con los alumnos
#    URL: https://abc123.trycloudflare.com
#    Usuario: student
#    Contraseña: lab123

# 4. Los alumnos navegan y completan el wizard de 7 pasos
#    Pueden ver queries, ejecutarlas, ver resultados, etc.

# 5. Al terminar la clase, presionar Ctrl+C para detener
```

### Para demostración individual:

```bash
# Levantar cualquier proyecto
./start-all.sh 1  # o 2 o 3

# Usar el proyecto según necesidad
# VisualizacionSQLIntro: Interfaz web completa
# EjemploDockerfile: Demo de migración por script
# RepoOptimizado: Demo de workflow sin rebuild
```

---

## 🚨 Solución de Problemas

### Docker no está corriendo:
```bash
# macOS: Abrir Docker Desktop

# Linux:
sudo systemctl start docker
sudo systemctl enable docker
```

### Error de permisos:
```bash
# Asegúrate que los scripts sean ejecutables
chmod +x start-all.sh
chmod +x VisualizacionSQLIntro/start.sh
chmod +x EjemploDockerfile/start.sh
chmod +x RepoOptimizado/start.sh
```

### Puerto en uso:
```bash
# Ver qué está usando el puerto 3000, 5432, o 8000
lsof -i :3000
lsof -i :5432
lsof -i :8000

# Matar el proceso
kill -9 <PID>
```

### Contenedores colgados:
```bash
# Ver todos los contenedores
docker ps -a

# Eliminar todos los contenedores
docker rm -f $(docker ps -aq)

# Eliminar todas las imágenes
docker rmi -f $(docker images -q)
```

### Cloudflare Tunnel falla:
- Es opcional, el proyecto funciona sin él
- Verifica que cloudflared esté instalado
- Si falla, usa la URL local (localhost:3000)

---

## 📊 Comparación de Proyectos

| Aspecto | Proyecto 1 | Proyecto 2 | Proyecto 3 |
|---------|------------|------------|------------|
| **Frontend** | React (7 pasos) | No | No |
| **Backend** | FastAPI (API) | No | No |
| **Migración** | Automática | Script Python | Make + psql |
| **Rebuild** | Sí | Sí | **No** ⚡ |
| **Cloudflare** | ✅ Sí | ❌ No | ❌ No |
| **Alumnos** | ✅ Perfecto | No | No |
| **Demo** | Sí | Sí | Sí |

---

## 🎓 Conceptos Clave

### Proyecto 1: VisualizacionSQLIntro
- **Aislamiento por schema**: Cada equipo tiene su propio schema
- **Basic Auth**: Autenticación HTTP simple para proteger el laboratorio
- **Rate Limiting**: Prevenir abusos (30 req/min)
- **Cloudflare Tunnel**: Exponer públicamente sin configuración de DNS
- **No SQL Libre**: Solo queries predefinidas (anti inyección SQL)

### Proyecto 2: EjemploDockerfile
- **Dockerfile Personalizado**: Crear imagen PostgreSQL custom
- **Script de Migración**: Esperar a DB, ejecutar scripts en orden
- **Manejo de Errores**: Retry logic, timeout, logging detallado
- **Resultados Tabulares**: Mostrar queries en formato legible

### Proyecto 3: RepoOptimizado
- **Volumen vs Build**: Scripts montados como volumen vs en la imagen
- **Sin Rebuild**: Modificar SQL y aplicar en segundos (1-2s vs 2-5min)
- **Makefile**: Automatización de comandos comunes
- **Workflow Eficiente**: Desarrollo iterativo rápido

---

## 🔗 Links de Documentación

- **Proyecto 1**: [VisualizacionSQLIntro/README.md](./VisualizacionSQLIntro/README.md)
- **Proyecto 2**: [EjemploDockerfile/README.md](./EjemploDockerfile/README.md)
- **Proyecto 3**: [RepoOptimizado/README.md](./RepoOptimizado/README.md)

---

## ✅ Checklist para la Clase

- [ ] Docker instalado y corriendo
- [ ] docker compose instalado
- [ ] cloudflared instalado (para proyecto 1)
- [ ] Scripts tienen permisos de ejecución
- [ ] Probar cada proyecto individualmente antes de la clase
- [ ] Tener credenciales a mano: `student` / `lab123`
- [ ] Verificar que los puertos 3000, 5432, 8000 estén libres
- [ ] Probar Cloudflare Tunnel antes de compartir URL

---

## 🚀 ¡Listo para la clase!

1. Levantar el proyecto 1: `./start-all.sh 1`
2. Copiar URL del Cloudflare Tunnel
3. Compartir URL + credenciales con alumnos
4. Los alumnos completan el wizard de 7 pasos
5. Al terminar, presionar Ctrl+C

**¡Buena suerte con la clase! 🎓**
