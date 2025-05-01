import { Calendar } from '@fullcalendar/core'
import dayGridPlugin from '@fullcalendar/daygrid'

document.addEventListener("turbo:load", () => {
  const calendarEl = document.querySelector("[data-controller='calendar']")
  if (!calendarEl) return

  const positionSelect = document.getElementById("positionSelect")
  const memberSelect = document.getElementById("memberSelect")
  const userLabel = document.getElementById("selectedUserLabel")
  const defaultUserId = calendarEl.dataset.userId || null

  let allEvents = []
  let userToPosition = {} // ✅ user_id -> position_id マッピング

  fetch("/api/calendar/histories")
    .then(response => response.json())
    .then(data => {
      allEvents = data.map(item => {
        const event = {
          title: item.name,
          date: item.date,
          position_id: Number(item.position_id),
          user_id: String(item.user_id)
        }
        userToPosition[event.user_id] = event.position_id
        return event
      })

      const calendar = new Calendar(calendarEl, {
        plugins: [dayGridPlugin],
        initialView: "dayGridMonth",
        locale: "ja",
        height: "auto",
        events: [],
        eventDisplay: "auto",
        displayEventTime: false,

       
        eventClick: function(info) {
          const userId = info.event.extendedProps.user_id
          if (userId) {
            window.location.href = `/users/${userId}/trainings`
          }
        }
      })

      calendar.render()

      if (defaultUserId) {
        memberSelect.value = defaultUserId
        const filtered = allEvents.filter(e => e.user_id === defaultUserId)
        calendar.addEventSource(filtered)

        const selectedName = filtered[0]?.title || "選手"
        userLabel.textContent = `${selectedName}のトレーニング履歴`
        userLabel.classList.remove("hidden")

        const posId = userToPosition[defaultUserId]
        if (posId && positionSelect) positionSelect.value = posId
      } else {
        calendar.addEventSource(allEvents)
      }

      positionSelect?.addEventListener("change", () => {
        const selected = positionSelect.value
        const filtered = selected
          ? allEvents.filter(e => e.position_id == selected)
          : allEvents

        calendar.removeAllEvents()
        calendar.addEventSource(filtered)

        if (memberSelect) memberSelect.value = ""
        userLabel.classList.add("hidden")
      })

      memberSelect?.addEventListener("change", () => {
        const selectedUser = memberSelect.value

        const userPositionMap = JSON.parse(calendarEl.dataset.userPositionMap || "{}")
        const posId = userPositionMap[selectedUser] || userToPosition[selectedUser]
        if (posId && positionSelect) positionSelect.value = posId

        const filtered = selectedUser
          ? allEvents.filter(e => e.user_id === selectedUser)
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
      console.error("\u274c カレンダーデータ取得エラー:", error)
    })
})
