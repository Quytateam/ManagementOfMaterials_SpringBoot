CREATE TABLE users (
  id NUMBER(19,0) GENERATED ALWAYS AS IDENTITY NOT NULL,
  username VARCHAR2(255) NOT NULL,
  email VARCHAR2(255) NOT NULL,
  firstname VARCHAR2(255),
  lastname VARCHAR2(255),
  password VARCHAR2(255) NOT NULL,
  town VARCHAR2(255), 
  country VARCHAR2(255),
  state VARCHAR2(255),
  address VARCHAR2(255),
  phone VARCHAR2(255),
  verification_code VARCHAR2(64),
  enable NUMBER(1, 0),
  CONSTRAINT users_pk PRIMARY KEY (id),
    CONSTRAINT users_username_uk UNIQUE (username),
    CONSTRAINT users_email_uk UNIQUE (email)
);

CREATE TABLE role (
  id NUMBER(19,0) NOT NULL,
  name VARCHAR2(20),
  CONSTRAINT role_pk PRIMARY KEY (id)
);

INSERT INTO role VALUES (1, 'ROLE_USER');
INSERT INTO role VALUES (2, 'ROLE_MODERATOR');
INSERT INTO role VALUES (3, 'ROLE_ADMIN');

CREATE TABLE user_roles (
    user_id NUMBER(19, 0) NOT NULL,
    role_id NUMBER(19, 0) NOT NULL,
    CONSTRAINT user_roles_pk PRIMARY KEY (user_id, role_id),
    CONSTRAINT user_roles_user_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT user_roles_role_fk FOREIGN KEY (role_id) REFERENCES role(id) ON DELETE CASCADE
);

CREATE TABLE category (
  id NUMBER(19,0) GENERATED ALWAYS AS IDENTITY NOT NULL,
  name VARCHAR2(255),
  enable NUMBER(1,0),
  CONSTRAINT category_pk PRIMARY KEY (id)
);
INSERT INTO category (name, enable) VALUES ('Fresh Meat', 1);

CREATE TABLE product (
  id NUMBER(19, 0) GENERATED ALWAYS AS IDENTITY NOT NULL,
  description CLOB,
  name VARCHAR2(255),
  price NUMBER(19, 0),
  quantity NUMBER(10, 0),
  unit VARCHAR2(255),
  enable NUMBER(1,0),
  category_id NUMBER(19, 0),
  CONSTRAINT product_pk PRIMARY KEY (id),
  CONSTRAINT product_fk_category FOREIGN KEY (category_id) REFERENCES category(id) ON DELETE CASCADE
);

CREATE TABLE image (
  id NUMBER(19,0)GENERATED ALWAYS AS IDENTITY NOT NULL,
  name VARCHAR2(255),
  type VARCHAR2(255),
  img_size NUMBER(19, 0),
  data BLOB,
  uploaded_by NUMBER(19, 0),
  CONSTRAINT image_pk PRIMARY KEY(id),
  CONSTRAINT image_fk_user FOREIGN KEY (uploaded_by) REFERENCES users (id) ON DELETE CASCADE
);

CREATE TABLE product_image (
  product_id NUMBER(19, 0) NOT NULL,
  image_id NUMBER(19, 0) NOT NULL,
  CONSTRAINT product_image_pk PRIMARY KEY (product_id, image_id),
  CONSTRAINT product_image_fk_product FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE,
  CONSTRAINT product_image_fk_image FOREIGN KEY (image_id) REFERENCES image(id) ON DELETE CASCADE
);

-- Nhà cung cấp
CREATE TABLE supplier(
    id NUMBER(19,0) GENERATED ALWAYS AS IDENTITY NOT NULL PRIMARY KEY,
    name NVARCHAR2(400),
    phone NVARCHAR2(12),
    address NVARCHAR2(400),
    email NVARCHAR2(50)
);

-- Phiếu nhập
CREATE TABLE importcoupon(
    id NUMBER(19,0) GENERATED ALWAYS AS IDENTITY NOT NULL PRIMARY KEY,
    user_id NUMBER(19,0) NOT NULL,
    supplier_id NUMBER(19,0) NOT NULL,
    date_import DATE,
    total_price NUMBER(19, 2),
    enable NUMBER(1,0),
    CONSTRAINT importcoupon_fk__user FOREIGN KEY( user_id ) REFERENCES users( id ) ON DELETE CASCADE,
    CONSTRAINT importcoupon_fk_supplier FOREIGN KEY( supplier_id ) REFERENCES supplier( id ) ON DELETE CASCADE
);

--CHI TIẾT PHIẾU NHẬP
CREATE TABLE importcoupon_detail( 
 "IMPORTCOUPON_ID" NUMBER(19,0), 
	"PRODUCT_ID" NUMBER(19,0), 
	"QUANTITY" NUMBER(10,0), 
	"UNIT_PRICE" NUMBER(10,2), 
	"AMOUNT" NUMBER(10,2)
    CONSTRAINT importcoupon_detail_pk PRIMARY KEY( importcoupon_id,product_id ),
    CONSTRAINT importcoupon_detail_fk FOREIGN KEY( importcoupon_id ) REFERENCES importcoupon( id ) ON DELETE CASCADE,
    CONSTRAINT importcoupon_detail_product_fk FOREIGN KEY( product_id ) REFERENCES product( id ) ON DELETE CASCADE
);

CREATE TABLE blog (
  id NUMBER(19, 0) GENERATED ALWAYS AS IDENTITY NOT NULL,
  title VARCHAR2(255),
  description VARCHAR2(255),
  content CLOB,
  create_at TIMESTAMP,
  image_id NUMBER(19, 0),
  user_id NUMBER(19, 0),
  CONSTRAINT blog_pk PRIMARY KEY (id),
  CONSTRAINT blog_fk_image FOREIGN KEY (image_id) REFERENCES image(id) ON DELETE CASCADE,
  CONSTRAINT blog_fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE tag (
  id NUMBER(19,0) GENERATED ALWAYS AS IDENTITY NOT NULL,
  enable NUMBER(1,0),
  name VARCHAR2(255),
  CONSTRAINT tag_pk PRIMARY KEY (id)
);
 INSERT   INTO tag (enable, name) VALUES (1, 'Beauty');
 INSERT INTO tag (enable, name) VALUES (1, 'Food');
INSERT INTO tag (enable, name) VALUES (1, 'LifeStyle');
INSERT INTO tag (enable, name) VALUES (1, 'Travel');

CREATE TABLE blog_tag (
  blog_id NUMBER(19,0) NOT NULL,
  tag_id NUMBER(19,0) NOT NULL,
  CONSTRAINT blog_tag_pk PRIMARY KEY (blog_id, tag_id),
  CONSTRAINT blog_tag_blog_fk FOREIGN KEY (blog_id) REFERENCES blog(id) ON DELETE CASCADE,
  CONSTRAINT blog_tag_tag_fk FOREIGN KEY (tag_id) REFERENCES tag(id) ON DELETE CASCADE
);

CREATE TABLE orders (
    id NUMBER(19, 0) GENERATED ALWAYS AS IDENTITY NOT NULL,
  firstname VARCHAR2(255),
  lastname VARCHAR2(255),
  country VARCHAR2(255),
  address VARCHAR2(255),
  town VARCHAR2(255),
  state VARCHAR2(255),
  post_code VARCHAR2(255),
  email VARCHAR2(255),
  phone VARCHAR2(255),
  note VARCHAR2(255),
  total_price NUMBER(19, 0),
  enable NUMBER(1,0),
  user_id NUMBER(19, 0),
  date_order DATE,
  CONSTRAINT orders_pk PRIMARY KEY (id),
  CONSTRAINT orders_fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE order_details (
 "ORDER_ID" NUMBER(19,0), 
	"PRODUCT_ID" NUMBER(19,0), 
	"PRICE" NUMBER(19,0), 
	"QUANTITY" NUMBER(10,0), 
	"SUB_TOTAL" NUMBER(19,0)
  CONSTRAINT order_detail_pk PRIMARY KEY (order_id,product_id),
  CONSTRAINT order_details_fk_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  CONSTRAINT order_details_product_fk FOREIGN KEY( product_id ) REFERENCES product( id ) ON DELETE CASCADE
);

Insert into TAG (ID,ENABLE,NAME) values (1,1,'Tin mới');
Insert into TAG (ID,ENABLE,NAME) values (2,1,'Tin khuyến mãi');
Insert into TAG (ID,ENABLE,NAME) values (3,1,'Thông báo');

Insert into CATEGORY (NAME,ENABLE) values ('Vật liệu xây dựng cơ bản',null);
Insert into CATEGORY (NAME,ENABLE) values ('Nội thất',null);
Insert into CATEGORY (NAME,ENABLE) values ('Khác',null);
Insert into CATEGORY (NAME,ENABLE) values ('Sơn',null);


Insert into ROLE (ID,NAME) values (1,'ROLE_USER');
Insert into ROLE (ID,NAME) values (2,'ROLE_MODERATOR');
Insert into ROLE (ID,NAME) values (3,'ROLE_ADMIN');

Insert into SUPPLIER (NAME,PHONE,ADDRESS,EMAIL) values ('Hoa Sen HCM','0912031234','Quận 1,HCM','hoasen.infor@gmail.com');
Insert into SUPPLIER (NAME,PHONE,ADDRESS,EMAIL) values ('Thăng Long SG','1230924931','Phường Bến Nghé,Quận 1','thanglong.hcm@gmail.com');
Insert into SUPPLIER (NAME,PHONE,ADDRESS,EMAIL) values ('Đại Thành FC','1023020241','Quận 4,HCM','daithanh@gmail.com');

Insert into TAG (ENABLE,NAME) values (1,'Tin mới');
Insert into TAG (ENABLE,NAME) values (1,'Tin khuyến mãi');
Insert into TAG (ENABLE,NAME) values (1,'Thông báo');

Insert into USERS (USERNAME,EMAIL,FIRSTNAME,LASTNAME,PASSWORD,COUNTRY,TOWN,STATE,ADDRESS,PHONE,VERIFICATION_CODE,ENABLED) values ('admin','admin',null,null,'$2a$10$KNbig4YLN5j61wpFP040yunJS4P9ecKWHOTZehv8UnL9pgbS0I52q','VN','HCM',null,null,null,null,1);
Insert into USERS (USERNAME,EMAIL,FIRSTNAME,LASTNAME,PASSWORD,COUNTRY,TOWN,STATE,ADDRESS,PHONE,VERIFICATION_CODE,ENABLED) values ('khang','khang@gmail.com','KhÃ¡ng','Nguyá»…n','$2a$10$KNbig4YLN5j61wpFP040yunJS4P9ecKWHOTZehv8UnL9pgbS0I52q','VN','HCM',null,'HCM','12341245',null,1);
Insert into USERS (USERNAME,EMAIL,FIRSTNAME,LASTNAME,PASSWORD,COUNTRY,TOWN,STATE,ADDRESS,PHONE,VERIFICATION_CODE,ENABLED) values ('luu','luu@gmail.com','Yáº¿n','LÆ°u','$2a$10$KNbig4YLN5j61wpFP040yunJS4P9ecKWHOTZehv8UnL9pgbS0I52q','VN','HCM',null,'HCM','923492394',null,1);

Insert into USER_ROLES (USER_ID,ROLE_ID) values (1,3);

insert into product(description,name,price,quantity,unit,category_id) values('',N'Sơn lót nội thất Dulux',840000,0,'Thùng',2);--1
insert into product(description,name,price,quantity,unit,category_id) values('',N'Sơn nước nội thất Maxilite',920000,0,'Thùng',2);--2-
insert into product(description,name,price,quantity,unit,category_id) values('',N'Sơn sắt mạ kẽm Indu',890000,0,'Thùng',2);--3
insert into product(description,name,price,quantity,unit,category_id) values('',N'Sơn nước trong nhà Maxilite',1100000,0,'Thùng',2);--4


insert into product(description,name,price,quantity,unit,category_id) values('',N'Cát vàng xây dựng',205000,0,'Khối',1);--5
insert into product(description,name,price,quantity,unit,category_id) values('',N'Cát xây tô',200000,0,'Khối',1);--6
insert into product(description,name,price,quantity,unit,category_id) values('',N'Cát san lấp',175000,0,'Khối',1);--7

insert into product(description,name,price,quantity,unit,category_id) values(N'Đá mi sàng dùng để làm phụ gia sản xuất bê tông và vật liệu xây dựng, công trình giao thông.',N'Đá mi sàng',300000,0,'Khối',1);--8
insert into product(description,name,price,quantity,unit,category_id) values(N'Đá 4×6 là loại đá có kích cỡ từ 40x60mm. Sản phẩm dùng làm đường, móng nhà xưởng, công trình để có lực chịu nén cao.',N'Đá 4x6 xanh',270000,0,'Khối',1);--9
insert into product(description,name,price,quantity,unit,category_id) values(N'Đá 4×6 là loại đá có kích cỡ từ 40x60mm. Sản phẩm dùng làm đường, móng nhà xưởng, công trình để có lực chịu nén cao.',N'Đá 4x6 đen',250000,0,'Khối',1);--10
insert into product(description,name,price,quantity,unit,category_id) values(N'Đá 1×2 là nguyên liệu chính dùng cho đổ sàn bê tông công trình xây dựng chung cư, nhà cao tầng. ',N'Đá 1x2 xanh',280000,0,'Khối',1);--11


insert into product(description,name,price,quantity,unit,category_id) values(N'Gạch xây dựng',N'Gạch ống 4 lỗ',1500,0,'Viên',1);--12
insert into product(description,name,price,quantity,unit,category_id) values(N'Gạch xây dựng',N'Gạch thẻ',1500,0,'Viên',1);--13
insert into product(description,name,price,quantity,unit,category_id) values(N'Gạch xây dựng',N'Gạch ống 6 lỗ',3000,0,'Viên',1);--14
insert into product(description,name,price,quantity,unit,category_id) values(N'Gạch Tàu Ô Tròn là dòng sản phẩm cao cấp của Công ty Cổ Phần Gạch Ngói Đồng Nai, được sản xuất trên dây chuyền công nghệ hiện đại của Cộng Hoà Liên Bang Đức, nung ở nhiệt độ >1000 độ C; cúp vàng ngành Xây Dựng Việt Nam từ 1997-2014; Sản phẩm sử dụng công nghệ chống thấm cao cấp, khả năng kháng rêu tốt; Bảo hành sản phẩm 2 năm.',N'Gạch tàu ô tròn lát nền',17000,0,'Viên',1);--15
insert into product(description,name,price,quantity,unit,category_id) values(N'Gạch Tàu Ô dừa là dòng sản phẩm cao cấp của Công ty Cổ Phần Gạch Ngói Đồng Nai, được sản xuất trên dây chuyền công nghệ hiện đại của Cộng Hoà Liên Bang Đức, nung ở nhiệt độ >1000 độ C; cúp vàng ngành Xây Dựng Việt Nam từ 1997-2014; Sản phẩm sử dụng công nghệ chống thấm cao cấp, khả năng kháng rêu tốt; Bảo hành sản phẩm 2 năm.',N'Gạch tàu ô dừa lát nền',18000,0,'Viên',1);--16
insert into product(description,name,price,quantity,unit,category_id) values(N'Bề mặt đá mài phủ nano siêu bóng giúp gạch catalan chống thấm chống trầy hiệu quả thường được sử dụng gạch lát nền cho phòng khách, sảnh khách sạn, phòng ăn và không gian nhà bếp, với mẫu mã chủng loại gạch đa dạng ',N'Gạch lát nền trắng 50x50',170000,0,'Viên',1);--17
insert into product(description,name,price,quantity,unit,category_id) values(N'Bề mặt đá mài phủ nano siêu bóng giúp gạch catalan chống thấm chống trầy hiệu quả thường được sử dụng gạch lát nền cho phòng khách, sảnh khách sạn, phòng ăn và không gian nhà bếp, với mẫu mã chủng loại gạch đa dạng ',N'Gach lát nền vân xám 80x80',250000,0,'Viên',1);--18


insert into product(description,name,price,quantity,unit,category_id) values('',N'Băng keo điện',75000,0,'Cuộn',4); --19
insert into product(description,name,price,quantity,unit,category_id) values('',N'Bút thử điện',920000,0,'Cái',4);--20
insert into product(description,name,price,quantity,unit,category_id) values('',N'Cầu dao tự động mp6-c106',157000,0,'Cái',4);--21
insert into product(description,name,price,quantity,unit,category_id) values('',N'Ổ cắm đa năng 2 chấu USB',225000,0,'Cái',4);--22
insert into product(description,name,price,quantity,unit,category_id) values('',N'Ổ cắm đa năng công tắc 10a-250v',270000,0,'Cái',4);--23
insert into product(description,name,price,quantity,unit,category_id) values('',N'Đèn led bulb 30W',176000,0,'Cái',4);--24
insert into product(description,name,price,quantity,unit,category_id) values('',N'Đèn led bulb 3W',790000,0,'Cái',4);--25
ALTER TABLE importcoupon MODIFY(ID GENERATED AS IDENTITY (START WITH 1));

insert into importcoupon (user_id,supplier_id,date_import,total_price,enable) values(1,1,TO_DATE( '2023-11-21','yyyy/mm/dd'), 0, 1);--1
insert into importcoupon (user_id,supplier_id,date_import,total_price,enable) values(1,2, TO_DATE( '2023-11-21','yyyy/mm/dd'), 0, 1);--2
insert into importcoupon (user_id,supplier_id,date_import,total_price,enable) values(1,3, TO_DATE( '2023-11-21','yyyy/mm/dd'), 0, 1);--3
insert into importcoupon (user_id,supplier_id,date_import,total_price,enable) values(1,1, TO_DATE( '2023-11-21','yyyy/mm/dd'), 0, 1);--4


insert into importcoupon_detail values(1, 1, 40, 840000, 33600000);
insert into importcoupon_detail values(1, 2, 21, 920000, 19320000);
insert into importcoupon_detail values(1, 3, 23, 890000, 20470000);
insert into importcoupon_detail values(1, 4, 64, 1100000, 70400000);
insert into importcoupon_detail values(1, 5, 43, 205000, 8815000);
insert into importcoupon_detail values(1, 6, 2, 200000, 400000);
insert into importcoupon_detail values(1, 7, 7, 175000, 1225000);
insert into importcoupon_detail values(1, 8, 2, 200000, 0);

insert into importcoupon_detail values(2, 8, 19, 300000, 5700000);
insert into importcoupon_detail values(2, 9, 17, 270000, 4590000);
insert into importcoupon_detail values(2, 10, 23, 250000, 5750000);
insert into importcoupon_detail values(2, 11, 20, 280000, 5600000);
insert into importcoupon_detail values(2, 12, 10000, 1500, 15000000);
insert into importcoupon_detail values(2, 13, 10000, 1500, 15000000);
insert into importcoupon_detail values(2, 14, 10000, 3000, 30000000);
insert into importcoupon_detail values(2, 15, 300, 17000, 5100000);
insert into importcoupon_detail values(2, 16, 300, 18000, 5400000);
insert into importcoupon_detail values(3, 17, 300, 170000, 5100000);
insert into importcoupon_detail values(3, 18, 28, 250000, 7000000);
insert into importcoupon_detail values(3, 19, 42, 75000, 3150000);
insert into importcoupon_detail values(3, 20, 42, 920000, 38640000);
insert into importcoupon_detail values(3, 21, 16, 157000, 2512000);
insert into importcoupon_detail values(3, 22, 41, 550000, 22550000);
insert into importcoupon_detail values(3, 23, 29, 270000, 7830000);
insert into importcoupon_detail values(3, 23, 16, 270000, 4320000);
insert into importcoupon_detail values(4, 24, 14, 176000, 2464000);
insert into importcoupon_detail values(4, 25, 19, 790000, 15010000);

insert into orders(firstname,lastname,country,address,town,state,post_code,email,phone,note,total_price,enable,user_id,date_order) values('Kháng', 'Nguyễn', 'VietNam', 'HCM', '31c Làng tăng Phú', 'Đã giao', '', '', '0374037659', '', 0, 1, 2, TO_DATE( '2023-11-21','yyyy/mm/dd'));--1
insert into order_details values(1,11,840000, 2, 1680000);
insert into order_details values(1,8,200000, 2, 0);

insert into orders(firstname,lastname,country,address,town,state,post_code,email,phone,note,total_price,enable,user_id,date_order) values('Luu', 'Yen', 'VietNam', 'HCM', '31c Làng tăng Phú', 'Đã giao', '', '', '0374037659', '', 0, 1, 3, TO_DATE( '2023-11-21','yyyy/mm/dd'));--2
insert into order_details values(2,15,205000,3,615000);
insert into orders(firstname,lastname,country,address,town,state,post_code,email,phone,note,total_price,enable,user_id,date_order) values('Luu', 'Yen', 'VietNam', 'HCM', '31c Làng tăng Phú', 'Đã giao', '', '', '0374037659', '', 0, 1, 2, TO_DATE( '2023-11-21','yyyy/mm/dd'));--3
insert into order_details values(3,23,1500, 500,750000);
