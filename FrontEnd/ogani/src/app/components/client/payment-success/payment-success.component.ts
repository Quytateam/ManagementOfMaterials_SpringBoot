import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-payment-success',
  templateUrl: './payment-success.component.html',
  styleUrls: ['./payment-success.component.css'],
})
export class PaymentSuccessComponent implements OnInit {
  amount: any;
  constructor(private router: Router, private route: ActivatedRoute) {}
  ngOnInit(): void {
    this.amount = this.route.snapshot.queryParams['amount'];
    setTimeout(() => {
      // Thực hiện chuyển hướng sau 10 giây
      this.router.navigate(['/checkout'], {
        queryParams: { paymentStatus: 'success' },
      });
    }, 3000);
  }
}
