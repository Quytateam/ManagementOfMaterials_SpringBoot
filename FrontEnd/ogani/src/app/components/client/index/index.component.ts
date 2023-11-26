import { HttpClient } from '@angular/common/http';
import {
  Component,
  OnInit,
  ChangeDetectorRef,
  AfterContentChecked,
} from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { text } from '@fortawesome/fontawesome-svg-core';
import {
  faBars,
  faHeart,
  faRightFromBracket,
  faUser,
} from '@fortawesome/free-solid-svg-icons';
import { faShoppingBag } from '@fortawesome/free-solid-svg-icons';
import { faPhone } from '@fortawesome/free-solid-svg-icons';
import { MessageService } from 'primeng/api';
import { AuthService } from 'src/app/_service/auth.service';
import { CartService } from 'src/app/_service/cart.service';
import { CategoryService } from 'src/app/_service/category.service';
import { StorageService } from 'src/app/_service/storage.service';
import { WishlistService } from 'src/app/_service/wishlist.service';

@Component({
  selector: 'app-index',
  templateUrl: './index.component.html',
  styleUrls: ['./index.component.css'],
  providers: [MessageService],
})
export class IndexComponent implements OnInit {
  listItemInCart: any[] = [];
  totalPrice = 0;
  heart = faHeart;
  bag = faShoppingBag;
  phone = faPhone;
  userIcon = faUser;
  logoutIcon = faRightFromBracket;
  bars = faBars;
  submitted = false;
  userRole: any;

  showDepartment = false;

  loginForm: any = {
    username: null,
    password: null,
  };

  // registerForm: any = {
  //   username: null,
  //   email: null,
  //   password: null,
  // };

  registerForm = new FormGroup({
    username: new FormControl('', [
      Validators.required,
      Validators.minLength(5),
      Validators.maxLength(30),
    ]),
    email: new FormControl('', [
      Validators.required,
      Validators.email,
      Validators.minLength(5),
      Validators.maxLength(30),
    ]),
    password: new FormControl('', [
      Validators.required,
      Validators.minLength(6),
      Validators.maxLength(30),
    ]),
  });

  isSuccessful = false;
  isSignUpFailed = false;
  isLoggedIn = false;
  isLoginFailed = false;
  roles: string[] = [];
  errorMessage = '';
  authModal: boolean = false;
  listCategoryEnabled: any;

  hello = '';

  keyword: any;

  constructor(
    public cartService: CartService,
    public wishlistService: WishlistService,
    private authService: AuthService,
    private storageService: StorageService,
    private messageService: MessageService,
    private categoryService: CategoryService,
    private router: Router,
    private http: HttpClient
  ) {}

  ngOnInit(): void {
    this.getCategoryEnbled();
    this.isLoggedIn = this.storageService.isLoggedIn();
    this.wishlistService.loadWishList();
    this.cartService.loadCart();
    this.http.get('http://localhost:8080/hello/').subscribe((res) => {});
    this.getUser();
    // console.log(this.cartService.getItems());
  }

  getUser() {
    this.userRole = this.storageService.getUser().roles[0];
  }

  showDepartmentClick() {
    this.showDepartment = !this.showDepartment;
  }

  getCategoryEnbled() {
    this.categoryService.getListCategoryEnabled().subscribe({
      next: (res) => {
        this.listCategoryEnabled = res;
      },
      error: (err) => {
        console.log(err);
      },
    });
  }

  removeFromCart(item: any) {
    this.cartService.remove(item);
  }

  removeWishList(item: any) {
    this.wishlistService.remove(item);
  }

  showAuthForm() {
    if (!this.isLoggedIn) {
      this.authModal = true;
      this.loginForm = { username: null, password: null };
      // this.registerForm = { username: null, email: null, password: null };
      this.registerForm.setValue({
        username: null,
        email: null,
        password: null,
      });
    }
  }

  login(): void {
    const { username, password } = this.loginForm;
    console.log(this.loginForm);
    this.authService.login(username, password).subscribe({
      next: (res) => {
        this.storageService.saveUser(res);
        this.isLoggedIn = true;
        this.isLoginFailed = false;
        this.roles = this.storageService.getUser().roles;
        this.showSuccess('Đăng nhập thành công!!');
        this.authModal = false;
      },
      error: (err) => {
        console.log(err);
        this.isLoggedIn = false;
        this.isLoginFailed = true;
        this.showError(err.message);
      },
    });
  }

  register(): void {
    // const { username, email, password } = this.registerForm;
    this.submitted = true;
    const username = this.registerForm.get('username')?.value || '';
    const email = this.registerForm.get('email')?.value || '';
    const password = this.registerForm.get('password')?.value || '';
    if (this.registerForm.valid) {
      this.authService.register(username, email, password).subscribe({
        next: (res) => {
          this.isSuccessful = true;
          this.isSignUpFailed = false;
          this.loginForm.username = username;
          this.loginForm.password = password;
          this.login();
          this.authModal = false;
        },
        error: (err) => {
          this.errorMessage = err.error.message;
          this.isSignUpFailed = true;
        },
      });
    }
  }

  logout(): void {
    this.authService.logout().subscribe({
      next: (res) => {
        this.storageService.clean();
        this.isLoggedIn = false;
        this.authModal = false;
        this.showSuccess('Bạn đã đăng xuất!!');
        this.cartService.clearCart();
        this.router.navigate(['/']);
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
