import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-payment-failed',
  templateUrl: './payment-failed.component.html',
  styleUrls: ['./payment-failed.component.css'],
})
export class PaymentFailedComponent {
  constructor(private router: Router) {}
  ngOnInit(): void {
    setTimeout(() => {
      // Thực hiện chuyển hướng sau 10 giây
      this.router.navigate(['/checkout']);
    }, 3000);
  }
}
