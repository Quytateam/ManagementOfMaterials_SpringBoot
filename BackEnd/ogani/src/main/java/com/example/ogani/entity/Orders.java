package com.example.ogani.entity;

import java.util.Date;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonBackReference;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "ORDERS")
public class Orders {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    private String firstname;

    private String lastname;

    private String country;

    private String address;

    private String town;

    private String state;

    @Column(name = "post_code")
    private long postCode;

    private String email;
    
    private String phone;

    private String note;

    private int enable;

    @Column(name = "total_price")
    private long totalPrice;

    @ManyToOne
    @JoinColumn(name="user_id")
    private Users users;

    @Column(name = "date_order")
    private Date date;

    @OneToMany(mappedBy="order")
    @JsonBackReference
    private Set<OrderDetails> orderdetails;
}
