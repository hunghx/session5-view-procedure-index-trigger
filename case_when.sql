use quanlydiemsv;

-- đánh giá học lực của sinh viên nào đó
delimiter //
create procedure danh_gia_hoc_luc(masinhvien char(3), OUT kq varchar(20))
begin
select @dtb := avg(Diem) from ketqua where MaSV = masinhvien group by MaSV;
set kq = case
        when @dtb < 5 then  'yếu'
        when @dtb < 6.5 then 'Trung binh'
        when @dtb < 8 then  'Khá'
        when @dtb < 9 then  'giỏi'
        else  'xuất sắc'
end ;
end//

call danh_gia_hoc_luc('B09',@dtb);
select 'B09', @dtb;

