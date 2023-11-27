
------------PROCEDURES----------
--1. procedure category

CREATE OR REPLACE PROCEDURE add_category(
  p_name IN VARCHAR2,
  p_enable IN NUMBER
)
AS
  v_count NUMBER;
BEGIN
  -- Kiểm tra xem tên danh mục đã tồn tại chưa
  SELECT COUNT(*)
  INTO v_count
  FROM CATEGORY
  WHERE name = p_name;

  IF v_count > 0 THEN
    -- Nếu danh mục đã tồn tại, thì in ra thông báo và rollback
    DBMS_OUTPUT.PUT_LINE('Danh mục đã tồn tại');
    ROLLBACK;
  ELSE
    -- Nếu danh mục chưa tồn tại, thì thêm danh mục mới
    INSERT INTO CATEGORY (name, enable)
    VALUES (p_name, p_enable);
    DBMS_OUTPUT.PUT_LINE('Thêm thành công');
  END IF;
END add_category;
/


SET SERVEROUTPUT ON;
BEGIN
  add_category('Nội thất', 1);
END;

--2. Procedure supplier
CREATE OR REPLACE PROCEDURE add_supplier(
  p_name IN NVARCHAR2,
  p_phone IN NVARCHAR2,
  p_address IN NVARCHAR2,
  p_email IN NVARCHAR2
)
AS
  v_count NUMBER;
BEGIN
  -- Kiểm tra xem tên nhà cung cấp đã tồn tại chưa
  SELECT COUNT(*)
  INTO v_count
  FROM SUPPLIER -- Đổi tên bảng thành SUPPLIER nếu đây là tên bảng chứa thông tin nhà cung cấp
  WHERE name = p_name;

  IF v_count > 0 THEN
    -- Nếu nhà cung cấp đã tồn tại, thì in ra thông báo và rollback
    DBMS_OUTPUT.PUT_LINE('Nhà cung cấp đã tồn tại');
    ROLLBACK;
  ELSE
    -- Nếu nhà cung cấp chưa tồn tại, thì thêm nhà cung cấp mới
    INSERT INTO SUPPLIER (name, phone, address, email) -- Đổi tên bảng thành SUPPLIER nếu đây là tên bảng chứa thông tin nhà cung cấp
    VALUES (p_name, p_phone, p_address, p_email);
    DBMS_OUTPUT.PUT_LINE('Thêm thành công');
  END IF;
END add_supplier;
/
SET SERVEROUTPUT ON;
BEGIN
  add_supplier('Hoa Sen HCM', '', '', '');
END;

--3.procedure product
CREATE OR REPLACE PROCEDURE add_product(
  p_description IN CLOB,
  p_name IN VARCHAR2,
  p_price IN NUMBER,
  p_quantity IN NUMBER,
  p_unit IN VARCHAR2,
  p_category_id NUMBER
)
AS
  v_category_count NUMBER;
BEGIN
  -- Kiểm tra xem danh mục sản phẩm đã tồn tại chưa
  SELECT COUNT(*)
  INTO v_category_count
  FROM CATEGORY
  WHERE id = p_category_id;

  IF v_category_count = 0 THEN
    -- Nếu danh mục sản phẩm không tồn tại, in ra thông báo và rollback
    DBMS_OUTPUT.PUT_LINE('Danh mục sản phẩm không tồn tại');
    ROLLBACK;
  ELSE
    -- Nếu danh mục sản phẩm tồn tại, thêm sản phẩm mới
    INSERT INTO PRODUCT (description, name, price, quantity, unit, category_id)
    VALUES (p_description, p_name, p_price, p_quantity, p_unit, p_category_id);
    DBMS_OUTPUT.PUT_LINE('Thêm sản phẩm thành công');
  END IF;
END add_product;
/

SET SERVEROUTPUT ON;
BEGIN
  add_product('', '', 0, 0, '', 3);
END;

--4. procedure users
CREATE OR REPLACE PROCEDURE add_user(
  p_username IN VARCHAR2,
  p_email IN VARCHAR2,
  p_firstname IN VARCHAR2,
  p_lastname IN VARCHAR2,
  p_password IN VARCHAR2,
  p_country IN VARCHAR2,
  p_town IN VARCHAR2,
  p_state IN VARCHAR2,
  p_address IN VARCHAR2,
  p_phone IN VARCHAR2,
  p_VERIFICATION_CODE IN VARCHAR2,
  p_enabled IN NUMBER
)
AS
  v_username_count NUMBER;
BEGIN
  -- Kiểm tra xem tên người dùng đã tồn tại chưa
  SELECT COUNT(*)
  INTO v_username_count
  FROM USERS 
  WHERE username = p_username;

  IF v_username_count > 0 THEN
    -- Nếu tên người dùng đã tồn tại, in ra thông báo và rollback
    DBMS_OUTPUT.PUT_LINE('Tên người dùng đã tồn tại');
    ROLLBACK;
  ELSE
    -- Nếu tên người dùng chưa tồn tại, thêm người dùng mới
    INSERT INTO USERS (
      username, email, firstname, lastname, password,
      country, town, state, address, phone, verification_code, enabled
    )
    VALUES (
      p_username, p_email, p_firstname, p_lastname, p_password,
      p_country, p_town, p_state, p_address, p_phone, p_VERIFICATION_CODE, p_enabled
    );
    DBMS_OUTPUT.PUT_LINE('Thêm người dùng thành công');
  END IF;
END add_user;
/

SET SERVEROUTPUT ON;
BEGIN
  add_user('luu', '', '', '', '', '','','','','','',0);
END;

--5. thu tuc chan thong bao tu he thong
PROCEDURE Chan IS 
BEGIN
    :SYSTEM.MESSAGE_LEVEL:=25; 
END;

--6. thu tuc xoa category
CREATE OR REPLACE PROCEDURE DELETE_CATEGORY (
    p_category_id IN NUMBER
) AS
    v_product_count NUMBER;
BEGIN
    -- Kiểm tra số lượng sản phẩm thuộc danh mục
    SELECT COUNT(*)
    INTO v_product_count
    FROM VLXD.PRODUCT
    WHERE CATEGORY_ID = p_category_id;

    IF v_product_count > 0 THEN
        -- Nếu có sản phẩm thuộc danh mục, không cho phép xóa
        DBMS_OUTPUT.PUT_LINE('Không thể xóa danh mục với ID ' || p_category_id || ' vì có sản phẩm thuộc danh mục này.');
    ELSE
        -- Xóa dữ liệu từ bảng "CATEGORY" với điều kiện là "ID" trùng với tham số đầu vào
        DELETE FROM VLXD.CATEGORY
        WHERE ID = p_category_id;

        IF SQL%ROWCOUNT = 0 THEN
            -- Không có danh mục nào được xóa
            DBMS_OUTPUT.PUT_LINE('Dữ liệu với ID ' || p_category_id || ' không tồn tại.');
        ELSE
            -- Commit chỉ khi có dữ liệu được xóa
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Dữ liệu đã được xóa thành công.');
        END IF;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        -- In ra thông báo lỗi nếu có lỗi xảy ra
        DBMS_OUTPUT.PUT_LINE('Lỗi: ' || SQLCODE || ' - ' || SQLERRM);
        ROLLBACK; -- Rollback nếu có lỗi
END DELETE_CATEGORY;
/


SET SERVEROUTPUT ON;
BEGIN
    DELETE_CATEGORY(p_category_id => 3);
END;

--7. thu tuc xoa san pham
CREATE OR REPLACE PROCEDURE DELETE_PRODUCT (
    p_product_id IN NUMBER
) AS
BEGIN
    -- Xóa sản phẩm từ bảng "PRODUCT"
    DELETE FROM VLXD.PRODUCT
    WHERE ID = p_product_id;

    IF SQL%ROWCOUNT = 0 THEN
        -- Không có sản phẩm nào được xóa
        DBMS_OUTPUT.PUT_LINE('Sản phẩm với ID ' || p_product_id || ' không tồn tại.');
    ELSE
        -- Commit chỉ khi có dữ liệu được xóa
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Sản phẩm đã được xóa thành công.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        -- In ra thông báo lỗi nếu có lỗi xảy ra
        DBMS_OUTPUT.PUT_LINE('Lỗi: ' || SQLCODE || ' - ' || SQLERRM);
        ROLLBACK; -- Rollback nếu có lỗi
END DELETE_PRODUCT;
/
SET SERVEROUTPUT ON;
BEGIN
    DELETE_PRODUCT(p_product_id => 82);
END;

--8. thu tuc xoa nha cung cap
CREATE OR REPLACE PROCEDURE DELETE_SUPPLIER (
    p_supplier_id IN NUMBER
) AS
    v_importcoupon_count NUMBER;
BEGIN
    -- Kiểm tra xem nhà cung cấp có tồn tại trong hóa đơn nhập không
    SELECT COUNT(*)
    INTO v_importcoupon_count
    FROM VLXD.IMPORTCOUPON
    WHERE SUPPLIER_ID = p_supplier_id;

    IF v_importcoupon_count > 0 THEN
        -- Nếu có hóa đơn nhập liên quan, không ngăn chặn xóa nhà cung cấp, nhưng thông báo cảnh báo
        DBMS_OUTPUT.PUT_LINE('Cảnh báo: Nhà cung cấp với ID ' || p_supplier_id || ' có liên quan đến hóa đơn nhập.');
    END IF;

    -- Xóa nhà cung cấp từ bảng "SUPPLIER"
    DELETE FROM VLXD.SUPPLIER
    WHERE ID = p_supplier_id;

    IF SQL%ROWCOUNT = 0 THEN
        -- Không có nhà cung cấp nào được xóa
        DBMS_OUTPUT.PUT_LINE('Nhà cung cấp với ID ' || p_supplier_id || ' không tồn tại.');
    ELSE
        -- Commit chỉ khi có dữ liệu được xóa
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Nhà cung cấp đã được xóa thành công.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        -- In ra thông báo lỗi nếu có lỗi xảy ra
        DBMS_OUTPUT.PUT_LINE('Lỗi: ' || SQLCODE || ' - ' || SQLERRM);
        ROLLBACK; -- Rollback nếu có lỗi
END DELETE_SUPPLIER;
/
SET SERVEROUTPUT ON;
BEGIN
    DELETE_SUPPLIER(p_supplier_id => 3);
END;

--9. thu tuc xoa users
CREATE OR REPLACE PROCEDURE DELETE_USER_BY_USERNAME (
    p_username IN VARCHAR2
) AS
BEGIN
    -- Xóa người dùng từ bảng "USERS"
    DELETE FROM VLXD.USERS
    WHERE USERNAME = p_username;

    IF SQL%ROWCOUNT = 0 THEN
        -- Không có người dùng nào được xóa
        DBMS_OUTPUT.PUT_LINE('Người dùng với tên đăng nhập ' || p_username || ' không tồn tại.');
    ELSE
        -- Commit chỉ khi có dữ liệu được xóa
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Người dùng đã được xóa thành công.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        -- In ra thông báo lỗi nếu có lỗi xảy ra
        DBMS_OUTPUT.PUT_LINE('Lỗi: ' || SQLCODE || ' - ' || SQLERRM);
        ROLLBACK; -- Rollback nếu có lỗi
END DELETE_USER_BY_USERNAME;
/
SET SERVEROUTPUT ON;
BEGIN
    DELETE_USER_BY_USERNAME(p_username => 'luu3333');
END;

--10. thu tuc thong ke san pham ban chay
CREATE OR REPLACE PROCEDURE TOP_SELLING_PRODUCTS (
    p_top_count IN NUMBER DEFAULT 10
) AS
    CURSOR c_top_selling_products IS
        SELECT
            p.ID AS PRODUCT_ID,
            p.NAME AS PRODUCT_NAME,
            SUM(od.QUANTITY) AS TOTAL_QUANTITY_SOLD
        FROM
            VLXD.ORDER_DETAILS od
            JOIN VLXD.PRODUCT p ON od.PRODUCT_ID = p.ID
        GROUP BY
            p.ID, p.NAME
        ORDER BY
            TOTAL_QUANTITY_SOLD DESC;

    TYPE product_info_rec IS RECORD (
        PRODUCT_ID NUMBER,
        PRODUCT_NAME VARCHAR2(255),
        TOTAL_QUANTITY_SOLD NUMBER
    );

    TYPE product_info_table IS TABLE OF product_info_rec;
    v_top_selling_products product_info_table;
BEGIN
    OPEN c_top_selling_products;
    FETCH c_top_selling_products BULK COLLECT INTO v_top_selling_products LIMIT p_top_count;
    CLOSE c_top_selling_products;

    FOR i IN 1..v_top_selling_products.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Product ID: ' || v_top_selling_products(i).PRODUCT_ID);
        DBMS_OUTPUT.PUT_LINE('Product Name: ' || v_top_selling_products(i).PRODUCT_NAME);
        DBMS_OUTPUT.PUT_LINE('Total Quantity Sold: ' || v_top_selling_products(i).TOTAL_QUANTITY_SOLD);
        DBMS_OUTPUT.PUT_LINE('---------------------------');
    END LOOP;

    -- Xuất thông tin nếu có dữ liệu
    IF v_top_selling_products.COUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Không có thông tin sản phẩm bán chạy.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        -- In ra thông báo lỗi nếu có lỗi xảy ra
        DBMS_OUTPUT.PUT_LINE('Lỗi: ' || SQLCODE || ' - ' || SQLERRM);
END TOP_SELLING_PRODUCTS;
/

SET SERVEROUTPUT ON;
DECLARE
    v_dummy NUMBER;
BEGIN
    TOP_SELLING_PRODUCTS(1);
END;
/

------------FUNCTIONS-----------------

--1. Tính tổng giá trị đơn hàng xuất
CREATE OR REPLACE FUNCTION calculate_order_total(
    p_order_id IN NUMBER
) RETURN NUMBER IS
    v_total NUMBER := 0;
BEGIN
    SELECT SUM(sub_total) INTO v_total
    FROM VLXD.ORDER_DETAILS
    WHERE ORDER_ID = p_order_id;

    RETURN v_total;
END calculate_order_total;
/

SELECT calculate_order_total(1) AS order_total
FROM dual;

--2. Tính tổng số lượng sản phẩm trong đơn hàng
CREATE OR REPLACE FUNCTION calculate_order_quantity(
    p_order_id IN NUMBER
) RETURN NUMBER IS
    v_quantity NUMBER := 0;
BEGIN
    SELECT SUM(QUANTITY) INTO v_quantity
    FROM VLXD.ORDER_DETAILS
    WHERE ORDER_ID = p_order_id;

    RETURN v_quantity;
END calculate_order_quantity;
/

SELECT calculate_order_quantity(1) AS order_quantity
FROM dual;

--3. Lấy thông tin sản phẩm dựa trên danh mục (CATEGORY)
CREATE OR REPLACE FUNCTION get_products_by_category(
    p_category_id IN NUMBER
) RETURN SYS_REFCURSOR IS
    v_result SYS_REFCURSOR;
BEGIN
    OPEN v_result FOR
        SELECT *
        FROM VLXD.PRODUCT
        WHERE CATEGORY_ID = p_category_id;

    RETURN v_result;
END get_products_by_category;
/

VARIABLE rc REFCURSOR;
BEGIN
  :rc := get_products_by_category(1);
END;
/
PRINT rc;


--4. Tính tổng giá trị đơn hàng của mỗi người dùng
CREATE OR REPLACE FUNCTION calculate_user_order_total(
    p_user_id IN NUMBER
) RETURN NUMBER IS
    v_total NUMBER := 0;
BEGIN
    SELECT SUM(TOTAL_PRICE) INTO v_total
    FROM VLXD.ORDERS
    WHERE USER_ID = p_user_id;

    RETURN v_total;
END calculate_user_order_total;
/

SELECT calculate_user_order_total(2) AS user_order_total
FROM dual;


--5. Tính tổng giá trị đơn nhập (calculate_import_total)
CREATE OR REPLACE FUNCTION calculate_import_total(
    p_importcoupon_id IN NUMBER
) RETURN NUMBER IS
    v_total NUMBER := 0;
BEGIN
    SELECT SUM(AMOUNT) INTO v_total
    FROM VLXD.IMPORTCOUPON_DETAIL
    WHERE IMPORTCOUPON_ID = p_importcoupon_id;

    RETURN v_total;
END calculate_import_total;
/

SELECT calculate_import_total(1) AS import_total
FROM dual;

--6. Lấy thông tin chi tiết đơn nhập theo sản phẩm (get_import_detail_by_product)
CREATE OR REPLACE FUNCTION get_import_detail_by_product(
    p_product_id IN NUMBER
) RETURN SYS_REFCURSOR IS
    v_result SYS_REFCURSOR;
BEGIN
    OPEN v_result FOR
        SELECT *
        FROM VLXD.IMPORTCOUPON_DETAIL d
        JOIN VLXD.IMPORTCOUPON i ON d.IMPORTCOUPON_ID = i.ID
        WHERE d.PRODUCT_ID = p_product_id;

    RETURN v_result;
END get_import_detail_by_product;
/
VARIABLE rc REFCURSOR;
BEGIN
  :rc := get_import_detail_by_product(1);
END;
/
PRINT rc;

--7. Tính tổng giá trị nhập từ một nhà cung cấp (calculate_supplier_import_total)
CREATE OR REPLACE FUNCTION calculate_supplier_import_total(
    p_supplier_id IN NUMBER
) RETURN NUMBER IS
    v_total NUMBER := 0;
BEGIN
    SELECT SUM(TOTAL_PRICE) INTO v_total
    FROM VLXD.IMPORTCOUPON
    WHERE SUPPLIER_ID = p_supplier_id;

    RETURN v_total;
END calculate_supplier_import_total;
/

SELECT calculate_supplier_import_total(1) AS supplier_import_total
FROM dual;

--8. Lấy thông tin sản phẩm tồn kho (get_product_inventory)
CREATE OR REPLACE FUNCTION get_product_inventory(
    p_product_id IN NUMBER
) RETURN NUMBER IS
    v_inventory NUMBER := 0;
BEGIN
    SELECT QUANTITY INTO v_inventory
    FROM VLXD.PRODUCT
    WHERE ID = p_product_id;

    RETURN v_inventory;
END get_product_inventory;
/

SELECT get_product_inventory(66) AS product_inventory
FROM dual;


--1:trigger tinh tong tien hoa don nhap xxxxxxxxxxxxxxxxxx
create or replace TRIGGER importcoupon_after_insert
AFTER INSERT or UPDATE
ON importcoupon_detail
FOR EACH ROW
declare old_amount number(19);
        old_quantity number(19);
BEGIN
    if(:old.amount is NULL) then
        old_amount := 0;
    else
        old_amount := :old.amount;
    end if;
    UPDATE importcoupon
    SET total_price = total_price + :new.amount - :old.amount
    WHERE importcoupon.id = :new.IMPORTCOUPON_ID;
    
    --cập nhật số lượng
    if(:old.quantity is NULL) then
        old_quantity := 0;
    else
        old_quantity := :old.quantity;
    end if;
    UPDATE product
    SET quantity = quantity + :new.quantity - old_quantity
    WHERE product.id = :new.PRODUCT_ID;
END;

--2:tinh tien chi tiet hoa don
create or replace TRIGGER amount_importcoupon_dt
BEFORE INSERT
ON importcoupon_detail
FOR EACH ROW
BEGIN
  -- Tính thành tiền
  :new.amount :=  :new.quantity * :new.unit_price;
END;

--3:trigger tinh tong tien hoa don nhap xxxxxxxxxx
create or replace TRIGGER orders_after_insert
AFTER INSERT or UPDATE
ON order_details
FOR EACH ROW
declare sub_total number(19);
        old_quantity number(19);
BEGIN
    if(:old.sub_total is NULL) then
        sub_total := 0;
    else
        sub_total := :old.sub_total;
    end if;
    UPDATE orders
    SET total_price = total_price + :new.sub_total - sub_total
    WHERE orders.id = :new.order_id;
    
    --cập nhật số lượng
    if(:old.quantity is NULL) then
        old_quantity := 0;
    else
        old_quantity := :old.quantity;
    end if;
    UPDATE PRODUCT
    SET quantity = quantity - :new.quantity + old_quantity
    WHERE PRODUCT.id = :new.PRODUCT_ID;
END;

--4:tinh tien chi tiet hoa don xuat
create or replace TRIGGER amount_order_details
BEFORE INSERT
ON order_details
FOR EACH ROW
declare slton number(19);
BEGIN
    select quantity into slton from product where product.id = :new.product_id;
    if(:new.quantity > slton) then
            RAISE_APPLICATION_ERROR(-20001, 'Số lượng tồn không đủ');
            rollback;
    end if;

    if(:new.quantity <= 0) then
        RAISE_APPLICATION_ERROR(-20001, 'Số lượng không được <= 0');
        rollback;
    end if;
  -- Tính thành tiền
  :new.sub_total :=  :new.quantity * :new.price;
END;
select * from nls_database_parameters
