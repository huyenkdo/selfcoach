import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="running-session-edit-form"
export default class extends Controller {
  static targets = [
    "freeOrNot", "kind", "intervalFields", "runIntervalKm", "runIntervalTime", "restIntervalTime", "runIntervalNbr"
  ]

  static values = {
    pace: String,
    km: String,
    time: String
  }

  toggleFields() {
    if (this.kindTarget.value === 'Interval') {
      this.intervalFieldsTarget.style.display = 'block'
      this.restIntervalTimeTarget.parentNode.classList.remove('d-none')
      this.runIntervalNbrTarget.parentNode.classList.remove('d-none')
    } else {
      this.intervalFieldsTarget.style.display = 'block'
      this.restIntervalTimeTarget.parentNode.classList.add('d-none')
      this.runIntervalNbrTarget.parentNode.classList.add('d-none')
    }
  }

  updateRunIntervalTime() {
    const runIntervalPace = parseFloat(this.paceValue);
    const runIntervalTime = parseFloat(this.timeValue);
    const kmValue = parseFloat(this.runIntervalKmTarget.value)
    console.log(kmValue)

    if (!isNaN(kmValue)) {
      this.runIntervalTimeTarget.value = (kmValue * runIntervalPace).toFixed(2)
    } else {
      this.runIntervalTimeTarget.value = runIntervalTime
    }
  }

  updateRunIntervalKm() {
    const runIntervalPace = parseFloat(this.paceValue);
    const runIntervalKm = parseFloat(this.kmValue);
    const timeValue = parseFloat(this.runIntervalTimeTarget.value)

    if (!isNaN(timeValue)) {
      this.runIntervalKmTarget.value = (timeValue / runIntervalPace).toFixed(2)
    } else {
      this.runIntervalKmTarget.value = runIntervalKm
    }
  }

  freeOrNotChanged() {
    this.kindTarget.classList.toggle('d-none')
    this.intervalFieldsTarget.classList.toggle('d-none')
  }

  kindChanged() {
    this.toggleFields()
  }
}
