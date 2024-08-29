import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modalElement"]

  connect() {
    this.modal = new bootstrap.Modal(this.modalElementTarget)
  }

  open(event) {
    const url = event.currentTarget.dataset.url
    this.getContent(url);
    this.modal.show();
  }

  close() {
    this.modal.hide();
  }

  async getContent(url) {
    const response = await fetch(url)
    const html = await response.text();

    const modalBody = this.modalElementTarget.querySelector(".modal-content");
    modalBody.innerHTML = html
  }
}
