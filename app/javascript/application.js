// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

import Chart from 'chart.js/auto'

document.addEventListener("DOMContentLoaded", () => {
  const userId = 23
  let maxData = {}  // 種目別マックス値
  let bodyData = [] // 体重・体脂肪率

  const now = new Date()
  let endDate = now
  let startDate = new Date(now)
  startDate.setDate(now.getDate() - 30)

  const maxCtx = document.getElementById("maxChart")
  const bodyCtx = document.getElementById("bodyChart")
  let maxChart, bodyChart

  const filterByDate = (data, start, end) => {
    const startYMD = start.toISOString().slice(0, 10)
    const endYMD = end.toISOString().slice(0, 10)
    return data.filter(d => {
      const dateYMD = d.date
      return dateYMD >= startYMD && dateYMD <= endYMD
    })
  }

  const generateDateRange = (start, end) => {
    const range = []
    const current = new Date(start)
    while (current <= end) {
      range.push(current.toISOString().slice(0, 10))
      current.setDate(current.getDate() + 1)
    }
    return range
  }

  fetch(`/api/charts/max_weights?user_id=${userId}`)
    .then(res => res.json())
    .then(data => {
      maxData = data.reduce((acc, cur) => {
        if (!acc[cur.name]) acc[cur.name] = []
        acc[cur.name].push({ date: cur.date, value: Number(cur.value), timestamp: new Date(cur.date).getTime() })
        return acc
      }, {})
      renderMaxChart()
    })
    .catch(error => console.error("❌ マックスデータ取得エラー：", error))

  fetch(`/api/charts/body_metrics?user_id=${userId}`)
    .then(res => res.json())
    .then(data => {
      bodyData = data.map(d => ({
        date: d.date,
        weight: Number(d.weight),
        fat: Number(d.body_fat)
      }))
      renderBodyChart()
    })
    .catch(error => console.error("❌ 体データ取得エラー：", error))

  const renderMaxChart = () => {
    if (!Object.keys(maxData).length) return
    if (maxChart) maxChart.destroy()

    const checked = [...document.querySelectorAll(".event-check:checked")].map(cb => cb.value)
    const colorMap = {
      ベンチプレス: 'rgba(255, 99, 132, 1)',
      スクワット: 'rgba(54, 162, 235, 1)',
      デッドリフト: 'rgba(75, 192, 192, 1)',
      クリーン: 'rgba(153, 102, 255, 1)'
    }

    const allDates = generateDateRange(startDate, endDate)

    const datasets = checked.map(event => {
      const entries = maxData[event] || []
      const dateMap = {}
      entries.forEach(entry => {
        const key = entry.date
        if (!dateMap[key] || new Date(entry.timestamp) > new Date(dateMap[key].timestamp)) {
          dateMap[key] = entry
        }
      })

      return {
        label: event,
        data: allDates.map(date => dateMap[date]?.value ?? null),
        borderColor: colorMap[event],
        backgroundColor: colorMap[event],
        tension: 0.3,
        borderWidth: 2,
        fill: false,
        spanGaps: true
      }
    })

    maxChart = new Chart(maxCtx, {
      type: 'line',
      data: { labels: allDates, datasets },
      options: {
        responsive: true,
        backgroundColor: 'white',
        scales: {
          y: { beginAtZero: true }
        }
      }
    })
  }

  const renderBodyChart = () => {
    if (!bodyData.length) return
    if (bodyChart) bodyChart.destroy()

    const allDates = generateDateRange(startDate, endDate)
    const weightMap = {}
    const fatMap = {}
    bodyData.forEach(entry => {
      weightMap[entry.date] = entry.weight
      fatMap[entry.date] = entry.fat
    })

    bodyChart = new Chart(bodyCtx, {
      type: 'bar',
      data: {
        labels: allDates,
        datasets: [
          {
            type: 'bar',
            label: '体重',
            data: allDates.map(date => weightMap[date] ?? null),
            backgroundColor: 'rgba(59,130,246,0.5)',
            spanGaps: true
          },
          {
            type: 'line',
            label: '体脂肪率',
            data: allDates.map(date => fatMap[date] ?? null),
            borderColor: 'rgba(34,197,94,1)',
            borderWidth: 2,
            yAxisID: 'y2',
            spanGaps: true
          }
        ]
      },
      options: {
        responsive: true,
        backgroundColor: 'white',
        scales: {
          y: {
            beginAtZero: true,
            position: 'left',
            title: { display: true, text: '体重 (kg)' }
          },
          y2: {
            beginAtZero: true,
            position: 'right',
            grid: { drawOnChartArea: false },
            title: { display: true, text: '体脂肪率 (%)' }
          }
        }
      }
    })
  }

  document.querySelectorAll(".event-check").forEach(cb => {
    cb.addEventListener("change", renderMaxChart)
  })

  const presetSelect = document.querySelector("select[data-date-preset-target='preset']")
  presetSelect.value = "30"

  presetSelect.addEventListener("change", e => {
    const value = e.target.value
    if (value === "custom") {
      document.getElementById("startDate").disabled = false
      document.getElementById("endDate").disabled = false
      return
    }
    const now = new Date()
    endDate = now
    startDate = new Date(now)
    startDate.setDate(now.getDate() - Number(value))
    renderMaxChart()
    renderBodyChart()
  })

  document.getElementById("startDate").addEventListener("change", () => {
    startDate = new Date(document.getElementById("startDate").value)
    renderMaxChart()
    renderBodyChart()
  })
  document.getElementById("endDate").addEventListener("change", () => {
    endDate = new Date(document.getElementById("endDate").value)
    renderMaxChart()
    renderBodyChart()
  })
})