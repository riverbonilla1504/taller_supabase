-- HabitGlass - Supabase Database Setup
-- Copy and paste this script into your Supabase SQL Editor

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
