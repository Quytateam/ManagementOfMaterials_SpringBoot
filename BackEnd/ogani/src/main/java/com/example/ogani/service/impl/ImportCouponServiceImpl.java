package com.example.ogani.service.impl;

import java.util.Date;
import java.util.List;

import javax.persistence.EntityManager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import com.example.ogani.entity.ImportCoupon;
import com.example.ogani.entity.ImportCouponDetail;
import com.example.ogani.entity.ImportCouponDetailId;
import com.example.ogani.entity.Product;
import com.example.ogani.entity.Supplier;
import com.example.ogani.entity.Users;
import com.example.ogani.exception.NotFoundException;
import com.example.ogani.model.request.CreateImportCouponDetailRequest;
import com.example.ogani.model.request.CreateImportCouponRequest;
import com.example.ogani.repository.ImportCouponDetailRepository;
import com.example.ogani.repository.ImportCouponRepository;
import com.example.ogani.repository.ProductRepository;
import com.example.ogani.repository.SupplierRepository;
import com.example.ogani.repository.UsersRepository;
import com.example.ogani.service.ImportCouponService;

@Service
public class ImportCouponServiceImpl implements ImportCouponService{
    
    @Autowired
    private ImportCouponRepository importCouponRepository;

    @Autowired
    private ImportCouponDetailRepository importCouponDetailRepository;

    @Autowired
    private UsersRepository usersRepository;

    @Autowired
    private SupplierRepository supplierRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private EntityManager entityManager;

    @Override
    public void placeImportCoupon(CreateImportCouponRequest request){
        ImportCoupon importCoupon = new ImportCoupon();
        Users users = usersRepository.findById(request.getUserId()).orElseThrow(() -> new NotFoundException("Not Found User With Id:" + request.getUserId()));
        importCoupon.setUsers(users);
        Supplier supplier = supplierRepository.findById(request.getSupplierId()).orElseThrow(() -> new NotFoundException("Not Found User With Id:" + request.getSupplierId()));
        importCoupon.setSupplier(supplier);
        importCoupon.setDate(new Date());
        importCoupon.setEnable(0);
        importCouponRepository.save(importCoupon);
        float totalPrice = 0;
        for (CreateImportCouponDetailRequest rq : request.getImportCouponDetail()) {
            ImportCouponDetailId importCouponDetailId = new ImportCouponDetailId();
            ImportCouponDetail importCouponDetail = new ImportCouponDetail();
            Product product = productRepository.findById(rq.getProductId()).orElseThrow(() -> new NotFoundException("Not Found Product With Id:" + rq.getProductId()));
            importCouponDetailId.setProductId(product.getId());
            importCouponDetailId.setimportcouponId(importCoupon.getId());
            importCouponDetail.setId(importCouponDetailId);
            importCouponDetail.setImportcoupon(importCoupon);
            importCouponDetail.setProduct(product);
            // importCouponDetail.setName(product.getName());
            importCouponDetail.setQuantity(rq.getQuantity());
            importCouponDetail.setUnitPrice(rq.getUnitPrice());
            importCouponDetail.setAmount(importCouponDetail.getQuantity() * importCouponDetail.getUnitPrice());
            totalPrice += importCouponDetail.getAmount();
            importCouponDetailRepository.save(importCouponDetail);
        }
        importCoupon.setTotalPrice(totalPrice);
        importCouponRepository.save(importCoupon);
    }

    @Override
    public List<ImportCoupon> getList() {
        return importCouponRepository.findAll(Sort.by("id").descending());
    }

    @Override
    public void enableImportCoupon(long id) {
        // TODO Auto-generated method stub
        ImportCoupon importCoupon = importCouponRepository.findById(id).orElseThrow(() -> new NotFoundException("Not Found Import Coupon With Id: " + id));
        if(importCoupon.getEnable() == 1){
            importCoupon.setEnable(0);
        } else{
            importCoupon.setEnable(1);
        }
        importCouponRepository.save(importCoupon);
    }

    @Override
    public void deleteImportCoupon(long id) {
        // TODO Auto-generated method stub
        // ImportCoupon importCoupon = importCouponRepository.findById(id).orElseThrow(() -> new NotFoundException("Not Found Category With Id: " + id));
        // importCouponRepository.delete(importCoupon);
        // importCouponRepository.deleteImportCoupon(id);
        // importCouponRepository.deleteById(id);
        importCouponRepository.deleteById(id);
        entityManager.clear();
    }

    @Override
    public List<ImportCouponDetail> getListDetails(long id) {
        return importCouponDetailRepository.getListDetails(id);
    }
}
