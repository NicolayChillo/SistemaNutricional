# Nutricional - Panel de Administración Web

Panel web de administración completo para la aplicación móvil Nutricional. Gestiona usuarios, productos, recetas y calendario de comidas desde una interfaz web moderna y responsiva.

## 🚀 Características

### 🔐 Autenticación
- Login seguro con Firebase Authentication
- Rutas protegidas
- Sesión persistente

### 👥 Gestión de Usuarios
- Listado de todos los usuarios registrados
- Visualización del historial de accesos por usuario
- Información detallada de cada usuario

- 

### 🍎 CRUD Completo de Productos
- ✅ Crear productos con código de barras
- ✅ Editar información de productos
- ✅ Eliminar productos
- ✅ Ver detalles completos
- 📊 Información nutricional detallada (calorías, proteínas, carbohidratos, grasas, fibra, azúcar, sodio)
- 🖼️ Soporte para imágenes

### 🍳 CRUD Completo de Recetas
- ✅ Crear recetas con título, descripción y categoría
- ✅ Editar recetas existentes
- ✅ Eliminar recetas
- ✅ Ver recetas completas
- 📝 Gestión de ingredientes (agregar/eliminar múltiples)
- 📋 Gestión de pasos de preparación
- ⏱️ Tiempo de preparación y porciones
- 🖼️ Imágenes de recetas

### 📅 CRUD Completo de Calendario
- ✅ Crear entradas de calendario
- ✅ Editar planificaciones
- ✅ Eliminar entradas
- 👤 Asignar recetas a usuarios
- 🍽️ Tipos de comida (Desayuno, Almuerzo, Cena, Merienda)
- 📆 Programación de fecha y hora
- 🔔 Estado de notificaciones

### 📊 Dashboard
- Estadísticas generales del sistema
- Contadores de usuarios, productos, recetas y entradas de calendario
- Tarjetas informativas con iconos

## 🛠️ Tecnologías

- **React 18** - Biblioteca de interfaz de usuario
- **Vite** - Build tool y dev server ultrarrápido
- **Firebase 10**
  - Firestore - Base de datos NoSQL
  - Authentication - Autenticación de usuarios
  - Storage - Almacenamiento de archivos
- **Material-UI (MUI) 5** - Componentes de UI
- **React Router 6** - Enrutamiento
- **React Hook Form** - Manejo de formularios
- **date-fns** - Manipulación de fechas

## 📦 Instalación

1. **Clonar o navegar al directorio del proyecto**
   ```bash
   cd admin-web
   ```

2. **Instalar dependencias**
   ```bash
   npm install
   ```

3. **Configuración de Firebase**
   
   Las credenciales de Firebase ya están configuradas en `src/config/firebase.js`. Si necesitas cambiarlas, edita ese archivo con tus propias credenciales.

## 🚀 Desarrollo

Para iniciar el servidor de desarrollo:

```bash
npm run dev
```

La aplicación se abrirá automáticamente en [http://localhost:3000](http://localhost:3000)

## 🏗️ Producción

Para generar la versión de producción:

```bash
npm run build
```

Para previsualizar la versión de producción:

```bash
npm run preview
```

## 📝 Uso

### Inicio de Sesión

1. Accede a `/login`
2. Ingresa con una cuenta de administrador de Firebase
3. El sistema te redirigirá al dashboard

### Navegación

El menú lateral incluye:
- **Dashboard** - Vista general con estadísticas
- **Usuarios** - Gestión de usuarios y accesos
- **Productos** - CRUD de productos
- **Recetas** - CRUD de recetas
- **Calendario** - CRUD de planificación de comidas

### Operaciones CRUD

#### Productos
- **Crear**: Click en "Nuevo Producto" → Completa el formulario → Guardar
- **Editar**: Click en el ícono de lápiz → Modifica los campos → Actualizar
- **Ver**: Click en el ícono de ojo → Ver detalles completos
- **Eliminar**: Click en el ícono de basura → Confirmar eliminación

#### Recetas
- **Crear**: Click en "Nueva Receta" → Completa título, descripción, etc.
- Agrega ingredientes con el botón "Agregar"
- Agrega pasos de preparación con el botón "Agregar"
- **Editar**: Modifica cualquier campo incluyendo ingredientes y pasos
- **Ver**: Visualiza la receta completa con formato
- **Eliminar**: Elimina la receta del sistema

#### Calendario
- **Crear**: Click en "Nueva Entrada" → Selecciona usuario, receta, fecha y tipo de comida
- **Editar**: Modifica la programación de cualquier entrada
- **Eliminar**: Elimina entradas del calendario

## 🗂️ Estructura del Proyecto

```
admin-web/
├── src/
│   ├── config/
│   │   └── firebase.js          # Configuración de Firebase
│   ├── contexts/
│   │   └── AuthContext.jsx      # Contexto de autenticación
│   ├── services/
│   │   ├── authService.js       # Servicios de autenticación
│   │   └── firestoreService.js  # Servicios de Firestore (CRUD)
│   ├── components/
│   │   ├── MainLayout.jsx       # Layout principal con navegación
│   │   └── ProtectedRoute.jsx   # Componente de rutas protegidas
│   ├── pages/
│   │   ├── LoginPage.jsx        # Página de login
│   │   ├── DashboardPage.jsx    # Dashboard principal
│   │   ├── UsersPage.jsx        # Gestión de usuarios
│   │   ├── ProductsPage.jsx     # CRUD de productos
│   │   ├── RecipesPage.jsx      # CRUD de recetas
│   │   └── CalendarPage.jsx     # CRUD de calendario
│   ├── App.jsx                  # Componente principal con rutas
│   ├── main.jsx                 # Punto de entrada
│   └── index.css                # Estilos globales
├── index.html
├── package.json
├── vite.config.js
└── README.md
```

## 🔥 Conexión a Firebase

El proyecto está configurado para conectarse a la base de datos Firebase de la aplicación móvil Nutricional:

- **Project ID**: nutricional-76dd0
- **Collections**: `users`, `products`, `recipes`, `calendar_entries`

## 📱 Compatibilidad

- ✅ Desktop (Chrome, Firefox, Safari, Edge)
- ✅ Tablet
- ✅ Mobile responsive

## 🔒 Seguridad

- Todas las rutas están protegidas por autenticación
- Solo usuarios autenticados pueden acceder al panel
- Sesión persistente con Firebase Auth

## 🆘 Solución de Problemas

### Error al instalar dependencias
```bash
rm -rf node_modules package-lock.json
npm install
```

### Error de Firebase
Verifica que las credenciales en `src/config/firebase.js` sean correctas

### Error de permisos en Firestore
Asegúrate de que las reglas de Firestore permitan lectura/escritura para usuarios autenticados

## 📄 Licencia

Este proyecto es parte de la aplicación Nutricional.

## 👨‍💻 Desarrollo

Desarrollado con ❤️ usando React + Firebase + Material-UI
