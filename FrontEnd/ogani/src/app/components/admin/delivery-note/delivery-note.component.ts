import { Component, OnInit } from '@angular/core';
import { MessageService } from 'primeng/api';
import { OrderService } from 'src/app/_service/order.service';

@Component({
  selector: 'app-delivery-note',
  templateUrl: './delivery-note.component.html',
  styleUrls: ['./delivery-note.component.css'],
  providers: [MessageService],
})
export class DeliveryNoteComponent implements OnInit {
  listOrder: any;

  constructor(
    private orderService: OrderService,
    private messageService: MessageService
  ) {}

  ngOnInit(): void {
    this.getListOrder();
  }

  getListOrder() {
    this.orderService.getListOrder().subscribe({
      next: (res) => {
        this.listOrder = res;
        console.log(true);
      },
      error: (err) => {
        console.log(err);
      },
    });
  }

  enableOrder(id: number) {
    this.orderService.enableOrder(id).subscribe({
      next: (res) => {
        this.getListOrder();
        this.showSuccess('Đơn hàng đã đã duyệt!!');
      },
      error: (err) => {
        this.showError(err.message);
      },
    });
  }

  showSuccess(text: string) {
    this.messageService.add({
      severity: 'success',
      summary: 'Success',
      detail: text,
    });
  }
  showError(text: string) {
    this.messageService.add({
      severity: 'error',
      summary: 'Error',
      detail: text,
    });
  }

  showWarn(text: string) {
    this.messageService.add({
      severity: 'warn',
      summary: 'Warn',
      detail: text,
    });
  }
}
