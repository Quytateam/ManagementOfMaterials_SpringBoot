package com.example.ogani.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.example.ogani.entity.Supplier;

@Repository
public interface SupplierRepository extends JpaRepository<Supplier, Long>{
    // @Query(value = "SELECT * FROM supplier ORDER BY id DESC", nativeQuery = true)
    // List<Supplier> getListAll();
}
