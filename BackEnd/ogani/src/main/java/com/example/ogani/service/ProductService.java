package com.example.ogani.service;

import java.util.List;

import com.example.ogani.entity.Product;
import com.example.ogani.model.request.CreateProductRequest;
import com.example.ogani.model.request.UpdateQuantityProductRequest;

public interface ProductService {
    
    List<Product> getList();

    List<Product> getListNewest(int number);

    List<Product> getListByPrice();

    List<Product> findRelatedProduct(long id);

    List<Product> getListProductByCategory(long id);

    List<Product> getListByPriceRange(long id,int min, int max);

    List<Product> searchProduct(String keyword);

    Product getProduct(long id);

    Product createProduct(CreateProductRequest request);

    Product updateProduct(long id, CreateProductRequest request);
    
    Product updateQuantityProduct(long id, UpdateQuantityProductRequest request);

    void enableProduct(long id);

    void deleteProduct(long id);

    long getQuantityById(long id);

}
