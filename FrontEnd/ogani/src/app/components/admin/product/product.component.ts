import { Component, OnInit } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { ConfirmationService, MessageService } from 'primeng/api';
import { CategoryService } from 'src/app/_service/category.service';
import { ImageService } from 'src/app/_service/image.service';
import { ProductService } from 'src/app/_service/product.service';
import { StorageService } from 'src/app/_service/storage.service';

@Component({
  selector: 'app-product',
  templateUrl: './product.component.html',
  styleUrls: ['./product.component.css'],
  providers: [MessageService, ConfirmationService],
})
export class ProductComponent implements OnInit {
  listProduct: any;
  listCategory: any;
  listImage: any;
  userRole: any;

  disabled: boolean = true;

  selectedFiles?: FileList;
  currentFile?: File;

  listImageChoosen: any = [];
  imageChoosen: any;

  onUpdate: boolean = false;
  showForm: boolean = false;
  showImage: boolean = false;
  showDelete: boolean = false;
  submitted = false;
  productForm = new FormGroup({
    id: new FormControl(0),
    name: new FormControl('', [
      Validators.required,
      Validators.minLength(5),
      Validators.maxLength(50),
    ]),
    description: new FormControl('', [
      Validators.required,
      Validators.minLength(0),
      Validators.maxLength(1000),
    ]),
    price: new FormControl(0, [Validators.required, Validators.min(0)]),
    quantity: new FormControl(0, [Validators.required, Validators.min(0)]),
    unit: new FormControl('', [Validators.required]),
    categoryId: new FormControl(0),
    imageIds: new FormControl([]),
  });

  constructor(
    private messageService: MessageService,
    private productService: ProductService,
    private imageService: ImageService,
    private categoryService: CategoryService,
    private storageService: StorageService
  ) {}

  ngOnInit(): void {
    this.getListProduct();
    this.getListCategoryEnabled();
    this.getListImage();
    this.getUserRole();
  }

  getUserRole() {
    this.userRole = this.storageService.getUser().roles[0];
  }

  openNew() {
    this.onUpdate = false;
    this.showForm = true;
    this.submitted = false;
    this.listImageChoosen = [];
    this.productForm.reset();
  }

  openUpdate(data: any) {
    this.submitted = false;
    this.listImageChoosen = [];
    this.onUpdate = true;
    this.showForm = true;
    this.productForm.patchValue({
      id: data.id,
      name: data.name,
      description: data.description,
      price: data.price,
      quantity: data.quantity,
      unit: data.unit,
      categoryId: data.category.id,
    });
    data.images.forEach((res: any) => {
      this.listImageChoosen.push(res);
    });
  }

  onChooseImage() {
    this.showImage = true;
    this.disabled = true;
    let data = document.querySelectorAll('.list-image img');
    data.forEach((i) => {
      i.classList.remove('choosen');
    });
  }

  getListProduct() {
    this.productService.getListProduct().subscribe({
      next: (res) => {
        this.listProduct = res;
      },
      error: (err) => {
        console.log(err);
      },
    });
  }

  getListCategoryEnabled() {
    this.categoryService.getListCategoryEnabled().subscribe({
      next: (res) => {
        this.listCategory = res;
      },
      error: (err) => {
        console.log(err);
      },
    });
  }

  getListImage() {
    this.imageService.getList().subscribe({
      next: (res) => {
        this.listImage = res;
      },
      error: (err) => {
        console.log(err);
      },
    });
  }

  uploadFile(event: any) {
    this.selectedFiles = event.target.files;
    if (this.selectedFiles) {
      const file: File | null = this.selectedFiles.item(0);
      if (file) {
        this.currentFile = file;
        this.imageService.upload(this.currentFile).subscribe({
          next: (res) => {
            this.currentFile = undefined;
            this.getListImage();
          },
          error: (err) => {},
        });
      }
      this.currentFile = undefined;
    }
  }

  createProduct() {
    this.submitted = true;
    let data = this.listImageChoosen;
    this.productForm.get('imageIds')?.setValue(data.map((res: any) => res.id));
    const name = this.productForm.get('name')?.value || '';
    const description = this.productForm.get('description')?.value || '';
    const price = this.productForm.get('price')?.value || 0;
    const quantity = this.productForm.get('quantity')?.value || 0;
    const unit = this.productForm.get('unit')?.value || '';
    const categoryId = this.productForm.get('categoryId')?.value || 0;
    const imageIds = this.productForm.get('imageIds')?.value || [];
    console.log(this.productForm);
    if (this.productForm.valid) {
      this.productService
        .createProduct(
          name,
          description,
          price,
          quantity,
          unit,
          categoryId,
          imageIds
        )
        .subscribe({
          next: (res) => {
            this.getListProduct();
            this.showForm = false;
            this.showSuccess('Thêm mới thành công');
            this.submitted = false;
          },
          error: (err) => {
            this.showError(err.message);
            this.submitted = false;
          },
        });
    }
  }

  updateProduct() {
    this.submitted = true;
    let data = this.listImageChoosen;
    this.productForm.get('imageIds')?.setValue(data.map((res: any) => res.id));
    const id = this.productForm.get('id')?.value || 0;
    const name = this.productForm.get('name')?.value || '';
    const description = this.productForm.get('description')?.value || '';
    const price = this.productForm.get('price')?.value || 0;
    const quantity = this.productForm.get('quantity')?.value || 0;
    const unit = this.productForm.get('unit')?.value || '';
    const categoryId = this.productForm.get('categoryId')?.value || 0;
    const imageIds = this.productForm.get('imageIds')?.value || [];
    if (this.productForm.valid) {
      this.productService
        .updateProduct(
          id,
          name,
          description,
          price,
          quantity,
          unit,
          categoryId,
          imageIds
        )
        .subscribe({
          next: (res) => {
            this.getListProduct();
            this.showForm = false;
            this.showSuccess('Cập nhật thành công');
            this.submitted = false;
          },
          error: (err) => {
            this.showError(err.message);
            this.submitted = false;
          },
        });
    }
  }

  enableProdcut(id: number) {
    this.productService.enableProduct(id).subscribe({
      next: (res) => {
        this.getListProduct();
        this.showSuccess('Cập nhật thành công!!');
      },
      error: (err) => {
        this.showError(err.message);
      },
    });
  }

  onDelete(id: number, name: string) {
    this.productForm.patchValue({
      id: 0,
    });
    this.showDelete = true;
    this.productForm.patchValue({
      id: id,
      name: name,
    });
  }

  deleteProduct() {
    const id = this.productForm.get('id')?.value || 0;
    this.productService.deleteProduct(id).subscribe({
      next: (res) => {
        this.getListProduct();
        this.showWarn('Xóa thành công');
        this.showDelete = false;
      },
      error: (err) => {
        this.showError(err.message);
      },
    });
  }

  chooseImage() {
    this.listImageChoosen.push(this.imageChoosen);
    this.showImage = false;
  }

  deleteImage() {
    this.imageService.deleteImage(this.imageChoosen.id).subscribe({
      next: (res) => {
        this.getListImage();
        this.showWarn('Xóa thành công');
      },
      error: (err) => {
        this.showError(err.message);
      },
    });
  }

  selectImage(event: any, res: any) {
    let data = document.querySelectorAll('.list-image img');
    data.forEach((i) => {
      i.classList.remove('choosen');
    });
    event.target.classList.toggle('choosen');
    this.imageChoosen = res;
    this.disabled = false;
  }

  deleteImageOnDoubleClick(image: any) {
    const index = this.listImageChoosen.findIndex(
      (img: any) => img.id === image.id
    );
    if (index !== -1) {
      this.listImageChoosen.splice(index, 1);
    }
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
