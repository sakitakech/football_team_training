import { Controller } from "@hotwired/stimulus"
import { Calendar } from "@fullcalendar/core"
import dayGridPlugin from "@fullcalendar/daygrid"

export default class extends Controller {
  connect() {
    const calendarEl = this.element

    const calendar = new Calendar(calendarEl, {
      plugins: [dayGridPlugin],
      initialView: "dayGridMonth",
      events: [], // ← 最初は空、後でAPIからデータ読み込む
      locale: 'ja', // 日本語にしたい場合
      height: "auto",
    })

    calendar.render()
  }
}
