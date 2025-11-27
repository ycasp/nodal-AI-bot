import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="product-selector"
export default class extends Controller {
  static targets = ["all", "box"]

  connect() {

  }

  select(event) {
    const all_bool = this.allTarget.checked
    this.boxTargets.forEach((box) => box.checked = all_bool)
  }
}
