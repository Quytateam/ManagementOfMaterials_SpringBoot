CREATE TABLE users (
  id NUMBER(19,0) GENERATED ALWAYS AS IDENTITY NOT NULL,
  username VARCHAR2(255) NOT NULL,
  email VARCHAR2(255) NOT NULL,
  firstname VARCHAR2(255),
  lastname VARCHAR2(255),
  password VARCHAR2(255) NOT NULL,
  country VARCHAR2(255),
  state VARCHAR2(255),
  address VARCHAR2(255),
  phone VARCHAR2(255),
  verification_code VARCHAR2(64),
  town VARCHAR2(255),
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
    id NUMBER(19, 0) GENERATED ALWAYS AS IDENTITY NOT NULL,
    importcoupon_id NUMBER(19,0) NOT NULL,
    product_id NUMBER(19,0) NOT NULL,
    -- name VARCHAR2(255),
    quantity NUMBER(10, 0),
    unit_price NUMBER(10, 2),
    amount NUMBER(10, 2),
    CONSTRAINT importcoupon_detail_pk PRIMARY KEY( id ),
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
  id NUMBER(19, 0) GENERATED ALWAYS AS IDENTITY NOT NULL,
  product_id NUMBER(19, 0),
  -- name VARCHAR2(255),
  price NUMBER(19, 0),
  quantity NUMBER(10, 0),
  sub_total NUMBER(19, 0),
  order_id NUMBER(19, 0), -- Tham chi?u ??n b?ng orders th�ng qua kh�a ngo?i
  CONSTRAINT order_detail_pk PRIMARY KEY (id),
  CONSTRAINT order_detail_fk_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);
