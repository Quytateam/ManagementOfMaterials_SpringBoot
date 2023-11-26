import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { BlogComponent } from './components/admin/blog/blog.component';
import { CategoryComponent } from './components/admin/category/category.component';
import { DashboardComponent } from './components/admin/dashboard/dashboard.component';
import { ProductComponent } from './components/admin/product/product.component';
import { TagComponent } from './components/admin/tag/tag.component';
import { BlogClientComponent } from './components/client/blog-client/blog-client.component';
import { BlogDetailComponent } from './components/client/blog-detail/blog-detail.component';
import { CartComponent } from './components/client/cart/cart.component';
import { CheckoutComponent } from './components/client/checkout/checkout.component';
import { HomeComponent } from './components/client/home/home.component';
import { IndexComponent } from './components/client/index/index.component';
import { LoginPageComponent } from './components/client/login-page/login-page.component';
import { MyOrderComponent } from './components/client/my-order/my-order.component';
import { ProductDetailComponent } from './components/client/product-detail/product-detail.component';
import { SearchComponent } from './components/client/search/search.component';
import { ShopComponent } from './components/client/shop/shop.component';
import { UserDetailComponent } from './components/client/user-detail/user-detail.component';
import { AuthGuardService } from './_service/auth-guard.service';
import { RoleGuardService } from './_service/role-guard.service';
import { ImportCouponComponent } from './components/admin/import-coupon/import-coupon.component';
import { ImportCouponDetailComponent } from './components/admin/import-coupon-detail/import-coupon-detail.component';
import { DeliveryNoteComponent } from './components/admin/delivery-note/delivery-note.component';
import { DeliveryNoteDetailComponent } from './components/admin/delivery-note-detail/delivery-note-detail.component';
import { SupplierComponent } from './components/admin/supplier/supplier.component';
import { AccountComponent } from './components/admin/account/account.component';
import { AccountInfoComponent } from './components/admin/account-info/account-info.component';
import { ContactComponent } from './components/client/contact/contact.component';
import { PaymentSuccessComponent } from './components/client/payment-success/payment-success.component';
import { PaymentFailedComponent } from './components/client/payment-failed/payment-failed.component';
import { BlockPaymentService } from './_service/block-payment.service';

const routes: Routes = [
  {
    path: 'admin',
    component: DashboardComponent,
    canActivate: [RoleGuardService],
    // data: { expectedRole: 'ROLE_ADMIN' },
    data: { expectedRole: ['ROLE_ADMIN', 'ROLE_MODERATOR'] },
    children: [
      { path: 'category', component: CategoryComponent },
      { path: 'product', component: ProductComponent },
      { path: 'supplier', component: SupplierComponent },
      { path: 'import-coupon', component: ImportCouponComponent },
      { path: 'import-coupon/:id', component: ImportCouponDetailComponent },
      { path: 'account', component: AccountComponent },
      { path: 'account/:id', component: AccountInfoComponent },
      { path: 'delivery-note', component: DeliveryNoteComponent },
      { path: 'delivery-note/:id', component: DeliveryNoteDetailComponent },
      { path: 'blog', component: BlogComponent },
      { path: 'tag', component: TagComponent },
    ],
  },
  {
    path: '',
    component: IndexComponent,
    children: [
      { path: '', component: HomeComponent },
      { path: 'cart', component: CartComponent },
      {
        path: 'checkout',
        component: CheckoutComponent,
        canActivate: [AuthGuardService],
      },
      { path: 'category/:id', component: ShopComponent },
      { path: 'product/:id', component: ProductDetailComponent },
      { path: 'blog', component: BlogClientComponent },
      { path: 'blog/:id', component: BlogDetailComponent },
      {
        path: 'user',
        component: UserDetailComponent,
        canActivate: [AuthGuardService],
      },
      {
        path: 'my-order',
        component: MyOrderComponent,
        canActivate: [AuthGuardService],
      },
      { path: 'search/:keyword', component: SearchComponent },
      { path: 'contact', component: ContactComponent },
      { path: 'payment-success', component: PaymentSuccessComponent },
      { path: 'payment-failed', component: PaymentFailedComponent },
    ],
  },
  { path: 'login', component: LoginPageComponent },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
