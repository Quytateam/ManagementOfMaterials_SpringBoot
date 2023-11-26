import { Component, OnInit } from '@angular/core';
import { OrderService } from 'src/app/_service/order.service';
import { StorageService } from 'src/app/_service/storage.service';
import { concatMap, from } from 'rxjs';
import { ProductService } from 'src/app/_service/product.service';
import { MessageService } from 'primeng/api';

@Component({
  selector: 'app-my-order',
  templateUrl: './my-order.component.html',
  styleUrls: ['./my-order.component.css'],
  providers: [MessageService],
})
export class MyOrderComponent implements OnInit {
  listOrder: any;
  listDetail: any;
  username: any;
  deleteForm: boolean = false;
  orderId: any;
  constructor(
    private orderService: OrderService,
    private storageService: StorageService,
    private productService: ProductService,
    private messageService: MessageService
  ) {}

  ngOnInit(): void {
    this.username = this.storageService.getUser().username;
    this.getListOrder();
  }

  getListOrder() {
    this.orderService.getListOrderByUser(this.username).subscribe({
      next: (res) => {
        this.listOrder = res;
      },
      error: (err) => {
        console.log(err);
      },
    });
  }
  onDelete(id: number) {
    this.orderId = id;
    this.deleteForm = true;
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

  deleteOrder() {
    this.orderService.getListOrderDetail(this.orderId).subscribe({
      next: (res) => {
        this.listDetail = res;
        console.log(res);
        from(this.listDetail)
          .pipe(
            concatMap((item: any) => {
              return this.productService.updateQuantityProduct(
                item.product.id,
                item.quantity
              );
            })
          )
          .subscribe({
            next: (res) => {
              // this.showSuccess('Cập nhật thành công!!');
            },
            error: (err) => {
              this.showError(err.message);
            },
          });
        this.orderService.deleteOrder(this.orderId).subscribe({
          next: (res) => {
            this.getListOrder();
            this.showWarn('Xóa phiếu nhập hàng thành công!!');
            this.deleteForm = false;
          },
          error: (err) => {
            this.showError(err.message);
          },
        });
      },
      error: (err) => {
        console.log(err);
      },
    });
    this.deleteForm = false;
  }
}
