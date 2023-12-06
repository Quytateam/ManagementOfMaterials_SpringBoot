package com.example.ogani.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.ogani.entity.Product;

@Repository
public interface ProductRepository extends JpaRepository<Product,Long> {

    @Query(value = "SELECT * FROM Product WHERE ROWNUM <= :number and enable = 1 ORDER BY id DESC", nativeQuery = true)
    List<Product> getListNewest(@Param("number") int number);

    @Query(value = "SELECT * FROM Product WHERE ROWNUM <= 8 and enable = 1 ORDER BY price", nativeQuery = true)
    List<Product> getListByPrice();

    @Query(value = "SELECT * FROM Product WHERE category_id = :id and enable = 1 ORDER BY DBMS_RANDOM.RANDOM FETCH FIRST 4 ROWS ONLY"
            , nativeQuery = true)
    List<Product> findRelatedProduct(@Param("id") long id);

    @Query(value = "SELECT * FROM Product WHERE category_id = :id and enable = 1", nativeQuery = true)
    List<Product> getListProductByCategory(@Param("id") long id);

    @Query(value = "SELECT * FROM Product WHERE category_id = :id and enable = 1 AND price BETWEEN :min AND :max", nativeQuery = true)
    List<Product> getListProductByPriceRange(@Param("id") long id, @Param("min") int min, @Param("max") int max);
    @Query(value = "SELECT p FROM Product p WHERE p.name LIKE %:keyword% and p.enable = 1 ORDER BY p.id DESC")
    List<Product> searchProduct(@Param("keyword") String keyword);

    @Query(value = "SELECT quantity FROM product WHERE id = :id", nativeQuery = true)
    long getQuantityById(@Param("id") long id);

}
