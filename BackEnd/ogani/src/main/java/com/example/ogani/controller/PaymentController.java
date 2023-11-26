package com.example.ogani.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.ogani.config.PaymentConfig;
import com.example.ogani.model.request.CreatePaymentRequest;
import com.example.ogani.model.request.PaymentRequest;

@RestController
@RequestMapping("/api/payment")
@CrossOrigin(origins = "*",maxAge = 3600)
public class PaymentController {
    
    @GetMapping("/create_payment")
    public String createPayment(@RequestParam("total") long total, HttpServletResponse resp) throws UnsupportedEncodingException{
        
         String orderType = "other";
        // long amount = Integer.parseInt(req.getParameter("amount"))*100;
        // String bankCode = req.getParameter("bankCode");

        // long amount = 10000;
        String vnp_Version = "2.1.0";
        String vnp_Command = "pay";
        // long amount = total*100;
        long amount = total*100;
        String bankCode = "NCB";
        
        String vnp_TxnRef = PaymentConfig.getRandomNumber(8);
        // String vnp_IpAddr = PaymentConfig.getIpAddress(req);
         String vnp_IpAddr = "127.0.0.1";


        String vnp_TmnCode = PaymentConfig.vnp_TmnCode;
        
        Map<String, String> vnp_Params = new HashMap<>();
        // vnp_Params.put("vnp_Version", PaymentConfig.vnp_Version);
        // vnp_Params.put("vnp_Command", PaymentConfig.vnp_Command);
        vnp_Params.put("vnp_Version", vnp_Version);
        vnp_Params.put("vnp_Command", vnp_Command);
        vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amount));
        vnp_Params.put("vnp_CurrCode", "VND");

       vnp_Params.put("vnp_BankCode", "NCB");
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_OrderInfo", "Thanh toan don hang:" + vnp_TxnRef);
        vnp_Params.put("vnp_OrderType", orderType);

        vnp_Params.put("vnp_Locale", "vn");
        vnp_Params.put("vnp_ReturnUrl", PaymentConfig.vnp_ReturnUrl+"?amount="+amount);
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);
        
        cld.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);
        
        List fieldNames = new ArrayList(vnp_Params.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        Iterator itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = (String) itr.next();
            String fieldValue = (String) vnp_Params.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                //Build hash data
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                //Build query
                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                query.append('=');
                query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                if (itr.hasNext()) {
                    query.append('&');
                    hashData.append('&');
                }
            }
        }
        String queryUrl = query.toString();
        String vnp_SecureHash = PaymentConfig.hmacSHA512(PaymentConfig.secretKey, hashData.toString());
        queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
        String paymentUrl = PaymentConfig.vnp_PayUrl + "?" + queryUrl;

        PaymentRequest paymentRequest = new PaymentRequest();
        paymentRequest.setStatus("OK");
        paymentRequest.setMessage("Successfully");
        paymentRequest.setURL(paymentUrl);

        // return ResponseEntity.status(HttpStatus.OK).body(paymentRequest);
        return paymentUrl;
    }
    @GetMapping("payment-callback")
    public ResponseEntity<Boolean> paymentCallback(@RequestParam Map<String, String> queryParams,HttpServletResponse response) throws IOException{
        String vnp_ResponseCode = queryParams.get("vnp_ResponseCode");
        String amountString = queryParams.get("amount");
        long amount = Long.parseLong(amountString);
        // long amount = (Long) session.getAttribute("amount");
        boolean paymentSuccess;
            if ("00".equals(vnp_ResponseCode)) {
                response.sendRedirect("http://localhost:4200/payment-success?amount=" + amount);
                paymentSuccess = true;
            } else if ("24".equals(vnp_ResponseCode)){
                response.sendRedirect("http://localhost:4200/payment-failed");
                paymentSuccess = false;
            } else {
                response.sendRedirect("http://localhost:4200/payment-failed");
                paymentSuccess = false;
                
            }
            return ResponseEntity.ok(paymentSuccess);
    }
    // @GetMapping("payment-callback")
    // public ResponseEntity<Map<String, Object>> paymentCallback(@RequestParam Map<String, String> queryParams, HttpServletResponse response) throws IOException {
    //     String vnp_ResponseCode = queryParams.get("vnp_ResponseCode");
    //     Map<String, Object> result = new HashMap<>();
    
    //     if ("00".equals(vnp_ResponseCode)) {
    //         result.put("status", "success");
    //         result.put("redirectUrl", "http://localhost:4200/checkout");
    //     } else if ("24".equals(vnp_ResponseCode)) {
    //         result.put("status", "failure");
    //         result.put("redirectUrl", "http://localhost:4200");
    //     } else {
    //         result.put("status", "failure");
    //         result.put("redirectUrl", "http://localhost:4200");
    //     }

    //     return ResponseEntity.ok(result);
    // }
}
