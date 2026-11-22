-- شغّل هذا الملف مرة واحدة في Supabase SQL Editor.
-- ينشئ مخزن صور الأخبار ويسمح بعرض الصور علنًا، بينما الرفع والحذف للمدير فقط.
insert into storage.buckets (id, name, public)
values ('news-images', 'news-images', true)
on conflict (id) do update set public = true;

drop policy if exists "Public can view news images" on storage.objects;
create policy "Public can view news images"
on storage.objects for select
to anon, authenticated
using (bucket_id = 'news-images');

drop policy if exists "Admin can upload news images" on storage.objects;
create policy "Admin can upload news images"
on storage.objects for insert
to authenticated
with check (
  bucket_id = 'news-images'
  and auth.uid() = '87460077-2933-4001-acaa-39a4a1577a05'::uuid
);

drop policy if exists "Admin can update news images" on storage.objects;
create policy "Admin can update news images"
on storage.objects for update
to authenticated
using (bucket_id = 'news-images' and auth.uid() = '87460077-2933-4001-acaa-39a4a1577a05'::uuid)
with check (bucket_id = 'news-images' and auth.uid() = '87460077-2933-4001-acaa-39a4a1577a05'::uuid);

drop policy if exists "Admin can delete news images" on storage.objects;
create policy "Admin can delete news images"
on storage.objects for delete
to authenticated
using (bucket_id = 'news-images' and auth.uid() = '87460077-2933-4001-acaa-39a4a1577a05'::uuid);

-- صلاحيات الوصول الأساسية لواجهة الموقع ولوحة الإدارة.
grant select on public.news to anon, authenticated;
grant insert, update, delete on public.news to authenticated;
