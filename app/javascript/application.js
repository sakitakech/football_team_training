// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

import Chart from 'chart.js/auto'

document.addEventListener("DOMContentLoaded", () => {
  // ✅ 仮データ：日付＆マックス種目
  const maxData = {
    ベンチプレス: [{ date: '4/1', value: 100 }, { date: '4/5', value: 105 }, { date: '4/10', value: 110 }],
    スクワット:   [{ date: '4/1', value: 140 }, { date: '4/5', value: 145 }, { date: '4/10', value: 150 }],
    デッドリフト: [{ date: '4/1', value: 160 }, { date: '4/5', value: 165 }, { date: '4/10', value: 170 }],
    クリーン:     [{ date: '4/1', value: 90 },{ date: '4/5', value: 95 },{ date: '4/10', value: 97 }]
  }

  const bodyData = [
    { date: '4/1', weight: 78.5, fat: 15.2 },
    { date: '4/5', weight: 79.0, fat: 15.0 },
    { date: '4/10', weight: 78.2, fat: 14.8 }
  ]

  const maxCtx = document.getElementById("maxChart")
  const bodyCtx = document.getElementById("bodyChart")
  let maxChart, bodyChart

  // ✅ マックスグラフ描画関数
  const renderMaxChart = () => {
    if (maxChart) maxChart.destroy()
    const checked = [...document.querySelectorAll(".event-check:checked")].map(cb => cb.value)
    const colorMap = {
        ベンチプレス: 'rgba(255, 99, 132, 1)',    // 赤
        スクワット:   'rgba(54, 162, 235, 1)',     // 青
        デッドリフト: 'rgba(75, 192, 192, 1)',    // 緑
        クリーン:     'rgba(153, 102, 255, 1)'     // 紫
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
    const labels = maxData[checked[0]].map(d => d.date)



    maxChart = new Chart(maxCtx, {
      type: 'line',
      data: { labels, datasets },
      options: { responsive: true, backgroundColor: 'white', scales: { y: { beginAtZero: true } } }
    })
  }


  // ✅ 体重・体脂肪グラフ描画関数
  const renderBodyChart = () => {
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
          y: { beginAtZero: true, position: 'left', title: { display: true, text: '体重 (kg)' } },
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

  // ✅ 初期描画 & イベント
  renderMaxChart()
  renderBodyChart()
  document.querySelectorAll(".event-check").forEach(cb => {
    cb.addEventListener("change", renderMaxChart)
  })
})