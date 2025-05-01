import { Calendar } from '@fullcalendar/core'
import dayGridPlugin from '@fullcalendar/daygrid'

document.addEventListener("turbo:load", () => {
  const calendarEl = document.querySelector("[data-controller='calendar']")
  if (!calendarEl) return

  const positionSelect = document.getElementById("positionSelect")
  const memberSelect = document.getElementById("memberSelect")
  const userLabel = document.getElementById("selectedUserLabel")

  let allEvents = []

  fetch('/api/calendar/histories')
    .then(response => response.json())
    .then(data => {
      allEvents = data.map(item => ({
        title: item.name,
        date: item.date,
        position_id: item.position_id,
        user_id: item.user_id
      }))

      const calendar = new Calendar(calendarEl, {
        plugins: [dayGridPlugin],
        initialView: 'dayGridMonth',
        locale: 'ja',
        height: 'auto',
        events: allEvents,
        eventDisplay: 'auto',
        displayEventTime: false,
        eventClick: function(info) {
          const userId = info.event.extendedProps.user_id
          if (userId) {
            window.location.href = `/users/${userId}/trainings`
          }
        }
      })

      calendar.render()

      // ポジションフィルター
      positionSelect?.addEventListener("change", () => {
        const selected = positionSelect.value
        const filtered = selected
          ? allEvents.filter(e => e.position_id == selected)
          : allEvents

        calendar.removeAllEvents()
        calendar.addEventSource(filtered)
      })

      // 選手フィルター
      memberSelect?.addEventListener("change", () => {
        const selectedUser = memberSelect.value

        const filtered = selectedUser
          ? allEvents.filter(e => e.user_id == selectedUser)
          : allEvents

        calendar.removeAllEvents()
        calendar.addEventSource(filtered)

        if (selectedUser) {
          const selectedName = filtered[0]?.title || "選手"
          userLabel.textContent = `${selectedName}のトレーニング履歴`
          userLabel.classList.remove("hidden")
        } else {
          userLabel.classList.add("hidden")
        }
      })
    })
    .catch(error => {
      console.error("❌ カレンダーデータ取得エラー:", error)
    })
})
