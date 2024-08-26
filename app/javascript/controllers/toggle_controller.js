import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ["togglableQuestion1", "togglableQuestion2", "togglableQuestion3", "togglableQuestion4", "togglableInput1", "togglableInput2", "togglableInput3", "togglableInput4", "togglableButton1", "togglableButton2", "togglableButton3", "togglableButton4", "togglableTitle1", "togglableTitle2", "togglableBlock1", "togglableBlock2"]

  fireQuestion2() {
    this.togglableQuestion2Target.classList.toggle("d-none");
    this.togglableInput2Target.classList.toggle("d-none");
    this.togglableButton2Target.classList.toggle("d-none");
    this.togglableQuestion1Target.classList.toggle("d-none");
    this.togglableInput1Target.classList.toggle("d-none");
    this.togglableButton1Target.classList.toggle("d-none");
  }

  fireQuestion3() {
    this.togglableQuestion3Target.classList.toggle("d-none");
    this.togglableInput3Target.classList.toggle("d-none");
    this.togglableButton3Target.classList.toggle("d-none");
    this.togglableQuestion2Target.classList.toggle("d-none");
    this.togglableInput2Target.classList.toggle("d-none");
    this.togglableButton2Target.classList.toggle("d-none");
  }

  fireQuestion4() {
    this.togglableQuestion4Target.classList.toggle("d-none");
    this.togglableInput4Target.classList.toggle("d-none");
    this.togglableButton4Target.classList.toggle("d-none");
    this.togglableQuestion3Target.classList.toggle("d-none");
    this.togglableInput3Target.classList.toggle("d-none");
    this.togglableButton3Target.classList.toggle("d-none");
  }

  fireDispos() {
    this.togglableTitle1Target.classList.toggle("d-none");
    this.togglableTitle2Target.classList.toggle("d-none");
    this.togglableBlock1Target.classList.toggle("d-none");
    this.togglableBlock2Target.classList.toggle("d-none");
  }
}
