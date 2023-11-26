package com.example.ogani.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import com.example.ogani.entity.Orders;
import com.example.ogani.entity.Product;
import com.example.ogani.entity.OrderDetails;
import com.example.ogani.entity.OrderDetailsId;
import com.example.ogani.entity.Users;
import com.example.ogani.exception.NotFoundException;
import com.example.ogani.model.request.CreateOrderDetailRequest;
import com.example.ogani.model.request.CreateOrderRequest;
import com.example.ogani.repository.OrderDetailsRepository;
import com.example.ogani.repository.OrdersRepository;
import com.example.ogani.repository.ProductRepository;
import com.example.ogani.repository.UsersRepository;
import com.example.ogani.service.OrdersService;

import java.util.Date;
import java.util.List;

import javax.persistence.EntityManager;

@Service
public class OrdersServiceImpl implements OrdersService {
    
    @Autowired
    private OrdersRepository ordersRepository;

    @Autowired
    private OrderDetailsRepository orderDetailsRepository;

    @Autowired
    private UsersRepository usersRepository;

    @Autowired
    private EntityManager entityManager;

    @Autowired
    private ProductRepository productRepository;

    @Override
    public void placeOrder(CreateOrderRequest request) {
        // TODO Auto-generated method stub
        Orders orders = new Orders();
        Users users = usersRepository.findByUsername(request.getUsername()).orElseThrow(() -> new NotFoundException("Not Found User With Username:" + request.getUsername()));
        orders.setFirstname(request.getFirstname());
        orders.setLastname(request.getLastname());
        orders.setCountry(request.getCountry());
        orders.setAddress(request.getAddress());
        orders.setTown(request.getTown());
        orders.setState(request.getState());
        orders.setPostCode(request.getPostCode());
        orders.setEmail(request.getEmail());
        orders.setPhone(request.getPhone());
        orders.setNote(request.getNote());
        orders.setEnable(0);
        orders.setDate(new Date());
        ordersRepository.save(orders);
        long totalPrice = 0;
        for(CreateOrderDetailRequest rq: request.getOrderDetails()){
            OrderDetailsId orderDetailsId = new OrderDetailsId();
            OrderDetails orderDetails = new OrderDetails();
            Product product = productRepository.findById(rq.getProductId()).orElseThrow(() -> new NotFoundException("Not Found Product With Id:" + rq.getProductId()));
            orderDetailsId.setProductId(product.getId());
            orderDetailsId.setOrderId(orders.getId());
            orderDetails.setId(orderDetailsId);
            // OrderDetailsId orderDetailsId = new OrderDetailsId();
            // orderDetails.setId(orderDetailsId);
            // orderDetails.setProductId(rq.getProductId());
            orderDetails.setProduct(product);
            // orderDetails.setName(rq.getName());
            orderDetails.setPrice(rq.getPrice());
            orderDetails.setQuantity(rq.getQuantity());
            orderDetails.setSubTotal(rq.getPrice()* rq.getQuantity());
            orderDetails.setOrder(orders);
            totalPrice += orderDetails.getSubTotal();
            orderDetailsRepository.save(orderDetails);
            
        }
        orders.setTotalPrice(totalPrice);
        orders.setUsers(users);
        ordersRepository.save(orders);
    }

    @Override
    public List<Orders> getList() {
        return ordersRepository.findAll(Sort.by("id").descending());
    }

    @Override
    public Orders getOrder(long id) {
        // TODO Auto-generated method stub
        Orders order= ordersRepository.findById(id).orElseThrow(() -> new NotFoundException("Not Found Order With Id: " + id));

        return order;
    }

    @Override
    public List<Orders> getOrdersByUser(String username) {
        Users users = usersRepository.findByUsername(username).orElseThrow(() -> new NotFoundException("Not Found User With Username:" + username));

        return ordersRepository.getOrderByUser(users.getId());
    }

    @Override
    public void deleteOrder(long id) {
        ordersRepository.deleteById(id);
        entityManager.clear();
    }

    @Override
    public List<OrderDetails> getListDetails(long id) {
        return orderDetailsRepository.getListDetails(id);
    }

    @Override
    public void enableOrder(long id) {
        // TODO Auto-generated method stub
        Orders order = ordersRepository.findById(id).orElseThrow(() -> new NotFoundException("Not Found Order With Id: " + id));
        if(order.getEnable() == 1){
            order.setEnable(0);
        } else{
            order.setEnable(1);
        }
        ordersRepository.save(order);
    }

}
