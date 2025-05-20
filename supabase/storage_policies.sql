-- Create the exercise-categories bucket
insert into storage.buckets (id, name, public)
values ('exercise-categories', 'exercise-categories', true)
on conflict (id) do nothing;

-- Create the exercises bucket
insert into storage.buckets (id, name, public)
values ('exercises', 'exercises', true)
on conflict (id) do nothing;

-- Policies for exercise-categories bucket
create policy "Public Access - Categories"
on storage.objects for select
using ( bucket_id = 'exercise-categories' );

create policy "Admin Upload - Categories"
on storage.objects for insert
to authenticated
with check ( bucket_id = 'exercise-categories' );

create policy "Admin Update - Categories"
on storage.objects for update
to authenticated
using ( bucket_id = 'exercise-categories' );

create policy "Admin Delete - Categories"
on storage.objects for delete
to authenticated
using ( bucket_id = 'exercise-categories' );

-- Policies for exercises bucket
create policy "Public Access - Exercises"
on storage.objects for select
using ( bucket_id = 'exercises' );

create policy "Admin Upload - Exercises"
on storage.objects for insert
to authenticated
with check ( bucket_id = 'exercises' );

create policy "Admin Update - Exercises"
on storage.objects for update
to authenticated
using ( bucket_id = 'exercises' );

create policy "Admin Delete - Exercises"
on storage.objects for delete
to authenticated
using ( bucket_id = 'exercises' ); 