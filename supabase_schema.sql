-- ==============================================================================
-- BROLY - ESQUEMA DE BASE DE DATOS POSTGRESQL PARA SUPABASE
-- ==============================================================================
-- Instrucciones:
-- 1. Ve a tu panel en https://supabase.com/dashboard/project/_/sql/new
-- 2. Pega todo este contenido y presiona "RUN".
-- ==============================================================================

-- 1. TABLA PÚBLICA DE PERFILES (Vinculada 1 a 1 con auth.users de Supabase)
create table if not exists public.profiles (
  id uuid references auth.users on delete cascade primary key,
  name text,
  avatar_url text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Habilitar Row Level Security (RLS)
alter table public.profiles enable row level security;

-- Políticas de seguridad para perfiles
create policy "Los usuarios pueden ver su propio perfil" 
  on public.profiles for select 
  using (auth.uid() = id);

create policy "Los usuarios pueden actualizar su propio perfil" 
  on public.profiles for update 
  using (auth.uid() = id);

create policy "Permitir inserción de perfil" 
  on public.profiles for insert 
  with check (auth.uid() = id);


-- 2. TRIGGER AUTOMÁTICO: Crear perfil al registrarse nuevo usuario en Supabase Auth
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, name)
  values (
    new.id, 
    coalesce(new.raw_user_meta_data->>'name', split_part(new.email, '@', 1))
  )
  on conflict (id) do nothing;
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();


-- 3. TABLA DE OFERTAS FAVORITAS POR USUARIO (Persistencia en la nube)
create table if not exists public.user_favorites (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  deal_id text not null,
  title text not null,
  sale_price text,
  normal_price text,
  savings text,
  thumb text,
  steam_rating_percent text,
  deal_rating text,
  store_id text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(user_id, deal_id)
);

-- Habilitar Row Level Security (RLS)
alter table public.user_favorites enable row level security;

-- Políticas de seguridad para favoritos (Cada usuario solo ve y modifica lo suyo)
create policy "El usuario solo puede ver sus propios favoritos" 
  on public.user_favorites for select 
  using (auth.uid() = user_id);

create policy "El usuario solo puede insertar sus propios favoritos" 
  on public.user_favorites for insert 
  with check (auth.uid() = user_id);

create policy "El usuario solo puede borrar sus propios favoritos" 
  on public.user_favorites for delete 
  using (auth.uid() = user_id);
