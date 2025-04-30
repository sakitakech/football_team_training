import { Calendar } from '@fullcalendar/core'
import dayGridPlugin from '@fullcalendar/daygrid'

document.addEventListener("turbo:load", () => {
  const calendarEl = document.querySelector("[data-controller='calendar']")
  if (!calendarEl) return

  fetch('/api/calendar/histories')
    .then(response => response.json())
    .then(data => {
      // APIデータをFullCalendarのイベント形式に変換
      const events = data.map(item => ({
        title: item.name,
        date: item.date
      }))

      const calendar = new Calendar(calendarEl, {
        plugins: [dayGridPlugin],
        initialView: 'dayGridMonth',
        locale: 'ja',
        height: 'auto',
        events: events,
        eventDisplay: 'auto',
        displayEventTime: false
      })

      calendar.render()
    })
    .catch(error => {
      console.error("❌ カレンダーデータ取得エラー:", error)
    })
})
