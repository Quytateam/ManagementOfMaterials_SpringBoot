import { Injectable } from '@angular/core';
import { ActivatedRouteSnapshot, CanActivate, Router } from '@angular/router';
import { CartService } from './cart.service';
import { ActivatedRoute } from '@angular/router';

@Injectable({
  providedIn: 'root',
})
export class BlockPaymentService implements CanActivate {
  constructor(
    public cartService: CartService,
    private router: Router,
    private route: ActivatedRoute
  ) {}
  currentRouteName: string = this.route.snapshot.routeConfig?.path || '';
  canActivate(): boolean {
    const cart = localStorage.getItem('cart_items');
    if (cart === null) {
      this.router.navigate(['/', { currentRouteName: this.currentRouteName }]);
      return false;
    }
    return true;
  }
}
