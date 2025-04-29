import "@hotwired/turbo-rails"
import "./controllers"
import Chart from 'chart.js/auto'

let maxData = {}
let bodyData = []
let maxChart = null
let bodyChart = null
let userId = null

document.addEventListener("turbo:load", () => {
  const userSelect = document.getElementById("userSelect")
  const presetSelect = document.querySelector("select[data-date-preset-target='preset']")
  const startInput = document.getElementById("startDate")
  const endInput = document.getElementById("endDate")
  const maxCtx = document.getElementById("maxChart")
  const bodyCtx = document.getElementById("bodyChart")

  const maxNoData = document.getElementById("maxChartNoData")
  const bodyNoData = document.getElementById("bodyChartNoData")
  
  
  const orientationWarning = document.getElementById("orientationWarning")
  const checkOrientation = () => {
    if (window.innerWidth < 640 && window.innerHeight > window.innerWidth) {
      orientationWarning.classList.remove("hidden")
    } else {
      orientationWarning.classList.add("hidden")
    }
  }

  checkOrientation()
  window.addEventListener("orientationchange", checkOrientation)
  window.addEventListener("resize", checkOrientation)

  userId = Number(userSelect.value)

  const now = new Date()
  let endDate = now
  let startDate = new Date(now)
  startDate.setDate(now.getDate() - 30)

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

  const fetchAndRender = async () => {
    userId = Number(userSelect.value)

    const now = new Date()
    endDate = now
    startDate = new Date(now)

    if (presetSelect.value !== "custom") {
      const days = Number(presetSelect.value || 30)
      startDate.setDate(now.getDate() - days)
      startInput.disabled = true
      endInput.disabled = true
    } else {
      startDate = new Date(startInput.value)
      endDate = new Date(endInput.value)
    }

    try {
      const maxRes = await fetch(`/api/charts/max_weights?user_id=${userId}`)
      const maxJson = await maxRes.json()
      maxData = maxJson.reduce((acc, cur) => {
        if (!acc[cur.name]) acc[cur.name] = []
        acc[cur.name].push({ date: cur.date, value: Number(cur.value), timestamp: new Date(cur.date).getTime() })
        return acc
      }, {})

      const bodyRes = await fetch(`/api/charts/body_metrics?user_id=${userId}`)
      const bodyJson = await bodyRes.json()
      bodyData = bodyJson.map(d => ({
        date: d.date,
        weight: Number(d.weight),
        fat: Number(d.body_fat)
      }))

      renderCharts()
    } catch (error) {
      console.error("❌ データ取得エラー：", error)
    }
  }

  const renderMaxChart = () => {
    if (maxChart) maxChart.destroy()

    const checked = [...document.querySelectorAll(".event-check:checked")].map(cb => cb.value)
    if (!checked.length || !Object.keys(maxData).length) {
      maxCtx.classList.add("hidden")
      maxNoData.classList.remove("hidden")
      return
    }

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

    if (datasets.every(ds => ds.data.every(v => v === null))) {
      maxCtx.classList.add("hidden")
      maxNoData.classList.remove("hidden")
      return
    }

    maxCtx.classList.remove("hidden")
    maxNoData.classList.add("hidden")

    maxChart = new Chart(maxCtx, {
      type: 'line',
      data: { labels: allDates, datasets },
      options: {
        responsive: true,
        backgroundColor: 'white',
        scales: { y:
            {

                beginAtZero: true,
                ticks: {
                  stepSize: 20 // 100刻み→20刻みに変更（例）
                },
                suggestedMin: 0,
                suggestedMax: 200 // 目安最大値
              
            }
          }
      }
    })
  }

  const renderBodyChart = () => {
    if (bodyChart) bodyChart.destroy()

    const allDates = generateDateRange(startDate, endDate)
    const weightMap = {}
    const fatMap = {}
    bodyData.forEach(entry => {
      weightMap[entry.date] = entry.weight
      fatMap[entry.date] = entry.fat
    })

    const weightData = allDates.map(date => weightMap[date] ?? null)
    const fatData = allDates.map(date => fatMap[date] ?? null)

    if (weightData.every(v => v === null) && fatData.every(v => v === null)) {
      bodyCtx.classList.add("hidden")
      bodyNoData.classList.remove("hidden")
      return
    }

    bodyCtx.classList.remove("hidden")
    bodyNoData.classList.add("hidden")

    bodyChart = new Chart(bodyCtx, {
        type: 'bar',
        data: {
          labels: allDates,
          datasets: [
            {
              type: 'bar',
              label: '体重',
              data: weightData,
              backgroundColor: 'rgba(59,130,246,0.5)',
              spanGaps: true
            },
            {
              type: 'line',
              label: '体脂肪率',
              data: fatData,
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
              min: 0,
              max: 140,
              ticks: {
                stepSize: 20
              },
              position: 'left',
              title: {
                display: true,
                text: '体重 (kg)'
              }
            },
            y2: {
              beginAtZero: true,
              min: 0,
              max: 40,
              ticks: {
                stepSize: 5
              },
              position: 'right',
              grid: {
                drawOnChartArea: false
              },
              title: {
                display: true,
                text: '体脂肪率 (%)'
            }
        }
      }
    }
  })
    }


  const renderCharts = () => {
    renderMaxChart()
    renderBodyChart()
  }

  fetchAndRender()

  document.querySelectorAll(".event-check").forEach(cb => cb.addEventListener("change", renderCharts))
  userSelect.addEventListener("change", fetchAndRender)

  presetSelect.addEventListener("change", () => {
    const selected = presetSelect.value
    if (selected === "custom") {
      startInput.disabled = false
      endInput.disabled = false
    } else {
      startInput.disabled = true
      endInput.disabled = true
    }
    fetchAndRender()
  })

  startInput.addEventListener("change", () => fetchAndRender())
  endInput.addEventListener("change", () => fetchAndRender())
})

document.addEventListener("turbo:before-cache", () => {
  if (maxChart) { maxChart.destroy(); maxChart = null }
  if (bodyChart) { bodyChart.destroy(); bodyChart = null }
})
