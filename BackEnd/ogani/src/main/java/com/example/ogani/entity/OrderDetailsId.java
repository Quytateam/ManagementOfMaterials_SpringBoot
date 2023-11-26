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
public class OrderDetailsId implements Serializable{

    @Column(name = "product_id")
    private long product;

    @Column(name = "order_id")
    private long order;

    public void setProductId(long productId) {
        this.product = productId;
    }

    // Thêm setter cho orderId
    public void setOrderId(long orderId) {
        this.order = orderId;
    }
}
