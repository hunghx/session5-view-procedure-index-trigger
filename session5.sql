# Tạo mới 1 view lấy toàn bộ dữ liệu bảng sp và thêm tên loại sp
create view view_sanpham_loaisp
as
select s.*,l.tenloaisp
from sanpham s join loaisp l on s.maloaisp = l.maloaisp;


select * from view_sanpham_loaisp;
#  sửa view
alter view view_sanpham_loaisp
AS
select s.masp,s.tensp,s.donvitinh,l.tenloaisp
from sanpham s join loaisp l on s.maloaisp = l.maloaisp
where l.tenloaisp in ('Điện thoại di động','laptop')
    with check option ;
#  xóa view
drop view view_sanpham_loaisp;

# check option test
update view_sanpham_loaisp set tenloaisp = 'laptop' where masp = 'sp01';

# tao chỉ mục
# create unique index

    # insert into loaisp values ('LSP7','Loại só 7','');
# select  * from loaisp;
#
# insert into demo values
#                      (1,'hung'),
#                      (3,'anh'),
#                      (2,'duc'),
#                      (9,'nam'),
#                      (7,'khanh');
# select * from demo;


#  Tạo procedure
use quanlybanhang;

delimiter //
create procedure proc_insert_into_loaisp (id_insert varchar(4),ten_insert varchar(30),ghichu_insert varchar(100))
begin
insert into loaisp(maloaisp, tenloaisp, ghichu) values (id_insert,ten_insert,ghichu_insert);
end //
delimiter //
create procedure proc_insert_into_loaisp (id_insert varchar(4),ten_insert varchar(30),ghichu_insert varchar(100))
begin
insert into loaisp(maloaisp, tenloaisp, ghichu) values (id_insert,ten_insert,ghichu_insert);
end //
# cập nhật bản ghi
delimiter //
create procedure proc_update_loaisp (id_edit varchar(4),ten_edit varchar(30),ghichu_edit varchar(100))
begin
update loaisp set tenloaisp = IF(ten_edit is null,tenloaisp,ten_edit),
                  ghichu= if(ghichu_edit is null,ghichu,ghichu_edit)
where maloaisp = id_edit;
end //
# sửa procedure - xóa và tạo lại proc
# xóa procedure
drop procedure proc_insert_into_loaisp;
# gọi procedure
call proc_insert_into_loaisp('LS11','Loại sp số 11','không có');

#  tạo 4 procedure thực hiện các thao tác crud của bảng sanpham


select * from loaisp;
call proc_update_loaisp('LSP3','Phụ kiên',null);

#  tính tổng tiền px01
delimiter //
create procedure proc_getTotal_by_Sopx (IN sopx_select varchar(4),OUT total double)

begin
    declare total_amount double;
select sum(soluong*giaban) into total_amount from ctphieuxuat where sopx = sopx_select;
set total = total_amount;  -- gán giá trị
end //

call proc_getTotal_by_Sopx('PX01',@total1);
call proc_getTotal_by_Sopx('PX02',@total2);
call proc_getTotal_by_Sopx('PX03',@total3);
select (@total1+@total2+@total3)/3;

-- viết thủ tục trả  về số lượng nhân viên nam và nữ;
delimiter //
create procedure proc_getCountGender (OUT soNam varchar(100) ,OUT soNu int)
begin

select  @n:=sum(if(gioitinh = 1,1,0)) from nhanvien;
select sum(if(gioitinh = 0,1,0)) into soNu from nhanvien;
set soNam = @n;
end //


call proc_getCountGender(@nam,@nu);
select @nam,@nu,curdate();

#  tạo trigger
#  trước khi cập nhật , nếu để trống trường ghi chú thì chèn giá trị mặc định
create  trigger trigger_insert_loaisp
    after insert ON loaisp
    for each row
begin
    #         không có ghi chú thì để ghi chú mặc định
        if(new.ghichu is null or NEW.ghichu ='') then
       set New.ghichu = 'Giá trị mặc định';
end if;
end;

insert into loaisp values('LS23','Loại số 23','rgggttbtb');


#  cập nhật ghi chú nếu như giá trị mới bằng null thì vẫn giữ giá trị cũ

create trigger update_loaisp
    before update
    on loaisp
    for each row
begin
    if New.tenloaisp =''
            then
           set NEW.tenloaisp = OLD.tenloaisp;
end if;
end ;

#  không cho thêm mới khách hàng có ngày sinh lớn hơn ngày hiện tại
create trigger insert_khachhang
    before insert
    on khachhang
    for each row
begin
    if New.Ngaysinh >= curdate()
    then
        signal sqlstate '40000'
        set message_text = 'tào lao, chưa ra đời đòi làm khách hàng';
end if;
end ;

insert into khachhang values ('KH99','Nguyễn vĂn','HCM','2023-11-5','0494587643');

#  nếu nhập dữ liệu không hợp lệ, ném ra lỗi
update loaisp set tenloaisp = 'LSP00002' where maloaisp = 'LSP2';