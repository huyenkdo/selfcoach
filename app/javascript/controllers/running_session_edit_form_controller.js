import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="running-session-edit-form"
export default class extends Controller {
  static targets = [
    "freeOrNot", "kind", "intervalFields", "runIntervalKm", "runIntervalTime", "restIntervalTime", "runIntervalNbr"
  ]

  toggleFields() {
    if (!this.freeOrNotTarget.checked) {
      this.intervalFieldsTarget.classList = 'd-none'
    } else {
      if (this.kindTarget.value === 'Interval') {
        this.intervalFieldsTarget.style.display = 'block'
        this.restIntervalTimeTarget.parentNode.style.display = ''
        this.runIntervalNbrTarget.parentNode.style.display = ''
      } else {
        this.intervalFieldsTarget.style.display = 'block'
        this.restIntervalTimeTarget.parentNode.style.display = 'none'
        this.runIntervalNbrTarget.parentNode.style.display = 'none'
      }
    }
  }

  updateRunIntervalTime() {
    const runIntervalPace = 6; // Assume 6 mins per km
    const kmValue = parseFloat(this.runIntervalKmTarget.value)

    if (!isNaN(kmValue)) {
      this.runIntervalTimeTarget.value = (kmValue * runIntervalPace).toFixed(2)
    }
  }

  freeOrNotChanged() {
    this.toggleFields()
  }

  kindChanged() {
    this.toggleFields()
  }
}
