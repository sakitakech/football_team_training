// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

import Chart from 'chart.js/auto'

document.addEventListener("DOMContentLoaded", () => {
  const userId = 23
  let maxData = {}  // 種目別マックス値
  let bodyData = [] // 体重・体脂肪率
  const maxCtx = document.getElementById("maxChart")
  const bodyCtx = document.getElementById("bodyChart")
  let maxChart, bodyChart

  // ✅ max_weights API からデータ取得
  fetch(`/api/charts/max_weights?user_id=${userId}`)
    .then(res => res.json())
    .then(data => {
      maxData = data.reduce((acc, cur) => {
        if (!acc[cur.name]) acc[cur.name] = []
        acc[cur.name].push({ date: cur.date, value: Number(cur.value) })
        return acc
      }, {})
      renderMaxChart()
    })
    .catch(error => {
      console.error("❌ マックスデータ取得エラー：", error)
    })

  // ✅ body_metrics API からデータ取得
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
    .catch(error => {
      console.error("❌ 体データ取得エラー：", error)
    })

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

    const datasets = checked.map(event => ({
      label: event,
      data: maxData[event].map(d => d.value),
      borderColor: colorMap[event],
      backgroundColor: colorMap[event],
      tension: 0.3,
      borderWidth: 2,
      fill: false
    }))
    const labels = maxData[checked[0]]?.map(d => d.date) || []

    maxChart = new Chart(maxCtx, {
      type: 'line',
      data: { labels, datasets },
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

    const labels = bodyData.map(d => d.date)

    bodyChart = new Chart(bodyCtx, {
      type: 'bar',
      data: {
        labels,
        datasets: [
          {
            type: 'bar',
            label: '体重',
            data: bodyData.map(d => d.weight),
            backgroundColor: 'rgba(59,130,246,0.5)'
          },
          {
            type: 'line',
            label: '体脂肪率',
            data: bodyData.map(d => d.fat),
            borderColor: 'rgba(34,197,94,1)',
            borderWidth: 2,
            yAxisID: 'y2'
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

  // ✅ チェックボックス変更時にマックスグラフ再描画
  document.querySelectorAll(".event-check").forEach(cb => {
    cb.addEventListener("change", renderMaxChart)
  })
})
