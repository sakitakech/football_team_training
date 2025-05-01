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

  fetch("/api/calendar/histories")
    .then(response => response.json())
    .then(data => {
      allEvents = data.map(item => ({
        title: item.name,
        date: item.date,
        position_id: Number(item.position_id),
        user_id: String(item.user_id) // ← 統一して文字列化
      }))

      const calendar = new Calendar(calendarEl, {
        plugins: [dayGridPlugin],
        initialView: "dayGridMonth",
        locale: "ja",
        height: "auto",
        events: [], // 初期空
        eventDisplay: "auto",
        displayEventTime: false
      })

      calendar.render()

      // ✅ 初期状態：user_id指定があればそれだけ表示
      if (defaultUserId) {
        memberSelect.value = defaultUserId
        const filtered = allEvents.filter(e => e.user_id === defaultUserId)
        calendar.addEventSource(filtered)

        const selectedName = filtered[0]?.title || "選手"
        userLabel.textContent = `${selectedName}のトレーニング履歴`
        userLabel.classList.remove("hidden")
      } else {
        calendar.addEventSource(allEvents)
      }

      // ✅ ポジションフィルター
      positionSelect?.addEventListener("change", () => {
        const selected = positionSelect.value
        const filtered = selected
          ? allEvents.filter(e => e.position_id == selected)
          : allEvents

        calendar.removeAllEvents()
        calendar.addEventSource(filtered)
      })

      // ✅ 選手フィルター
      memberSelect?.addEventListener("change", () => {
        const selectedUser = memberSelect.value

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
      console.error("❌ カレンダーデータ取得エラー:", error)
    })
})
