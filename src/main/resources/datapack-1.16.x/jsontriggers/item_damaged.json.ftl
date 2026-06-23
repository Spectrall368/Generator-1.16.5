"${registryname}_${cbi}": {
  "trigger": "minecraft:item_durability_changed",
  "conditions": {
    "item": {
        "item": ${input$item},
        "durability": {
          "min": ${input$amount_l},
          "max": ${input$amount_h}
        }
      }
  }
},