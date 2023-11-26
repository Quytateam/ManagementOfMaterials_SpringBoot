import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { MessageService } from 'primeng/api';
import { AuthService } from 'src/app/_service/auth.service';
import { StorageService } from 'src/app/_service/storage.service';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { CartService } from 'src/app/_service/cart.service';
@Component({
  selector: 'app-login-page',
  templateUrl: './login-page.component.html',
  styleUrls: ['./login-page.component.css'],
  providers: [MessageService],
})
export class LoginPageComponent implements OnInit {
  isSuccessful = false;
  isSignUpFailed = false;
  isLoggedIn = false;
  isLoginFailed = false;
  roles: string[] = [];
  errorMessage = '';
  submitted = false;

  loginForm: any = {
    username: null,
    password: null,
  };

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
      Validators.minLength(5),
      Validators.maxLength(30),
    ]),
  });

  constructor(
    private authService: AuthService,
    private storageService: StorageService,
    private messageService: MessageService,
    private router: Router,
    public cartService: CartService
  ) {}

  ngOnInit(): void {}

  login(): void {
    const { username, password } = this.loginForm;
    console.log(this.loginForm);
    this.authService.login(username, password).subscribe({
      next: (res) => {
        this.storageService.saveUser(res);
        this.isLoggedIn = true;
        this.isLoginFailed = false;
        this.roles = this.storageService.getUser().roles;
        this.cartService.clearCart();
        this.showSuccess('Đăng nhập thành công!!');
        this.router.navigate(['/']);
      },
      error: (err) => {
        console.log(err);
        this.isLoggedIn = false;
        this.isLoginFailed = true;
      },
    });
  }

  register(): void {
    const username = this.registerForm.get('username')?.value || '';
    const email = this.registerForm.get('email')?.value || '';
    const password = this.registerForm.get('password')?.value || '';
    if (this.registerForm.valid) {
      this.authService.register(username, email, password).subscribe({
        next: (res) => {
          this.isSuccessful = true;
          this.isSignUpFailed = false;
          this.showSuccess('Đăng ký thành công');
          this.loginForm.username = username;
          this.loginForm.password = password;
          this.login();
        },
        error: (err) => {
          this.showError(err.message);
          this.errorMessage = err.error.message;
          this.isSignUpFailed = true;
        },
      });
    }
  }

  loginFormChange() {
    document
      .getElementById('container')
      ?.classList.remove('right-panel-active');
  }
  registerFormChange() {
    document.getElementById('container')?.classList.add('right-panel-active');
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
