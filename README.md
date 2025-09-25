# HabitGlass 🔥

Una aplicación moderna de seguimiento de hábitos construida con Flutter, Supabase, GetX y Clean Architecture. Diseñada con un impresionante efecto glassmorphism.

## 🌟 Características

- ✅ Seguimiento de hábitos diario
- 📊 Progreso semanal visual
- 🔥 Sistema de rachas
- 🎨 Interfaz glassmorphism moderna
- ⚡ Actualizaciones en tiempo real
- 🔐 Autenticación con Supabase
- 📱 Diseño responsivo

## 🏗️ Arquitectura

La aplicación sigue los principios de **Clean Architecture**:

```
lib/
├── core/                   # Configuración y constantes
│   ├── config/            # Configuración de Supabase
│   ├── constants/         # Colores y estilos de texto
│   └── theme/             # Tema de la aplicación
├── domain/                # Lógica de negocio
│   ├── entities/          # Entidades del dominio
│   ├── repositories/      # Contratos de repositorios
│   └── services/          # Servicios del dominio
├── data/                  # Capa de datos
│   ├── models/           # Modelos de datos
│   └── repositories/     # Implementación de repositorios
└── presentation/         # Capa de presentación
    ├── controllers/      # Controladores GetX
    ├── pages/           # Páginas de la aplicación
    └── widgets/         # Widgets reutilizables
```

## 🚀 Configuración

### 1. Requisitos previos

- Flutter SDK (>=3.19)
- Cuenta de Supabase
- Editor de código (VS Code, Android Studio, etc.)

### 2. Configurar Supabase

1. Crea un nuevo proyecto en [Supabase](https://supabase.com)
2. Ve a **SQL Editor** y ejecuta el siguiente script:

```sql
-- Crear tabla de hábitos
create table public.habits (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  color text,
  created_at timestamptz not null default now()
);

-- Crear tabla de logs de hábitos
create table public.habit_logs (
  id bigserial primary key,
  habit_id uuid not null references public.habits(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  date date not null,
  done boolean not null default true,
  created_at timestamptz not null default now(),
  unique (habit_id, date)
);

-- Habilitar Row Level Security
alter table public.habits enable row level security;
alter table public.habit_logs enable row level security;

-- Políticas RLS para hábitos
create policy "crud own habits"
on public.habits for all
using  (auth.uid() = user_id)
with check (auth.uid() = user_id);

-- Políticas RLS para logs
create policy "crud own habit logs"
on public.habit_logs for all
using  (auth.uid() = user_id)
with check (auth.uid() = user_id);

-- Índices para mejor rendimiento
create index if not exists habits_user_id_idx on public.habits(user_id);
create index if not exists habit_logs_habit_date_idx on public.habit_logs(habit_id, date);
```

### 3. Configurar variables de entorno

1. Copia el archivo de ejemplo:
```bash
cp .env.example .env
```

2. Edita `.env` con tus credenciales de Supabase:
```env
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_ANON_KEY=tu-clave-anonima
```

3. Obtén estas variables desde:
   - Supabase Dashboard → Settings → API
   - **Project URL** → `SUPABASE_URL`
   - **anon/public key** → `SUPABASE_ANON_KEY`

### 4. Instalar dependencias

```bash
flutter pub get
```

### 5. Ejecutar la aplicación

```bash
flutter run
```

## 🎨 Características técnicas

### Estado y navegación
- **GetX** para manejo de estado reactivo
- **GetX** para navegación y gestión de dependencias

### Base de datos
- **Supabase** con PostgreSQL
- **Row Level Security** para seguridad
- **Subscripciones en tiempo real** para actualizaciones automáticas

### Arquitectura de UI
- **Clean Architecture** con separación clara de responsabilidades
- **Repository Pattern** para abstracción de datos
- **Dependency Injection** con GetX

### Estilo visual
- **Glassmorphism** con efectos de blur y transparencia
- **Gradientes** para fondos atractivos
- **Animaciones fluidas** para mejor UX
- **Diseño responsivo** para múltiples tamaños de pantalla

## 📊 Funcionalidades principales

### Gestión de hábitos
- Crear hábitos con nombre y color personalizable
- Eliminar hábitos con confirmación
- Vista de lista con información detallada

### Seguimiento de progreso
- Marcar/desmarcar hábitos por día
- Cálculo automático de rachas
- Progreso semanal visual (0-100%)
- Indicador de estado "hecho hoy"

### Métricas y análisis
- **Racha actual**: Días consecutivos completados
- **Progreso semanal**: Porcentaje de los últimos 7 días
- **Estado diario**: Indicador visual del progreso actual

## 🔧 Criterios de aceptación

✅ **Creación de hábitos**: Puedo crear un hábito y aparece en la lista  
✅ **Marcado diario**: Puedo marcar/desmarcar "Hoy" y la UI cambia inmediatamente  
✅ **Métricas**: Veo progreso semanal (0..1) y racha correcta  
✅ **Eliminación**: Al borrar un hábito, se elimina y la lista se actualiza  
✅ **Tiempo real**: Cambios se reflejan en tiempo real (opcional)  
✅ **Diseño**: Interfaz con glassmorphism y degradado de fondo  

## 🛠️ Tecnologías utilizadas

- **Flutter** (>=3.19) - Framework de UI
- **Dart** - Lenguaje de programación
- **Supabase** - Backend como servicio
- **GetX** - Estado y navegación
- **PostgreSQL** - Base de datos
- **Row Level Security** - Seguridad de datos

## 📱 Ideas para extensiones

### Funcionalidades adicionales
- 🎉 Animación de confeti para rachas importantes (7, 14, 30 días)
- 🏷️ Filtros por color/categoría
- 📊 Gráficos de progreso mensual/anual
- 📅 Vista de calendario
- 🏆 Sistema de logros y badges
- 📈 Estadísticas detalladas
- 💾 Exportación de datos (CSV)
- 🔔 Notificaciones de recordatorio
- 👥 Compartir progreso
- 🌙 Modo oscuro/claro

### Mejoras técnicas
- 🔄 Sincronización offline
- 🌐 Internacionalización (i18n)
- 🧪 Tests unitarios y de integración
- 📊 Analytics y métricas de uso
- 🔒 Autenticación con email/social
- 📱 Versión web (Flutter Web)

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu característica (`git checkout -b feature/nueva-caracteristica`)
3. Commit tus cambios (`git commit -m 'Agregar nueva característica'`)
4. Push a la rama (`git push origin feature/nueva-caracteristica`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto es parte de un taller educativo sobre Flutter y Supabase.

---

**HabitGlass** - Construye tu mejor versión, un hábito a la vez. ✨