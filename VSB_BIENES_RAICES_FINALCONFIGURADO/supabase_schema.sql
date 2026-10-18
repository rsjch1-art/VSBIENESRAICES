-- Ejecuta esto en Supabase > SQL Editor.
create table if not exists public.admin_users(user_id uuid primary key references auth.users(id) on delete cascade);
create table if not exists public.propiedades(id text primary key, orden integer not null default 0, data jsonb not null);
alter table public.admin_users enable row level security;
alter table public.propiedades enable row level security;
create policy "admin lee su permiso" on public.admin_users for select to authenticated using (user_id = (select auth.uid()));
create policy "catalogo publico disponible" on public.propiedades for select to anon, authenticated using (data->>'estado' = 'disponible' or exists(select 1 from public.admin_users where user_id = (select auth.uid())));
create policy "admin inserta" on public.propiedades for insert to authenticated with check (exists(select 1 from public.admin_users where user_id=(select auth.uid())));
create policy "admin actualiza" on public.propiedades for update to authenticated using (exists(select 1 from public.admin_users where user_id=(select auth.uid()))) with check (exists(select 1 from public.admin_users where user_id=(select auth.uid())));
create policy "admin borra" on public.propiedades for delete to authenticated using (exists(select 1 from public.admin_users where user_id=(select auth.uid())));
insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types) values ('propiedades','propiedades',true,47185920,array['image/jpeg','image/png','image/webp','video/mp4','video/webm']) on conflict(id) do nothing;
create policy "admin sube multimedia" on storage.objects for insert to authenticated with check (bucket_id='propiedades' and exists(select 1 from public.admin_users where user_id=(select auth.uid())));
create policy "admin elimina multimedia" on storage.objects for delete to authenticated using (bucket_id='propiedades' and exists(select 1 from public.admin_users where user_id=(select auth.uid())));
-- Después de crear el usuario email/contraseña en Supabase Authentication > Users,
-- reemplaza ESTE_UUID por su identificador real y ejecuta:
-- insert into public.admin_users(user_id) values ('ESTE_UUID');
