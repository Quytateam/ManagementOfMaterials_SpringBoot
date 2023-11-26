import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { DashboardComponent } from './components/admin/dashboard/dashboard.component';
import { CategoryComponent } from './components/admin/category/category.component';
import { ProductComponent } from './components/admin/product/product.component';
import { BlogComponent } from './components/admin/blog/blog.component';
import { AccountComponent } from './components/admin/account/account.component';
import { IndexComponent } from './components/client/index/index.component';
import { FontAwesomeModule } from '@fortawesome/angular-fontawesome';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { CardModule } from 'primeng/card';
import { DialogModule } from 'primeng/dialog';
import { ToastModule } from 'primeng/toast';
import { ButtonModule } from 'primeng/button';
import { TableModule } from 'primeng/table';
import { InputNumberModule } from 'primeng/inputnumber';
import { FormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { ToolbarModule } from 'primeng/toolbar';
import { FileUploadModule } from 'primeng/fileupload';
import { ConfirmDialogModule } from 'primeng/confirmdialog';
import { InputTextareaModule } from 'primeng/inputtextarea';
import { InputTextModule } from 'primeng/inputtext';
import { RadioButtonModule } from 'primeng/radiobutton';
import { DividerModule } from 'primeng/divider';
import { CarouselModule } from 'primeng/carousel';
import { HomeComponent } from './components/client/home/home.component';
import { OverlayPanelModule } from 'primeng/overlaypanel';
import { ShopComponent } from './components/client/shop/shop.component';
import { ProductDetailComponent } from './components/client/product-detail/product-detail.component';
import { CartComponent } from './components/client/cart/cart.component';
import { CheckoutComponent } from './components/client/checkout/checkout.component';
import { TabViewModule } from 'primeng/tabview';
import { PasswordModule } from 'primeng/password';
import { SliderModule } from 'primeng/slider';
import { DataViewModule } from 'primeng/dataview';
import { TagComponent } from './components/admin/tag/tag.component';
import { MultiSelectModule } from 'primeng/multiselect';
import { BlogClientComponent } from './components/client/blog-client/blog-client.component';
import { BlogDetailComponent } from './components/client/blog-detail/blog-detail.component';
import { UserDetailComponent } from './components/client/user-detail/user-detail.component';
import { MyOrderComponent } from './components/client/my-order/my-order.component';
import { SearchComponent } from './components/client/search/search.component';
import { LoginPageComponent } from './components/client/login-page/login-page.component';
import { ImportCouponComponent } from './components/admin/import-coupon/import-coupon.component';
import { ImportCouponDetailComponent } from './components/admin/import-coupon-detail/import-coupon-detail.component';
import { DeliveryNoteComponent } from './components/admin/delivery-note/delivery-note.component';
import { DeliveryNoteDetailComponent } from './components/admin/delivery-note-detail/delivery-note-detail.component';
import { SupplierComponent } from './components/admin/supplier/supplier.component';
import { AccountInfoComponent } from './components/admin/account-info/account-info.component';
import { ReactiveFormsModule } from '@angular/forms';
import { ContactComponent } from './components/client/contact/contact.component';
import { PaymentFailedComponent } from './components/client/payment-failed/payment-failed.component';
import { PaymentSuccessComponent } from './components/client/payment-success/payment-success.component';
@NgModule({
  declarations: [
    AppComponent,
    DashboardComponent,
    CategoryComponent,
    ProductComponent,
    BlogComponent,
    AccountComponent,
    IndexComponent,
    HomeComponent,
    CartComponent,
    CheckoutComponent,
    ShopComponent,
    ProductDetailComponent,
    TagComponent,
    BlogClientComponent,
    BlogDetailComponent,
    UserDetailComponent,
    MyOrderComponent,
    SearchComponent,
    LoginPageComponent,
    ImportCouponComponent,
    ImportCouponDetailComponent,
    DeliveryNoteComponent,
    DeliveryNoteDetailComponent,
    SupplierComponent,
    AccountInfoComponent,
    ContactComponent,
    PaymentFailedComponent,
    PaymentSuccessComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FontAwesomeModule,
    NgbModule,
    CardModule,
    DialogModule,
    ToastModule,
    ButtonModule,
    TableModule,
    InputNumberModule,
    FormsModule,
    HttpClientModule,
    BrowserAnimationsModule,
    ToolbarModule,
    FileUploadModule,
    ConfirmDialogModule,
    InputTextareaModule,
    InputTextModule,
    RadioButtonModule,
    DividerModule,
    CarouselModule,
    OverlayPanelModule,
    TabViewModule,
    PasswordModule,
    SliderModule,
    DataViewModule,
    MultiSelectModule,
    ReactiveFormsModule,
  ],
  providers: [],
  bootstrap: [AppComponent],
})
export class AppModule {}
