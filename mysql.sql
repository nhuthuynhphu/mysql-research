create database salemanagement;

use salemanagement;

create table customer
(
	id varchar(5) NOT NULL,
	fullName nvarchar(30) NOT NULL,
	address nvarchar(50),
	phone varchar(11),
	email varchar(30)
);

create table supply
(
	id varchar(5) NOT NULL,
	fullName nvarchar(30) NOT NULL,
	unit nvarchar(20),
	price float,
	quantity int
);

create table invoice
(
	id varchar(10) NOT NULL,
	createdAt date,
	customerId varchar(5) NOT NULL,
	total float
);

create table invoiceDetail
(
	invoiceId varchar(10) NOT NULL,
	supplyId varchar(5) NOT NULL,
	quantity int,
	promotion float,
	price float
);

-- add pk
alter table customer
add constraint pk_customer primary key (id);

alter table supply
add constraint pk_supply primary key (id);

alter table invoice
add constraint pk_invoice primary key (id,customerId);

alter table invoiceDetail
add constraint pk_invoiceDetail primary key (invoiceId,supplyId);

-- add fk
alter table invoiceDetail
add constraint fk_invoiceDetail_supplyId foreign key (supplyId) references supply (id);

alter table invoice
add constraint fk_invoice_customerId foreign key (customerId) references customer (id);

alter table invoiceDetail
add constraint fk_invoiceDetail_invoiceId foreign key (invoiceId) references invoice (id);

-- alter table HOADON
-- add constraint FK_HOADON_MAHD foreign key (MAHD) references CTHD (MAHD)

-- alter table customer
-- add constraint chk_customer_phone check ( phone <= 11 and phone >= 8 );
alter table supply
add constraint chk_supply_price check ( price > 0 );
alter table supply
add constraint chk_supply_quantity check ( quantity >= 0 );
-- alter table invoice
-- add constraint chk_invoice_createdAt check ( createdAt <= CURDATE() );
alter table invoiceDetail
add constraint chk_invoiceDetail_quantity check ( quantity > 0 );

SELECT tc.constraint_name, tc.table_name, tc.constraint_type, tc.enforced, cc.check_clause
FROM information_schema.TABLE_CONSTRAINTS tc
   LEFT JOIN information_schema.CHECK_CONSTRAINTS cc
   ON tc.CONSTRAINT_SCHEMA=cc.CONSTRAINT_SCHEMA
   AND tc.CONSTRAINT_NAME=cc.CONSTRAINT_NAME
WHERE
    tc.TABLE_SCHEMA='salemanagement'
    AND tc.CONSTRAINT_TYPE='CHECK';
    
insert into supply values ('VT01',N'Xi măng','Bao', 50000, 5000);
insert into supply values ('VT02',N'Cát',N'Khối', 45000, 50000);
insert into supply values ('VT03',N'Gạch ống',N'Viên', 120, 800000);
insert into supply values ('VT04',N'Gạch thẻ','Viên', 110, 800000);
insert into supply values ('VT05',N'Đá lớn',N'Khối', 25000, 100000);
insert into supply values ('VT06',N'Đá nhỏ',N'Khối', 33000, 100000);
insert into supply values ('VT07',N'Lam gió',N'Cái', 15000, 50000);

-- ALTER TABLE customer
-- MODIFY COLUMN phone varchar(11);
-- ALTER TABLE customer
-- drop check chk_customer_phone;

insert into customer values ('KH01',N'Nguyễn Thị Bé',N'Tân Bình', 38457895, 'bnt@yahoo.com');
insert into customer values ('KH02',N'Lê Hoàng Nam',N'Bình Chánh', 39878987, 'namlehoang@gmail.com');
insert into customer values ('KH03',N'Trần Thị Chiêu',N'Tân Bình', 38457895, NULL);
insert into customer values ('KH04',N'Mai Thị Quế Anh',N'Bình Chánh', NULL, NULL);
insert into customer values ('KH05',N'Lê Văn Sáng',N'Quận 10', NULL, 'sanglv@hcm.vnn.com');
insert into customer values ('KH06',N'Trần Hoàng',N'Tân Bình', 38457897, NULL);

insert into invoice values ('HD001', '2010-05-12', 'KH01', NULL);
insert into invoice values ('HD002', '2010-05-25', 'KH02', NULL);
insert into invoice values ('HD003', '2010-05-25', 'KH01', NULL);
insert into invoice values ('HD004', '2010-05-25', 'KH04', NULL);
insert into invoice values ('HD005', '2010-05-26', 'KH04', NULL);
insert into invoice values ('HD006', '2010-06-02', 'KH03', NULL);
insert into invoice values ('HD007', '2010-06-22', 'KH04', NULL);
insert into invoice values ('HD008', '2010-06-25', 'KH03', NULL);
insert into invoice values ('HD009', '2010-08-15', 'KH04', NULL);
insert into invoice values ('HD020', '2010-09-30', 'KH01', NULL);

UPDATE invoice
SET id = 'HD010'
WHERE invoice.id = 'HD020';

insert into invoiceDetail values ('HD001', 'VT01', 5, NULL, 52000);
insert into invoiceDetail values ('HD001', 'VT05', 10, NULL, 30000);
insert into invoiceDetail values ('HD002', 'VT03', 10000, NULL, 150);
insert into invoiceDetail values ('HD003', 'VT02', 20, NULL, 55000);
insert into invoiceDetail values ('HD004', 'VT03', 50000, NULL, 150);
insert into invoiceDetail values ('HD004', 'VT04', 20000, NULL, 120);
insert into invoiceDetail values ('HD005', 'VT05', 10, NULL, 30000);
insert into invoiceDetail values ('HD005', 'VT06', 15, NULL, 35000);
insert into invoiceDetail values ('HD005', 'VT07', 20, NULL, 17000);
insert into invoiceDetail values ('HD006', 'VT04', 10000, NULL, 120);
insert into invoiceDetail values ('HD007', 'VT04', 20000, NULL, 125);
insert into invoiceDetail values ('HD008', 'VT01', 100, NULL, 55000);
insert into invoiceDetail values ('HD008', 'VT02', 20, NULL, 47000);
insert into invoiceDetail values ('HD009', 'VT02', 25, NULL, 48000);
insert into invoiceDetail values ('HD010', 'VT01', 25, NULL, 57000);

delete from invoiceDetail where invoiceId = 'HD010';

select * from customer;
select * from invoice;

select id, fullName, phone, address, email
from customer
where not (phone is null or email is null) and address like N'%Tân Bình';

select *
from invoice
where createdAt between '2010-05-25' and '2010-06-25'
and customerId in ('KH02', 'KH03');

select c.fullName as customerName, i.id as invoiceId
from invoice i
inner join customer c
on i.customerId = c.id;

select c.fullName as customerName, i.id as invoiceId
from invoice i
inner join customer c
on i.customerId = c.id
ORDER BY i.id desc;

select c.fullName as customerName, count(i.id) as total
from invoice i
inner join customer c
on i.customerId = c.id
group by c.id
ORDER BY total desc;

create view v1
as
	select c.id, fullname
	from customer c left join invoice i
	on c.id = i.customerId and month(i.createdAt) = 6 and year(i.createdAt) = 2010
    where i.id is null;
    
select * from v1;

DELIMITER $
create procedure VIP_CUSTOMER()
begin
	select c.id, fullName, address, phone, email, totalPrice
	from customer c
    join (select i.customerId, sum(price * quantity) as totalPrice
		  from invoice i
          join invoiceDetail d
		  on i.id = d.invoiceId
		  group by i.customerId) A
	on c.id = A.customerId and totalPrice > 10000000;
end $
DELIMITER ;

call VIP_CUSTOMER;

DELIMITER $
create procedure LESS_PROFIT_SUPPLY(in selectTop int, out supply varchar(30))
begin
    set supply = (
		select fullName
		from (	select fullName, sum(PROFIT) as PROFITS
				from (
					select s.id as SUPPLYID, s.fullName, (d.quantity*d.price)-(d.quantity*s.price) as PROFIT
					from supply s
					join invoiceDetail d
					on d.supplyId = s.id
					group by s.id, d.quantity, d.price, s.price
				) A
				group by SUPPLYID
				order by PROFITS asc
				limit selectTop
        ) B
	);
end $
DELIMITER ;

call LESS_PROFIT_SUPPLY(1, @supply);
SELECT @supply;

DELIMITER $
create function calculateProfit(supplyId varchar(5))
returns int
DETERMINISTIC
begin
	declare profit float;
	if( supplyId is null ) then
		set profit = (	select sum( d.quantity * ( d.price - s.price ) )
						from invoiceDetail d, supply s
						where s.id = d.supplyId);
	else
		set profit = (	select sum( d.quantity * ( d.price - s.price ) )
						from invoiceDetail d, supply s
						where s.id = d.supplyId and d.supplyId = supplyId
						group by d.supplyId);
	end if;
	if( profit is null ) then
		set profit = 0;
	end if;
	return profit;
end $
DELIMITER ;

select calculateProfit('VT02');
select calculateProfit(null);

drop trigger t1;
DELIMITER $
create trigger t1 before insert on invoiceDetail
for each row
begin
	if((select ( new.price / s.price ) * 100
		from supply s
		where s.id = new.supplyId
		group by s.id, new.price, s.price ) < 50
	) then
			SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Not allowed to sell at a loss of more than 50%';
	end if;
end $
DELIMITER ;

insert into invoiceDetail values ('HD005','VT03',2,null,50);
insert into invoiceDetail values ('HD005','VT03',2,null,70);