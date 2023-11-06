use music_player;
# tạo index cột name
create unique index index_name
    on users(name);
# xóa chỉ mục
drop index index_name on users;
#  kiểm tra tốc độ thực thi sql
explain analyze select name from users where name = 'Dr. Bernita Zulauf';
