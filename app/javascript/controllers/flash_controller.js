import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // ตั้งเวลาปิดแถบแจ้งเตือนอัตโนมัติหลังผ่านไป 2 วินาที (2000 ms)
    setTimeout(() => {
      this.dismiss()
    }, 2000)
  }

  dismiss() {
    // ค่อยๆ จางลงก่อนลบองค์ประกอบออกจากหน้าจอ
    this.element.style.transition = "opacity 0.5s ease"
    this.element.style.opacity = "0"

    setTimeout(() => {
      this.element.remove()
    }, 500)
  }
}
