import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="running-session-edit-form"
export default class extends Controller {
  static targets = [
    "freeOrNot", "kind", "intervalFields", "runIntervalKm", "runIntervalTime", "restIntervalTime", "runIntervalNbr", "kindInput", "totalRunTime", "restIntervalTimeInput", "runIntervalNbrInput"
  ]

  static values = {
    pace: String,
    km: String,
    time: String
  }

  toggleFields() {
    if (this.kindInputTarget.value === 'Interval') {
      this.intervalFieldsTarget.style.display = 'block'
      this.restIntervalTimeTarget.classList.remove('d-none')
      this.runIntervalNbrTarget.classList.remove('d-none')
    } else {
      this.intervalFieldsTarget.style.display = 'block'
      this.restIntervalTimeTarget.classList.add('d-none')
      this.runIntervalNbrTarget.classList.add('d-none')
    }
  }

  updateRunIntervalTime() {
    const runIntervalPace = parseFloat(this.paceValue);
    const runIntervalTime = parseFloat(this.timeValue);
    const kmValue = parseFloat(this.runIntervalKmTarget.value)

    if (!isNaN(kmValue)) {
      this.runIntervalTimeTarget.value = (kmValue * runIntervalPace).toFixed(2)
    } else {
      this.runIntervalTimeTarget.value = runIntervalTime
    }

    this.totalRunTimeTarget.innerHTML = "Durée totale : " + this.runIntervalTimeTarget.value + " mins"
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

    this.totalRunTimeTarget.innerHTML = "Durée totale : " + this.runIntervalTimeTarget.value + " mins"
  }

  updateTotalTime() {
    const totalTime = (this.runIntervalTimeTarget.value * this.runIntervalNbrInputTarget.value) + (this.restIntervalTimeInputTarget.value * (this.runIntervalNbrInputTarget.value - 1))
    this.totalRunTimeTarget.innerHTML = "Durée totale : " + parseFloat(totalTime).toFixed(2) + " mins"
  }

  freeOrNotChanged() {
    this.kindTarget.classList.toggle('d-none')
    this.intervalFieldsTarget.classList.toggle('d-none')
    this.totalRunTimeTarget.classList.toggle('d-none')
  }

  kindChanged() {
    this.toggleFields()
  }
}
