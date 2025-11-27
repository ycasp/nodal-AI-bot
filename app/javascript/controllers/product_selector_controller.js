import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="product-selector"
export default class extends Controller {
  static targets = ["all", "box", "categoryBox"]

  static values = {
    category: String,
  }

  connect() {

  }

  select_all(event) {
    const all_bool = this.allTarget.checked;
    this.boxTargets.forEach((box) => box.checked = all_bool);
    this.categoryBoxTargets.forEach((categoryBox) => categoryBox.checked = all_bool);
  }

  select_cat(event) {
    const category_bool = event.target.checked;
    const category = event.target.id;
    this.boxTargets.forEach((box) => {
      if (box.dataset.category === category) {
        box.checked = category_bool;
      };
    });

    const count = this.categoryBoxTargets.filter((box) => box.checked === true).length;
    this.allTarget.checked = (count === this.categoryBoxTargets.length);
  }

  check_all_selected(event) {
    const count = this.boxTargets.filter((box) => box.checked === true).length;
    this.allTarget.checked = (count === this.boxTargets.length);

    this.categoryBoxTargets.forEach((cat_box) => {
      const cat_boxes = this.boxTargets.filter((box) => box.dataset.category === cat_box.id);
      const cat_count = cat_boxes.length;
      const cat_count_active = cat_boxes.filter((box) => box.checked).length;
      cat_box.checked = (cat_count === cat_count_active);
    });
  }
}
