import { Calendar } from '@fullcalendar/core'
import dayGridPlugin from '@fullcalendar/daygrid'

document.addEventListener("turbo:load", () => {
  const calendarEl = document.querySelector("[data-controller='calendar']")
  if (!calendarEl) return

  const positionSelect = document.getElementById("positionSelect")
  let allEvents = [] // ← フィルタ用に全データを保存しておく

  fetch('/api/calendar/histories')
    .then(response => response.json())
    .then(data => {
      // データを保存（後でフィルタに使う）
      allEvents = data.map(item => ({
        title: item.name,
        date: item.date,
        position_id: item.position_id // ← フィルタに必要
      }))

      // 初期表示（全イベント）
      const calendar = new Calendar(calendarEl, {
        plugins: [dayGridPlugin],
        initialView: 'dayGridMonth',
        locale: 'ja',
        height: 'auto',
        events: allEvents, // ← 最初は全表示
        eventDisplay: 'auto',
        displayEventTime: false
      })

      calendar.render()

      // ポジション選択でフィルタリング
      positionSelect?.addEventListener("change", () => {
        const selected = positionSelect.value
        const filtered = selected
          ? allEvents.filter(e => e.position_id == selected)
          : allEvents

        calendar.removeAllEvents()
        calendar.addEventSource(filtered)
      })
    })
    .catch(error => {
      console.error("❌ カレンダーデータ取得エラー:", error)
    })
})
