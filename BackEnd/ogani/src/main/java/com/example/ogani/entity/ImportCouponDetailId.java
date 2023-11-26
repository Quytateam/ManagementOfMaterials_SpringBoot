package com.example.ogani.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;

import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

@Embeddable
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode
public class ImportCouponDetailId implements Serializable{
    @Column(name = "importcoupon_id")
    private Long importcouponId;

    @Column(name = "product_id")
    private Long productId;

    public void setProductId(long productId) {
        this.productId = productId;
    }

    // Thêm setter cho importcouponId
    public void setimportcouponId(long importcouponId) {
        this.importcouponId = importcouponId;
    }
}
