package com.example.ogani.entity;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "order_details")
public class OrderDetails {

    // @Id
    // @GeneratedValue(strategy = GenerationType.IDENTITY)
    // private long id;

    // @Column(name = "product_id")
    // private long productId;

    @EmbeddedId
    private OrderDetailsId id;

    @ManyToOne(cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinColumn(name = "product_id", insertable = false, updatable = false)
    private Product product;

    // private String name;

    private long price;

    private int quantity;

    @Column(name = "sub_total")
    private long subTotal;

    @ManyToOne(cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinColumn(name ="order_id", insertable = false, updatable = false)
    private Orders order;
}
