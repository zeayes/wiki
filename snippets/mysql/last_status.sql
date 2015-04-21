
select * from (select * from user_video_0 order by id desc) as tbl group by tbl.user_id;

select tbl.* from user_video_0 as tbl where id = (select max(id) from user_video_0 where tbl.user_id = user_id);

select tbl.* from user_video_0 as tbl where not exists (select * from user_video_0 where user_id = tbl.user_id and id > tbl.id);

select tbl.* from user_video_0 as tbl where exists (select count(*) from user_video_0 where user_id = tbl.user_id and id > tbl.id having count(*) = 0);
