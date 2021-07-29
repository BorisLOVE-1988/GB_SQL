-- Use kashirov_vk

-- ���������������� �������, ������� ����������� �� �������, ���������� ��������� ������������� �/��� ��������� (JOIN ���� �� ���������).

-- 1 ����� ����� ��������� ������������. 
-- �� ���� ������ ����� ������������ ������� ��������, ������� ������ ���� ������� � ����� �������������.

-- ������� �:
select count(id) my_count, 
	   from_user_id, 
	   to_user_id,
	   (select status 
	   		from friend_requests
 			where status = 'approved' 
 			and (target_user_id = 736 or initiator_user_id = 736) 
 			limit 1) status
from messages
where to_user_id = 736
group by from_user_id
order by my_count desc 
limit 1; -- ��������� ����� ���������� desc ������ ����������

-- ����� � ����� select MAX(my_count) from '��� ������ ����'
select max(my_count) max_msg, from_user_id, to_user_id, 'status'
from (select count(id) my_count, 
			 from_user_id, 
			 to_user_id,
			 (select status 
			 		 from friend_requests
					 where status = 'approved' 
					 and (target_user_id = 736 or initiator_user_id = 736) 
					 limit 1)
	  from messages
	  where to_user_id = 736
	  group by from_user_id
	  order by my_count desc) my_tbl_3;

-- 2 ���������� ����� ���������� ������, ������� �������� 10 ����� ������� �������������.
select sum(my_like) my_top_like
from (select count(user_id) my_like, 
			user_id
		from likes
		where user_id in (select user_id from profiles order by birthday desc)
		group by user_id
		order by user_id
		limit 10) my_likes;

-- ������� 2:
select count(user_id) my_like
from likes
where user_id in (select user_id from profiles order by birthday desc);

-- 3 ���������� ��� ������ �������� ������ (�����) - ������� ��� �������?

select count(id) my_likes, 
	(select (case (gender) when 'm' then 'male' 
			 end) 
	 from profiles where gender = 'm' limit 1) gender,
	(select count(user_id) from profiles where gender = 'm' limit 1) num_users
from likes
where user_id in (select user_id from profiles where gender = 'm')
union 
select count(id) my_likes, 
	(select (case (gender) when 'f' then 'female' 
			 end) 
	 from profiles where gender = 'f' limit 1),
	(select count(user_id) from profiles where gender = 'f' limit 1)
from likes
where user_id in (select user_id from profiles where gender = 'f');


-- 4 ����� 10 �������������, ������� ��������� ���������� ���������� � ������������� ���������� ����.

select sum(num) user_activity, user_id 
from (
		select count(id) num, from_user_id as user_id
		from messages
		group by user_id

		union all

		select count(id) num, user_id as user_id
		from media
		group by user_id

		union all

		select count(id) num, user_id as user_id
		from likes
		group by user_id
	) my_activity_tbl
group by user_id
order by user_activity
limit 10;

	

